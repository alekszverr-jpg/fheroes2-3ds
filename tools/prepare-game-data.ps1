param([string]$Destination = (Join-Path $PSScriptRoot '../sdmc/3ds/fheroes2'),
      [string]$OriginalGame = (Join-Path $PSScriptRoot '../Heroes of Might and Magic II Gold'),
      [switch]$ForceCopy)
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Destination = [IO.Path]::GetFullPath($Destination)
if (!(Test-Path (Join-Path $OriginalGame 'Data/heroes2.agg'))) { throw 'Original Data/heroes2.agg is required' }
$prepareClock = [Diagnostics.Stopwatch]::StartNew()
$copyStats = @{ copied=0; skipped=0; bytes=0 }
function Copy-PreparedFile([IO.FileInfo]$SourceFile, [string]$TargetFile) {
    $existing = if (Test-Path -LiteralPath $TargetFile) { Get-Item -LiteralPath $TargetFile } else { $null }
    if (!$ForceCopy -and $existing -and $existing.Length -eq $SourceFile.Length -and $existing.LastWriteTimeUtc -eq $SourceFile.LastWriteTimeUtc) {
        $copyStats.skipped++
        return
    }
    New-Item -ItemType Directory -Force ([IO.Path]::GetDirectoryName($TargetFile)) | Out-Null
    Copy-Item -LiteralPath $SourceFile.FullName -Destination $TargetFile -Force
    $copyStats.copied++
    $copyStats.bytes += $SourceFile.Length
}
New-Item -ItemType Directory -Force $Destination | Out-Null
foreach ($directory in @('Data','Maps','Tracks2')) {
    $source = Join-Path $OriginalGame $directory
    if (Test-Path $source) {
        $targetName = if ($directory -eq 'Tracks2') { 'music' } else { $directory.ToLowerInvariant() }
        $target = Join-Path $Destination $targetName
        New-Item -ItemType Directory -Force $target | Out-Null
        if ($directory -ne 'Tracks2') {
            foreach ($asset in Get-ChildItem -LiteralPath $source -File -Recurse) {
                $relative = [IO.Path]::GetRelativePath([IO.Path]::GetFullPath($source), $asset.FullName)
                Copy-PreparedFile $asset (Join-Path $target $relative)
            }
        }
        if ($directory -eq 'Tracks2') {
            foreach ($track in Get-ChildItem -LiteralPath $source -File) {
                if ($track.Name -match '^(\d+)-AudioTrack.*\.ogg$') {
                    Copy-PreparedFile $track (Join-Path $target ("Track{0:D2}.ogg" -f [int]$Matches[1]))
                }
            }
        }
    }
}
$h2d = Join-Path $Destination 'files/data'
New-Item -ItemType Directory -Force $h2d | Out-Null
foreach ($asset in Get-ChildItem -Path (Join-Path $workspace 'fheroes2/files/data/*.h2d') -File) { Copy-PreparedFile $asset (Join-Path $h2d $asset.Name) }
$translations = Join-Path $Destination 'files/lang'
New-Item -ItemType Directory -Force $translations | Out-Null
$msgfmt = 'C:/msys64/usr/bin/msgfmt.exe'
if (Test-Path $msgfmt) {
    # Cache the compiled CP1251 catalog across staging destinations.
    $temporaryDirectory = Join-Path $workspace 'build/translations'
    New-Item -ItemType Directory -Force $temporaryDirectory | Out-Null
    $sourcePo = Join-Path $workspace 'fheroes2/files/lang/ru.po'
    $cachedMo = Join-Path $temporaryDirectory 'ru.mo'
    $stamp = Join-Path $temporaryDirectory 'ru-mo-source.txt'
    $cacheKey = 'cp1251-v1:' + (Get-FileHash -LiteralPath $sourcePo -Algorithm SHA256).Hash + ':' + (Get-FileHash -LiteralPath $msgfmt -Algorithm SHA256).Hash
    $previousKey = if (Test-Path -LiteralPath $stamp) { [IO.File]::ReadAllText($stamp) } else { '' }
    if ($ForceCopy -or !(Test-Path -LiteralPath $cachedMo) -or $previousKey -ne $cacheKey) {
        [Text.Encoding]::RegisterProvider([Text.CodePagesEncodingProvider]::Instance)
        $po = [IO.File]::ReadAllText($sourcePo, [Text.Encoding]::UTF8).Replace('charset=UTF-8', 'charset=CP1251')
        $encodedPo = Join-Path $temporaryDirectory 'ru-cp1251.po'
        [IO.File]::WriteAllText($encodedPo, $po, [Text.Encoding]::GetEncoding(1251, [Text.EncoderFallback]::ExceptionFallback, [Text.DecoderFallback]::ExceptionFallback))
        $pendingMo = Join-Path $temporaryDirectory 'ru-pending.mo'
        $options = @('-o', $pendingMo, $encodedPo)
        if ((& $msgfmt --help) -match '--no-convert') { $options += '--no-convert' }
        & $msgfmt @options
        if ($LASTEXITCODE -ne 0) { throw 'Russian translation compilation failed' }
        Move-Item -LiteralPath $pendingMo -Destination $cachedMo -Force
        [IO.File]::WriteAllText($stamp, $cacheKey)
    }
    Copy-PreparedFile (Get-Item -LiteralPath $cachedMo) (Join-Path $translations 'ru.mo')
}
Write-Output "Private game data prepared: $Destination"
Write-Output ("Data preparation: copied={0} skipped={1} bytes={2} elapsed_ms={3}" -f $copyStats.copied,$copyStats.skipped,$copyStats.bytes,$prepareClock.ElapsedMilliseconds)
