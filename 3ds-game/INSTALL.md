# fheroes2 for Nintendo 3DS — preview 0.3.60

## Preview 0.3.60: folded scroll proportions

Fixed horizontally stretched folded Mage Guild scrolls: the original 61x79 TOWNWIND sprite is now proportionally fitted (47x62) and centred within its existing card, instead of stretched to 128x62. Touch targets and the remaining layout are unchanged. Bounded MageGuild runs passed New/Old Russian and New English; Good/Evil captures inspected. ARM build, desktop syntax, clean-baseline patch application and packaged binary identity passed. Full was not run. Replace only `3ds/fheroes2/fheroes2.3dsx`; visual validation on physical New 3DS XL remains pending.

## Preview 0.3.59: original-style Mage Guild

The Mage Guild now uses the accepted original Good/Evil frame on both screens. The lower panel retains the original open/sealed scroll artwork and proportionally fitted spell icons, with four inset cards, level indicator, castle arrows and separate level/Exit controls. The upper panel keeps the race-specific guild building and original spell description, with whole visible text rows and a dedicated scroll track/arrows. Frames, building artwork and scroll backgrounds are prepared once per panel.

Validation: bounded monitored Azahar runs passed MageGuild New/Old Russian and New English, plus CastleScreen and CastleStereo New Russian. Checks cover all six races/built levels/library slots, original spells and unchanged funds, touch castle navigation/Exit, controller selection, exact stylus and D-pad scrolling of a real long spell description, rejected outside release/footer/Close drag, Evil and actual flat/stereo castle return. Captures inspected; ARM build, desktop syntax, 28-group/41-marker infrastructure and clean-baseline patch application passed. Full was not run.

Replace only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL check spell selection, Y/level arrows, long descriptions, library/empty slots, town navigation and return to the panorama/3D. Real hero spell learning and previously outstanding hardware cases remain separate manual checks.

## Preview 0.3.58: original-style tavern

The tavern now uses the accepted original Good/Evil frame on both screens. Its original animated scene fills the lower picture viewport, with a centred inset Close control and separate 128x38 touch target. The upper rumor uses themed paper, whole visible rows and scroll track/arrows. Page movement follows complete rows so paging does not skip the row hidden at the viewport edge. The original AnimationDialogElement, delay, rumor text and optional rumor language are unchanged; short, long, empty and mixed-language content keep their source semantics.

Validation: short monitored Azahar 2126.2 MXE runs passed Tavern New/Old Russian and New English, plus CastleScreen and Messages New Russian. Tests cover visible original animation, real rumor/source/language preservation, A/L/touch closure, close drag cancellation, outside release/footer rejection, line/page/stylus scrolling with bounds and whole-row paging, empty/mixed-language text, Evil, and actual castle flat/stereo entry/return. Funds, heroes, army, rumor, frame and modal/input context remain unchanged. Captures inspected; ARM build, desktop syntax of the changed file, 28-group/41-marker infrastructure and clean-baseline patch application passed. Full was not run.

Replace only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL check scene animation/readability, long-rumor scrolling, Close and return to the town/3D. Explicit mixed-language coverage is a synthetic fixture; real custom-map rumor language remains a manual check. Earlier outstanding hardware cases remain separate.

## Preview 0.3.57: original-style castle options

Castle options now use the accepted original Good/Evil frame on both screens. Candidate portraits grow from 80x74 to a proportionally fitted 91x84 inside inset cards; formation, Back and Details controls have separate 128x28 touch regions within the frame. Action labels fit without truncation. Empty cards no longer show a selected-candidate highlight. The upper screen retains the original hero portrait, class/level/stats and the source recruitment/formation reason. Missing candidates, no captain and insufficient funds have dedicated validation captures.

Selection returns the same candidate pointers and Spread/Grouped/Close actions. Captain gating, formation application and real hero recruitment/payment remain in the original castle caller. Touch-up checks the final position, rejecting an outside release or footer tap. Upper panorama/stereo and the 0.3.56 halfling/animation fixes are preserved.

Validation: short monitored Azahar 2126.2 MXE runs passed CastleOptions New/Old Russian and New English, plus HeroRecruit, Construction, CastleScreen and CastleStereo New Russian. Checks cover first/second touch/Y/controller choice, empty/single candidates, no captain, formation actions, readonly hero/held information, drag/footer/outside release, touch Back, funds reason, Evil and restored funds/heroes/formation/frame/context. CastleScreen also exercises the actual main castle -> construction -> options -> Back -> construction -> town return. Captures inspected; ARM build, two-file desktop syntax, 28-group/41-marker infrastructure and clean-baseline patch application passed. Full was not run.

Replace only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL check candidate/Details/held information, captain/no-captain formations, actual formation application and hero hire/payment, Back and return to the town/3D. Synthetic options tests preserve funds and formation; they do not establish those gameplay effects on hardware.

## Preview 0.3.56: construction styling and readable halfling portraits

Construction now uses the accepted Good/Evil frame with six original building cards, inset page/options/exit controls, wide castle-switch buttons and a compact income button. Upper artwork, condition/requirements and descriptions use whole text rows, a separate footer and visible scroll track/arrows. Source BuildingInfo/CheckBuyBuilding and the caller still own availability, confirmation, payment and building application; the catalog preserves its action contract. Outside release uses the actual final stylus position.

The tiny held battle halfling was reproduced: its 278x99 standing sprite contains isolated opaque pixels far from the creature. Portrait scaling now uses the largest connected opaque body component (with a small margin) only when the canvas exceeds twice that component's dimensions. Ordinary body bounds are retained otherwise. Original frames, random selection, offsets and 150 ms timing are unchanged. Clipped nearest-neighbour sampling produces only the visible viewport, avoiding a large temporary image for padded frames. A held battle-halfling fixture and a minimum visible-height check cover the regression; the original animation comparison now covers five creatures and both death policies, 400 frames each (4000 steps).

Validation: short monitored Azahar 2126.2 MXE runs passed Construction, Army and Recruit on New/Old Russian and New English, plus Well, CastleScreen and CastleStereo New Russian. The long-scroll case uses the mage-guild description in both languages. Checks cover pages/options, single/multiple-castle navigation, nested purchase cancellation/held info, drag/outside release, scrolling, Evil, readonly held halfling and unchanged funds/frame/context. Original sequence/timing tests pass; captures inspected. ARM build, three-file desktop syntax, 28-group/41-marker infrastructure and clean-baseline patch application passed. Full was not run. Synthetic construction tests preserve funds and do not confirm real building application; real construction/payment and held-halfling appearance remain hardware checks.

Replace only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL check the held battle halfling, original animation, construction paging/requirements/options/income/castle navigation, actual purchase/payment and town return. User reports broad success with 0.3.55 without individual scenario results; earlier open hardware cases remain separate.

## Preview 0.3.55: original-style castle army panel

The main castle garrison/visiting-hero panel and the standalone army panel now use the accepted original Good/Evil lower frame. Five slots per row remain, with compact original creature icons, recessed trays and full counts. Oversized count text scales proportionally inside its strip instead of using an ellipsis. Headings, castle arrows, income and two action rows have separate inset touch regions. Construction receives extra width so localized action labels remain complete; smoke checks enforce label fit and button/frame bounds.

ArmyBar still owns transfer, merge, swap, last-hero-creature protection and manual/drag splitting. Details, hero information, buildings, construction, income and castle navigation preserve their action identifiers. Touch-up checks the actual release point, preventing an outside release/footer tap from opening construction. Upper town/panorama/stereo painting is unchanged; a normal static-town upper snapshot matched 0.3.54 pixel-for-pixel.

Validation: short monitored Azahar 2126.2 MXE runs passed CastleArmy and CastleScreen New/Old Russian and New English, plus CastleBuildings, CastleStereo and Well New Russian. Cases cover original ArmyBar actions/conservation, nested details/hero/split cancel, missing hero, four-billion count, Evil, Y/catalog return, construction, previous/next/single-castle gating, footer/outside release and restored funds/heroes/frame/context. Well checks retain exact individual/Max payment/population/army totals. Captures inspected; ARM build, two-file desktop syntax, 28-group/41-marker infrastructure and clean-baseline patch application passed. Full was not run. Replace only `3ds/fheroes2/fheroes2.3dsx`; on New 3DS XL verify readability/touch, real transfers/splits, castle arrows, construction/catalog and stereo return. Hardware checks remain separate.

## Preview 0.3.54: original-style built-building catalog

The built-building catalog now uses the accepted Good/Evil game frame: six original building thumbnails below, selected artwork and description above. Paging arrows, OK and Back sit inside the lower frame with separate inset touch targets. The page number appears in the heading. Upper text has a separate position indicator and visible scroll track/arrows, keeping the footer clear. Text is shown in whole rows at the viewport edges. Touch-up now checks the actual release position, so releasing outside an action does not open a building.

Building ordering/filtering and action identifiers remain unchanged: upgraded dwellings, highest mage-guild level and built-only actions still use the original castle dispatch. This iteration styles the catalog; the main garrison/hero control panel keeps its current layout. Town panorama and stereo rendering are unchanged. Replace only `3ds/fheroes2/fheroes2.3dsx`.

Validation: short monitored Azahar 2126.2 MXE runs passed CastleBuildings New/Old Russian and New English, plus CastleArmy, CastleScreen and CastleStereo New Russian. Tests cover race-specific mappings, filters/empty state, touch/controller selection, pages/disabled previous arrow, hold/drag/footer/outside-release rejection, long text scroll, nested information, Evil, Y/army return and unchanged funds/garrison/frame/context. Captures inspected; ARM build, desktop syntax of the changed file, 28-group/41-marker infrastructure and clean-baseline patch application passed. Full was not run. On New 3DS XL check paging/readability/holding and real entry/return from several building actions; actual building gameplay and earlier open hardware checks remain separate.

## Preview 0.3.53: original-style well and original creature animation

