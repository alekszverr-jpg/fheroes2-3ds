$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$source = Join-Path $workspace 'fheroes2'
$baseline = '9754feff8501dbb69df95f3b999156a32eb8d7d3'
$head = & git -C $source rev-parse HEAD
if ($LASTEXITCODE -ne 0 -or !$head -or $head.Trim() -ne $baseline) { throw 'Engine checkout must remain at the pinned baseline' }
$lines = [Collections.Generic.List[string]]::new()
$tracked = & git -C $source diff --binary $baseline
if ($LASTEXITCODE -ne 0) { throw 'Cannot export tracked source changes' }
$lines.AddRange([string[]]$tracked)
$untracked = @(& git -C $source ls-files --others --exclude-standard)
if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate new source files' }
foreach ($file in $untracked) {
    if ($file -notmatch '^src/.*\.(cpp|h)$') { throw "Review new non-source file before exporting: $file" }
    $diff = & git -C $source diff --no-index --binary -- /dev/null $file
    if ($LASTEXITCODE -gt 1) { throw "Cannot export new source file: $file" }
    $lines.AddRange([string[]]$diff)
}
$patch = Join-Path $workspace 'patches/fheroes2-3ds.patch'
[IO.File]::WriteAllText($patch, ($lines -join "`n") + "`n", [Text.UTF8Encoding]::new($false))
& git -C $source apply --reverse --check $patch
if ($LASTEXITCODE -ne 0) { throw 'Exported patch does not match the engine checkout' }
Write-Output "Port patch exported and verified: $patch"
