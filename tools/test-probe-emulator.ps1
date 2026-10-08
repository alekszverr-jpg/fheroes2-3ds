param([ValidateSet('New','Old')][string]$Model = 'New', [int]$TimeoutSeconds = 60, [switch]$Engine)
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$emulator = Join-Path $workspace '.toolchain/azahar/azahar.exe'
$profile = Join-Path $workspace '.toolchain/azahar/user'
$config = Join-Path $profile 'config/qt-config.ini'
$application = if ($Engine) { 'fheroes2-engine-test' } else { 'fheroes2-probe' }
$testDirectory = if ($Engine) { 'engine-tests' } else { 'probe-tests' }
$sd = Join-Path $profile "sdmc/3ds/$application"
$output = Join-Path $workspace "build/$testDirectory/$Model"
if (!(Test-Path $emulator) -or !(Test-Path $config)) { throw 'Prepare the isolated portable Azahar profile first' }
# Terminate only the project-local emulator; preserve every other Azahar instance.
Get-CimInstance Win32_Process -Filter "name='azahar.exe'" | Where-Object { $_.ExecutablePath -eq $emulator } | ForEach-Object { Stop-Process -Id $_.ProcessId }
New-Item -ItemType Directory -Force $sd, $output | Out-Null
$originalConfig = [IO.File]::ReadAllText($config)
$isNew = if ($Model -eq 'New') { 'true' } else { 'false' }
$newConfig = [regex]::Replace($originalConfig, '(?m)^is_new_3ds=.*$', "is_new_3ds=$isNew")
$newConfig = [regex]::Replace($newConfig, '(?m)^is_new_3ds\\default=.*$', 'is_new_3ds\default=false')
[IO.File]::WriteAllText($config, $newConfig)
$log = Join-Path $sd $(if ($Engine) { 'results.log' } else { 'probe.log' })
if (Test-Path $log) { Move-Item -LiteralPath $log -Destination (Join-Path $output ("previous-" + [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss-ffff') + '.log')) }
$marker = Join-Path $sd 'selftest.enabled'
Set-Content -LiteralPath $marker -Value 'Emulator-only automated test' -Encoding ascii
$process = $null
function Read-TestLog {
    $stream = [IO.File]::Open($log, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $reader = [IO.StreamReader]::new($stream)
    try { return $reader.ReadToEnd() } finally { $reader.Dispose() }
}
try {
    $binary = Join-Path $workspace $(if ($Engine) { 'build/game/fheroes2-engine-test.3dsx' } else { 'build/probe/fheroes2-probe.3dsx' })
    $process = Start-Process -FilePath $emulator -ArgumentList ('"' + $binary + '"') -WindowStyle Hidden -PassThru
    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    $finished = $false
    do {
        Start-Sleep -Seconds 2
        if (Test-Path $log) { $finished = (Read-TestLog).Contains($(if ($Engine) { 'ENGINE SELFTEST:' } else { 'END normal exit' })) }
        if ($process.HasExited -and !$finished) { throw 'Emulator exited before test completed' }
    } while (!$finished -and [DateTime]::UtcNow -lt $deadline)
    if (!$finished) { throw "Emulator test timed out after $TimeoutSeconds seconds" }
    Copy-Item -LiteralPath $log -Destination (Join-Path $output 'probe.log') -Force
    if (!$Engine) {
        foreach ($name in @('top.bmp','bottom.bmp')) { Copy-Item -LiteralPath (Join-Path $sd $name) -Destination $output -Force }
    }
    $report = Read-TestLog
    if (!$report.Contains('SELFTEST: PASS') -or $report.Contains('FAIL')) { throw "Probe self-test failed; inspect $output" }
    $expectedModel = if ($Model -eq 'New') { 'MODEL new=1' } else { 'MODEL new=0' }
    if (!$report.Contains($expectedModel)) { throw 'Emulated model does not match requested model' }
    Write-Output "$application $Model emulator self-test PASS: $output"
} finally {
    if ($process -and !$process.HasExited) { Stop-Process -Id $process.Id }
    if (Test-Path $marker) { Remove-Item -LiteralPath $marker }
    [IO.File]::WriteAllText($config, $originalConfig)
}
