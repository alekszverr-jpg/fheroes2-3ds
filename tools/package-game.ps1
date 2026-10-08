$ErrorActionPreference = 'Stop'
$version = '0.3.8'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
& (Join-Path $PSScriptRoot 'build-game.ps1')
$staging = Join-Path $workspace ("build/packaging/$version-" + [Guid]::NewGuid().ToString('N'))
$package = Join-Path $staging 'fheroes2-menu-preview'
$app = Join-Path $package '3ds/fheroes2'
New-Item -ItemType Directory -Force $app | Out-Null
foreach ($name in @('fheroes2.3dsx','fheroes2.smdh')) { Copy-Item -LiteralPath (Join-Path $workspace "build/game/$name") -Destination $app -Force }
$data = Join-Path $app 'files/data'
New-Item -ItemType Directory -Force $data | Out-Null
Copy-Item -Path (Join-Path $workspace 'fheroes2/files/data/*.h2d') -Destination $data -Force
Copy-Item -LiteralPath (Join-Path $workspace '3ds-game/INSTALL_RU.md') -Destination (Join-Path $package 'INSTALL_RU.md') -Force
Copy-Item -LiteralPath (Join-Path $workspace '3ds-game/INSTALL.md') -Destination (Join-Path $package 'INSTALL.md') -Force
Copy-Item -LiteralPath (Join-Path $workspace 'fheroes2/LICENSE') -Destination $package -Force
Copy-Item -LiteralPath (Join-Path $workspace 'vendor/SDL2/LICENSE.txt') -Destination (Join-Path $package 'SDL2-LICENSE.txt') -Force
Copy-Item -LiteralPath (Join-Path $workspace 'vendor/SDL2_mixer/LICENSE.txt') -Destination (Join-Path $package 'SDL2_mixer-LICENSE.txt') -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'sdk-lock.json') -Destination $package -Force
$manifest = [ordered]@{
    port_version=$version; upstream='9754feff8501dbb69df95f3b999156a32eb8d7d3'
    sdl2='4c2d9014afda49553c76f7045529207bb593f9b5'; sdl2_mixer='8f0c805d54dbd1ff6b4b784d351ca884b8fe5ee9'
    binary_sha256=(Get-FileHash (Join-Path $app 'fheroes2.3dsx') -Algorithm SHA256).Hash.ToLowerInvariant()
    renderer='native RGBA8 framebuffer, 800x480 indexed game frame, 400x240 standard or optional 800x240 high-resolution 2D overview'
    native_messages='Common supported showMessage and chest gold/experience choice; native 400x240 information top, 320x240 answers bottom; remaining specialized dialogs retain original layouts'
    hardware_native_messages='0.3.3 pending physical validation; synthetic New/Old emulator checks are not full gameplay'
    emulated_native_messages='Russian New/Old and English New: top information, bottom OK, stylus NO, drag cancellation, long bottom/top scroll, nested resource information, viewport edge restoration and release isolation'
    native_chest_choice='Fixed Gold/Experience buttons, rewards and context; scrolling description; original true=gold/false=experience caller contract; L chooses experience'
    hardware_chest_choice='User reports Gold choice works on New 3DS XL; Experience and level-up not separately confirmed'
    native_level_up='Touchscreen: two secondary choices, one skill confirmation, primary-only; top skill descriptions; original caller grants upgrades'
    native_recruitment='Native 320x240 recruitment: quantity buttons/slider, D-pad, affordable maximum, optional downgrade variants, top creature information; unchanged caller payment/army placement'
    hardware_recruitment='Pending actual recruitment and resource/army checks on New 3DS XL'
    emulated_recruitment='Russian New/Old and English New: actual RecruitMonster, quantity/availability/rare-resource limits, touch/controller, slider, cancel/drag, nested top info, downgrade, empty treasury/dwelling, large quantities, Evil UI, unchanged funds/frame/viewport/strip'
    hardware_level_up='Pending real-match validation on New 3DS XL'
    emulated_level_up='Russian New/Old and English New: actual dialog, both slots and choices, upgraded skill, tap/controller, drag cancellation, nested descriptions, long name, Evil UI, unchanged hero/frame/viewport'
    high_resolution='R + Start; saved immediately; high-resolution default; Old 2DS or failed model query uses standard output'
    hardware_high_resolution='User reports substantial image-quality improvement on New 3DS XL; long-session performance unmeasured'
    emulated_high_resolution='New/Old: wide framebuffer pixels, extra horizontal detail, unchanged framing and lower viewport, information proportions, repeated switch inside dialog without answering'
    emulated_chest_choice='Russian New/Old and English New: actual SelectGoldOrExp, both rewards, D-pad, Escape, drag cancellation, nested gold/experience info, long text, Evil UI, unchanged hero/funds and frame/viewport'
    hardware_game_test='User reports AI turns, battle, save/load working on New 3DS XL; restart between save/load not specified'
    hardware_menu_test='0.2.0 menu and match reported on New 3DS XL; 0.2.1 stick follow confirmed; 0.2.2 stylus follow confirmed; 0.2.4 controls and 0.3.0 panel reported working on New 3DS XL; 0.3.1 strip reported working on New 3DS XL; 0.3.2 wide frame and D-pad pending hardware check'; emulated_menu_test='New and Old; original icon strip touch selection, disabled commands, hold info, drag cancellation and 200px viewport bounds, 800px frame edges, contextual D-pad hold/diagonal/release and real GameArea scrolling on synthetic map'; original_assets_in_archive=$false
}
$manifest | ConvertTo-Json | Set-Content (Join-Path $package 'build-manifest.json') -Encoding utf8

