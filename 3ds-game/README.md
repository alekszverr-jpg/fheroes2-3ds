# fheroes2 Nintendo 3DS game build

Preview **0.3.2** builds the fheroes2 engine and game for Homebrew Launcher. See [installation and controls](INSTALL.md), the [root README](../README.md) for build instructions, and [CONTRIBUTING.md](../CONTRIBUTING.md) for editing the engine patch.

The renderer presents an 800×480 indexed game frame as a full 400×240 overview on the top screen and a native-scale detail viewport on the touchscreen. Circle Pad and stylus control the cursor and detail viewport; the D-pad scrolls the adventure map. Y toggles a touchscreen strip using the original adventure command icons.

The build entry point in `CMakeLists.txt` combines the upstream engine/Smacker targets with game sources, pinned SDL2 and SDL2_mixer, and the local devkitARM toolchain adapter. It preserves the upstream desktop configuration. Platform changes are distributed in `../patches/fheroes2-3ds.patch` against upstream commit `9754feff8501dbb69df95f3b999156a32eb8d7d3`.

`engine_smoke.cpp` checks the platform/engine input and rendering behavior. The menu test also exercises command-strip selection and map scrolling on a synthetic world. New/Old Azahar checks passed; preview 0.3.2 still needs physical hardware validation. Previous previews were reported working on New 3DS XL for matches, AI, combat and saving/loading.

The next UI work is informational popups on the top screen, interactive dialogs on the bottom screen, then battle commands. Stereo 3D is a later experiment. Detailed historical notes and plans remain available in [Russian](README_RU.md).
