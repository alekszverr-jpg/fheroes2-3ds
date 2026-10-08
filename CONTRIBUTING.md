# Contributing

Build and test the current preview before changing code. The maintained environment is Windows/PowerShell 7; alternative host environments need their own toolchain integration.

## Editing the engine

`tools/prepare-upstream.ps1` creates the ignored `fheroes2/` working checkout at the pinned baseline and applies `patches/fheroes2-3ds.patch`. Edit engine/game sources in that checkout. Existing edits are preserved on subsequent builds.

Before committing port changes, export the updated patch:

```powershell
./tools/export-port-patch.ps1
./tools/build-game.ps1
git diff --check
git diff --stat
```

Commit the patch and any wrapper/build/documentation changes in this repository. Do not commit changes separately in the generated upstream checkout: builds expect its HEAD to stay at the pinned baseline. The export script includes tracked changes against that baseline and untracked source files, and verifies that the resulting patch corresponds to the checkout.

For meaningful input or renderer changes, run the engine/menu checks in the configured isolated Azahar profile for both models and then test on hardware. Run emulator scripts sequentially because they share one profile. Record what was actually tested; distinguish emulator results from physical Old/New hardware results.

## Game data and releases

Keep original game resources, saves, configuration, logs, extracted SDKs and build outputs in ignored local directories. Do not force-add them to Git. Preview releases should contain the application/free fheroes2 resources plus a corresponding source archive, never the private SD staging tree.

Keep upstream copyright notices and GPL license information. Keep SDL/dependency source pins and SDK checksums explicit when changing dependencies. Platform changes should remain conditional on `__3DS__` so that desktop behavior is preserved.
