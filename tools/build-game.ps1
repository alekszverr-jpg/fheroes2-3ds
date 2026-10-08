param([string]$CMake = 'C:/msys64/mingw64/bin/cmake.exe', [string]$Ninja = 'C:/msys64/mingw64/bin/ninja.exe')
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
& (Join-Path $PSScriptRoot 'prepare-upstream.ps1')
& (Join-Path $PSScriptRoot 'bootstrap-sdk.ps1')
$sdlCommit = '4c2d9014afda49553c76f7045529207bb593f9b5'
$mixerCommit = '8f0c805d54dbd1ff6b4b784d351ca884b8fe5ee9'
foreach ($dependency in @(
    @{Path='vendor/SDL2'; Url='https://github.com/libsdl-org/SDL.git'; Commit=$sdlCommit},
    @{Path='vendor/SDL2_mixer'; Url='https://github.com/libsdl-org/SDL_mixer.git'; Commit=$mixerCommit}
)) {
    $path = Join-Path $workspace $dependency.Path
    if (!(Test-Path (Join-Path $path '.git'))) {
        & git clone --no-checkout --depth 1 --branch SDL2 $dependency.Url $path
        if ($LASTEXITCODE -ne 0) { throw 'Dependency clone failed' }
        & git -C $path fetch --depth 1 origin $dependency.Commit
        if ($LASTEXITCODE -ne 0) { throw 'Pinned dependency fetch failed' }
        & git -C $path checkout --detach $dependency.Commit
        if ($LASTEXITCODE -ne 0) { throw 'Pinned dependency checkout failed' }
    }
    $head = & git -C $path rev-parse HEAD
    if ($LASTEXITCODE -ne 0 -or $head.Trim() -ne $dependency.Commit) { throw "Unexpected revision: $path" }
    $changes = & git -C $path status --porcelain --untracked-files=no
    if ($LASTEXITCODE -ne 0 -or $changes) { throw "Dependency has local changes: $path" }
}
$upstream = Join-Path $workspace 'fheroes2'
$head = if (Test-Path (Join-Path $upstream '.git')) { & git -C $upstream rev-parse HEAD }
        elseif (Test-Path (Join-Path $upstream 'upstream-revision.txt')) { Get-Content (Join-Path $upstream 'upstream-revision.txt') -Raw }
        else { '' }
if (!$head -or $head.Trim() -ne '9754feff8501dbb69df95f3b999156a32eb8d7d3') {
    throw 'Prepare fheroes2 at the baseline in PORTING_PLAN_RU.md and apply the local 3DS patch'
}
# Local engine changes are intentional and preserved; this is a development build.
$build = Join-Path $workspace 'build/game'
& $CMake -S (Join-Path $workspace '3ds-game') -B $build -G Ninja "-DCMAKE_MAKE_PROGRAM=$Ninja" "-DCMAKE_TOOLCHAIN_FILE=$(Join-Path $workspace 'cmake/native-3ds.cmake')" -DCMAKE_BUILD_TYPE=Release
if ($LASTEXITCODE -ne 0) { throw 'Game CMake configuration failed' }
& $CMake --build $build --parallel 6
if ($LASTEXITCODE -ne 0) { throw 'Game ARM build failed' }
Write-Output "Development binary: $(Join-Path $build 'fheroes2.3dsx')"
