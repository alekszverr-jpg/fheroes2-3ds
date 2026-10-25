$ErrorActionPreference = 'Stop'
$version = '0.3.51'
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
    shared_review_fixes='Input/render separation; unified RenderEngine factory; required software cursor via Settings/config; named geometry/framebuffer validation; model error logging; null argv guard'
    hardware_shared_review_fixes='0.3.19 accepted by user on New 3DS XL without scenario breakdown; no physical Old 3DS'
    renderer='native RGBA8 framebuffer, 800x480 indexed game frame, 400x240 standard or optional 800x240 high-resolution 2D overview'
    illustrated_message_style='0.3.50: original Good/Evil frame, upper descriptions, lower static element rows and game buttons; independent bounded scroll, held information after text scrolling; passive/wide/animated layouts unchanged'
    validation_illustrated_messages='Elements New/Old ru and New en; Messages/Chest/LevelUp/BattleDialogs New ru; monitored short groups, ARM, five-file desktop syntax, 28 groups/40 markers and clean patch; real rewards and console pending'
    native_messages='Common supported showMessage and chest gold/experience choice; native 400x240 information top, 320x240 answers bottom; remaining specialized dialogs retain original layouts'
    hardware_native_messages='0.3.3 pending physical validation; synthetic New/Old emulator checks are not full gameplay'
    emulated_native_messages='Russian New/Old and English New: top information, bottom OK, stylus NO, drag cancellation, long bottom/top scroll, nested resource information, viewport edge restoration and release isolation'
    native_chest_choice='Fixed Gold/Experience buttons, rewards and context; scrolling description; original true=gold/false=experience caller contract; L chooses experience'
    hardware_chest_choice='User reports Gold choice works on New 3DS XL; Experience and level-up not separately confirmed'
    native_level_up='Touchscreen: two secondary choices, one skill confirmation, primary-only; top skill descriptions; original caller grants upgrades'
    recruitment_style='0.3.51: original Good/Evil frame and RECRBKG/BLDGXTRA cost card, upper base attributes/total costs/remaining balances, lower animated portrait/quantity/slider and inset original OK/Cancel, 128x38 touch targets and drawn variant arrows'
    validation_recruitment_style='Recruit New/Old ru and New en; Well/Messages/Elements New ru; bounded monitored groups, visible idle/large quantity/downgrade/rare resources/held scrolling/footer and outside release; physical readability and real hires pending'
    native_recruitment='Native 320x240 recruitment: quantity buttons/slider, D-pad, affordable maximum, optional downgrade variants, top creature information; unchanged caller payment/army placement'
    recruitment_portraits='104x90 original creature sprites and idle frames, fixed scale per variant; stylus/D-pad scrolling while portrait-held information is open; release closes without purchase'
    hardware_recruitment_feedback='User tested 0.3.8 on New 3DS XL: portraits too small and held tooltip could not scroll; other recruitment behavior reported working without scenario breakdown. 0.3.11 accepted on New 3DS XL without detailed scenario breakdown'
    marketplace_button_labels='0.3.23 centered by actual sprite dimensions and visible glyph bounds; pressed offset retained; hardware pending'
    grouped_validation='42 independent menu group/model/language combinations and New/Old engine checks passed; New Russian, Old Russian, New English; no monolithic Full run'
    grouped_host_peaks='Sampled Azahar process: 10.9 percent total CPU, 604.3MB working set, 1004.9MB private; previous freeze cause unresolved'
    native_castle_buildings='Army panel Buildings button; six built entries/page, dwellings first, upgrades/highest guild, original race drawing IDs, upper artwork/description/availability; same Castle::OpenDialog action dispatch'
    validation_castle_buildings='CastleBuildings New/Old Russian and New English plus CastleArmy New/Old passed; filters/six races/touch/controller/pages/hold/drag/scroll/SDL Y nested return and restoration; full castle action dispatch and gameplay effects pending hardware'
    emulated_guild_exit='MageGuild New/Old ru and New en; SystemExit and engine New/Old; CastleScreen/CastleStereo New; synthetic system-close events, real HOME close pending hardware verification'
    emulated_well='Well New/Old ru and New en: six races/upgrades, original populations, touch/controller, drag/hold, actual castle individual/all recruitment YES/NO, exact payment/population/army totals, visible idle, flat/stereo, Evil and restoration; Recruit/CastleScreen New regressions passed; physical full-army/guest/funds/save checks pending'
    emulated_tavern='Azahar 2126.2: Tavern New/Old ru and New en, original visible animation, rumor/language/source/funds/army/heroes readonly, explicit mixed-language fixture, bounded scroll/touch/controller/drag, actual flat/stereo castle return, Evil and restoration; Messages/CastleScreen New regressions; actual custom-map and hardware checks pending'
    emulated_thieves_guild='Azahar 2126.2: New/Old ru and New en; source counts 0-5, ties/order/active colors, hidden groups/stats/personality/monster omission, Oracle full, pages/disabled arrows/A/L/touch/drag, actual one-guild castle flat/stereo and Oracle dialog entry, Evil, readonly kingdoms/army/frame/context; CastleScreen New regression; real map/multiple guilds/hardware pending'
    native_thieves_guild='13 categories, original rank helpers/ties and active-player sources; original 0-5 guild disclosure gates, hidden data omitted, full Oracle report, original flags/portraits/icons, flat modal and city/map return'
    hardware_thieves_guild='0.3.40 pending New 3DS XL; previous 0.3.37-0.3.39 checks also open; no physical Old console'
    native_tavern='Original caller rumor/language and AnimationDialogElement frames/timing; upper normal-font text with bounded stylus/D-pad scroll, lower original scene and Exit; flat modal restores city'
    hardware_tavern='0.3.39 pending New 3DS XL; 0.3.37 guild/HOME close and 0.3.38 Well also pending; no physical Old'
    native_well='Six original creature icons/populations, large standing-idle portrait, statistics/growth/unit resource costs; original Castle recruitment/payment/placement and hire-all confirmation; flat full-screen panel and return'
    hardware_well='0.3.38 pending New 3DS XL; physical Old unavailable; 0.3.37 guild and real HOME close also pending'
    native_mage_guild='Original spell scrolls/artwork; built-level paging, library-aware spell lists, top descriptions/stylus scrolling and castle navigation; original caller book purchase/learning unchanged'
    system_close='aptShouldClose SDL_QUIT bypasses game confirmation; no rendering during shutdown/unwind; ordinary game quit hook preserved'
    hardware_guild_exit='0.3.37 pending New 3DS XL; user confirms marketplace 0.3.36 works, guild freeze in 2D/3D and HOME-close ARM11 crash; physical Old unavailable'
    emulated_castle_services='CastleScreen New/Old ru and New en: direct Construction and actual catalog cancel; full castle-market-return with markets=1; CastleStereo New/Old ru enters actual market; Market and Construction New regressions passed; reported hardware pre-market freeze not reproduced/fix unconfirmed'
    castle_service_handoff='0.3.36 direct Construction button; Income beside guest name; retain flat background between building chooser and service, restore stereo only on main-panel resume; detailed marketplace-entry diagnostics; hardware-only freeze not reproduced in Azahar and physical fix unconfirmed'
    native_castle_stereo='Experimental slider-controlled 400x240 per-eye town panorama; original sprite/animation/occlusion rendering with shared near architecture and flat terrain/bay; four conservative depth levels; 2DS exclusion, flat child upper dialogs, automatic restoration of saved wide/standard 2D preference'
    emulated_castle_stereo='CastleStereo New/Old ru and New en: six-race original-zero/distinct-eye/frame restoration, real eye buffers and source-pixel comparison allowing palette cycles, wide/standard/slider and flat-child/resume, actual castle Y/return, 2DS model exclusion; engine/Startup/CastleScreen New/Old and Messages New regressions passed; hardware stereo comfort pending'
    hardware_castle_stereo='0.3.35 pending New 3DS XL: visual comfort, all races, edges and completed-building/boat animation; no physical Old 3DS'
    native_castle_main='Direct native main view with animated original panorama, stone/beveled army trays, Buildings/Y, income, castle arrows and close; persistent modal background across original building handlers; original ArmyBar mutations; recruited guest appears immediately'
    emulated_castle_main='CastleScreen New/Old ru and New en passed: actual Castle::OpenDialog entry/exit and dwelling/construction cancellation, animation callback, navigation choice/disabled arrows, Evil UI and state restoration; CastleArmy New/Old and CastleBuildings New regressions passed; positive purchases/new guests/building fade/multi-castle gameplay require hardware'
    hardware_castle_main='0.3.34 pending New 3DS XL; physical Old unavailable'
    hardware_castle_buildings='0.3.33 pending New 3DS XL; no physical Old 3DS'
    upgrade_castle_buildings='From 0.3.32 replace 3dsx and files/lang/ru.mo for Buildings label'
    native_castle_army='Castle Y panel; original town snapshot above, garrison/guest slots and Details/Split/Hero/Back below; original ArmyBar transfers/split/card and last-hero-creature rules; main castle retains original layout'
    validation_castle_army='CastleArmy New/Old Russian and New English plus Army New passed; SDL Y dispatch, real ArmyBar moves/merge/swap, final hero and garrison creature rules, button/drag split/cancel, controller, card/hero/held/missing guest/Evil; creature conservation/funds/heroes/frame/viewport/modal/release; full real-map castle entry, positive upgrade/dismiss and persistence pending hardware'
    hardware_castle_army='0.3.32 normal overall operation reported on New 3DS XL on 2026-10-15; no scenario breakdown or physical Old 3DS'
    upgrade_castle_army='From 0.3.31 replace 3dsx only; translations unchanged'
    native_castle_options='Two original candidates, upper hero statistics/reason, native readonly hero details, captain-gated Spread/Grouped and Back to catalog; original GetRecruits/DialogBuyHero/RecruitHero/SetSpreadFormation in Castle'
    validation_castle_options='New/Old Russian and New English short groups passed; Construction and HeroRecruit New regressions passed; touch/controller/Y, missing candidates, captain gate, formation command return, readonly/hold/drag, Evil modal/frame/viewport/input restore; actual private-handler recruitment/formation effects and hardware pending'
    hardware_castle_options='0.3.31 pending New 3DS XL; no physical Old 3DS'
    upgrade_castle_options='From 0.3.30 replace 3dsx only; translations unchanged'
    native_hero_recruit='Original framed portrait, description/statistics/army above; opaque cost, treasury, reason and Recruit Hero/Cancel below; original AllowBuyHero checked before returning; caller payment/recruitment retained'
    validation_hero_recruit='Short HeroRecruit New/Old Russian and New English passed; real DialogBuyHero null/default/allowed/disabled, hero limit, drag/hold/nested/scroll/Evil restoration; unchanged funds/heroes; actual RecruitHero effects and hardware pending; no monolithic Full'
    hardware_hero_recruit='0.3.30 pending New 3DS XL; no physical Old 3DS'
    upgrade_hero_recruit='From 0.3.29 replace 3dsx only; translations unchanged'
    construction_arrows='Graphic arrows for pages/previous-next castles; font glyphs replaced; castle buttons 96px and Income 112px; Russian/English New Construction and visual captures passed; Old not rerun for this local sprite change'
    upgrade_construction_arrows='From 0.3.28 replace 3dsx only; translations unchanged'
    native_construction='Six original building icons per lower page; upper description/status/requirements; native confirmation; original eligibility, upgrades and purchase caller; native Options contains candidates/formation'
    validation_construction='Construction New/Old Russian and New English passed; Building New regression passed; selection/pages/nav/options/nested cancel/hold/drag/restoration; positive purchase, actual castle entry/income/recruitment/other races pending hardware; no monolithic Full'
    hardware_construction='0.3.28 accepted New 3DS XL with navigation arrow rendering issue; 0.3.29 pending; no scenario breakdown or physical Old 3DS'
    upgrade_construction='Replace 3dsx and Russian files/lang/ru.mo'
    native_building='Native dual-screen construction confirmation: original artwork/description/requirements above, opaque cost and Build/Cancel below; original eligibility rechecked on confirmation and payment handled by caller'
    validation_building='ARM/static checks and grouped New/Old Russian plus New English passed; actual BuildingInfo cancellation, synthetic allowed/disabled actions, drag, scroll, nested info, readonly, seven resources; actual payment/hardware pending'
    upgrade_building='Replace 3dsx and Russian files/lang/ru.mo for new labels'
    native_card_book='Opaque full-screen interactive creature background; wide Adventure/Combat text tabs in full spellbook, Y retained, total mana above; original single-category casting unchanged'
    emulated_card_book='Independent Army/Spellbook groups passed on New/Old Russian and New English; captures inspected; earlier freeze cause unresolved; no monolithic Full'
    hardware_card_book='0.3.26 pending New 3DS XL validation'
    upgrade_card_book='Replace 3dsx and Russian files/lang/ru.mo for category labels'
    native_hero='Top portrait/stats, lower Army/Artifacts/Skills tabs; original widget army and artifact actions, full book, readonly/dismiss/switch protections; editor uses legacy screen'
    emulated_hero='New/Old Russian and New English passed: real OpenDialog/widget moves/merges/swaps/splits, artifact/book actions, readonly, formation, navigation, dismissal result/protections, held info/tabs, nested restoration and large counts; actual castle upgrades/outer hero removal/save effects pending hardware'
    hardware_hero='0.3.25 accepted on New 3DS XL with lower creature background and tiny book tab issues; no scenario breakdown; no physical Old 3DS'
    upgrade_hero='Replace 3dsx and Russian files/lang/ru.mo for new short labels'
    native_resource_gift='Full lower recipients/resources/quantity/slider/send/cancel; top per-recipient gift and total balances; original next-day event and sender deduction handler'
    emulated_resource_gift='Russian New/Old and English New passed: multi-recipient budgets/reset, seven resources, gold steps/MIN/MAX/slider/controller, disabled/drag/cancel, signed limits, nested/Evil modal/frame/HUD/viewport/input; real caller cancellation; confirmed send and next-day event delivery not exercised by automated tests'
    hardware_resource_gift='0.3.24 accepted by user on New 3DS XL on 2026-10-13; individual cases not enumerated; no physical Old 3DS'
    native_marketplace='Full lower resource grids/quantity/slider/Trade/Gift/Exit; top exact quote/balances; original rates and game-dialog mutations; native gift dialog from 0.3.24'
    emulated_marketplace='Russian New/Old and English New passed: all rates at 1/3/9 markets; real Trading Post trades/rounding, slider/controller, disabled/drag cancellation, Gift dispatch and nested modal/Evil frame/HUD/viewport/input restoration; town entry/full gifting/surrender return pending hardware'
    hardware_marketplace='0.3.22 accepted by user on New 3DS XL on 2026-10-12; individual cases not enumerated; no physical Old 3DS'
    native_necromancy='Top original WINCMBT animation/message/skeleton count; full lower modal background and Okay; original raising calculations and army mutations remain with caller'
    emulated_necromancy='Azahar New/Old Russian and New English passed: dialog controls/counts/evil UI, real Arena animation and unchanged army/frame/HUD/viewport/actions; full battle raising and audio pending hardware'
    hardware_necromancy='0.3.21 accepted by user on New 3DS XL on 2026-10-11; individual cases not enumerated; no physical Old 3DS'
    native_battle_outcome='Native top original summary animation/outcome/experience/ransom and scrollable casualties; lower Okay/optional Restart; captured and ultimate-artifact notices with held B details'
    battle_report_layout='Full lower modal background; persistent D-pad scroll hint and directional arrows; proportional casualty icons in padded 36x32 cells; inset surrender portrait'
    native_surrender='Top opponent portrait/ransom/funds/shortfall, lower Accept/Marketplace/Decline; original AllowPayment and marketplace availability, refreshed after Marketplace game dialog; caller handles payment/battle completion'
    emulated_battle_outcome='Russian New/Old and English New: native summary Okay/Restart/cancel, long and empty losses, stylus scroll, drag cancellation; actual surrender affordable/unaffordable/cancel with unchanged funds; artifact held details; actual Arena outcome paths and restart with human fixture; marketplace trades separately exercised by 0.3.22; final caller payments/experience/artifact transfer not exercised'
    hardware_battle_outcome='0.3.17 New 3DS XL screenshots confirm result and surrender display; user requested layout fixes, 0.3.18 layout accepted by user on New 3DS XL without scenario breakdown; no physical Old 3DS'
    emulated_hero_actions='Touch/controller results, disabled actions, drag cancellation, Y closure and unchanged frame/viewport; actual Arena Y dispatch and HUD restoration; no real retreat/surrender or full hero-screen interaction exercised'
    native_hero_actions='Combat Y/click hero opens lower cast/retreat/surrender/close dock; Y/L close, disabled actions and original caller confirmations retained'
    native_adventure_spellbook='Original lower book artwork, 6 spells/spread, upper description; explicit confirm; ADVN casting and ALL readonly tabs via original bookmarks/Y; unchanged original caller execution and mana/movement rules'
    emulated_adventure_spellbook='Russian New/Old and English New: actual ADVN/ALL OpenSpellBook, scroll, choice/touch/controller, confirmation, pages/restoration, readonly Y/touch tabs, information, zero mana, movement/boat restrictions, bounded description scroll, empty/Evil UI, unchanged mana/movement/book/frame/context; actual map casting/world effects/caller payment not exercised'
    hardware_adventure_spellbook='0.3.20 pending New 3DS XL validation; no physical Old 3DS'
    native_combat_spellbook='CMBT-only original book artwork, two lower leaves with three spells each, costs/mana, explicit confirm and page controls; hero-aware top description/stylus scroll and held info; original learned spells/scrolls, costs, CanCastSpell and caller cast/target/payment rules'
    hardware_combat_spellbook='User broadly accepted 0.3.15 on New 3DS XL without individual scenario breakdown; 0.3.16 hero panel/artwork broadly accepted on New 3DS XL without individual scenario breakdown; no physical Old 3DS'
    emulated_combat_spellbook='Russian New/Old and English New: actual combat book learned spells/scroll filter, Snake-Ring cost bonus, touch/controller choice, explicit confirm, pages/restoration, cancel/button drag, scroll preserves selection, long real descriptions, nested/held info, readonly, zero mana, empty/missing book, Evil UI, unchanged hero/frame/context; real Arena callback and HUD restore; actual casting/target/payment/round not exercised'
    native_army_info='Native 400x240 top animated portrait/count, normal-font statistics, stack upgrade cost, properties and active spells; lower compact action dock over frozen detail, size follows available actions; original confirmations and caller contract'
    hardware_army_info='0.3.13 user reports remaining cases generally working on New 3DS XL; requests less empty lower layout/larger top statistics; 0.3.14 layout pending physical validation, Old hardware unavailable'
    emulated_army_info='Russian New/Old and English New: actual ArmyInfo upgrade/dismiss YES/NO, unaffordable, forbidden controls, no-upgrade layout, drag cancellation, held-stylus/D-pad scroll, synthetic battle bonuses/shots/health/effects, nested info and Evil UI; real Arena unit closes and restores HUD/frame/viewport/actions; caller payments/army mutations not exercised'
    native_army_split='Native 320x240 ArmySplitTroop: exact amount buttons/slider/D-pad and even 2-6 stack choices; original caller count/fast/slots contract and cancellation retained'
    hardware_army_split='0.3.12 user reports everything working on New 3DS XL; individual redistribution/last-creature scenarios not separately confirmed'
    emulated_army_split='Russian New/Old and English New: actual dialog, default/chosen fast slots, manual count, bounds, slider, cancellation/drag, large counts, Evil UI and unchanged frame/viewport/strip; caller army mutations not exercised'
    hardware_preview_0_3_11='User reports everything normal on New 3DS XL; no scenario breakdown or physical Old 3DS validation'
    native_battle_log='Full 320x240 lower-screen modal, raw wrapped entries, latest events first, stylus/D-pad scrolling, fixed close control and release isolation; original upper overlay disabled'
    hardware_battle_log='After 0.3.11 fixes the user reports everything normal on New 3DS XL; detailed scenario breakdown not provided'
    emulated_battle_log='New/Old Russian and New English: long/empty logs, latest/older/newer entries, D-pad/stylus, button drag cancellation, closure and unchanged game frame/viewport; actual battle-HUD log dispatch and input isolation'
    native_battle_hud='Original Auto/Settings/Skip icons and two padded single-line messages in a native 320x40 bottom HUD; old footer removed from game frame; original input handlers and battle geometry retained'
    hardware_battle_hud='0.3.11 accepted on New 3DS XL; detailed individual autocombat/spell/post-battle scenarios not separately reported'
    emulated_battle_hud='Real synthetic Arena: footer removed, native three-button/log mapping, original SKIP dispatch, native log dispatch, settings restore, hold information, drag cancellation and viewport/lifetime; not full battle gameplay'
    hardware_recruitment='0.3.8 user reports other recruitment behavior working on New 3DS XL without scenario breakdown; 0.3.11 accepted on New 3DS XL, scenario breakdown not provided'
    emulated_recruitment='Russian New/Old and English New: actual RecruitMonster, visibly animated enlarged portrait, independent held-stylus/D-pad scrolling and release isolation, quantity/availability/rare-resource limits, touch/controller, slider, cancel/drag, nested top info, downgrade, empty treasury/dwelling, large quantities, Evil UI, unchanged funds/frame/viewport/strip'
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
