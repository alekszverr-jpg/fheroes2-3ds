param([ValidateSet('New','Old')][string]$Model = 'New', [int]$TimeoutSeconds = 90,
      [ValidateSet('ru','en')][string]$Language = 'ru',
      [ValidateSet('Default','Off')][string]$DisplayMode = 'Default')
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$emulator = Join-Path $workspace '.toolchain/azahar/azahar.exe'
$config = Join-Path $workspace '.toolchain/azahar/user/config/qt-config.ini'
$sd = Join-Path $workspace '.toolchain/azahar/user/sdmc/3ds/fheroes2'
$output = Join-Path $workspace "build/menu-tests/$Model"
if ($Language -eq 'en') { $output += '-English' }
if ($DisplayMode -eq 'Off') { $output += '-Standard' }
Get-CimInstance Win32_Process -Filter "name='azahar.exe'" | Where-Object { $_.ExecutablePath -eq $emulator } | ForEach-Object { Stop-Process -Id $_.ProcessId }
New-Item -ItemType Directory -Force $output | Out-Null
& (Join-Path $PSScriptRoot 'prepare-game-data.ps1') -Destination $sd
$originalConfig = [IO.File]::ReadAllText($config)
$isNew = if ($Model -eq 'New') { 'true' } else { 'false' }
$newConfig = [regex]::Replace($originalConfig, '(?m)^is_new_3ds=.*$', "is_new_3ds=$isNew")
$newConfig = [regex]::Replace($newConfig, '(?m)^is_new_3ds\\default=.*$', 'is_new_3ds\default=false')
[IO.File]::WriteAllText($config, $newConfig)
$gameConfig = Join-Path $sd 'fheroes2.cfg'
$originalGameConfig = if (Test-Path $gameConfig) { [IO.File]::ReadAllText($gameConfig) } else { $null }
$gameLanguage = if ($Language -eq 'en') { '' } else { 'ru' }
$displayOption = if ($DisplayMode -eq 'Off') { "`n3ds high resolution = off" } else { '' }
Set-Content -LiteralPath $gameConfig -Value "first time game run = off`nlang = $gameLanguage`nmusic = external$displayOption" -Encoding ascii
$log = Join-Path $sd 'fheroes2.log'
if (Test-Path $log) { Move-Item -LiteralPath $log -Destination (Join-Path $output ("previous-" + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-ffff') + '.log')) }
$marker = Join-Path $sd 'menu-smoke.enabled'
Set-Content -LiteralPath $marker -Value 'Automated first menu test' -Encoding ascii
$process = $null
function Read-MenuLog {
    $stream = [IO.File]::Open($log, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $reader = [IO.StreamReader]::new($stream)
    try { return $reader.ReadToEnd() } finally { $reader.Dispose() }
}
try {
    $binary = Join-Path $workspace 'build/game/fheroes2.3dsx'
    $process = Start-Process -FilePath $emulator -ArgumentList ('"' + $binary + '"') -WindowStyle Hidden -PassThru
    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    do {
        Start-Sleep -Seconds 2
        $report = if (Test-Path $log) { Read-MenuLog } else { '' }
        if ($process.HasExited -and !$report.Contains('3DS MENU SMOKE: PASS')) { throw 'Emulator exited before menu was ready' }
    } while (!$report.Contains('3DS MENU SMOKE: PASS') -and [DateTime]::UtcNow -lt $deadline)
    if (!$report.Contains('3DS MENU SMOKE: PASS')) { throw 'Menu test timeout' }
    if (!$report.Contains('3DS COMMAND STRIP SMOKE: PASS')) { throw 'Command panel smoke test incomplete' }
    if (!$report.Contains('3DS MAP SCROLL SMOKE: PASS')) { throw 'Adventure map scroll smoke test incomplete' }
    if (!$report.Contains('3DS NATIVE MESSAGES SMOKE: PASS')) { throw 'Native message smoke test incomplete' }
    $expectedPreference = if ($DisplayMode -eq 'Off') { 'off' } else { 'on' }
    if (!$report.Contains("3DS DISPLAY STARTUP preference=$expectedPreference")) { throw 'Startup display preference differs' }
    if (!$report.Contains('3DS HIGH RESOLUTION SMOKE: PASS')) { throw 'High-resolution smoke test incomplete' }
    if (!$report.Contains('3DS LEVEL UP SMOKE: PASS')) { throw 'Level-up smoke test incomplete' }
    if (!$report.Contains('3DS CHEST SMOKE: PASS')) { throw 'Chest reward choice smoke test incomplete' }
    foreach ($name in @('fheroes2.log','menu-top.bmp','menu-bottom.bmp','wide-menu-top.bmp','wide-menu-bottom.bmp','wide-panel-top.bmp','wide-panel-bottom.bmp','wide-info-top.bmp','wide-info-bottom.bmp','wide-dialog-top.bmp','wide-dialog-bottom.bmp')) { Copy-Item -LiteralPath (Join-Path $sd $name) -Destination $output -Force }
    Add-Type -AssemblyName System.Drawing
    $standardTop = [Drawing.Bitmap]::new((Join-Path $output 'menu-top.bmp'))
    $wideTop = [Drawing.Bitmap]::new((Join-Path $output 'wide-menu-top.bmp'))
    $wideInfo = [Drawing.Bitmap]::new((Join-Path $output 'wide-info-top.bmp'))
    try {
        if ($standardTop.Width -ne 400 -or $wideTop.Width -ne 800 -or $wideTop.Height -ne 240) { throw 'Top framebuffer dimensions differ' }
        $extraDetail = 0
        for ($y = 0; $y -lt 240; $y++) {
            for ($x = 0; $x -lt 400; $x++) {
                $even = $wideTop.GetPixel($x * 2, $y).ToArgb()
                if ($standardTop.GetPixel($x, $y).ToArgb() -ne $even) { throw 'Wide overview changed the framing' }
                if ($wideTop.GetPixel($x * 2 + 1, $y).ToArgb() -ne $even) { $extraDetail++ }
                if ($wideInfo.GetPixel($x * 2, $y).ToArgb() -ne $wideInfo.GetPixel($x * 2 + 1, $y).ToArgb()) { throw 'Wide information lost its physical proportions' }
            }
        }
        if ($extraDetail -eq 0) { throw 'Wide overview contains no extra horizontal detail' }
        if ((Get-FileHash (Join-Path $output 'menu-bottom.bmp')).Hash -ne (Get-FileHash (Join-Path $output 'wide-menu-bottom.bmp')).Hash) { throw 'Display switch changed the lower viewport' }
        Write-Output "Wide pixels PASS: $extraDetail additional detail pixels; framing, lower viewport and information proportions preserved"
    } finally { $standardTop.Dispose(); $wideTop.Dispose(); $wideInfo.Dispose() }
    Write-Output "Menu $Model PASS: $output"
} finally {
    if ($process -and !$process.HasExited) { Stop-Process -Id $process.Id }
    if (Test-Path $marker) { Remove-Item -LiteralPath $marker }
    [IO.File]::WriteAllText($config, $originalConfig)
    if ($null -ne $originalGameConfig) { [IO.File]::WriteAllText($gameConfig, $originalGameConfig) }
    elseif (Test-Path $gameConfig) { Remove-Item -LiteralPath $gameConfig }
}
