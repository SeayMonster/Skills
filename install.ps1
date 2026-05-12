# michellesacia-lab Skills - Claude Code Installer
# No prerequisites - uses only built-in PowerShell (Windows 10/11).
# Usage: paste into any PowerShell window:
#   irm https://raw.githubusercontent.com/michellesacia-lab/Skills/main/install.ps1 | iex

# Re-launch with execution-policy bypass if needed (fixes "not digitally signed" error)
if ($MyInvocation.ScriptName -and (Get-ExecutionPolicy) -in 'Restricted','AllSigned') {
    powershell -ExecutionPolicy Bypass -File $MyInvocation.ScriptName; exit
}

# UTF-8 BOM-safe write helper (avoids Claude Desktop JSON parse errors)
function Write-JsonNoBom($obj, $path) {
    $json = $obj | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($path, $json, [System.Text.UTF8Encoding]::new($false))
}

# Strip BOM from a file if present (safety net for files manually edited in Notepad)
function Remove-Bom($path) {
    if (-not (Test-Path $path)) { return }
    $bytes = [System.IO.File]::ReadAllBytes($path)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        [System.IO.File]::WriteAllBytes($path, $bytes[3..($bytes.Length - 1)])
    }
}

$repo      = "michellesacia-lab/Skills"
$branch    = "main"
$marketKey = "michellesacia-lab"

$plugins = @(
    @{ name = "crisp-bc-workflow-chart"; version = "1.0.0" },
    @{ name = "crisp-bc-sdd";            version = "1.0.0" }
)

$claudeDir      = "$env:USERPROFILE\.claude"
$settingsPath   = "$claudeDir\settings.json"
$marketplaceDir = "$claudeDir\plugins\marketplaces\$marketKey"

Write-Host ""
Write-Host "Crisp Consulting Skills Installer" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor DarkCyan
Write-Host ""

# -----------------------------------------------------------------------
# Step 1: Register marketplace in settings.json
# -----------------------------------------------------------------------

if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir | Out-Null }

Remove-Bom $settingsPath

if (Test-Path $settingsPath) {
    $raw = Get-Content $settingsPath -Raw
    try   { $settings = $raw | ConvertFrom-Json }
    catch {
        Write-Host "  ERROR: $settingsPath contains invalid JSON. Fix it manually first." -ForegroundColor Red
        exit 1
    }
} else {
    $settings = [PSCustomObject]@{}
}

$alreadyRegistered = $settings.PSObject.Properties["extraKnownMarketplaces"] -and
                     $settings.extraKnownMarketplaces.PSObject.Properties[$marketKey]

if (-not $alreadyRegistered) {
    if (-not $settings.PSObject.Properties["extraKnownMarketplaces"]) {
        $settings | Add-Member -MemberType NoteProperty -Name "extraKnownMarketplaces" -Value ([PSCustomObject]@{})
    }
    $entry = [PSCustomObject]@{
        source = [PSCustomObject]@{ source = "github"; repo = $repo }
    }
    $settings.extraKnownMarketplaces | Add-Member -MemberType NoteProperty -Name $marketKey -Value $entry
    Write-JsonNoBom $settings $settingsPath
    Write-Host "  [1/4] Marketplace registered in settings.json" -ForegroundColor Green
} else {
    Write-Host "  [1/4] Marketplace already registered - skipped" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------
# Step 2: Download repo ZIP and copy to marketplace dir
# -----------------------------------------------------------------------

$repoSlug = $repo.Split('/')[-1]
$zipUrl   = "https://github.com/$repo/archive/refs/heads/$branch.zip"
$tmpZip   = "$env:TEMP\$repoSlug-$branch.zip"
$tmpDir   = "$env:TEMP\$repoSlug-extract"
$srcDir   = "$tmpDir\$repoSlug-$branch"

Write-Host "  [2/4] Downloading skills from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $tmpZip -UseBasicParsing
} catch {
    Write-Host "  ERROR: Could not download skills. Check your internet connection." -ForegroundColor Red
    exit 1
}