# A separate private SD staging tree contains only this user's local game resources.
$privateApp = Join-Path $workspace 'sdmc/3ds/fheroes2'
& (Join-Path $PSScriptRoot 'prepare-game-data.ps1') -Destination $privateApp
foreach ($name in @('fheroes2.3dsx','fheroes2.smdh')) { Copy-Item -LiteralPath (Join-Path $app $name) -Destination $privateApp -Force }
$privateConfig = Join-Path $privateApp 'fheroes2.cfg'
if (!(Test-Path $privateConfig)) { Set-Content -LiteralPath $privateConfig -Value "first time game run = off`nlang = ru`nmusic = external" -Encoding ascii }
Copy-Item -LiteralPath (Join-Path $workspace '3ds-game/INSTALL_RU.md') -Destination (Join-Path $workspace 'sdmc/INSTALL_RU.md') -Force
$packageLang = Join-Path $app 'files/lang'
New-Item -ItemType Directory -Force $packageLang | Out-Null
if (Test-Path (Join-Path $privateApp 'files/lang/ru.mo')) { Copy-Item -LiteralPath (Join-Path $privateApp 'files/lang/ru.mo') -Destination $packageLang -Force }
Set-Content -LiteralPath (Join-Path $app 'fheroes2.cfg') -Value "first time game run = off`nlang = `nmusic = external" -Encoding ascii
Compress-Archive -Path (Join-Path $package '*') -DestinationPath (Join-Path $workspace "dist/fheroes2-menu-preview-$version.zip") -Force

$source = Join-Path $staging 'fheroes2-menu-source'
New-Item -ItemType Directory -Force $source | Out-Null
foreach ($directory in @('3ds-game','3ds-platform-probe','cmake','tools')) { Copy-Item -LiteralPath (Join-Path $workspace $directory) -Destination $source -Recurse -Force }
foreach ($name in @('README.md','README_RU.md','CONTRIBUTING.md','LICENSE','.gitignore','.gitattributes')) {
    Copy-Item -LiteralPath (Join-Path $workspace $name) -Destination $source -Force
}
Copy-Item -LiteralPath (Join-Path $workspace 'patches') -Destination $source -Recurse -Force
$sourceEngine = Join-Path $source 'fheroes2'
New-Item -ItemType Directory -Force $sourceEngine | Out-Null
Copy-Item -LiteralPath (Join-Path $workspace 'fheroes2/src') -Destination $sourceEngine -Recurse -Force
foreach ($name in @('LICENSE','version.txt')) { Copy-Item -LiteralPath (Join-Path $workspace "fheroes2/$name") -Destination $sourceEngine -Force }
Set-Content -LiteralPath (Join-Path $sourceEngine 'upstream-revision.txt') -Value $manifest.upstream -Encoding ascii
$sourceFiles = Join-Path $sourceEngine 'files'
New-Item -ItemType Directory -Force $sourceFiles | Out-Null
foreach ($name in @('data','lang')) { Copy-Item -LiteralPath (Join-Path $workspace "fheroes2/files/$name") -Destination $sourceFiles -Recurse -Force }
$dependencySource = Join-Path $source 'dependency-sources'
New-Item -ItemType Directory -Force $dependencySource | Out-Null
foreach ($name in @('SDL2','SDL2_mixer')) {
    & git -C (Join-Path $workspace "vendor/$name") archive --format=tar "--output=$(Join-Path $dependencySource "$name.tar")" HEAD
    if ($LASTEXITCODE -ne 0) { throw 'Dependency source export failed' }
}
Copy-Item -LiteralPath (Join-Path $package 'build-manifest.json') -Destination $source -Force
Copy-Item -LiteralPath (Join-Path $workspace 'PORTING_PLAN_RU.md') -Destination $source -Force
Compress-Archive -Path (Join-Path $source '*') -DestinationPath (Join-Path $workspace "dist/fheroes2-menu-source-$version.zip") -Force
Write-Output "Menu preview package and source archive ready; private SD directory: $privateApp"
