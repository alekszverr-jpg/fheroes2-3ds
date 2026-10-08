# fheroes2 Nintendo 3DS game build

## Preview 0.3.11: battle log on the touchscreen

Tap battle messages to open a full 320×240 lower-screen log. The upper screen retains the battlefield; the original log overlay is no longer drawn there. Complete entries wrap to the text width and the log opens at the latest events. D-pad up/down scrolls lines, left/right scrolls a page; stylus dragging scrolls in both directions. OK, A/Start, B or L closes the log and restores the HUD. Dragging from OK cancels the press; closing input does not reach battle controls.

HUD messages now have padding below and inside the decorative frame, with one shortened line per message. Full action messages remain in the log. The 0.3.10 recruitment changes are included. On New 3DS XL, check a long battle log, scrolling both ways, closing and resuming combat/spell selection. Other specialized dialogs retain their existing layouts.

## Preview 0.3.10: larger animated recruitment portraits

Recruitment portraits now occupy 104×90 instead of 86×44, using creature sprites and original idle frames with stable scale and aspect ratio. Variant arrows sit beside availability on the right. Quantity and purchase controls remain the same.

Hold the portrait until information appears on the top screen, then move the stylus up/down without lifting it to scroll. D-pad up/down also scrolls while the stylus is held. Releasing the stylus closes information and restores the same recruitment selection, even after dragging; the closing gesture cannot activate recruitment buttons. B information still closes when B is released.

On New 3DS XL, check small/large creatures, animation, variant switching and a long tooltip with both stylus dragging and D-pad scrolling while held. Release over the purchase button to verify isolation. The 0.3.9 battle HUD changes are included and still await separate hardware feedback.

0.3.10 emulator checks passed in Russian New/Old and English New: visible portrait animation, independent held-stylus and D-pad scrolling, release isolation, existing quantity/resource checks and other dialog/battle-HUD regressions.

## Native battle footer — development preview 0.3.9

Battle messages and the original Auto/Settings/Skip icons now occupy the bottom 320×40 strip, with an enlarged 320×200 viewport above. The old footer is removed from the upper game frame. Original hit regions and handlers are retained through native touch mapping, including log access and hold information. Synthetic real-Arena checks pass in Russian New/Old and English New; full combat on New 3DS XL remains pending.

## Native recruitment — development preview 0.3.8

RecruitMonster now uses a 320×240 touchscreen layout with quantity buttons and a slider, D-pad adjustment, availability/funds limits, permitted downgrade variants and top-screen creature information. The original caller still handles payment, dwelling stock and army placement. Emulator checks cover Russian New/Old and English New; actual recruitment on New 3DS XL remains pending. See [controls and hardware checks](INSTALL.md).

## Native hero level-up — preview 0.3.7

Level-up now uses the touchscreen for all three cases: two offered secondary skills, one offered skill, or only a primary-stat increase. Choose left/right with the D-pad and confirm with A/Start, or tap Learn. Tapping a skill card selects it; holding the card or B opens its description above. A single available skill uses a confirmation window; the same B/hold information applies. Long text scrolls while two-skill cards and Learn buttons remain fixed. L does not select or cancel a two-skill choice. Skill identifiers are returned to the unchanged upstream caller, which grants the upgrade.

Tested through the actual LevelUpSelectSkill dialog in Russian New/Old and English New emulator runs: both skill slots and choices, controller/touch, upgraded skill level, drag cancellation, nested information, long name, Evil UI, unchanged hero and viewport. A full level-up in a real match still needs hardware validation. The original View Hero button inside the two-skill window is not included in this layout; the full hero screen remains available through the usual game interface.

## High-resolution top screen — preview 0.3.6

Hold **R**, then press **Start** to switch 400×240 ↔ **800×240 in 2D**. The choice is saved immediately in `fheroes2.cfg` as `3ds high resolution = on/off`; new installations default to on. Existing explicit `off` preferences are respected. Stereo 3D is not enabled. Narrower physical pixels preserve the proportions and framing of the 800×480 game frame. Native top-screen information retains its readable size; the lower screen stays at 320×240. Old 2DS and failed model detection use standard output.

Test on real hardware: compare fine map details, viewport borders, information and chest windows, then combat. R + Start inside a dialog must not confirm an answer. Restart to check the saved preference. The user confirmed a substantial quality improvement on New 3DS XL with 0.3.5. Long-session performance and battery impact remain unmeasured.

Preview **0.3.6** builds the fheroes2 engine and game for Homebrew Launcher. See [installation and controls](INSTALL.md), the [root README](../README.md) for build instructions, and [CONTRIBUTING.md](../CONTRIBUTING.md) for editing the engine patch.

The renderer presents an 800×480 indexed game frame as a full 400×240 overview on the top screen and a native-scale detail viewport on the touchscreen. Circle Pad and stylus control the cursor and detail viewport; the D-pad scrolls the adventure map. Y toggles a touchscreen strip using the original adventure command icons.

The build entry point in `CMakeLists.txt` combines the upstream engine/Smacker targets with game sources, pinned SDL2 and SDL2_mixer, and the local devkitARM toolchain adapter. It preserves the upstream desktop configuration. Platform changes are distributed in `../patches/fheroes2-3ds.patch` against upstream commit `9754feff8501dbb69df95f3b999156a32eb8d7d3`.

`engine_smoke.cpp` checks the platform/engine input and rendering behavior. The menu test also exercises command-strip selection and map scrolling on a synthetic world. New/Old Azahar checks passed; high-resolution quality was confirmed on New 3DS XL; long-session performance remains unmeasured. Previous previews were reported working on New 3DS XL for matches, AI, combat and saving/loading.

Preview 0.3.3 routes supported common messages to separate native-resolution images: information on top, answers on the touchscreen. Text wraps at the target screen width; long content scrolls while answer buttons stay fixed. Nested information retains the lower dialog. Closing input is captured and viewport motion is frozen through the modal scope.

Preview 0.3.4 also adapts `Dialog::SelectGoldOrExp` to the touchscreen, reusing the modal input and content-scrolling code. Gold/Experience buttons, reward icons and amounts, current kingdom gold and experience needed for the next level stay fixed. Holding a reward icon or B on the selected option opens information above. The original boolean return and reward-granting caller remain unchanged: Gold is true, Experience is false; L still chooses Experience.

Army/monster information, recruitment and custom interactive elements retain their original paths. These specialized windows and battle commands are the next UI work. Stereo 3D is a later experiment. Detailed historical notes and plans remain available in [Russian](README_RU.md).
