# Contributing

Build and test the current preview before changing code. `build-game.ps1` defaults to two compiler jobs (including packaging); `-Jobs` can override this explicitly. The maintained environment is Windows/PowerShell 7; alternative host environments need their own toolchain integration.

## Current host emulator limitation

On 2026-10-13 this Windows host froze during a monolithic Azahar run and required a forced reboot. The user subsequently explicitly authorized emulator validation; all groups passed sequentially on New/Old Russian and New English with CPU/memory monitoring and per-process deadlines. Use only the affected short groups for ongoing changes, sequentially, with BelowNormal priority and bounded diagnostics. Do not automatically run monolithic Full on this host. Stop the series on a failed group, excessive load or reported desktop problems, and investigate before continuing.

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

For meaningful input or renderer changes, when host emulator runs are permitted, select the affected menu group explicitly and run the full suite separately for broad regression. `test-menu-emulator.ps1` defaults to Startup; use `-Group Full` for all checks. See [grouped testing](3ds-game/TESTING.md). For renderer/input changes run the appropriate engine/menu checks for both models and then test on hardware. Run emulator scripts sequentially because they share one profile. Record what was actually tested; distinguish emulator results from physical Old/New hardware results.

## Game data and releases

Keep original game resources, saves, configuration, logs, extracted SDKs and build outputs in ignored local directories. Do not force-add them to Git. Preview releases should contain the application/free fheroes2 resources plus a corresponding source archive, never the private SD staging tree.

Keep upstream copyright notices and GPL license information. Keep SDL/dependency source pins and SDK checksums explicit when changing dependencies. Platform changes should remain conditional on `__3DS__` so that desktop behavior is preserved.