The well now uses the accepted original Good/Evil frame, inset actions and a six-creature grid. Its upper screen retains a large selected-creature portrait, original population/growth/stat sources and proportionally scaled unit-cost icons. The lower screen keeps selection, individual recruitment and Max; long names fit their available space, with the selected creature's full title above. Empty/unbuilt states remain disabled as before.

Recruitment, interactive army cards and the well now share the upstream RandomMonsterAnimation implementation and CASTLE_UNIT_DELAY (150 ms), replacing the custom standing/idle loop. Original movement, melee, ranged and idle selection/return offsets are used. Army cards retain upstream hit/death animations; the well and animated recruitment use the no-death well policy. Upstream recruitment itself is static; the port deliberately keeps its accepted animated portrait. Readonly/held army cards stay static as upstream. Scale/anchor are based on the standing body and remain fixed across all reachable frames. Wide attacks/flight frames are clipped to the portrait viewport, keeping creatures readable and neighbouring text clear. All idle variants are included in bound checks. The native viewport still scales the original sprites; this is not a pixel-identical desktop layout.

Validation: monitored short Azahar 2126.2 MXE runs passed Recruit, Well and Army on New/Old Russian and New English, plus CastleScreen, CastleStereo, CastleArmy and BattleDialogs New Russian. A required portrait check compares 400 frames and offsets per creature for four creatures and both death policies against the upstream class with identical RNG seeds (3200 steps), tests timing, fixed bounds, readonly and mirror/reflection drawing. Measurement initially consumed a random idle choice; the comparison caught it, and raw idle enumeration removed the RNG side effect. Capture fixtures select a reproducible original animated sequence and restore RNG state; production selection remains untouched. Well tests cover all six races/upgrades, large creature/long castle name, drag/hold/footer rejection, visible animation, exact individual/Max payment/population/army totals and flat/stereo return. ARM build, four-file desktop syntax, 28-group/41-marker infrastructure and clean-baseline patch application passed. Full was not run.

Replace only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL leave portraits open to check the varied animation, fixed scale and readability; test Well individual/Max hiring, exact payment/population/army changes, cancellation and town return. Emulator checks do not replace hardware validation.

## Preview 0.3.52: original-style army cards and split controls

Army information and splitting now use the accepted original Good/Evil frame. Cards keep the creature portrait, stats, upgrade costs, properties and battle effects above; the lower screen has a heading and inset action buttons. The upper content viewport reserves a separate footer for its position indicator, with a visible right-hand scroll track and arrows. Held/noninteractive cards retain their original close and scrolling behaviour; interactive portraits keep their current idle animation.

Split controls now sit inside the frame: quantity and slider, optional multi-slot distribution, and original inset OK/Cancel buttons with separate 128x38 touch targets. Manual and fast splitting preserve their caller contracts, including zero redistribution and large counts. Only `3ds/fheroes2/fheroes2.3dsx` needs replacement.

Validation: short monitored Azahar 2126.2 MXE runs passed Army New/Old Russian and New English, plus CastleArmy, BattleDialogs and Recruit New Russian. Tests cover upgrade/dismiss YES/NO, unaffordable/forbidden actions, nested information, held scroll, battle stats/effects, quantity/slider/manual/fast slots, large/zero cases, drag/footer rejection, Evil and unchanged caller values/troop/frame/context. Captures inspected; ARM build, two-file desktop syntax, 28-group/40-marker infrastructure and clean-baseline patch application passed. Full was not run. On New 3DS XL verify readability/scrolling and actual upgrade payment, dismissal and redistribution from hero/castle armies; emulator dialog tests do not confirm those gameplay effects on hardware.

## Preview 0.3.51: original-style recruitment

Recruitment now uses the accepted original Good/Evil frame on both screens and the original RECRBKG/BLDGXTRA cost card. The lower screen keeps the animated creature portrait, unit price, availability, quantity controls, slider and original inset OK/Cancel buttons with separate 128x38 touch targets. Variant controls draw actual arrows. The upper screen shows base creature attributes, total resource costs and the current-minus-cost balance. Portrait scale stays fixed across idle frames; holding/B retains the original information and scrolling behaviour.

Update only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL check portrait readability, quantities/slider, downgrade variants and cancel; perform a real hire and confirm exact payment, dwelling decrease and army placement. The dialog continues to return the selected troop; the original caller applies payment/army changes.

Validation: short monitored Azahar 2126.2 MXE runs passed Recruit New/Old Russian and New English; Well, Messages and Elements New Russian. Recruit covers visible idle, affordable/available/rare-resource limits, 100000000 quantity, buttons/slider, disabled/empty cases, downgrade gating, held information with stylus/D-pad scroll, outside/footer/drag rejection, Evil and restored funds/frame/viewport/strip. Old test coordinates for the slider endpoint and cancel button were updated after two bounded diagnostic failures; neither deadline was increased. ARM build, five-file desktop syntax, 28-group/40-marker infrastructure and clean-baseline patch application passed. Full was not run. Real hire effects and physical readability remain hardware checks.

## Preview 0.3.50: original-style illustrated messages

Response messages containing supported static game elements now use the accepted original frame: descriptions on the upper screen, resource/artifact/spell/stat icons and original response buttons below. Icon rows and long descriptions scroll within their own bounds; controls stay fixed. Held icons and B retain nested original information, including after text scrolling. Good/Evil backgrounds are opaque. Information-only messages, wide passive artwork and animations keep their existing layout.

Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. On New 3DS XL check resource/artifact/spell notifications, holding icons, long descriptions and return to the map. The original caller still applies rewards; actual resource/artifact/spell grants remain manual gameplay checks.

Validation: short monitored Azahar 2126.2 MXE runs passed Elements New/Old Russian and New English, plus Messages, Chest, LevelUp and BattleDialogs New Russian. Cases cover mixed rows, long descriptions, held information after scrolling, negative responses, release outside targets, Evil and unchanged caller funds/experience/frame/context. Captures were inspected. ARM build, five-file desktop syntax, 28-group/40-marker infrastructure and clean-baseline patch application passed. Full was not run; physical readability and actual rewards are pending.

## Preview 0.3.49: original-style plain confirmations

Plain response dialogs without illustration elements now use the accepted flat BUYBUILD/BUYBUILE frame, opaque themed paper/grey background and original localized game buttons. OK, Cancel, OK/Cancel and Yes/No are supported. Short text blocks are vertically centred in the content area; long text scrolls with fixed controls and a visible position indicator. Single buttons are centred; paired buttons share the inset centres and separated large touch targets. Shadows and focus follow the visible buttons. Text and actions stay on the lower screen; the upper game view keeps its existing behaviour. Information-only and illustrated-message layouts retain their current paths.

Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. A/Start, left/right, L, stylus and display-mode chords retain their response semantics. Dragging, releasing outside the target or tapping the lower ornament does not confirm. On New 3DS XL check acknowledgement, both response choices, cancellation from the in-game quit prompt and long descriptions. Real HOME-close behaviour remains a separate outstanding hardware check.

Validation: short monitored Azahar 2126.2 MXE runs passed Messages New/Old Russian and New English, plus Chest, LevelUp, BattleDialogs and SystemExit New Russian. Tests cover button sets, centred single controls, touch/controller selection, negative responses, outside/footer/drag rejection, text scrolling, Evil UI, display chords, illustrated nested-information regression and restored frame/context. Captures were inspected. ARM build, four-file desktop syntax, 27-group/39-marker infrastructure and clean-baseline patch application passed; Full was not run. The first final Messages attempt reached game PASS/normal exit but failed the runner's 5-second emulator-stop wait. The monitor then encountered an already-exited PID during cleanup. Its ignored local cleanup was made tolerant of that race; an isolated retry and the subsequent bounded sequence passed. The cause of the initial stop delay is not established; no game pass markers or shutdown assertions were suppressed.

## Preview 0.3.48: original-style level-up panels

Level-up now uses the accepted dual-screen game frame for all three cases: two secondary skills, one available secondary skill, or primary-stat growth alone. Hero/growth information appears above; original skill cards, readable normal-font names and Learn/OK controls appear below. Cards, names, buttons and held-information targets share aligned centres. A sole card and its confirmation are centred. Long text scrolls while the controls remain fixed; held cards/B open the original descriptions.

The original caller still grants attributes and skills. Two-option selection cannot be cancelled with L; a single informational confirmation keeps its previous acknowledgement behaviour. Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. On New 3DS XL check skill choice/upgrade, held information, actual post-confirmation learning/stat growth and single/primary-only notices when available. This is visual/input work; earlier outstanding hardware checks remain separate.

Validation: short monitored Azahar 2126.2 MXE runs passed LevelUp New/Old Russian and New English, plus Chest and Messages New Russian. Tests cover all three cases, centred single/primary touch confirmation, both choice buttons, D-pad, ignored L in two-choice mode, drag/release-outside rejection, nested information, forced long-name scrolling, Evil UI, unchanged hero stats/skills/experience and restored frame/context. The long-name fixture was expanded because its previous length now fits the larger upper viewport. Captures were inspected; chest snapshots match 0.3.47 pixel-for-pixel. ARM build, four-file desktop syntax, 27-group/39-marker infrastructure and clean-baseline patch application passed; Full was not run. Real caller-side learning/growth and console readability still require hardware testing.

## Preview 0.3.47: aligned chest reward columns

Gold/experience icons, reward amounts, treasury/level details and held-information targets now share the same centre coordinates as their inset buttons. Each reward is a single aligned column; visual elements and input regions use one shared position function.

Update only `3ds/fheroes2/fheroes2.3dsx`. Chest passed short monitored Azahar checks on New/Old Russian and New English, including held information and both reward branches. Captures, ARM build, desktop syntax and clean-baseline patch application passed. Full was not run; physical appearance/input and actual reward application remain console checks.

## Preview 0.3.46: inset chest buttons

Both reward buttons move 8 pixels toward the centre, adding space between their faces and the side frame. Shadows, focus and touch targets follow the buttons. Touch targets remain 128×48 pixels with a 16-pixel gap between them.