if (Test-Path $tmpDir) { Remove-Item $tmpDir -Recurse -Force }
Expand-Archive -Path $tmpZip -DestinationPath $tmpDir -Force
Remove-Item $tmpZip -Force

if (Test-Path $marketplaceDir) { Remove-Item $marketplaceDir -Recurse -Force }
Copy-Item $srcDir $marketplaceDir -Recurse -Force
Remove-Item $tmpDir -Recurse -Force

Write-Host "  [2/4] Skills downloaded" -ForegroundColor Green

# -----------------------------------------------------------------------
# Step 3: Populate plugin cache for each plugin
# -----------------------------------------------------------------------

Write-Host "  [3/4] Populating plugin cache..." -ForegroundColor Cyan

foreach ($plugin in $plugins) {
    $pluginSrc   = "$marketplaceDir\plugins\$($plugin.name)"
    $pluginCache = "$claudeDir\plugins\cache\$marketKey\$($plugin.name)\$($plugin.version)"

    if (Test-Path $pluginCache) { Remove-Item $pluginCache -Recurse -Force }
    New-Item -ItemType Directory -Path $pluginCache -Force | Out-Null
    Copy-Item "$pluginSrc\*" $pluginCache -Recurse -Force
    Write-Host "    - $($plugin.name) cached" -ForegroundColor Green
}

Write-Host "  [3/4] Plugin cache populated" -ForegroundColor Green

# -----------------------------------------------------------------------
# Step 4: Register plugins in installed_plugins.json and enable in settings.json
# -----------------------------------------------------------------------

$installedPluginsPath = "$claudeDir\plugins\installed_plugins.json"
$now = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

Remove-Bom $installedPluginsPath

if (Test-Path $installedPluginsPath) {
    try   { $ip = Get-Content $installedPluginsPath -Raw | ConvertFrom-Json }
    catch { $ip = [PSCustomObject]@{ version = 2; plugins = [PSCustomObject]@{} } }
} else {
    $ip = [PSCustomObject]@{ version = 2; plugins = [PSCustomObject]@{} }
}

if (-not $ip.PSObject.Properties["plugins"]) {
    $ip | Add-Member -MemberType NoteProperty -Name "plugins" -Value ([PSCustomObject]@{})
}

Remove-Bom $settingsPath
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

if (-not $settings.PSObject.Properties["enabledPlugins"]) {
    $settings | Add-Member -MemberType NoteProperty -Name "enabledPlugins" -Value ([PSCustomObject]@{})
}

foreach ($plugin in $plugins) {
    $pluginKey   = "$($plugin.name)@$marketKey"
    $installPath = "$claudeDir\plugins\cache\$marketKey\$($plugin.name)\$($plugin.version)"

    $entry = @([PSCustomObject]@{
        scope       = "user"
        installPath = $installPath
        version     = $plugin.version
        installedAt = $now
        lastUpdated = $now
    })

    if ($ip.plugins.PSObject.Properties[$pluginKey]) {
        $ip.plugins.PSObject.Properties.Remove($pluginKey)
    }
    $ip.plugins | Add-Member -MemberType NoteProperty -Name $pluginKey -Value $entry

    if (-not $settings.enabledPlugins.PSObject.Properties[$pluginKey]) {
        $settings.enabledPlugins | Add-Member -MemberType NoteProperty -Name $pluginKey -Value $true
    }
}

New-Item -ItemType Directory -Path (Split-Path $installedPluginsPath) -Force | Out-Null
Write-JsonNoBom $ip $installedPluginsPath
Write-JsonNoBom $settings $settingsPath

Write-Host "  [4/4] Plugins registered and enabled" -ForegroundColor Green

# -----------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------

Write-Host ""
Write-Host "All done! Restart Claude Code and the skills will be ready." -ForegroundColor Green
Write-Host ""
Write-Host "Plugins installed:" -ForegroundColor Cyan
foreach ($plugin in $plugins) {
    Write-Host "  $($plugin.name)@$marketKey v$($plugin.version)"
}
Write-Host ""
