$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$fixture=Join-Path (Join-Path $root 'build') ('test-data-cache-'+[Guid]::NewGuid().ToString('N'))
$source=Join-Path $fixture 'original'
$target=Join-Path $fixture 'sd'
foreach ($directory in @('Data','Maps/nested','Tracks2')) { New-Item -ItemType Directory -Force (Join-Path $source $directory) | Out-Null }
[IO.File]::WriteAllText((Join-Path $source 'Data/heroes2.agg'),'fixture')
[IO.File]::WriteAllText((Join-Path $source 'Maps/nested/example.mp2'),'map-one')
[IO.File]::WriteAllText((Join-Path $source 'Tracks2/1-AudioTrack.ogg'),'track-one')
[IO.File]::WriteAllText((Join-Path $source 'Tracks2/readme.txt'),'not-a-track')
$script=Join-Path $root 'tools/prepare-game-data.ps1'
$first=@(& $script -OriginalGame $source -Destination $target)
$agg=Join-Path $target 'data/heroes2.agg'
$time=(Get-Item -LiteralPath $agg).LastWriteTimeUtc
[IO.File]::WriteAllText((Join-Path $target 'fheroes2.cfg'),'preserve-config')
[IO.File]::WriteAllText((Join-Path $target 'example.sav'),'preserve-save')
$second=@(& $script -OriginalGame $source -Destination $target)
if (!(($second -join "`n") -match 'copied=0 .*bytes=0 ')) { throw "Unchanged preparation recopied files: $second" }
if ((Get-Item -LiteralPath $agg).LastWriteTimeUtc -ne $time) { throw 'Unchanged asset timestamp changed' }
if (!(Test-Path (Join-Path $target 'music/Track01.ogg')) -or (Test-Path (Join-Path $target 'music/readme.txt'))) { throw 'Track mapping/filter changed' }
$map=Join-Path $source 'Maps/nested/example.mp2'
[IO.File]::WriteAllText($map,'map-two')
[IO.File]::SetLastWriteTimeUtc($map,[DateTime]::UtcNow.AddSeconds(2))
$third=@(& $script -OriginalGame $source -Destination $target)
if (!(($third -join "`n") -match 'copied=1 .*bytes=7 ')) { throw "Changed file was not updated alone: $third" }
if ([IO.File]::ReadAllText((Join-Path $target 'maps/nested/example.mp2')) -ne 'map-two') { throw 'Nested map not updated' }
foreach ($item in @(@('fheroes2.cfg','preserve-config'),@('example.sav','preserve-save'))) {
 if ([IO.File]::ReadAllText((Join-Path $target $item[0])) -ne $item[1]) { throw 'Preparation touched user state' }
}
. (Join-Path $root 'tools/menu-test-groups.ps1')
$historicalPath=Join-Path $root 'build/menu-tests/New/fheroes2.log'
$historical=if (Test-Path -LiteralPath $historicalPath) { [IO.File]::ReadAllText($historicalPath) } else { $null }
foreach ($group in $menuTestGroups.Keys) {
 $plan=(& (Join-Path $root 'tools/test-menu-emulator.ps1') -Group $group -PlanOnly) | ConvertFrom-Json
 if (@($plan.Groups).Count -ne 1 -or $plan.Groups[0] -ne $group) { throw "Group leaked into another: $group" }
 foreach ($marker in $plan.Markers) { if ($null -ne $historical -and $group -notin @('Building','Construction','HeroRecruit','CastleOptions','CastleArmy','CastleBuildings','CastleScreen','CastleStereo') -and !$historical.Contains($marker)) { throw "Full suite marker was changed/lost: $marker" } }
}
$full=(& (Join-Path $root 'tools/test-menu-emulator.ps1') -Group Full -PlanOnly) | ConvertFrom-Json
if (@($full.Groups).Count -ne 21 -or @($full.Markers).Count -ne 33) { throw 'Full suite lost checks' }
$default=(& (Join-Path $root 'tools/test-menu-emulator.ps1') -PlanOnly) | ConvertFrom-Json
if ($default.Group -ne 'Startup' -or $default.Groups.Count -ne 1) { throw 'Default is not a quick group' }
$rejected=$false
try { & (Join-Path $root 'tools/test-menu-emulator.ps1') -Group Typo -PlanOnly } catch { $rejected=$true }
if (!$rejected) { throw 'Invalid group accepted' }
$initialCount=[int]([regex]::Match(($first -join "`n"),'copied=(\d+)').Groups[1].Value)
$forced=@(& $script -OriginalGame $source -Destination $target -ForceCopy)
if (!(($forced -join "`n") -match "copied=$initialCount skipped=0 ")) { throw 'ForceCopy did not refresh all fixture assets' }
$first; $second; $third; $forced
Write-Output 'PASS: initial/incremental/changed data, nested maps, tracks, preserved saves/config, group isolation, original component markers and Building plus completion, quick default, invalid group rejection; no emulator launched'

