param([ValidateSet('New','Old')][string]$Model = 'New', [int]$TimeoutSeconds = 0,
      [ValidateSet('ru','en')][string]$Language = 'ru',
      [ValidateSet('Default','Off')][string]$DisplayMode = 'Default',
      [ValidateSet('Startup','Messages','Chest','LevelUp','Recruit','Market','Gift','Hero','Army','Spellbook','BattleLog','BattleDialogs','BattleIntegration','Building','Construction','HeroRecruit','CastleOptions','Full')][string]$Group = 'Startup',
      [switch]$PlanOnly)
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
. (Join-Path $PSScriptRoot 'menu-test-groups.ps1')
$selectedGroups = @(if ($Group -eq 'Full') { $menuTestGroups.Keys } else { $Group })
$markers = @($selectedGroups | ForEach-Object { $menuTestGroups[$_].Markers })
$captures = @($selectedGroups | ForEach-Object { $menuTestGroups[$_].Captures } | Select-Object -Unique)
if ($TimeoutSeconds -eq 0) { $TimeoutSeconds = if ($Group -eq 'Full') { 360 } elseif ($Group -in @('Spellbook','BattleDialogs','BattleIntegration')) { 120 } else { 90 } }
if ($TimeoutSeconds -lt 1) { throw 'TimeoutSeconds must be positive' }
if ($PlanOnly) {
    [ordered]@{ Group=$Group; Model=$Model; Language=$Language; TimeoutSeconds=$TimeoutSeconds; Groups=$selectedGroups; Markers=$markers; Captures=$captures } | ConvertTo-Json -Depth 4
    return
}
$emulator = Join-Path $workspace '.toolchain/azahar/azahar.exe'
$config = Join-Path $workspace '.toolchain/azahar/user/config/qt-config.ini'
$sd = Join-Path $workspace '.toolchain/azahar/user/sdmc/3ds/fheroes2'
$output = Join-Path $workspace "build/menu-tests/$Model"
if ($Language -eq 'en') { $output += '-English' }
if ($DisplayMode -eq 'Off') { $output += '-Standard' }
if ($Group -ne 'Full') { $output = Join-Path $output $Group }
Get-CimInstance Win32_Process -Filter "name='azahar.exe'" | Where-Object { $_.ExecutablePath -eq $emulator } | ForEach-Object { Stop-Process -Id $_.ProcessId }
New-Item -ItemType Directory -Force $output | Out-Null
$timing = [ordered]@{ group=$Group; model=$Model; language=$Language; started_utc=[DateTime]::UtcNow.ToString('o'); status='incomplete'; preparation_ms=$null; emulation_ms=$null; validation_ms=$null; groups=@(); error=$null }
$stageClock = [Diagnostics.Stopwatch]::StartNew()
$activeStage = 'preparation_ms'
function Save-MenuTiming {
    $timing | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $output 'timings.json') -Encoding utf8
}
Save-MenuTiming
$gameConfig = Join-Path $sd 'fheroes2.cfg'
$recoveryPath = Join-Path $workspace 'build/menu-tests/profile-recovery.json'
# A forced reboot bypasses finally. Restore the previous test's temporary profile
# before taking a new backup; this path belongs only to the isolated test runner.
if (Test-Path -LiteralPath $recoveryPath) {
    $recovery = [IO.File]::ReadAllText($recoveryPath) | ConvertFrom-Json
    [IO.File]::WriteAllText($config, $recovery.emulator_config)
    if ($null -ne $recovery.game_config) { [IO.File]::WriteAllText($gameConfig, $recovery.game_config) }
    elseif (Test-Path -LiteralPath $gameConfig) { Remove-Item -LiteralPath $gameConfig }
    Remove-Item -LiteralPath $recoveryPath
}
$originalConfig = [IO.File]::ReadAllText($config)
$originalGameConfig = if (Test-Path $gameConfig) { [IO.File]::ReadAllText($gameConfig) } else { $null }
$log = Join-Path $sd 'fheroes2.log'
$marker = Join-Path $sd 'menu-smoke.enabled'
$selection = Join-Path $sd 'menu-smoke-group.txt'
[ordered]@{ emulator_config=$originalConfig; game_config=$originalGameConfig } | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $recoveryPath -Encoding utf8
$process = $null
function Read-MenuLog {
    $stream = [IO.File]::Open($log, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $reader = [IO.StreamReader]::new($stream)
    try { return $reader.ReadToEnd() } finally { $reader.Dispose() }
}
try {
    & (Join-Path $PSScriptRoot 'prepare-game-data.ps1') -Destination $sd
    $isNew = if ($Model -eq 'New') { 'true' } else { 'false' }
    $newConfig = [regex]::Replace($originalConfig, '(?m)^is_new_3ds=.*$', "is_new_3ds=$isNew")
    $newConfig = [regex]::Replace($newConfig, '(?m)^is_new_3ds\\default=.*$', 'is_new_3ds\default=false')
    [IO.File]::WriteAllText($config, $newConfig)
    $gameLanguage = if ($Language -eq 'en') { '' } else { 'ru' }
    $displayOption = if ($DisplayMode -eq 'Off') { "`n3ds high resolution = off" } else { '' }
    Set-Content -LiteralPath $gameConfig -Value "first time game run = off`nlang = $gameLanguage`nmusic = external$displayOption" -Encoding ascii
    if (Test-Path $log) { Move-Item -LiteralPath $log -Destination (Join-Path $output ("previous-" + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-ffff') + '.log')) }
    # Remove only captures expected from this group, so old files cannot mask missing output.
    foreach ($name in $captures) {
        $capturePath = Join-Path $sd $name
        if (Test-Path -LiteralPath $capturePath) { Remove-Item -LiteralPath $capturePath }
    }
    Set-Content -LiteralPath $selection -Value $Group -Encoding ascii
    Set-Content -LiteralPath $marker -Value 'Automated selected UI test' -Encoding ascii
    $timing.preparation_ms = $stageClock.ElapsedMilliseconds
    Save-MenuTiming
    $activeStage = 'emulation_ms'
    $stageClock.Restart()
    $binary = Join-Path $workspace 'build/game/fheroes2.3dsx'
    $process = Start-Process -FilePath $emulator -ArgumentList ('"' + $binary + '"') -WindowStyle Hidden -PassThru
    if (!$process.HasExited) { $process.PriorityClass = [Diagnostics.ProcessPriorityClass]::BelowNormal }
    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    $completion = "3DS MENU SMOKE: PASS group=$Group"
    do {
        Start-Sleep -Seconds 2
        $report = if (Test-Path $log) { Read-MenuLog } else { '' }
        $timing.emulation_ms = $stageClock.ElapsedMilliseconds
        Save-MenuTiming
        if ($process.HasExited -and !$report.Contains($completion)) { throw 'Emulator exited before selected group completed' }
    } while (!$report.Contains($completion) -and [DateTime]::UtcNow -lt $deadline)
    if (!$report.Contains($completion)) { throw 'Selected group timeout' }
    if (!$process.HasExited) { Stop-Process -Id $process.Id }
    if (!$process.WaitForExit(5000)) { throw 'Emulator did not stop after test completed' }
    $timing.emulation_ms = $stageClock.ElapsedMilliseconds
    Save-MenuTiming
    $activeStage = 'validation_ms'
    $stageClock.Restart()
    foreach ($expected in $markers) { if (!$report.Contains($expected)) { throw "Missing marker: $expected" } }
    foreach ($selected in $selectedGroups) {
        $match = [regex]::Match($report, "3DS TEST END group=$selected elapsed_ms=(\d+)")
        if (!$match.Success) { throw "Missing group timing: $selected" }
        $timing.groups += [ordered]@{ group=$selected; elapsed_ms=[long]$match.Groups[1].Value }
    }
    $expectedPreference = if ($DisplayMode -eq 'Off') { 'off' } else { 'on' }
    if (!$report.Contains("3DS DISPLAY STARTUP preference=$expectedPreference")) { throw 'Startup display preference differs' }
    foreach ($name in @($captures) + @('fheroes2.log')) { Copy-Item -LiteralPath (Join-Path $sd $name) -Destination $output -Force }
    if ($Group -in @('Startup','Full')) {
        Add-Type -AssemblyName System.Drawing
        $standardTop = [Drawing.Bitmap]::new((Join-Path $output 'menu-top.bmp'))
        $wideTop = [Drawing.Bitmap]::new((Join-Path $output 'wide-menu-top.bmp'))
        try {
            if ($standardTop.Width -ne 400 -or $wideTop.Width -ne 800 -or $wideTop.Height -ne 240) { throw 'Top framebuffer dimensions differ' }
            $extraDetail = 0
            for ($y = 0; $y -lt 240; $y++) {
                for ($x = 0; $x -lt 400; $x++) {
                    $even = $wideTop.GetPixel($x * 2, $y).ToArgb()
                    if ($standardTop.GetPixel($x, $y).ToArgb() -ne $even) { throw 'Wide overview changed the framing' }
                    if ($wideTop.GetPixel($x * 2 + 1, $y).ToArgb() -ne $even) { $extraDetail++ }
                }
            }
            if ($extraDetail -eq 0) { throw 'Wide overview contains no extra horizontal detail' }
            if ((Get-FileHash (Join-Path $output 'menu-bottom.bmp')).Hash -ne (Get-FileHash (Join-Path $output 'wide-menu-bottom.bmp')).Hash) { throw 'Display switch changed the lower viewport' }
            Write-Output "Wide pixels PASS: $extraDetail additional detail pixels; framing, lower viewport and information proportions preserved"
        } finally { $standardTop.Dispose(); $wideTop.Dispose() }
    }
    if ($Group -in @('Messages','Full')) {
        Add-Type -AssemblyName System.Drawing
        $wideInfo = [Drawing.Bitmap]::new((Join-Path $output 'wide-info-top.bmp'))
        try {
            if ($wideInfo.Width -ne 800 -or $wideInfo.Height -ne 240) { throw 'Wide information dimensions differ' }
            for ($y = 0; $y -lt 240; $y++) {
                for ($x = 0; $x -lt 400; $x++) {
                    if ($wideInfo.GetPixel($x * 2, $y).ToArgb() -ne $wideInfo.GetPixel($x * 2 + 1, $y).ToArgb()) { throw 'Wide information lost its physical proportions' }
                }
            }
        } finally { $wideInfo.Dispose() }
    }
    $timing.validation_ms = $stageClock.ElapsedMilliseconds
    $timing.status = 'passed'
    Write-Output "Menu $Model $Group PASS: $output"
} catch {
    $timing.error = $_.Exception.Message
    throw
} finally {
    if ($process -and !$process.HasExited) { Stop-Process -Id $process.Id }
    try {
        # Preserve failure evidence and stage times, not just successful runs.
        if (Test-Path -LiteralPath $log) {
            Copy-Item -LiteralPath $log -Destination (Join-Path $output 'fheroes2.log') -Force
            $report = Read-MenuLog
            if (!$timing.groups.Count) {
                foreach ($match in [regex]::Matches($report, '3DS TEST END group=(\w+) elapsed_ms=(\d+)')) {
                    $timing.groups += [ordered]@{ group=$match.Groups[1].Value; elapsed_ms=[long]$match.Groups[2].Value }
                }
            }
        }
    } finally {
        foreach ($path in @($marker,$selection)) { if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path } }
        [IO.File]::WriteAllText($config, $originalConfig)
        if ($null -ne $originalGameConfig) { [IO.File]::WriteAllText($gameConfig, $originalGameConfig) }
        elseif (Test-Path $gameConfig) { Remove-Item -LiteralPath $gameConfig }
        if (Test-Path -LiteralPath $recoveryPath) { Remove-Item -LiteralPath $recoveryPath }
        if ($timing.status -ne 'passed') { $timing[$activeStage] = $stageClock.ElapsedMilliseconds }
        Save-MenuTiming
    }
    Write-Output ("Timing ({0}): prepare={1}ms emulate={2}ms validate={3}ms" -f $timing.status,$timing.preparation_ms,$timing.emulation_ms,$timing.validation_ms)
}
