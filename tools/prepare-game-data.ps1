param([string]$Destination = (Join-Path $PSScriptRoot '../sdmc/3ds/fheroes2'),
      [string]$OriginalGame = (Join-Path $PSScriptRoot '../Heroes of Might and Magic II Gold'))
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Destination = [IO.Path]::GetFullPath($Destination)
if (!(Test-Path (Join-Path $OriginalGame 'Data/heroes2.agg'))) { throw 'Original Data/heroes2.agg is required' }
New-Item -ItemType Directory -Force $Destination | Out-Null
foreach ($directory in @('Data','Maps','Tracks2')) {
    $source = Join-Path $OriginalGame $directory
    if (Test-Path $source) {
        $targetName = if ($directory -eq 'Tracks2') { 'music' } else { $directory.ToLowerInvariant() }
        $target = Join-Path $Destination $targetName
        New-Item -ItemType Directory -Force $target | Out-Null
        if ($directory -ne 'Tracks2') { Copy-Item -Path (Join-Path $source '*') -Destination $target -Recurse -Force }
        if ($directory -eq 'Tracks2') {
            foreach ($track in Get-ChildItem -LiteralPath $source -File) {
                if ($track.Name -match '^(\d+)-AudioTrack.*\.ogg$') {
                    Copy-Item -LiteralPath $track.FullName -Destination (Join-Path $target ("Track{0:D2}.ogg" -f [int]$Matches[1])) -Force
                }
            }
        }
    }
}
$h2d = Join-Path $Destination 'files/data'
New-Item -ItemType Directory -Force $h2d | Out-Null
Copy-Item -Path (Join-Path $workspace 'fheroes2/files/data/*.h2d') -Destination $h2d -Force
$translations = Join-Path $Destination 'files/lang'
New-Item -ItemType Directory -Force $translations | Out-Null
$msgfmt = 'C:/msys64/usr/bin/msgfmt.exe'
if (Test-Path $msgfmt) {
    # Match upstream files/lang/Makefile: the engine consumes Russian strings in CP1251.
    [Text.Encoding]::RegisterProvider([Text.CodePagesEncodingProvider]::Instance)
    $po = [IO.File]::ReadAllText((Join-Path $workspace 'fheroes2/files/lang/ru.po'), [Text.Encoding]::UTF8).Replace('charset=UTF-8', 'charset=CP1251')
    $temporaryDirectory = Join-Path $workspace 'build/translations'
    New-Item -ItemType Directory -Force $temporaryDirectory | Out-Null
    $encodedPo = Join-Path $temporaryDirectory 'ru-cp1251.po'
    [IO.File]::WriteAllText($encodedPo, $po, [Text.Encoding]::GetEncoding(1251, [Text.EncoderFallback]::ExceptionFallback, [Text.DecoderFallback]::ExceptionFallback))
    $options = @('-o', (Join-Path $translations 'ru.mo'), $encodedPo)
    if ((& $msgfmt --help) -match '--no-convert') { $options += '--no-convert' }
    & $msgfmt @options
    if ($LASTEXITCODE -ne 0) { throw 'Russian translation compilation failed' }
}
Write-Output "Private game data prepared: $Destination"
