# fheroes2 for Nintendo 3DS — preview 0.3.7

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
