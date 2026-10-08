param([string]$Destination = (Join-Path $PSScriptRoot '../fheroes2'),
      [string]$Repository = 'https://github.com/ihhub/fheroes2.git')
$ErrorActionPreference = 'Stop'
$baseline = '9754feff8501dbb69df95f3b999156a32eb8d7d3'
$Destination = [IO.Path]::GetFullPath($Destination)
$patch = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../patches/fheroes2-3ds.patch'))
if (!(Test-Path $patch)) { throw 'The 3DS source patch is missing' }

if (!(Test-Path $Destination)) {
    & git init --quiet $Destination
    if ($LASTEXITCODE -ne 0) { throw 'Cannot initialize upstream checkout' }
    & git -C $Destination remote add origin $Repository
    if ($LASTEXITCODE -ne 0) { throw 'Cannot configure upstream remote' }
}

$hasGit = Test-Path (Join-Path $Destination '.git')
$head = if ($hasGit) { & git -C $Destination rev-parse --verify HEAD 2>$null }
        elseif (Test-Path (Join-Path $Destination 'upstream-revision.txt')) { Get-Content (Join-Path $Destination 'upstream-revision.txt') -Raw }
        else { '' }
if ($hasGit -and !$head) {
    # Resume a new checkout if its initial fetch was interrupted.
    & git -C $Destination fetch --depth 1 origin $baseline
    if ($LASTEXITCODE -ne 0) { throw 'Cannot fetch pinned fheroes2 baseline' }
    & git -C $Destination checkout --detach FETCH_HEAD
    if ($LASTEXITCODE -ne 0) { throw 'Cannot check out pinned fheroes2 baseline' }
    $head = & git -C $Destination rev-parse HEAD
}
if (!$head -or $head.Trim() -ne $baseline) { throw 'Unexpected upstream revision; existing files were preserved' }

if (Test-Path (Join-Path $Destination 'src/engine/platform_3ds.cpp')) {
    Write-Output "3DS upstream source already prepared; local edits preserved: $Destination"
    return
}
if (!$hasGit) { throw 'Exported source is missing the 3DS platform implementation' }
$changes = & git -C $Destination status --porcelain
if ($LASTEXITCODE -ne 0 -or $changes) { throw 'Upstream checkout has unrelated local changes; patch was not applied' }
& git -C $Destination apply --check $patch
if ($LASTEXITCODE -ne 0) { throw 'The 3DS patch does not apply to this checkout' }
& git -C $Destination apply $patch
if ($LASTEXITCODE -ne 0) { throw 'Cannot apply the 3DS patch' }
Write-Output "Pinned fheroes2 source and 3DS patch ready: $Destination"
