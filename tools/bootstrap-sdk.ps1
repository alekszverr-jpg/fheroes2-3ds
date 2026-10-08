param([string]$Destination = (Join-Path $PSScriptRoot '../.toolchain/sdk'))
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$cache = Join-Path $workspace '.toolchain/downloads'
$Destination = [IO.Path]::GetFullPath($Destination)
New-Item -ItemType Directory -Force $cache, $Destination | Out-Null

function Download-File([string]$Url, [string]$Output) {
    & curl.exe --silent --show-error --fail --location --retry 2 --max-time 180 --user-agent 'pacman/7.0.0' --output $Output $Url
    if ($LASTEXITCODE -ne 0) { throw "Download failed: $Url" }
}

$repositories = @{
    windows = 'https://pkg.devkitpro.org/packages/windows/x86_64'
    libs = 'https://pkg.devkitpro.org/packages'
}
$packages = @{}
$locked = @(Get-Content (Join-Path $PSScriptRoot 'sdk-lock.json') -Raw | ConvertFrom-Json)
$installed = @()
$manifestPath = Join-Path $Destination 'packages.json'
if ((Test-Path $manifestPath) -and (Test-Path (Join-Path $Destination 'devkitARM/bin/arm-none-eabi-g++.exe'))) {
    $installed = @(Get-Content $manifestPath -Raw | ConvertFrom-Json)
    $matching = $installed.Count -eq $locked.Count
    foreach ($entry in $locked) {
        $found = @($installed | Where-Object { $_.name -eq $entry.name -and $_.version -eq $entry.version -and $_.sha256 -eq $entry.sha256 })
        $matching = $matching -and $found.Count -eq 1
    }
    if ($matching) { Write-Output "Pinned SDK already ready: $Destination"; return }
}
foreach ($entry in $locked) {
    if ($entry.filename -notmatch '^[a-z0-9][a-z0-9.+_-]*\.pkg\.tar\.(zst|xz)$' -or $entry.sha256 -notmatch '^[a-f0-9]{64}$') {
        throw "Invalid SDK lock entry: $($entry.name)"
    }
    $repository = if ($entry.filename -like '*-x86_64.pkg.tar.*') { $repositories.windows } else { $repositories.libs }
    $packages[$entry.name] = @{ FILENAME=$entry.filename; VERSION=$entry.version; SHA256SUM=$entry.sha256; Repository=$repository }
}

# Official packages only; extract into a project-local SDK without registry/PATH changes.
$required = @('devkitarm-binutils', 'devkitarm-gcc', 'devkitarm-newlib',
    'devkitarm-crtls', 'devkitarm-rules', 'general-tools', '3dstools', 'libctru',
    '3ds-cmake', 'devkitarm-cmake', 'dkp-cmake-common-utils', '3ds-pkg-config', 'dkp-toolchain-vars', '3ds-zlib')
$manifest = @()
foreach ($name in $required) {
    $package = $packages[$name]
    if (!$package) { throw "Official package missing: $name" }
    if ($installed | Where-Object { $_.name -eq $name -and $_.version -eq $package['VERSION'] -and $_.sha256 -eq $package['SHA256SUM'] }) {
        $manifest += [ordered]@{ name=$name; version=$package['VERSION']; filename=$package['FILENAME']; sha256=$package['SHA256SUM'] }
        continue
    }
    $archive = Join-Path $cache $package['FILENAME']
    if (!(Test-Path $archive)) {
        Write-Output "Downloading $name $($package['VERSION'])"
        Download-File "$($package['Repository'])/$($package['FILENAME'])" $archive
    }
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $archive).Hash.ToLowerInvariant()
    if ($hash -ne $package['SHA256SUM']) { throw "Checksum mismatch: $name" }
    # Restrict archive extraction to the SDK payload, excluding package metadata/hooks.
    $entries = & tar.exe -tf $archive
    if ($LASTEXITCODE -ne 0) { throw "Cannot list $archive" }
    foreach ($entry in $entries) {
        if ($entry -match '(^/|(^|/)\.\.(/|$)|^[A-Za-z]:)') { throw "Unsafe archive entry: $entry" }
    }
    if ($entries | Where-Object { $_ -like 'opt/devkitpro/*' }) {
        & tar.exe -xf $archive -C $Destination --strip-components 2 opt/devkitpro
        if ($LASTEXITCODE -ne 0) { throw "Cannot extract SDK payload: $name" }
    } else { throw "No SDK payload: $name" }
    $manifest += [ordered]@{ name=$name; version=$package['VERSION']; filename=$package['FILENAME']; sha256=$hash }
}
$manifest | ConvertTo-Json | Set-Content (Join-Path $Destination 'packages.json') -Encoding utf8
Write-Output "SDK ready: $Destination"
