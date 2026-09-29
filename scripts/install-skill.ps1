[CmdletBinding()]
param([string]$SkillsDirectory)
$ErrorActionPreference = 'Stop'
$source = Split-Path -Parent $PSScriptRoot
# A Git clone is also a valid install source; never copy its repository metadata.
$sourceFiles = @(Get-ChildItem -LiteralPath $source -Recurse -File -Force | Where-Object {
    $relativePath = $_.FullName.Substring($source.Length+1)
    $relativePath -notmatch '(^|[\\/])\.git([\\/]|$)'
})
if (-not $SkillsDirectory) {
    $codexDirectory = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex' }
    $SkillsDirectory = Join-Path $codexDirectory 'skills'
}
$target = [IO.Path]::GetFullPath((Join-Path $SkillsDirectory 'autocomsol'))
if ([IO.Path]::GetFullPath($source) -eq $target) {
    Write-Output "Already in skill directory: $target"
    return
}
if (Test-Path -LiteralPath $target) {
    foreach ($file in $sourceFiles) {
        $relative = $file.FullName.Substring($source.Length+1)
        $installed = Join-Path $target $relative
        if (-not (Test-Path -LiteralPath $installed) -or
            (Get-FileHash -LiteralPath $installed).Hash -ne (Get-FileHash -LiteralPath $file.FullName).Hash) {
            throw "An existing skill differs at $relative. Review and back up before updating."
        }
    }
    Write-Output "Identical skill already installed: $target"
    return
}
New-Item -ItemType Directory -Path $SkillsDirectory -Force | Out-Null
New-Item -ItemType Directory -Path $target -Force | Out-Null
foreach ($file in $sourceFiles) {
    $relative = $file.FullName.Substring($source.Length+1)
    $destination = Join-Path $target $relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
    Copy-Item -LiteralPath $file.FullName -Destination $destination
}
Write-Output "Installed skill: $target"
Write-Output 'In a new Codex chat invoke $autocomsol to bootstrap MCP and validate the COMSOL with MATLAB session.'