Update only `3ds/fheroes2/fheroes2.3dsx`. Chest passed short monitored Azahar checks on New/Old Russian and New English; captures were inspected. ARM build, desktop syntax and clean-baseline patch application passed. Full was not run. Console appearance/touch and actual reward application remain manual checks.

## Preview 0.3.45: original-style dual-screen treasure chest

The chest description now occupies the upper screen in the accepted flat game frame. The lower screen keeps original gold/experience icons, large reward amounts, current treasury/experience-needed details and clearly labelled Gold/Experience buttons. Both backgrounds are opaque. Icon scaling is bounded to leave separate space for values, details and buttons. Large touch targets, focused selection, held-icon information, D-pad selection and stylus/D-pad text scrolling remain available. The original caller still awards rewards: L keeps the existing experience branch, and A/Start confirms the focused choice.

Frame/paper rendering was moved into a shared 3DS style module, reused by chest, shipyard and building purchase. Other message and level-up layouts retain their current paths. Updating requires only `3ds/fheroes2/fheroes2.3dsx`; no translation change. On New 3DS XL check both rewards and their actual application, held information, long descriptions, large amounts, controller/stylus selection and return to the adventure map. Visual approval of 0.3.44 building purchase is recorded separately from functional hardware checks.

Validation: short monitored Azahar 2126.2 MXE runs passed Chest New/Old Russian and New English, plus LevelUp, Messages, Building and Shipyard New Russian. Checks preserve reward branch selection, nested information, scrolling, drag rejection, release outside targets, inactive footer, uint32 maximum amounts, Evil UI and unchanged hero experience/treasury/frame/context. Chest captures were inspected. Shipyard and building captures match their accepted appearances pixel-for-pixel. ARM build, desktop syntax for four files, 27-group/39-marker infrastructure and clean-baseline patch application passed; Full was not run. Physical reward application/readability and earlier outstanding hardware scenarios remain manual checks.

## Preview 0.3.44: original-style building purchase

Building confirmation now shares the accepted flush BUYBUILD/BUYBUILE frame, opaque themed paper/grey background, original OK/Cancel buttons, shadows, gold focus and enlarged touch targets with the shipyard. The upper screen shows the original BLDGXTRA card with the supplied building artwork/name at 1.25× scale and normal-font description/requirements. Long content scrolls with stylus or D-pad and shows its position. The lower screen centres the original resource order in one or two rows, including all seven resources, with larger amounts. Frame/background composition is cached for the dialog. Information-only windows retain the existing common message path.

Update only `3ds/fheroes2/fheroes2.3dsx`; no translation changes. Eligibility still uses the supplied castle callback and the original caller performs construction/payment. Cancel stays selected by default. On New 3DS XL check different races/buildings, requirements and scrolling, allowed/blocked confirmation, touch/controller cancellation and actual construction/payment/return to the castle. The user accepted the 0.3.43 shipyard appearance; this does not confirm previously pending hardware purchase or other service scenarios.

Validation: short monitored Azahar 2126.2 MXE runs passed Building New/Old Russian and New English, Shipyard New Russian and Construction New Russian. Checks cover original-entry cancellation, actual castle price preview, seven-resource layout, disabled touch/controller, default cancellation, enlarged targets, release outside, drag cancellation, nested information, bounded D-pad/stylus scrolling, Evil UI and frame/context/input restoration. Building captures were inspected; shipyard captures match accepted 0.3.43 pixel-for-pixel. ARM build, three-file desktop syntax, 27-group/39-marker infrastructure and clean-baseline patch application passed. Full was not run. Actual map construction/payment and physical readability still require hardware validation.

## Preview 0.3.43: flush shipyard upper frame

The protruding crest is removed on both screens. An uninterrupted rail made from original BUYBUILD/BUYBUILE flat sections and corners now meets the upper screen edge. The lower ornament, themed texture, original buttons and enlarged touch targets remain. Titles and the boat/cost group move upward to use the reclaimed space. No input or purchase rules changed.

Update only `3ds/fheroes2/fheroes2.3dsx`. Shipyard passed short monitored Azahar runs on New/Old Russian and New English; Building New Russian regression, ARM build, desktop syntax and clean-baseline patch application passed. Good/Evil and localized captures were inspected; before/after images were retained locally. Full was not run. Physical appearance/touch and real coastal purchase/payment/2D–3D return still need New 3DS XL checks; earlier pending hardware scenarios remain open.

## Preview 0.3.42: original-style shipyard prototype

The shipyard now uses the original BUYBUILD/BUYBUILE frame and parchment/grey background instead of a stone sheet and a plain outline. Decorative corners, central flourishes and jewels retain their pixel proportions; small plain border/background sections extend to each screen. The original boat is displayed at 2× scale with transparency preserved. The lower screen groups the original wood/gold cost, larger quantity labels and localized game OK/Cancel buttons with their shadows and pressed/disabled states. Gold focus marks the controller selection; invisible 128×44 touch targets surround the smaller visible buttons. The backgrounds are fully opaque and composed once per dialog. Other panels retain their previous styling while this prototype awaits feedback.

Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. A selects the focused button, left/right changes focus, L cancels; Cancel remains the default. Taps confirm, dragging or releasing outside a target does not, and the decorative footer is inactive. Original eligibility, payment and map placement remain in the castle caller. On New 3DS XL check visual quality/readability, touch/controller actions, actual boat purchase/payment, unavailable purchase and return to the town in 2D/3D. Hardware checks for 0.3.37–0.3.42 remain pending.

Validation: Shipyard New/Old Russian and New English, plus Building and CastleScreen New Russian, passed short monitored Azahar 2126.2 MXE runs. Original-dialog reference, before/after, Good/Evil, pressed/disabled and localized captures were inspected. Added checks cover enlarged targets, release outside without a motion event, inactive footer and opaque backgrounds. Existing confirmation/cancellation, nested modal, frame/funds/context and input-release checks remain. ARM build, three-file desktop syntax, 27-group/39-marker infrastructure and clean-baseline patch application passed. Full was not run. Actual coastal purchase/map placement and physical readability still need console testing. The legacy reference is a read-only reconstruction using the original dialog drawing calls/resources, not an emulator interaction with its old event loop.

## Preview 0.3.41: native shipyard

Ship purchase now uses both screens: original ship artwork above, the original resource cost and Build/Cancel controls below, with opaque stone backgrounds. D-pad left/right selects a button, A activates it, L cancels; stylus taps work and dragging does not confirm a purchase. Cancel is selected by default. The existing castle caller still decides whether purchasing is allowed and performs the payment and boat placement; the native window only returns the original confirmation/cancellation result. Desktop layout is unchanged.

Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. On New 3DS XL check castle → Buildings → Shipyard, purchase with sufficient resources, cancellation, insufficient resources, an occupied landing area, the resulting boat/payment, and return to the town in 2D/3D. Hardware validation of 0.3.37–0.3.41 remains pending; further stereo experiments remain deferred.

Validation (2026-10-24, Azahar 2126.2 MXE): Shipyard passed New/Old Russian and New English; Building and CastleScreen New Russian regressions passed in short monitored runs. Checks cover the original Dialog::BuyBoat entry, enabled/disabled touch and controller confirmation, default/touch/L cancellation, drag cancellation, Evil UI, nested modal restoration, unchanged funds/frame/context and input release. Captures were inspected. ARM build, desktop syntax for three affected files, 27-group/39-marker infrastructure and clean-baseline patch application passed. Full was not run. The synthetic castle has no sea access and automatically removes its shipyard, so these checks do not exercise a real coastal castle purchase or map placement; those remain manual hardware checks.

## Preview 0.3.40: native Thieves Guild and Oracle

The lower screen presents 13 categories over four pages with arrows and Exit. The upper screen shows the selected ranking with original flags, best-hero portraits/statistics, personalities or strongest-creature icons. Tied players share one rank; flags wrap at three players so color names remain readable. Original artwork, stone textures and localized labels are retained with full opaque backgrounds. D-pad up/down moves focus, left/right changes pages, Y cycles pages, A activates a choice/control and L exits. Stylus selects; dragging off Exit does not activate it.

Original information thresholds remain: towns/castles/heroes and hero portraits always; gold, wood/ore and hero statistics at two guilds; rare resources, obelisks and personalities at three; artifacts, army strength and strongest monsters at four; income at five. Locked values are omitted from the UI model, and no original-hidden numeric totals or extra hero details are added. Ranking order and ties reuse the original helpers; actual active players and owned guild count use the original sources. Oracle uses the same flat layout with the full original report. Closing returns to the panorama/map.

Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. Physical New 3DS XL checks remain pending: categories/pages, ties/multiple players, actual 1–5 owned guilds, hero portraits, flat/stereo return and Oracle map entry. Physical guild/HOME-close, Well and Tavern checks from 0.3.37–0.3.39 also remain open; no physical Old console is available. Further stereo experiments remain deferred.

## Preview 0.3.39: native Tavern and rumor reading

The Tavern now has a dedicated two-screen layout: the upper screen shows its heading and normal-font rumor text; the lower screen shows the original animated scene and a large Exit button. The original AnimationDialogElement supplies unchanged frames and timing; the scene fits proportionally and stone backgrounds fill both screens. Long rumors show a scrollbar. Drag vertically over the scene to scroll the upper text; D-pad up/down moves by lines, left/right by pages. A/L or Exit closes; dragging off Exit does not activate it.

Castle::_openTavern still obtains the current world rumor once and builds the original MultiFontText with its language. The adapter only displays that text and animation; rumor selection, weekly state, funds, army and heroes are unchanged. The window stays flat and returns to the town panorama. Thieves Guild and other remaining specialized city windows are follow-ups; further stereo-depth work remains deferred.

Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. Hardware checks are pending: Tavern animation, long/custom rumors, scroll and flat/stereo return. Physical guild/HOME-close/Well validation from 0.3.37–0.3.38 is also still pending; physical Old hardware is unavailable.

## Preview 0.3.38: native Well and town recruitment

