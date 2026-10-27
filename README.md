# fheroes2-3ds

**English** | [Русский](README_RU.md)

A Nintendo 3DS port of [fheroes2](https://github.com/ihhub/fheroes2), the open-source Heroes of Might and Magic II engine.

**[Download preview 0.3.33](https://github.com/alekszverr-jpg/fheroes2-3ds/releases/tag/v0.3.33)** — use `fheroes2-menu-preview-0.3.33.zip` for your SD card. The separate source ZIP contains the modified engine and dependency sources. Original Heroes II game data is required and is not included.

Local development **0.3.75** joins the battle status plates without a dark gap and bottom-aligns the proportional buttons with matching touch targets. [Details and validation](3ds-game/README.md). The published release remains 0.3.33.

## Current preview

Version **0.3.33** adds built-building selection through **castle → Y → Buildings**. Dwellings appear first, upgrades replace base entries, and the highest built Mage Guild level is shown. Selected buildings use the original castle action handlers. Updating from 0.3.32 requires both `3ds/fheroes2/fheroes2.3dsx` and `3ds/fheroes2/files/lang/ru.mo`; preserve your configuration and saves.

New 3DS XL gameplay and overall operation through 0.3.32 have been reported working by the tester, without a complete scenario breakdown. The 0.3.33 selector passed short Azahar checks on New/Old in Russian and New in English; physical validation of 0.3.33 is pending. Physical Old 3DS support and long-session performance remain unverified.

## Features

- Top-screen overview of an 800×480 game frame, with standard 400×240 or high-resolution 800×240 **2D** output. R + Start switches and saves the preference; Old 2DS uses standard output. Local 0.3.35 adds experimental stereo for the town panorama only; stereo temporarily replaces wide output and does not alter the saved 2D preference.
- Cursor-following touchscreen detail, Circle Pad cursor, D-pad adventure-map scrolling, taps and held stylus information.
- Original adventure command strip and contextual combat hero panel on Y; native battle controls, scrollable log, results, surrender and necromancy dialogs.
- Touchscreen chest and level-up choices, animated creature recruitment, troop splitting and army information cards.
- Hero army/artifact/skill tabs and original spellbook artwork adapted for combat and adventure spell selection.
- Native marketplace and resource gifts, retaining original eligibility, exchange rates and caller-side game actions.
- Dual-screen construction confirmation/catalog, hero recruitment and castle options; Y garrison/visiting-hero army panel with original transfer rules and built-building selection.

Some specialized windows and the main castle scene retain their original layout. Detailed [preview history and limitations](3ds-game/README.md), [installation and controls](3ds-game/INSTALL.md), and [hardware results](3ds-game/HARDWARE_RESULTS_RU.md) distinguish emulator checks from physical testing.

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

The emulator scripts use an isolated portable Azahar profile under `.toolchain/azahar/`. Select the affected short group and run sequentially with process deadlines and load monitoring; do not automatically run monolithic Full on the maintained host. Tests cover UI/input, state restoration and selected original game handlers, but do not certify complete gameplay or physical Old 3DS support. See [grouped testing](3ds-game/TESTING.md) and [CONTRIBUTING.md](CONTRIBUTING.md).

- [Hardware results](3ds-game/HARDWARE_RESULTS_RU.md)
- [Controls and two-screen UI plan](3ds-game/UX_PLAN_RU.md)
- [Porting plan and pinned baseline](PORTING_PLAN_RU.md)

## License and credits

The port code and modified fheroes2 engine are **GPL-2.0-or-later**; see [LICENSE](LICENSE) and the retained upstream copyright notices in the patch/source files. fheroes2 is developed by its upstream contributors. SDL2, SDL2_mixer, zlib and the devkitPro tools retain their respective licenses and notices. Original Heroes II assets are not covered by the port's license and are not distributed here.
