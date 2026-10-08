# fheroes2-3ds

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

A work-in-progress Nintendo 3DS port of [fheroes2](https://github.com/ihhub/fheroes2), the open-source Heroes of Might and Magic II engine.

**English** | [Русский](README_RU.md)

**[Download preview 0.3.11](https://github.com/alekszverr-jpg/fheroes2-3ds/releases/tag/v0.3.11)** — download `fheroes2-menu-preview-0.3.11.zip` for your SD card. The source archive is for developers. See [installation and controls](3ds-game/INSTALL.md).

Current preview: **0.3.11**. The game has been run on a New Nintendo 3DS XL; AI turns, battles and saving/loading were reported working with earlier previews. The chest Gold choice was reported working on New 3DS XL. The user reports a substantial image-quality improvement on New 3DS XL; high-resolution output is now the default. Long-session performance remains unmeasured. Physical Old 3DS compatibility is unverified.

## Features

- An 800×480 game frame filling the top screen: 400×240 standard or optional 800×240 high-resolution 2D, switched with R + Start and saved in configuration; standard output on Old 2DS.
- A native-scale detail viewport on the touchscreen, following the cursor or stylus.
- Circle Pad cursor control; D-pad adventure-map scrolling, including diagonals.
- Short stylus taps for left clicks and stationary holds for right-button information.
- A toggleable bottom strip with the original adventure-map command icons.
- Common informational messages at native resolution on the top screen; common OK/yes/no dialogs on the touchscreen, with fixed buttons and scrolling for long content.
- Native touchscreen hero level-up: two-skill choice, one-skill confirmation and primary-stat-only increase, with skill descriptions on top.
- Native touchscreen treasure-chest choice with labeled Gold/Experience buttons, fixed reward amounts and top-screen information.
- SD logging and a separate platform/engine test application.

Native messages cover the supported common `showMessage` path and the chest gold/experience choice. Recruitment uses a native touchscreen layout with animated creature portraits. Battle controls and a scrollable log also use the touchscreen. Army/monster information and remaining custom interactive windows retain their existing layouts. Stereo 3D is not implemented yet.

Preview **0.3.11** includes native touchscreen recruitment, larger animated portraits, held-tooltip scrolling and a bottom battle footer with messages and Auto/Settings/Skip icons. The user reports other 0.3.8 recruitment behavior working on New 3DS XL; the combined portrait/scroll and battle-log fixes were accepted in 0.3.11 on New 3DS XL, without a detailed scenario breakdown. See [installation and controls](3ds-game/INSTALL.md).

## Installation

The application requires your own original Heroes II game data. Original game data, music, maps, saves and local SDK files are excluded from this repository.

Extract the release ZIP to the root of your SD card, then add your original game data under `/3ds/fheroes2/`. Start the application from Homebrew Launcher. Preserve existing configuration and saves when updating. See the complete [English installation and controls guide](3ds-game/INSTALL.md) or [Russian guide](3ds-game/INSTALL_RU.md). New installations default to English; Russian can be selected in the game settings.

## Build on Windows

The currently maintained build uses **PowerShell 7**, Git, Windows `curl.exe` and `tar.exe`, and native CMake/Ninja. The scripts default to MSYS2's `C:/msys64/mingw64/bin/cmake.exe` and `ninja.exe`; other native installations can be supplied as parameters. MSYS2 GNU gettext at `C:/msys64/usr/bin/msgfmt.exe` is used for Russian translations during local data preparation/packaging.

```powershell
git clone https://github.com/alekszverr-jpg/fheroes2-3ds.git
cd fheroes2-3ds
./tools/build-game.ps1
```

For alternative CMake/Ninja locations:

```powershell
./tools/build-game.ps1 -CMake 'C:/path/to/cmake.exe' -Ninja 'C:/path/to/ninja.exe'
```

The build prepares the pinned upstream source and applies the port patch, downloads the official devkitPro packages listed with checksums in [sdk-lock.json](tools/sdk-lock.json), and checks out pinned SDL2/SDL2_mixer sources. Network access is needed for initial preparation. Existing prepared source changes are preserved.

Outputs: `build/game/fheroes2.3dsx`, `fheroes2.smdh`, and `fheroes2-engine-test.3dsx`. Building does not require original game assets; running the game does.

To prepare your own game data without uploading it:

```powershell
./tools/prepare-game-data.ps1 -OriginalGame 'C:/path/to/Heroes II'
```

This stages `Data`, `Maps` and supported `Tracks2` files in the ignored `sdmc` directory. `tools/package-game.ps1` creates public application/source ZIPs and a separate private SD staging directory; this local packaging workflow expects a game-data installation at its configured default path. Public ZIPs exclude original game assets.

## Source layout

This repository stores the port as a build wrapper plus a source patch against **fheroes2 1.1.17 snapshot `9754feff8501dbb69df95f3b999156a32eb8d7d3`**. It does not use an implicit or unpinned submodule.

| Path | Purpose |
|---|---|
| `patches/fheroes2-3ds.patch` | Engine/game changes and new 3DS renderer, input and command-strip code |
| `3ds-game/` | Game build entry point, engine checks and hardware notes |
| `3ds-platform-probe/` | Standalone platform probe |
| `cmake/` | Local devkitARM toolchain adapter |
| `tools/` | Source/SDK preparation, build, packaging and test scripts |
| `fheroes2/` | Generated, ignored upstream working checkout |
| `vendor/`, `.toolchain/`, `build/`, `dist/`, `sdmc/` | Generated or private local directories, ignored by Git |

See [CONTRIBUTING.md](CONTRIBUTING.md) before changing engine sources. Source ZIPs produced for previews contain the full modified engine sources and pinned dependency source archives in addition to this wrapper and patch.

## Testing and roadmap

The emulator scripts target an already configured, isolated portable Azahar profile under `.toolchain/azahar/`. They check engine serialization, viewport behavior, input routing, command-strip actions and map scrolling on a synthetic map. They do not certify full gameplay or physical Old 3DS support. Test scripts temporarily change that profile's model/configuration and restore it when finished.

- [Hardware results](3ds-game/HARDWARE_RESULTS_RU.md)
- [Controls and two-screen UI plan](3ds-game/UX_PLAN_RU.md)
- [Porting plan and pinned baseline](PORTING_PLAN_RU.md)

## License and credits

The port code and modified fheroes2 engine are **GPL-2.0-or-later**; see [LICENSE](LICENSE) and the retained upstream copyright notices in the patch/source files. fheroes2 is developed by its upstream contributors. SDL2, SDL2_mixer, zlib and the devkitPro tools retain their respective licenses and notices. Original Heroes II assets are not covered by the port's license and are not distributed here.