The Well now owns both native screen images instead of drawing beneath the persistent castle panel. The lower screen shows six original creature icons, available populations and Recruit/Max/Exit. The upper screen shows a large standing/idle portrait from original frames, normal-font statistics, growth and per-creature resource costs. Built/upgraded dwellings are respected; growth matches the original Well, including the Well and first-tier special growth building. Exact original portrait animation behavior remains a future task.

D-pad selects cards/buttons, A opens selected recruitment, Y opens the original hire-all confirmation and L exits. Tap another creature to select; tap the selected creature to recruit. Dragging/long holds do not activate. Empty/unbuilt recruitment and hire-all with no creatures are disabled. Original Castle recruitment and hire-all handlers retain payment, population, army placement and confirmations; the existing native quantity dialog is reused. Counts refresh after nested dialogs. The flat, full-background window returns to the town panorama.

Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. Physical New 3DS XL checks remain pending: races/upgrades, individual/all recruitment and cancellation, insufficient funds/full army, flat/stereo return and save/load. The 0.3.37 physical guild and real HOME-close checks also remain pending; further stereo-depth development is deferred.

## Preview 0.3.37: native Mage Guild and system close

The legacy Mage Guild was drawn into the game framebuffer beneath the persistent castle panel, which also captured input: it appeared frozen in both 2D and 3D. It now owns native upper/lower images. The upper screen shows original guild artwork and the selected spell description; the lower screen uses original scrolls, built-level pages, castle navigation and Exit. Y cycles levels, lower arrows page levels, upper arrows change castles; stylus selects/scrolls, D-pad left/right changes focus and up/down scrolls, A activates and L exits. Original spell lists/library and caller-owned book purchase/learning rules are preserved. The guild is flat and returns to the panorama.

System HOME → Close now bypasses the in-game quit confirmation when aptShouldClose is set. Repeated SDL_QUIT events could otherwise recursively open confirmations. Rendering stops while modal scopes/resources unwind; ordinary in-game exit confirmation remains. The 0.3.36 photo maps PC 0x00721CD4 to _malloc_r and LR 0x0071EF90 to _memalign_r; SP 0x08000008 and the recursive code path are consistent with stack exhaustion, but the photo is not a full backtrace or proof of a unique cause.

On 2026-10-17 the user confirmed the marketplace works on New 3DS XL, reported the guild freeze in both modes and the HOME-close crash. Hardware validation of 0.3.37 is pending. Check guild entry/levels/library/descriptions/navigation and return with/without a guest/book, then HOME/resume and HOME/Close from map, castle and guild. Update only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. Further stereo-depth development remains deferred.

## Preview 0.3.36: direct construction access and marketplace handoff

The main castle panel now has an explicit Construction button for the original new-building catalog/options/hero recruitment; towns retain the original tent-upgrade action. Buildings/Y still selects existing services. Income moves beside the guest name; both army rows and their actions remain. Existing translations are reused: only the 3dsx needs updating.

Building selection no longer briefly restores stereo between closing the chooser, unwinding the parent and opening the selected service. The background stays flat until the main castle panel resumes; canceling the chooser restores stereo immediately. This removes extra display-mode transitions as a possible workaround for a hardware-only freeze before marketplace appearance. Azahar has not reproduced the user's freeze, so a physical fix is not confirmed. The log records marketplace entry, players/count preparation, controls, initial drawing and readiness.

Validation: two-job ARM Release, desktop syntax for eight files and offline infrastructure (21 groups/33 components) passed. CastleScreen passed New/Old Russian and New English, including direct construction choice, actual catalog/cancel and full Castle::OpenDialog → chooser → market → return with a registered kingdom marketplace (markets=1). CastleStereo passed New/Old Russian with actual marketplace entry from stereo town; Market/New validated original trades/payments/gifts and Construction/New validated the catalog. Russian/English captures were inspected and catalog/market readiness confirmed in logs. Monolithic Full was not run. The physical freeze remains unconfirmed as fixed and needs a hardware retry.

On 2026-10-17 the user positively assessed town stereo on New 3DS XL, then reported the marketplace freeze and unclear construction access; slider state during the freeze is unknown. Further stereo-depth development is deferred at the user's request. Check direct construction/purchase/cancel/options and Buildings → Marketplace with the physical slider both off/on, trading, return and restored stereo. Hardware validation is pending; physical Old hardware is unavailable.

## Preview 0.3.35: experimental stereoscopic town panorama

The physical 3D slider enables stereo only in the main castle view. Both eyes are rendered from original sprites with the original animation and occlusion order: terrain/river/bay stay at screen depth, architecture shares one near plane. Connected buildings and extensions remain together. This is a two-plane experiment, not individual building depths. Text and the lower controls remain flat. Four conservative slider levels control disparity; slider zero disables stereo.

libctru wide 800×240 and stereo are mutually exclusive: stereo provides 400×240 per eye. Slider zero, leaving town and ordinary upper-screen dialogs restore the selected 2D mode without changing the saved high-resolution preference. R+Start still updates that preference. Both 2DS models are excluded from stereo; New 2DS XL retains wide 2D support. A child owning the upper screen suppresses the right-eye town image; returning regenerates the correct pair.

Validation: two-job ARM Release, desktop syntax for six files and offline infrastructure (21 groups/33 components) passed. CastleStereo passed New/Old Russian and New English: all six races at zero/original and nonzero/distinct disparity, restored game frame, real GFX_LEFT/GFX_RIGHT output, stereo ↔ wide/standard, flat child/resume, actual Castle::OpenDialog/Y/return and both 2DS model exclusions. Captured eye framebuffers match their source geometry/palette; only the normal animated fire palette cycles differ. Engine self-test/Startup and CastleScreen passed New/Old; Messages passed New. Captures inspected; monolithic Full not run. Construction/boat animation in stereo, complete matches and physical visual comfort remain unverified.

The smoke-only slider override exercises actual left/right framebuffers in Azahar; normal gameplay reads the physical slider. Game rules/input are unchanged. Updating from 0.3.34 needs only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL check all races, slider comfort/edges/animation, completed buildings/boat, nested hero/book/recruitment/construction/building dialogs, stereo resumption, R+Start and previous 2D preference after exit. Hardware/visual-comfort validation is pending.

## Preview 0.3.34: main castle screen and original-style panels

Entering a castle now opens the native two-screen view directly. The upper screen keeps the entire original town panorama, its aspect ratio and building animation, without legacy army rows or tiny controls. The lower screen contains garrison/guest armies, Details, Split, Hero, Buildings, Income and Close. Graphic header arrows switch castles and are disabled for a single castle. Y opens built buildings; L/Close exits the castle. Select the castle building for construction/options; a town tent retains the original castle-upgrade action.

The panel uses original Heroes II stone textures/buttons, recessed portrait wells, separate count strips and warm bevels/selection frames. A persistent native background covers the entire lower screen during child dialogs and construction animation. Original ArmyBar and Castle handlers still own game operations; the UI returns a building ID or navigation command. A recruited guest appears immediately rather than using the legacy portrait fade.

Town layers remain rendered by the original building queue. Stereo is not implemented: a future separate experiment will test background/building/foreground depth, occlusion and all races. Validation uses short sequential Azahar groups with time/load guards, never automatic monolithic Full.

Validation: two-job ARM Release, desktop syntax for three changed files and offline infrastructure (20 groups/32 components) passed. CastleScreen passed New/Old Russian and New English; CastleArmy New/Old and CastleBuildings New regressions passed. Checks include real Castle::OpenDialog entry/exit, dwelling recruitment and construction cancellation, nested return, animation callback, navigation choices/disabled arrows, Evil UI and unchanged funds/army/hero list/frame/viewport/modal context with release isolation. Russian/English captures were inspected. Positive purchases, new guest appearance, completed-building animation, actual navigation between castles, all races and save persistence still require hardware validation.

Updating from 0.3.33 requires only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. On New 3DS XL check entry/animation across races, transfers/merge/split, hero/book, Y → buildings → recruitment/construction/options/market and cancellation/return, income, castle navigation, clean exit and save/load. Hardware validation of 0.3.34 is pending; physical Old hardware is unavailable.

## Preview 0.3.33: built-building selector

The castle Y army panel now includes Buildings beside Back. It opens six built buildings per page: creature dwellings first, followed by castle/tent, guild, market and other services/information. Original icons/names are used; the upper screen shows enlarged artwork, description and dwelling availability. Unbuilt buildings are omitted, upgraded dwellings replace their base entries, and only the highest built guild level is shown. Towers without a separate original action are excluded. Tent uses castle-upgrade destination artwork. This selects existing buildings; the castle entry still opens construction.

Tap selects, repeated tap/A/Okay opens; D-pad selects, Y and graphic arrows change pages. Hold/B shows information; stylus movement scrolls long descriptions without activation. Back/L returns to the army panel, where Y/L/Back closes it. Entering Buildings clears troop selection while keeping completed transfers.

The selected ID returns through the panel to Castle::OpenDialog and the same building-action loop used by city clicks/hotkeys. IDs come from the original race-specific drawing list and are checked again with isBuild. Recruitment, spellbook purchase, market, well, boat, construction and information use existing handlers; the selector does not buy/recruit/spend funds. Dwelling descriptions use BuildingInfo; other descriptions use Castle::GetDescriptionBuilding.

Two-job ARM Release, four-file desktop syntax, offline infrastructure (19 groups/31 components) and clean-baseline patch checks passed. CastleBuildings passed New/Old Russian and New English; CastleArmy regression passed New/Old, with captures inspected. Checks cover built/missing entries, upgrades/highest guild, six-race original-ID mapping, excluded towers, touch/controller, pages/disabled arrow, hold/drag/long scroll, actual Y → army → Buildings ID return and nested cancellation, Evil UI and unchanged funds/garrison/frame/viewport/parent/input. The full private Castle::OpenDialog action loop on a real map and actual recruitment/trading/construction are not executed by this group; gameplay effects and persistence require hardware checks. Monolithic Full was not run.

