param([string]$CMake = 'C:/msys64/mingw64/bin/cmake.exe',
      [string]$Ninja = 'C:/msys64/mingw64/bin/ninja.exe')
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$sdk = Join-Path $workspace '.toolchain/sdk'
$sdl = Join-Path $workspace 'vendor/SDL2'
$sdlCommit = '4c2d9014afda49553c76f7045529207bb593f9b5'
if (!(Test-Path (Join-Path $sdk 'devkitARM/bin/arm-none-eabi-g++.exe'))) {
    & (Join-Path $PSScriptRoot 'bootstrap-sdk.ps1')
}
$installed = Get-Content (Join-Path $sdk 'packages.json') -Raw | ConvertFrom-Json
$locked = Get-Content (Join-Path $PSScriptRoot 'sdk-lock.json') -Raw | ConvertFrom-Json
foreach ($entry in $locked) {
    $found = @($installed | Where-Object { $_.name -eq $entry.name })
    if ($found.Count -ne 1 -or $found[0].version -ne $entry.version -or $found[0].sha256 -ne $entry.sha256) {
        throw "SDK differs from sdk-lock.json: $($entry.name); run tools/bootstrap-sdk.ps1"
    }
}
if (!(Test-Path (Join-Path $sdl '.git'))) {
    & git clone --no-checkout --depth 1 --branch SDL2 https://github.com/libsdl-org/SDL.git $sdl
    if ($LASTEXITCODE -ne 0) { throw 'SDL2 clone failed' }
    & git -C $sdl fetch --depth 1 origin $sdlCommit
    if ($LASTEXITCODE -ne 0) { throw 'SDL2 pinned revision fetch failed' }
    & git -C $sdl checkout --detach $sdlCommit
    if ($LASTEXITCODE -ne 0) { throw 'SDL2 checkout failed' }
}
$actualCommit = & git -C $sdl rev-parse HEAD
if ($LASTEXITCODE -ne 0 -or $actualCommit.Trim() -ne $sdlCommit) { throw 'Unexpected SDL2 revision; preserve local changes and review before updating' }
$sdlChanges = & git -C $sdl status --porcelain --untracked-files=no
if ($LASTEXITCODE -ne 0 -or $sdlChanges) { throw 'SDL2 has local changes; preserve them and review before building a pinned package' }
if (!(Test-Path $CMake) -or !(Test-Path $Ninja)) { throw 'Specify paths to native Windows CMake and Ninja with -CMake and -Ninja' }
$build = Join-Path $workspace 'build/probe'
& $CMake -S (Join-Path $workspace '3ds-platform-probe') -B $build -G Ninja "-DCMAKE_MAKE_PROGRAM=$Ninja" "-DCMAKE_TOOLCHAIN_FILE=$(Join-Path $workspace 'cmake/native-3ds.cmake')" -DCMAKE_BUILD_TYPE=Release
if ($LASTEXITCODE -ne 0) { throw 'CMake configuration failed' }
& $CMake --build $build --parallel 6
if ($LASTEXITCODE -ne 0) { throw 'Build failed' }
$package = Join-Path $workspace 'dist/fheroes2-probe/3ds/fheroes2-probe'
New-Item -ItemType Directory -Force $package | Out-Null
Copy-Item -LiteralPath (Join-Path $build 'fheroes2-probe.3dsx') -Destination $package
Copy-Item -LiteralPath (Join-Path $build 'fheroes2-probe.smdh') -Destination $package
Copy-Item -LiteralPath (Join-Path $workspace '3ds-platform-probe/README_RU.md') -Destination (Join-Path $workspace 'dist/fheroes2-probe/README_RU.md')
Copy-Item -LiteralPath (Join-Path $sdk 'packages.json') -Destination (Join-Path $workspace 'dist/fheroes2-probe/sdk-packages.json')
$sourcePackage = Join-Path $workspace 'dist/fheroes2-probe/source'
New-Item -ItemType Directory -Force $sourcePackage | Out-Null
foreach ($directory in @('3ds-platform-probe', 'cmake')) {
    Copy-Item -LiteralPath (Join-Path $workspace $directory) -Destination $sourcePackage -Recurse -Force
}
$sourceTools = Join-Path $sourcePackage 'tools'
New-Item -ItemType Directory -Force $sourceTools | Out-Null
foreach ($name in @('build-probe.ps1','bootstrap-sdk.ps1','sdk-lock.json','test-probe-emulator.ps1')) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination $sourceTools -Force
}
$testResults = Join-Path $workspace 'dist/fheroes2-probe/test-results'
New-Item -ItemType Directory -Force $testResults | Out-Null
foreach ($model in @('New','Old')) {
    $testLog = Join-Path $workspace "build/probe-tests/$model/probe.log"
    if (Test-Path $testLog) { Copy-Item -LiteralPath $testLog -Destination (Join-Path $testResults "$model.log") -Force }
}
$licenses = Join-Path $workspace 'dist/fheroes2-probe/licenses'
New-Item -ItemType Directory -Force $licenses | Out-Null
Copy-Item -LiteralPath (Join-Path $sdl 'LICENSE.txt') -Destination (Join-Path $licenses 'SDL2.txt')
$manifest = [ordered]@{
    probe_version = '0.1.0'
    sdl2_commit = $sdlCommit
    fheroes2_baseline = '9754feff8501dbb69df95f3b999156a32eb8d7d3'
    binary_sha256 = (Get-FileHash (Join-Path $package 'fheroes2-probe.3dsx') -Algorithm SHA256).Hash.ToLowerInvariant()
}
$manifest | ConvertTo-Json | Set-Content (Join-Path $workspace 'dist/fheroes2-probe/build-manifest.json') -Encoding utf8
$zip = Join-Path $workspace 'dist/fheroes2-probe-0.1.0.zip'
Compress-Archive -Path (Join-Path $workspace 'dist/fheroes2-probe/*') -DestinationPath $zip -Force
Write-Output "Package ready: $zip"
