# fheroes2-3ds

A work-in-progress Nintendo 3DS port of [fheroes2](https://github.com/ihhub/fheroes2), the open-source Heroes of Might and Magic II engine.

**English** | [Русский](README_RU.md)

**[Download preview 0.3.5](https://github.com/alekszverr-jpg/fheroes2-3ds/releases/tag/v0.3.5)** — download `fheroes2-menu-preview-0.3.5.zip` for your SD card. The source archive is for developers. See [installation and controls](3ds-game/INSTALL.md).

Current preview: **0.3.5**. The game has been run on a New Nintendo 3DS XL; AI turns, battles and saving/loading were reported working with earlier previews. The chest Gold choice was reported working on New 3DS XL. High-resolution output in 0.3.5 still needs hardware validation. Physical Old 3DS compatibility is unverified.

## Features

- An 800×480 game frame filling the top screen: 400×240 standard or optional 800×240 high-resolution 2D, switched with R + Start and saved in configuration; standard output on Old 2DS.
- A native-scale detail viewport on the touchscreen, following the cursor or stylus.
- Circle Pad cursor control; D-pad adventure-map scrolling, including diagonals.
- Short stylus taps for left clicks and stationary holds for right-button information.
- A toggleable bottom strip with the original adventure-map command icons.
- Common informational messages at native resolution on the top screen; common OK/yes/no dialogs on the touchscreen, with fixed buttons and scrolling for long content.
- Native touchscreen treasure-chest choice with labeled Gold/Experience buttons, fixed reward amounts and top-screen information.
- SD logging and a separate platform/engine test application.

Native messages cover the supported common `showMessage` path and the chest gold/experience choice. Hero level-up, army/monster information, recruitment and custom interactive windows retain their existing layouts and are the next UI work. Stereo 3D is not implemented yet.

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