Updating from 0.3.32 requires `3ds/fheroes2/fheroes2.3dsx` and `3ds/fheroes2/files/lang/ru.mo` for the new Buildings label. On New 3DS XL check Y → Buildings, pages, upgraded-dwelling recruitment, guild/spellbook purchase, market/well/construction and cancellation, release isolation and save/load. On 2026-10-15 the user reported normal overall operation of 0.3.32 on New 3DS XL and authorized continuation, without a scenario breakdown. Hardware validation of 0.3.33 is pending; physical Old hardware is unavailable.

## Preview 0.3.32: garrison and visiting hero army panel

First main-castle adaptation stage: Y opens a native army panel. Above are a snapshot of the current original town artwork without legacy army rows, castle name and selected troop information. Below are five garrison slots, five visiting hero slots, counts, Details, Split, Hero and Back. Opaque backgrounds hide the underlying map. The normal castle status line includes Y: Army. Y/L/Back closes the panel; the main scene and building interactions retain their original layout. Town artwork is static while the panel is open; animation resumes after closing.

Tap/A selects a source and destination for moving/merging/swapping within or between rows. Split enables destination selection for the original redistribution dialog; dragging to an empty or same-type slot also opens it. Dragging outside or to another creature type does not change troops. D-pad moves focus, B/hold shows original information, and Details/repeated tap opens the interactive creature card. Hero opens the adapted editable guest dialog with dismissal/switching disabled from this panel. Missing guest slots and Hero perform no actions.

Actions call the original ArmyBar methods, retaining merging, swapping, redistribution, upgrade/dismiss and last-hero-creature rules. The garrison can be emptied; the hero keeps at least one creature. Transfers apply immediately and closing the panel does not undo them. Cancelling redistribution leaves armies unchanged. The upper town image comes from the current game frame; the panel does not draw into that frame. The original Castle::OpenDialog redraws army rows after return.

Two-job ARM Release, three-file desktop syntax, offline infrastructure (18 groups/30 components) and clean-baseline patch checks passed. CastleArmy passed New/Old Russian and New English; Army/New regression passed, with captures inspected. Checks cover actual Y handler via SDL, Y closure, original ArmyBar with real same/cross-army moves, merging/swapping, last hero creature protection for occupied/empty destinations, unrestricted final garrison creature, button/drag redistribution, cancel, controller, held info, creature/hero dialogs, missing guest and Evil UI. Each run checks creature totals by type, funds, hero list, frame/viewport/parent windows and release isolation. Full Castle::OpenDialog on a real map, positive upgrade/dismiss, refreshed legacy rows and persisted game effects are not exercised. Monolithic Full was not run.

Updating from 0.3.31 requires only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. On New 3DS XL open castle → Y and check both rows, moves/merge/swap, split/cancel, last hero creature, missing guest, details/upgrade, hero/book, Y/L closure and refreshed original castle rows, then save/load. Hardware validation of 0.3.29–0.3.32 is pending; physical Old hardware is unavailable.

## Preview 0.3.31: dual-screen castle options

Construction Options now opens a native 3DS window. The lower screen contains both candidate portraits/names and availability indicators, Spread/Grouped garrison formation, Back and Details. The upper screen shows castle name, selected hero portrait, class/level, primary statistics and recruitment/formation restrictions. Both screens have opaque backgrounds. Tap another candidate to select, tap the selected candidate/A to open the 0.3.30 confirmation; Y switches candidates and D-pad moves focus among six controls. B/hold or Details opens the original readonly hero OpenDialog through the adapted hero UI; formation B/hold shows original explanations. Dragging does not activate actions. Back/L returns to the construction catalog.

The UI returns commands and the original candidate pointer. Castle::_openConstructionDialog obtains candidates through GetRecruits, invokes DialogBuyHero/RecruitHero after confirmation, and returns the original RecruitHero result. Cancelled recruitment returns to Options. Formation uses the original SetSpreadFormation in Castle, guarded by BUILD_CAPTAIN both in the UI and when applying the command. Options no longer sends 3DS to the legacy full construction window; castle navigation/income/buildings remain in the catalog. The main castle scene retains its original layout.

Two-job ARM Release, four-file desktop syntax, offline infrastructure (17 groups/29 components) and clean-baseline patch checks passed. CastleOptions passed for New/Old Russian and New English; Construction/New and HeroRecruit/New regressions also passed, with captures inspected. Checks cover both candidates/touch/Y/controller, missing candidates, captain-gated and enabled formation commands, readonly hero/B/hold, drag cancellation, Evil UI, parent windows/frame/viewport and release isolation. UI tests do not mutate funds, hero lists or formation and do not execute RecruitHero; actual formation/recruitment through the private castle handler requires hardware checks. Monolithic Full was not run.

Updating from 0.3.30 requires only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. On New 3DS XL check Construction → Options, both candidates, readonly details/book, hire confirmation/cancel, payment/hero appearance, catalog return, formation unavailable without captain, both formations with captain, and save/load. Hardware validation of 0.3.29–0.3.31 is pending; physical Old hardware is unavailable.

## Preview 0.3.30: hero recruitment confirmation

Castle::DialogBuyHero now uses separate screens: enlarged original framed portrait, original level/class/artifact description, primary statistics and army above; an opaque window with cost, treasury gold, eligibility reason and Recruit Hero/Cancel below. Normal descriptions fit; long descriptions scroll with D-pad up/down or stylus drag on free space. Left/right choose a button, A/Start confirm, L cancel, and B/hold show upper information. Cancel is selected by default; dragging off a button does not recruit.

Original descriptions and PaymentConditions::RecruitHero remain. AllowBuyHero is checked while drawing and again before confirmation; funds, hero limit and an occupied castle follow original rules. The dialog returns OK/CANCEL; the existing caller recruits/places the hero and spends funds. Candidate selection and other Options still use the original layout; the main castle screen remains a subsequent task.

Two-job ARM Release, three-file desktop syntax, offline group infrastructure and clean-baseline patch checks passed. Short HeroRecruit runs passed for New/Old Russian and New English (about 14s each), with captures inspected. Checks cover the real DialogBuyHero entry, null hero, allowed touch/controller, default cancel, insufficient gold, hero limit, held/nested information, drag cancellation, long-text scrolling, Evil UI and parent window/frame/viewport/input restoration without changes to funds or hero lists. Automated tests do not execute RecruitHero or its gameplay effects; monolithic Full was not run.

Updating from 0.3.29 requires only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged. On New 3DS XL check recruitment through Construction → Options, both candidates, cost/payment, hero appearance, insufficient funds/limit/occupied castle, cancel, and save/load after hiring. Hardware validation of 0.3.29 and 0.3.30 is pending; physical Old hardware is unavailable.

## Preview 0.3.29: construction navigation arrows

Four page/castle navigation buttons now draw graphic arrows instead of text `<`/`>` characters that the game font rendered incorrectly. Arrows remain visible in released, pressed and disabled states; Castle labels are retained beside them. At the user's request, castle controls were widened from 76 to 96 pixels and Income narrowed from 152 to 112, leaving more space around the labels. Actions are unchanged.

ARM Release and short Construction/New runs in Russian/English passed; captures were inspected. Old was not rerun for this local sprite change. On New 3DS XL check page and previous/next castle arrows, including disabled first-page/one-castle controls. Updating from 0.3.28 requires replacing only `3ds/fheroes2/fheroes2.3dsx`; translations are unchanged.

On 2026-10-14 the user accepted normal operation of 0.3.28 on New 3DS XL with an issue where arrows looked like dots. No scenario breakdown was provided; no physical Old 3DS is available. Hardware validation of 0.3.29 is pending.

## Preview 0.3.28: construction catalog

Castle construction selection now uses both screens. The lower screen shows six original building icons per page, names, a status line (green: available, red: unavailable, brown: built), selection and paging. The upper screen shows enlarged artwork, description, current availability reason and prerequisites. Tap to select; tap the selected building/A to open the 0.3.27 confirmation. Hold/B show information, D-pad moves selection, Y changes pages, and dragging scrolls the description without activating a building. Exit/L cancel.

Page controls, previous/next castle and income remain available; castle navigation is disabled with only one castle. Options opens the complete original window for hero recruitment, garrison formation and other existing actions. The main castle scene and these extra actions retain their original layout. BuildingInfo/original rules supply building IDs, dwelling upgrades, next guild level and tavern/shrine substitutions. Eligibility is checked before returning a build choice to the original Castle::BuyBuilding caller; the catalog does not spend funds itself.

Validation: two-job ARM Release, desktop syntax for four files, clean-baseline patch application and offline test catalog checks passed. Independent Construction passed New/Old Russian and New English (about 14 seconds including loading); Building/New regression passed. Covered selection, Y/touch pages, Options result, disabled/enabled castle navigation, nested purchase cancellation, held info, drag cancellation, unchanged funds/frame/context and release isolation. Russian/English captures were inspected. Positive catalog purchase, real recruitment/income, actual castle entry, other races and game effects require hardware checks; synthetic fixtures do not construct buildings. Monolithic Full was not run.

On 2026-10-14 the user accepted 0.3.27 on New 3DS XL without a scenario breakdown; no physical Old 3DS is available. Replace `3ds/fheroes2/fheroes2.3dsx` and Russian `3ds/fheroes2/files/lang/ru.mo` for 0.3.28. Check entry, pages/upgrades, affordable/unavailable buildings, payment/cancel, next castle, Options/recruitment, income, another race, release isolation and save/load. Hardware acceptance of 0.3.28 is pending.

## Preview 0.3.27: dual-screen construction confirmation

Complete grouped validation on 2026-10-13: 14 groups × New/ru, Old/ru and New/en = 42 PASS results; New/Old engine self-tests also passed. Covered startup/rendering, messages, chest, level-up, recruitment, market, gifts, hero, army, spellbooks, battle log/outcomes/integration and building confirmation. Russian/English book, card/building captures were inspected. The only correction was capture ownership: army-info-battle-bottom.bmp is produced by BattleIntegration, not Army. The completed New/ru Army run was validated from its saved markers, timing and fresh captures without rerunning the emulator; other Army variants passed normally.

