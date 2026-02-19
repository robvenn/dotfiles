#!/usr/bin/env bash
# Stage 1 bootstrap for macOS. Idempotent.
set -euo pipefail

REPO_URL="https://github.com/robvenn/dotfiles.git"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Fallback for piped execution (curl | bash)
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    DOTFILES_DIR="$HOME/dotfiles"
fi

# ── Helpers ───────────────────────────────────────────────────────────────────

info()    { printf "  [ \033[0;34m..\033[0m ] %s\n" "$1"; }
success() { printf "  [ \033[0;32mOK\033[0m ] %s\n" "$1"; }
warn()    { printf "  [\033[0;33mWARN\033[0m] %s\n" "$1"; }
fail()    { printf "  [\033[0;31mFAIL\033[0m] %s\n" "$1"; exit 1; }

warnings=()

# ── Homebrew ──────────────────────────────────────────────────────────────────

echo ""
echo "==> Homebrew"

if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew already installed (Apple Silicon)"
elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    success "Homebrew already installed (Intel)"
else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    success "Homebrew installed"
fi

# ── Core Tools ────────────────────────────────────────────────────────────────

echo ""
echo "==> Core Tools"

for tool in nushell git dotter; do
    if brew list "$tool" &>/dev/null; then
        success "$tool already installed"
    else
        info "Installing $tool..."
        brew install "$tool"
        success "$tool installed"
    fi
done

# ── Rosetta 2 (Apple Silicon) ────────────────────────────────────────────────

echo ""
echo "==> Rosetta 2"

arch="$(uname -m)"
if [ "$arch" = "arm64" ]; then
    if /usr/bin/pgrep -q oahd 2>/dev/null; then
        success "Rosetta 2 already installed"
    elif [ -t 0 ]; then
        printf "  [ \033[0;34m..\033[0m ] Install Rosetta 2 for x86_64 compatibility? [y/N] "
        read -r answer < /dev/tty
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            softwareupdate --install-rosetta --agree-to-license
            success "Rosetta 2 installed"
        else
            warnings+=("Rosetta 2 skipped --some x86_64 binaries may not work")
            warn "${warnings[-1]}"
        fi
    else
        warnings+=("Rosetta 2 skipped (non-interactive)")
        warn "${warnings[-1]}"
    fi
else
    success "Intel Mac --Rosetta 2 not needed"
fi

# ── Clone Dotfiles ────────────────────────────────────────────────────────────

echo ""
echo "==> Dotfiles Repo"

if [ -d "$DOTFILES_DIR/.git" ]; then
    success "Dotfiles repo already exists at $DOTFILES_DIR"
else
    info "Cloning dotfiles repo..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    success "Dotfiles repo cloned"
fi

# ── Dotter local.toml ────────────────────────────────────────────────────────

echo ""
echo "==> Dotter Configuration"

local_toml="$DOTFILES_DIR/.dotter/local.toml"

if [ -f "$local_toml" ]; then
    success "local.toml already exists"
else
    info "Creating local.toml for macOS..."
    cat > "$local_toml" << 'EOF'
packages = ["nushell", "git", "editorconfig", "bat", "ripgrep", "fzf", "mise", "helix", "zed"]
EOF
    success "local.toml created"
fi

# ── Dotter Deploy ─────────────────────────────────────────────────────────────

echo ""
echo "==> Dotter Deploy"

info "Deploying dotfiles..."
(cd "$DOTFILES_DIR" && dotter deploy)
success "Dotfiles deployed"

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "==> Summary"

if [ ${#warnings[@]} -eq 0 ]; then
    success "All steps completed successfully"
else
    warn "${#warnings[@]} warning(s):"
    for w in "${warnings[@]}"; do
        warn "  - $w"
    done
fi

# ── Stage 2 ───────────────────────────────────────────────────────────────────

echo ""
echo "==> Stage 2"

provision_script="$DOTFILES_DIR/scripts/provision.nu"
if [ -f "$provision_script" ]; then
    info "Invoking provision.nu..."
    nu "$provision_script"
else
    warn "provision.nu not found --skipping Stage 2"
fi
