[CmdletBinding()]
param(
    [string]$RuntimeDir,
    [string]$CodexDirectory,
    [switch]$RegisterMcp
)
$ErrorActionPreference = 'Stop'
if ([Environment]::OSVersion.Platform -ne 'Win32NT' -or -not [Environment]::Is64BitOperatingSystem) {
    throw 'This installer supports Windows x64 only.'
}
$skillRoot = Split-Path -Parent $PSScriptRoot
$release = Get-Content -Raw -LiteralPath (Join-Path $skillRoot 'assets/mcp-release.json') | ConvertFrom-Json
if (-not $CodexDirectory) {
    $CodexDirectory = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex' }
}
if (-not $RuntimeDir) { $RuntimeDir = Join-Path $CodexDirectory ('tools/matlab-mcp/' + $release.version) }
$RuntimeDir = [IO.Path]::GetFullPath($RuntimeDir)
New-Item -ItemType Directory -Path $RuntimeDir -Force | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding($false)
foreach ($asset in $release.assets) {
    $destination = Join-Path $RuntimeDir $asset.name
    if (-not (Test-Path -LiteralPath $destination)) {
        $download = $destination + '.download'
        $url = 'https://github.com/' + $release.repository + '/releases/download/' + $release.version + '/' + $asset.name
        Invoke-WebRequest -Uri $url -OutFile $download -UseBasicParsing
        if ((Get-FileHash -LiteralPath $download -Algorithm SHA256).Hash.ToLowerInvariant() -ne $asset.sha256) {
            throw "Checksum failed: $download. Nothing was executed."
        }
        Move-Item -LiteralPath $download -Destination $destination
    }
    if ((Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash.ToLowerInvariant() -ne $asset.sha256) {
        throw "Existing file checksum differs: $destination. Refusing to replace or execute."
    }
}
$binary = Join-Path $RuntimeDir 'matlab-mcp-server-windows-x64.exe'
$toolbox = (Join-Path $RuntimeDir 'MATLABMCPServerToolbox.mltbx').Replace("'", "''")
$prepare = @"
% Run this script in the COMSOL with MATLAB session you want Codex to use.
% No model is created and no existing workspace variables are cleared.
if isempty(which('mphversion'))
    error('AutoCOMSOL:NoLiveLink', 'Run this in COMSOL with MATLAB, not a plain MATLAB session.');
end
fprintf('MATLAB: %s\nCOMSOL: %s\n', version, mphversion);
if isempty(which('shareMATLABSession'))
    matlab.addons.toolbox.installToolbox('$toolbox', true);
end
shareMATLABSession();
fprintf('AUTOCOMSOL_SESSION_SHARED\n');
"@
[IO.File]::WriteAllText((Join-Path $RuntimeDir 'prepare_session.m'), $prepare, $utf8)
# TOML literal strings preserve Windows backslashes. Reject the delimiter itself.
if ($binary.Contains("'")) { throw 'RuntimeDir must not contain an apostrophe for this TOML installer.' }
$block = @"
[mcp_servers.autocomsol_matlab]
command = '$binary'
args = ["--matlab-session-mode=existing", "--disable-telemetry=true"]
env_vars = ["WINDIR", "TEMP", "TMP"]
startup_timeout_sec = 60
tool_timeout_sec = 180
"@
[IO.File]::WriteAllText((Join-Path $RuntimeDir 'mcp-config.toml'), $block, $utf8)
if ($RegisterMcp) {
    New-Item -ItemType Directory -Path $CodexDirectory -Force | Out-Null
    $config = Join-Path $CodexDirectory 'config.toml'
    $existing = if (Test-Path -LiteralPath $config) { [IO.File]::ReadAllText($config) } else { '' }
    if ($existing -match '(?m)^\s*\[mcp_servers\.autocomsol_matlab(?:\]|\.)') {
        if (-not $existing.Contains($block.Trim())) {
            throw 'autocomsol_matlab already exists with different settings. Review mcp-config.toml and merge intentionally.'
        }
        Write-Output 'MCP registration already matches; config left unchanged.'
    } else {
        if ($existing -match '(?im)matlab-mcp-(?:core-)?server') {
            throw 'Another MATLAB MCP configuration exists. Inspect and reuse it; do not register duplicate connections.'
        }
        if (Test-Path -LiteralPath $config) {
            Copy-Item -LiteralPath $config -Destination ($config + '.autocomsol-' + (Get-Date -Format 'yyyyMMdd-HHmmssfff') + '.bak')
        }
        [IO.File]::WriteAllText($config, $existing.TrimEnd() + "`r`n`r`n" + $block + "`r`n", $utf8)
        Write-Output "Registered autocomsol_matlab in $config"
    }
}
Write-Output "Verified official MATLAB MCP $($release.version): $binary"
Write-Output "In COMSOL with MATLAB run: run('$(($RuntimeDir + '\prepare_session.m').Replace("'", "''"))')"
Write-Output 'Then reload MCP in Codex or start a new chat. COMSOL/MATLAB versions and licenses still need live validation.'