Sampled Azahar process peaks: 10.9% CPU across logical processors, 604.3MB working set and 1004.9MB private memory. Time/load guards were not triggered; the user did not report another host freeze. These are not whole-system/GPU measurements and do not establish the cause of the earlier incident. Monolithic Full was not run. Actual purchase/payment, gift delivery, persisted game effects and hardware validation remain outside this suite.

Explicitly requested Azahar diagnostics on 2026-10-13: separate Russian New Startup and Building passed with a 20-second deadline each. Startup: preparation 533ms, launch/emulation 8323ms, capture validation 2446ms; group 1605ms. The user reported no noticeable desktop impact during Startup. Building: preparation 566ms, launch/emulation 10294ms, validation 53ms; group 5216ms. Synthetic allow/deny touch/controller, default cancel, drag cancellation, nested information, long text, readonly, seven resources, Evil UI, frame/context and release restoration passed; actual BuildingInfo entry was exercised only for cancellation. Captures were inspected. Actual match purchase/payment, Old and English were not tested. The earlier host freeze remains unexplained; no Full run was performed.

The first castle adaptation covers BuildingInfo::DialogBuyBuilding. The upper screen shows original building artwork enlarged proportionally, name, description, availability reasons and requirements. Long content scrolls with D-pad up/down or dragging an empty lower-screen area. The lower screen has an opaque dialog background, original resource costs, Build and Cancel. Left/right select a button, A/Start activate, L cancels, and B/button hold show information. Cancel is selected initially; dragging off a button cancels activation.

Unavailable construction cannot be confirmed: the Build button is disabled and CheckBuyBuilding is checked again before returning confirmation. Payment and construction remain in original callers. Information-only calls use the existing upper dialog including artwork/cost. Desktop, the construction list and main castle screen retain their existing layout; this adapts confirmation only.

Validation: two-job ARM Release, desktop syntax for buildinginfo.cpp/ui_3ds_building.cpp and clean-baseline patch application passed. Azahar was not launched after the host freeze. Runtime/layout and game effects need New 3DS XL validation; no physical Old 3DS is available. Separate hardware acceptance of 0.3.26 has not been reported.

Replace `3ds/fheroes2/fheroes2.3dsx` and Russian `3ds/fheroes2/files/lang/ru.mo` for new labels. On hardware check affordable construction/payment, cancel without payment, insufficient resources, today's build limit, unmet requirements, different races/themes, long text and held information. Check release isolation and save/load of a completed building.

## Preview 0.3.26: opaque creature card and readable spellbook tabs

0.3.26 validation: ARM Release with two build jobs, the complete Russian New 3DS run, desktop syntax for both changed files, and clean-baseline patch application passed. Background and Russian tab captures were inspected. The English run was interrupted by a host freeze requiring a forced reboot and did not pass. Old and additional engine tests were not repeated for this UI change. Automatic Azahar runs on this host are suspended. Ready 3dsx/ru.mo files are staged for SD; 0.3.26 archives have not been created yet.

Interactive creature information now covers the entire lower screen with its dialog background, including the area above the action buttons. The full spellbook has two wide text tabs, Adventure and Combat, at the top of the lower screen, with the selected category outlined. Y still switches categories. Original book artwork, six spells per spread, paging and explicit cast confirmation are retained. Total mana is shown on the upper screen when both categories are available.

Updating from 0.3.25 requires replacing `3ds/fheroes2/fheroes2.3dsx` and Russian `3ds/fheroes2/files/lang/ru.mo` for the new labels. On New 3DS XL, check creature details from the hero army, complete background coverage and returning to the army tab. In the full book, check both touch tabs/Y, selection, paging, spell details and return to the hero. Also check the battle/adventure books for their permitted category and original cast confirmation. Hardware validation of 0.3.26 is pending; no physical Old 3DS is available.

On 2026-10-13 the user accepted 0.3.25 on New 3DS XL with two UI issues: the map remained visible behind the lower creature panel and spellbook category switches were too small. No scenario breakdown was provided.

## Preview 0.3.25: dual-screen hero dialog

0.3.25 validation: ARM Release, complete New/Old Russian and New English runs, and engine regressions for both models passed. Real Heroes::OpenDialog calls exercise original army move/merge/swap, split/drag cancellation, artifact reorder and book viewing without mana/inventory changes. Covered formation, readonly mode, PREV/NEXT, dismiss confirmation/cancellation/protection, last-troop information and stylus hold, tabs/Y and held-touch release, skill details, nested Evil UI and large counts. Game frame, HUD, viewport and input restore correctly. All tab/localization captures, desktop syntax for three files and clean-baseline patch application passed. Actual castle upgrades, outer-caller hero removal, battle/castle entry and saving results need hardware testing.

The regular hero dialog now uses a large upper portrait, name/class/level, primary stats, experience, mana, morale, luck and movement points. The lower screen has Army, Artifacts and Skills tabs, actions, previous/next hero, dismiss and close. Y cycles tabs; D-pad moves focus, A activates, B opens focused-item information, and L closes. Holding the stylus on an item opens top-screen information until release.

Army taps select then move/merge/swap through original widget handlers; tapping again or Details opens the adapted creature card. Split selects a destination, and dragging to a compatible/empty slot invokes the original split handler. Formation has a separate toggle. Artifact selection/reordering uses original handlers; repeated taps/Details show descriptions, while the book slot/button opens the full spellbook viewer. Skills show four primary and up to eight secondary skills with original descriptions. Readonly mode, dismiss/switch restrictions and dismiss confirmation remain in force. Map Editor retains the original dialog.

Updating from 0.3.24 requires replacing `3ds/fheroes2/fheroes2.3dsx`; Russian users must also replace `3ds/fheroes2/files/lang/ru.mo` for the new short labels. On New 3DS XL test entry from adventure/castle and readonly battle views, tabs, army move/merge/split, artifact reorder, book/skill details, formation, hero switching, dismiss cancellation and readonly restrictions. Then check save/load and battle after changes. Physical 0.3.25 validation is pending; the user accepted 0.3.24 on New 3DS XL and no physical Old 3DS is available.

## Preview 0.3.24: dual-screen resource gifts

0.3.24 validation: ARM Release built; New/Old Russian, New English and engine regressions for both models passed. Covered multiple-recipient budgets, a mixed seven-resource gift, gold step 100, MIN/MAX, slider/controller, recipient reset, empty gifts/funds, drag cancellation, INT32_MAX, Evil UI and restored nested modal/frame/HUD/viewport/input. The real MakeGiftResource call passed cancellation without spending funds; confirmed sending and next-day event delivery were not exercised by automated tests. Russian/English captures, desktop syntax for three files and clean-baseline patch application were checked.

GIFT from the market now opens a dedicated 3DS interface. The lower screen is covered by recipient flags, seven resources, quantity, −/+, MIN/MAX, slider, send and cancel. The top shows recipients, the equal per-player gift and sender balances before/after sending. Changing recipient count resets the gift as in the original UI; the maximum accounts for every recipient. Gold buttons step by 100, other resources by one; MIN clears the selected resource.

D-pad Left/Right moves focus, A activates it, Up/Down changes quantity, and L cancels. Touch selects recipients/resources and drags the slider; dragging away from a button cancels its press. Empty gifts and missing recipients disable sending. The original game handler retains delivery on the next game day and deducts the per-player gift for every recipient only after confirmation.

Updating from 0.3.23 requires replacing only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL test market entry, one/multiple recipients, mixed resources, MIN/MAX, slider, recipient changes, cancellation and return to the market. After sending, check total deduction and next-day delivery to selected players. On 2026-10-13, the user accepted 0.3.24 on New Nintendo 3DS XL ("everything works"), without an individual scenario breakdown; separate hardware confirmation of 0.3.23 label centering is still pending. No physical Old 3DS is available.

## Preview 0.3.23: centered marketplace button labels

0.3.23 validation: ARM Release built; complete New Russian and English runs passed and both localized button captures were visually checked. Desktop syntax and clean-baseline patch application passed. Old and engine checks were not repeated for this local label-rendering fix.

All seven marketplace button labels are centered using actual sprite dimensions and visible glyph bounds. Extra button borders and the pressed-label offset are accounted for.

