# fheroes2 for Nintendo 3DS — preview 0.3.19

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
