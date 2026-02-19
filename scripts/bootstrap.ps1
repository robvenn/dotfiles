#Requires -Version 5.1
# Stage 1 bootstrap for Windows. Idempotent.
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoUrl = "https://github.com/robvenn/dotfiles.git"

if ($PSScriptRoot) {
    $DotfilesDir = Split-Path -Parent $PSScriptRoot
} else {
    $DotfilesDir = "$env:USERPROFILE\dotfiles"
}

# ── Helpers ───────────────────────────────────────────────────────────────────

function Write-Info    { param([string]$Msg) Write-Host "  [ .. ] $Msg" -ForegroundColor Blue }
function Write-Success { param([string]$Msg) Write-Host "  [ OK ] $Msg" -ForegroundColor Green }
function Write-Warn    { param([string]$Msg) Write-Host "  [WARN] $Msg" -ForegroundColor Yellow }

function Set-PersistentEnv {
    param([string]$Name, [string]$Value)
    $current = [Environment]::GetEnvironmentVariable($Name, 'User')
    if ($current -eq $Value) {
        Write-Success "$Name already set"
        return
    }
    [Environment]::SetEnvironmentVariable($Name, $Value, 'User')
    Set-Item -Path "Env:\$Name" -Value $Value
    Write-Success "$Name = $Value"
}

$warnings = @()

# ── Developer Mode ────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Developer Mode" -ForegroundColor Magenta

$devModeKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
try {
    $val = Get-ItemPropertyValue -Path $devModeKey -Name AllowDevelopmentWithoutDevLicense -ErrorAction SilentlyContinue
    if ($val -eq 1) {
        Write-Success "Developer Mode already enabled"
    } else {
        Write-Info "Attempting to enable Developer Mode (requires admin)..."
        Set-ItemProperty -Path $devModeKey -Name AllowDevelopmentWithoutDevLicense -Value 1 -ErrorAction Stop
        Write-Success "Developer Mode enabled"
    }
} catch {
    $warnings += "Developer Mode not enabled (not admin). Dotter will use file copies instead of symlinks."
    Write-Warn $warnings[-1]
}

# ── Scoop ─────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Scoop" -ForegroundColor Magenta

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Success "Scoop already installed"
} else {
    Write-Info "Installing Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    Write-Success "Scoop installed"
}

# ── Git ───────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Git" -ForegroundColor Magenta

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Success "Git already installed"
} else {
    Write-Info "Installing git via scoop..."
    scoop install git
    if ($LASTEXITCODE -ne 0) { throw "scoop install git failed" }
    Write-Success "Git installed"
}

# ── Scoop Buckets ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Scoop Buckets" -ForegroundColor Magenta

$installedBuckets = scoop bucket list | Select-Object -ExpandProperty Name
if ($installedBuckets -contains "main") {
    Write-Success "main bucket already added"
} else {
    Write-Info "Adding main bucket..."
    scoop bucket add main
    if ($LASTEXITCODE -ne 0) { throw "scoop bucket add main failed" }
    Write-Success "main bucket added"
}

# ── Core Tools ────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Core Tools" -ForegroundColor Magenta

foreach ($tool in @("nu", "dotter")) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        Write-Success "$tool already installed"
    } else {
        Write-Info "Installing $tool..."
        scoop install $tool
        if ($LASTEXITCODE -ne 0) { throw "scoop install $tool failed" }
        Write-Success "$tool installed"
    }
}

# ── Environment Variables ─────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Environment Variables" -ForegroundColor Magenta

Set-PersistentEnv "XDG_CONFIG_HOME" "$env:USERPROFILE\.config"
Set-PersistentEnv "XDG_DATA_HOME"   "$env:USERPROFILE\.local\share"
Set-PersistentEnv "XDG_STATE_HOME"  "$env:USERPROFILE\.local\state"
Set-PersistentEnv "XDG_CACHE_HOME"  "$env:USERPROFILE\.cache"

Set-PersistentEnv "BAT_CONFIG_PATH"       "$env:USERPROFILE\.config\bat\config"
Set-PersistentEnv "RIPGREP_CONFIG_PATH"   "$env:USERPROFILE\.config\ripgrep\config"
Set-PersistentEnv "FZF_DEFAULT_OPTS_FILE" "$env:USERPROFILE\.config\fzf\config"
Set-PersistentEnv "FZF_DEFAULT_COMMAND"   "fd --type f --hidden --follow --exclude .git"

# ── Clone Dotfiles ────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Dotfiles Repo" -ForegroundColor Magenta

if (Test-Path "$DotfilesDir\.git") {
    Write-Success "Dotfiles repo already exists at $DotfilesDir"
} else {
    Write-Info "Cloning dotfiles repo..."
    git clone $RepoUrl $DotfilesDir
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
    Write-Success "Dotfiles repo cloned"
}

# ── Dotter local.toml ────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Dotter Configuration" -ForegroundColor Magenta

$localToml = "$DotfilesDir\.dotter\local.toml"

if (Test-Path $localToml) {
    Write-Success "local.toml already exists"
} else {
    Write-Info "Creating local.toml for Windows..."
    @'
includes = [".dotter/windows.toml"]
packages = ["nushell", "git", "editorconfig", "bat", "ripgrep", "fzf", "mise", "helix", "zed"]
'@ | Set-Content -Path $localToml -NoNewline
    Write-Success "local.toml created"
}

# ── Dotter Deploy ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Dotter Deploy" -ForegroundColor Magenta

Write-Info "Deploying dotfiles..."
Push-Location $DotfilesDir
try {
    dotter deploy
    if ($LASTEXITCODE -ne 0) { throw "dotter deploy failed" }
    Write-Success "Dotfiles deployed"
} finally {
    Pop-Location
}

# ── Summary ───────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Summary" -ForegroundColor Magenta

if ($warnings.Count -eq 0) {
    Write-Success "All steps completed successfully"
} else {
    Write-Warn "$($warnings.Count) warning(s):"
    foreach ($w in $warnings) {
        Write-Warn "  - $w"
    }
}

# ── Stage 2 ───────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "==> Stage 2" -ForegroundColor Magenta

$provisionScript = "$DotfilesDir\scripts\provision.nu"
if (Test-Path $provisionScript) {
    Write-Info "Invoking provision.nu..."
    nu $provisionScript
} else {
    Write-Warn "provision.nu not found -- skipping Stage 2"
}