Updating from 0.3.22 requires replacing only `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL check −/+, MIN/MAX, TRADE, GIFT and Exit labels in released and pressed states. Physical 0.3.23 validation is pending; the user accepted 0.3.22 on New 3DS XL.

## Preview 0.3.22: dual-screen marketplace

0.3.22 validation: ARM Release, complete New/Old Russian and New English runs, and engine regression checks for both models passed. Covered all resource directions at 1/3/9 markets, original gold rates, rounding and Funds limits. Real Trading Post Dialog::Marketplace calls exercised gold/resource and resource/resource trades with slider/controller input; empty funds, same-resource trades, disabled actions and dragging did not spend funds. Gift dispatch, nested modal/Evil UI restoration, unchanged frame/HUD/viewport and input isolation passed. Desktop syntax for three files and clean-baseline patch application passed; both screen captures were visually checked. Automated checks do not cover full gifting, entering a town market or returning to surrender; hardware feedback is recorded below.

Marketplace and Trading Post now use a dedicated 3DS interface. The lower screen is covered by the dialog: player resources on the left, resources to buy on the right, then −/+, MIN/MAX, a quantity slider, TRADE, GIFT and Exit. The upper screen shows the selected resources, exact sale/purchase amounts, resulting balances, rate and trade units. Large cell values are shown in full on top after selecting the resource.

Touch selects resources and drags the slider. D-pad Left/Right moves focus, A activates the focused item, Up/Down changes quantity, and L closes. Dragging away from a button cancels its press. Selecting resources resets quantity to zero; only a separate TRADE confirmation spends funds. Original rates still depend on marketplace count; Trading Post retains the three-market rate. The game dialog executes each trade after checking funds and overflow. GIFT opens the existing resource-gift dialog; adapting that dialog is outside this preview.

Updating from 0.3.21 requires replacing only `3ds/fheroes2/fheroes2.3dsx`. On 2026-10-12, the user confirmed successful 0.3.22 testing on New Nintendo 3DS XL ("tested, all good"). Individual cases were not enumerated. On New 3DS XL test town markets and Trading Posts, gold/resource and resource/resource trades, rounding remainders, MIN/MAX and slider, cancellation, buttons and touch. Also test returning to battle surrender from the market and gifting with another player present. The user accepted 0.3.21 on New 3DS XL; no physical Old 3DS is available.

## Preview 0.3.21: post-battle necromancy

0.3.21 validation: ARM Release built; complete Azahar New/Old Russian and New English runs passed. Covered A/touch/L, drag cancellation, counts 0/1/123456/UINT32_MAX and evil UI. The real Arena dialog call checks original animation advancement and unchanged army, frame, HUD, viewport and actions. Desktop syntax passed for six affected/related files; the exported patch applies to the clean pinned revision. These automated checks do not exercise raising troops after a complete battle or audio; hardware feedback is recorded below.

Necromancy now uses both screens: the original animation, message and skeleton count appear on top; a full dialog background and Okay button cover the lower screen. A/Start or touch confirms, L closes. D-pad Up/Down or a stylus drag above the button scrolls long text; dragging away from the button cancels its press. The original WINCMBT sequence and timer are shared with adapted battle summaries. Original game code still calculates and adds the raised troops.

Updating from 0.3.20 only requires replacing `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL, test a victory with Necromancy, animation, message/count, closing and the resulting army. On 2026-10-11, the user confirmed successful 0.3.21 testing on New Nintendo 3DS XL ("tested, all good"). Individual cases were not enumerated. Separate physical validation of the 0.3.20 adventure book remains unconfirmed; physical Old 3DS testing is unavailable. Marketplace is a separate next step.

## Preview 0.3.20: adventure spellbook

The Adventure Map spellbook now uses original book artwork on the lower screen, with six spells per spread. The upper screen shows the selected spell's description, cost and availability reason. Selecting a spell only highlights it; Cast Spell or A confirms. D-pad Up/Down selects a spell, Left/Right changes pages, L closes, and B or holding a spell opens information. A stylus drag scrolls a long upper description without casting.

Viewing the full book through the hero's artifact uses the same interface. Original bookmarks at the upper right of the lower screen switch adventure/combat sections; Y also switches sections. In view mode, confirmation opens information. Casting on the map or in battle shows only the corresponding spells. Original game code retains mana/movement costs, learned spells/scrolls, hero restrictions and spell execution.

Updating from 0.3.19 only requires replacing `3ds/fheroes2/fheroes2.3dsx`. Physical validation of 0.3.20 is pending: test both entry points, select/cancel/cast, pagination, information/scrolling and full-book tabs on New 3DS XL.

## Preview 0.3.19: shared upstream review fixes

The current port incorporates shared fixes from PR #11048: pointer state reaches the renderer through the input layer, the native backend uses RenderEngine::create(), and named geometry and framebuffer checks protect drawing. Settings keeps the required software cursor enabled, including when reading configuration. Model detection logs failures, and startup handles missing argv. Stylus controls, panels, dialogs and R+Start remain available. Early logging, intro handling and audio recovery retain the full port's 0.3.18 behavior.

Updating from 0.3.18 only requires replacing `3ds/fheroes2/fheroes2.3dsx`. Physical validation of 0.3.19 is pending: check Circle Pad/stylus follow, held right-click, map/battle Y panels, R+Start and return from dialogs on New 3DS XL.

## Preview 0.3.18: battle results and surrender across both screens

The dialog covers the entire lower screen. A D-pad hint and arrows indicate scrolling; casualty icons align with their names and the surrender portrait has more padding. Updating from 0.3.17 only requires replacing the `.3dsx`.

Battle results use the top screen for the original animation, outcome, experience/ransom and all casualties. D-pad Up/Down or a stylus drag above the lower buttons scrolls the report. The lower dock contains Okay and Restart when the original game permits it; Left/Right selects a button, A/Start confirms, L closes without restarting. Captured/disappearing artifacts are also shown on top; hold B for their details.

Surrender shows the opponent portrait, ransom, available gold and any shortfall on top. Accept, Marketplace and Decline are on the lower screen. Accept requires sufficient funds; Marketplace requires insufficient gold and a marketplace in the kingdom. Returning from Marketplace refreshes funds and availability. The dialog only returns a choice; the original game charges gold and completes the battle. Updating from 0.3.16 only requires replacing `3ds/fheroes2/fheroes2.3dsx`. Physical validation is pending. The separate necromancy dialog and Marketplace retain their original layouts.


## Preview 0.3.16: Y hero actions and original book artwork

In combat, Y opens the lower hero action panel: spellbook, retreat, surrender and close. Y again or L closes the panel. Clicking a hero opens the same panel; unavailable actions retain the original eligibility rules. The top screen keeps the battlefield. Tap your hero’s name in the panel header to open the full hero screen. Retreat and surrender use the existing confirmations and action handlers.

The lower spellbook retains the original pages, binding and corners, with three spells per leaf, six per spread. Icons and text are laid out for 320×240 instead of shrinking the original text. The top screen shows the selected spell description. Selection requires the confirmation button or A to cast. Updating from 0.3.15 only requires replacing `3ds/fheroes2/fheroes2.3dsx`. The user tested 0.3.16 on New 3DS XL and reported everything working, without a scenario breakdown. Physical Old 3DS remains untested.


## Preview 0.3.15: combat spellbook across both screens

The combat-only (`CMBT`) book shows six spells per lower-screen page, icons, costs and current/maximum mana. Tap selects a row and displays its description above; A/Start or Cast Spell confirms. D-pad up/down selects a spell, left/right and arrow buttons turn pages; L or Close cancels. The page is retained when the caller requests restoration. Hero power/artifacts affect descriptions; stylus dragging scrolls them. B or holding a row opens information with D-pad up/down scrolling; release returns without casting.

Original learned spells/scrolls, sorting, artifact-adjusted costs and CanCastSpell checks are retained. Unavailable spells appear gray; attempting to select them displays the original reason. The book only returns a selected spell: target selection, combat restrictions, casting and mana payment remain in the original battle handler. Read-only viewing returns no spell. Adventure books, combined-category views and the editor retain their existing layouts. Updating from 0.3.14 only requires replacing `3ds/fheroes2/fheroes2.3dsx`.

## Preview 0.3.14: larger top card and compact actions

The animated portrait, stack count, statistics, entire stack upgrade cost, properties and battle effects are grouped on the top screen. Statistics use the normal game font instead of the small font. The lower screen contains only available action buttons in a compact dock over a frozen game detail. Two buttons occupy less space than three; a single Close button uses an even smaller dock. Without an available upgrade, the cost block is omitted and the portrait is taller.

Controls remain: D-pad up/down or dragging above the dock scrolls top information, left/right selects an action, A/Start confirms and L closes. The frozen detail provides context; touches do not issue game commands. Confirmations, cancellation and held information retain their behavior. Updating from 0.3.13 only requires replacing `3ds/fheroes2/fheroes2.3dsx`.

## Preview 0.3.13: army card across both screens

Creature statistics, properties and active battle spells use a native 400×240 top card. The lower screen shows an enlarged portrait with idle frames, the entire stack's upgrade cost and available Upgrade, Dismiss and Close controls. Original confirmations and insufficient-resource messages remain; the unchanged caller modifies the army and pays for upgrades. Unavailable actions are omitted.

D-pad up/down or stylus dragging scrolls top text; left/right selects a lower button, A/Start confirms and L closes. B or holding a button shows information. When the card opens as held information, the stylus can scroll until released; release closes it without clicking game controls. Battle statistics include current bonuses, remaining shots, the last creature's remaining health and effect duration.

Updating from 0.3.12 only requires replacing `3ds/fheroes2/fheroes2.3dsx`. On New 3DS XL, check upgrades with sufficient/insufficient resources, dismiss confirmation/cancellation, long held information and a battle unit with an active spell. Physical validation of 0.3.13 is pending.

## Preview 0.3.12: troop splitting on the touchscreen

`ArmySplitTroop` now uses a native 320×240 layout. Tap a troop to select it, then hold and release the stylus on an empty slot or another stack of the same creature type: the original right click opens redistribution. Set an exact amount with −/+, MIN/MAX or the slider. D-pad left/right changes the amount, up selects maximum and down minimum. Quantity changes/the slider select manual mode. Buttons 2–6 select even splitting into the available number of stacks; the selected option is underlined. Available options come from the unchanged caller.

A/Start or Okay confirms; L or Cancel preserves caller values. Dragging from a button cancels its press. The original caller still redistributes creatures and protects the hero's last troop. On New 3DS XL, check exact/even splitting, redistribution into an existing matching stack, cancellation and last-creature protection. The army card is adapted in the following 0.3.13 iteration.

## Preview 0.3.11: battle log on the touchscreen

Tap battle messages to open a full 320×240 lower-screen log. The upper screen retains the battlefield; the original log overlay is no longer drawn there. Complete entries wrap to the text width and the log opens at the latest events. D-pad up/down scrolls lines, left/right scrolls a page; stylus dragging scrolls in both directions. OK, A/Start, B or L closes the log and restores the HUD. Dragging from OK cancels the press; closing input does not reach battle controls.

HUD messages now have padding below and inside the decorative frame, with one shortened line per message. Full action messages remain in the log. The 0.3.10 recruitment changes are included. On New 3DS XL, check a long battle log, scrolling both ways, closing and resuming combat/spell selection. Other specialized dialogs retain their existing layouts.

## Preview 0.3.10: larger animated recruitment portraits

Recruitment portraits now occupy 104×90 instead of 86×44, using creature sprites and original idle frames with stable scale and aspect ratio. Variant arrows sit beside availability on the right. Quantity and purchase controls remain the same.

