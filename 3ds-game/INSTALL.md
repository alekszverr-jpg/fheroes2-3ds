# fheroes2 for Nintendo 3DS — preview 0.3.32

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