Hold the portrait until information appears on the top screen, then move the stylus up/down without lifting it to scroll. D-pad up/down also scrolls while the stylus is held. Releasing the stylus closes information and restores the same recruitment selection, even after dragging; the closing gesture cannot activate recruitment buttons. B information still closes when B is released.

On New 3DS XL, check small/large creatures, animation, variant switching and a long tooltip with both stylus dragging and D-pad scrolling while held. Release over the purchase button to verify isolation. The 0.3.9 battle HUD changes are included and still await separate hardware feedback.

## New in 0.3.9: battle footer

At the bottom of the touchscreen: Auto (upper left), Settings (lower left), Skip (right), and two messages in the center. Tap the messages to toggle the original battle log; hold an icon or message for information. The enlarged battle viewport remains above the strip. Dragging cancels a button click. The original footer is removed from the upper game frame.

On hardware, test Skip, automatic combat and interruption, the log, settings and return, spell selection, and return to the map after combat. Emulator checks do not cover a full hardware match.

## New in 0.3.8: touchscreen recruitment

Use D-pad left/right or −/+ to change the quantity; down/MIN selects one, up/MAX selects the affordable maximum. Drag the slider for quick selection. A/Start or Okay confirms; L or Cancel closes without a purchase. Hold B or the portrait for creature information above, then release to return. Arrows below the portrait cycle through available downgrade variants when permitted by the original dialog; switching selects the newly affordable maximum. Holding quantity buttons does not repeat their action.

Below the slider, each amount shows the total cost and remaining funds in parentheses, ordered like the resource icons above. Copy the application and `files/lang/ru.mo` when updating. Test actual castle/map-dwelling recruitment, cancellation, army quantities and gold/rare-resource deductions on hardware. This iteration has emulator validation; hardware validation is pending.

## Native hero level-up — preview 0.3.7

Level-up now uses the touchscreen for all three cases: two offered secondary skills, one offered skill, or only a primary-stat increase. Choose left/right with the D-pad and confirm with A/Start, or tap Learn. Tapping a skill card selects it; holding the card or B opens its description above. A single available skill uses a confirmation window; the same B/hold information applies. Long text scrolls while two-skill cards and Learn buttons remain fixed. L does not select or cancel a two-skill choice. Skill identifiers are returned to the unchanged upstream caller, which grants the upgrade.

Tested through the actual LevelUpSelectSkill dialog in Russian New/Old and English New emulator runs: both skill slots and choices, controller/touch, upgraded skill level, drag cancellation, nested information, long name, Evil UI, unchanged hero and viewport. A full level-up in a real match still needs hardware validation. The original View Hero button inside the two-skill window is not included in this layout; the full hero screen remains available through the usual game interface.

## High-resolution top screen — preview 0.3.6

Hold **R**, then press **Start** to switch 400×240 ↔ **800×240 in 2D**. The choice is saved immediately in `fheroes2.cfg` as `3ds high resolution = on/off`; new installations default to on. Existing explicit `off` preferences are respected. Stereo 3D is not enabled. Narrower physical pixels preserve the proportions and framing of the 800×480 game frame. Native top-screen information retains its readable size; the lower screen stays at 320×240. Old 2DS and failed model detection use standard output.

Test on real hardware: compare fine map details, viewport borders, information and chest windows, then combat. R + Start inside a dialog must not confirm an answer. Restart to check the saved preference. The user confirmed a substantial quality improvement on New 3DS XL with 0.3.5. Long-session performance and battery impact remain unmeasured.

[Русский](INSTALL_RU.md) | [Project and downloads](https://github.com/alekszverr-jpg/fheroes2-3ds)

## Installation

1. Download `fheroes2-menu-preview-0.3.7.zip` from the [release page](https://github.com/alekszverr-jpg/fheroes2-3ds/releases/tag/v0.3.7).
2. Extract its `3ds` directory to the root of the console's SD card.
3. Add the original Heroes of Might and Magic II files from your own game installation to the directories below. The release does not include original game data, maps or music.
4. Launch **fheroes2 3DS preview** from Homebrew Launcher.

```text
/3ds/fheroes2/fheroes2.3dsx
/3ds/fheroes2/fheroes2.smdh
/3ds/fheroes2/fheroes2.cfg
/3ds/fheroes2/data/heroes2.agg
/3ds/fheroes2/data/heroes2x.agg       (if supplied with your edition)
/3ds/fheroes2/maps/                 (your original map files)
/3ds/fheroes2/music/TrackXX.ogg      (optional external music)
/3ds/fheroes2/files/data/resurrection.h2d
/3ds/fheroes2/files/lang/ru.mo
```

Copy the contents of your original `Data` and `Maps` directories into `data` and `maps`. For supported GOG `Tracks2` files, the preparation script renames `02-AudioTrack…ogg` to `Track02.ogg`, and similarly for the other tracks. External music is optional. Sound and long sessions still need separate hardware testing.

When updating, back up your saves and configuration. Replace the application and bundled `files` resources, keeping your existing `fheroes2.cfg`, original resources and saves. When updating specifically from 0.3.1 to 0.3.3, replacing `fheroes2.3dsx` is sufficient.

New installations use English. Choose Russian in the game's language settings; its translation is bundled. Existing language settings remain yours. Intro videos are skipped on 3DS. The log is written to `/3ds/fheroes2/fheroes2.log`.

## Screens and controls

The top screen shows the full 800×480 game frame at a uniform half scale, filling 400×240 pixels. The adventure map gains 160 pixels of width while the original panels and sprites keep their proportions. A red rectangle marks the area shown below. Stereo 3D is not implemented.

The touchscreen shows a 320×240 detail viewport at the game's native scale. It follows the Circle Pad cursor and the stylus smoothly, with a central dead zone to reduce unwanted movement. Dragging the stylus moves this detail viewport without dragging the adventure map. After a drag, lift the stylus and tap again to click.

| Input | Action |
|---|---|
| Circle Pad | Move the mouse cursor |
| R | Speed up cursor movement |
| A | Left mouse button |
| B, held | Right mouse button / information |
| Short stylus tap | Left click |
| Stationary stylus hold, 550 ms | Right-button information; release does not cause a left click |
| D-pad on the adventure map | Scroll the map continuously; two directions scroll diagonally |
| Y on the adventure map | Show or hide the bottom command strip |
| Start | Enter / confirm |
| L | Escape / back |
| X | End-turn shortcut |
| Select | File-menu shortcut |

D-pad map scrolling uses the game's scroll-speed setting and stops on release. Opposite directions cancel each other. It stops a moving hero first. Menus, dialogs and battles retain the existing button handling; a held map direction is cancelled on entering a dialog and requires a fresh press afterwards.

## Bottom command strip

Press Y on the adventure map to display eight original 40×40 command icons along the bottom edge. From left to right: next hero, move/revisit, kingdom overview, spells, end turn, adventure actions, file menu and settings.

Tap an icon to run its command. Hold it still for 550 ms to show information, including for disabled commands. Moving 10 pixels or leaving the pressed icon cancels the action. Strip touches do not issue commands to the map underneath. Ending a turn through the strip always requires confirmation.

The detail viewport becomes 320×200 while the strip is visible. The strip hides during dialogs, battles and AI turns. Visibility is remembered during the current application session, but is not yet saved between launches.

## Current validation and limitations

Earlier previews have been tested on a physical New Nintendo 3DS XL: entering a match, AI turns, battles, saving/loading and the 0.3.1 command strip were reported working. Preview 0.3.3 passed New/Old Azahar checks for input, viewport boundaries, command-strip routing and real map scrolling on a synthetic map. These automated checks do not exercise a full match.

The 800×480 frame, D-pad changes and native messages still need physical-console validation. Physical Old 3DS compatibility, audio and long-session stability are unverified. Native messages passed Russian New/Old and English New emulator checks.

## Native messages in 0.3.3

Common informational messages appear at native scale on the top screen while the bottom retains the game context or an open lower dialog. Release the opening B/stylus hold to close; A/Start or L can also dismiss information. The command-strip descriptions now use this informational path.

Common OK, OK/Cancel and Yes/No messages appear on the bottom screen. Tap a button, or select it with D-pad left/right and confirm with A/Start. L chooses Cancel/No when available; single OK/Cancel windows retain their usual close behavior. The command strip is covered while a lower dialog is open.

D-pad up/down scrolls long content. You can also drag the stylus in the text area; buttons remain fixed. Dragging out of a pressed button cancels the click. Hold a supported resource/artifact/spell/skill element for information on the top screen, then release to return to the lower dialog without selecting an answer.

This adaptation covers the common `showMessage` path with standard elements and passive images/animations. Army/monster information, recruitment and custom interactive windows retain their original layout and input. No stereo 3D is enabled.

## Treasure chests in 0.3.6

The gold/experience choice appears on the touchscreen with explicit **Gold** and **Experience** buttons. Reward icons and amounts, your current kingdom gold and experience needed for the next level stay visible while you scroll the description.

Tap a button, or choose with D-pad left/right and confirm with A/Start. Gold is initially selected. **L chooses Experience**, preserving the original Escape/No behavior; the chest does not have a separate cancel option. Dragging away from a pressed button cancels that click.

Hold a reward icon with the stylus, or hold B on the selected option, to display its information on the top screen. Release to return to the same chest choice; showing information does not grant a reward. The upstream game caller still grants the chosen gold or experience.

Russian New/Old and English New Azahar checks exercised the actual chest dialog, both choices, controller navigation, L, drag cancellation, both nested descriptions, long text and the Evil interface. They checked that the dialog leaves reward granting to its caller and preserves the game frame/viewport. These are UI tests; collecting a chest in a real match still needs hardware validation. Other chest outcomes such as artifacts or sea-chest notices continue through the supported common message path where applicable.

Updating from 0.3.3: replace only `/3ds/fheroes2/fheroes2.3dsx`, preserving configuration, original resources and saves.

For a hardware report, include your console model, map/scenario, reproduction steps and `/3ds/fheroes2/fheroes2.log`.
