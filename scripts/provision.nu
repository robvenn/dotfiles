#!/usr/bin/env nu

# ── Helpers ───────────────────────────────────────────────────────────────────

def info [msg: string] { print $"  (ansi blue)[ .. ](ansi reset) ($msg)" }
def success [msg: string] { print $"  (ansi green)[ OK ](ansi reset) ($msg)" }
def warn [msg: string] { print $"  (ansi yellow)[WARN](ansi reset) ($msg)" }

def has-command [name: string] {
    (which $name | is-not-empty)
}

# ── Setup ─────────────────────────────────────────────────────────────────────

let dotfiles_dir = ($nu."home-dir" | path join "dotfiles")
let os = $nu."os-info".name

print ""
print $"==> Provisioning \(($os))"

# ── CLI Tools ─────────────────────────────────────────────────────────────────

print ""
print "==> CLI Tools"

if $os == "windows" {
    let scoopfile = ($dotfiles_dir | path join "scoopfile.json")
    if ($scoopfile | path exists) {
        info "Importing scoop packages..."
        try {
            ^scoop import $scoopfile
            success "Scoop packages imported"
        } catch {
            warn "scoop import failed -- some packages may need manual install"
        }
    } else {
        warn "scoopfile.json not found -- skipping scoop import"
    }
} else if $os == "macos" {
    let brewfile = ($dotfiles_dir | path join "Brewfile")
    if ($brewfile | path exists) {
        info "Installing Homebrew packages..."
        try {
            ^brew bundle --file=$brewfile --no-lock
            success "Homebrew packages installed"
        } catch {
            warn "brew bundle failed -- some packages may need manual install"
        }
    } else {
        warn "Brewfile not found -- skipping brew bundle"
    }
}

# ── Rustup ────────────────────────────────────────────────────────────────────

print ""
print "==> Rust Toolchain"

if (has-command "rustup") {
    success "rustup already installed"
} else {
    info "Installing rustup..."
    try {
        if $os == "windows" {
            let installer = ($nu."home-dir" | path join "rustup-init.exe")
            http get "https://win.rustup.rs" | save -f $installer
            ^$installer -y --default-toolchain stable
            rm $installer
        } else {
            ^bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable"
        }
        success "rustup installed"
    } catch {
        warn "rustup installation failed"
    }
}

# Make cargo available for the rest of this script
$env.PATH = ($env.PATH | prepend ($nu."home-dir" | path join ".cargo" "bin"))

if (has-command "rustup") {
    info "Ensuring stable toolchain + rust-analyzer..."
    try {
        ^rustup default stable
        ^rustup component add rust-analyzer
        success "Rust stable + rust-analyzer configured"
    } catch {
        warn "rustup component setup failed"
    }
}

# ── Cargo Tools ───────────────────────────────────────────────────────────────

print ""
print "==> Cargo Tools"

if (has-command "cargo") {
    if not (has-command "cargo-binstall") {
        info "Installing cargo-binstall..."
        try {
            ^cargo install cargo-binstall
            success "cargo-binstall installed"
        } catch {
            warn "cargo-binstall installation failed"
        }
    } else {
        success "cargo-binstall already installed"
    }

    if (has-command "cargo-binstall") {
        info "Installing cargo-update via binstall..."
        try {
            ^cargo binstall -y cargo-update
            success "cargo-update installed"
        } catch {
            warn "cargo-update installation failed"
        }
    }
} else {
    warn "cargo not found -- skipping cargo tools"
}

# ── mise ──────────────────────────────────────────────────────────────────────

print ""
print "==> mise"

if (has-command "mise") {
    info "Running mise install..."
    try {
        ^mise install
        success "mise runtimes installed"
    } catch {
        warn "mise install failed"
    }
} else {
    warn "mise not found -- skipping runtime installation"
}

# ── Vendor Autoload (Shell Integrations) ──────────────────────────────────────

print ""
print "==> Shell Integrations (vendor autoload)"

let vendor_dir = ($nu."data-dir" | path join "vendor" "autoload")
mkdir $vendor_dir

if (has-command "zoxide") {
    info "Generating zoxide.nu..."
    try {
        ^zoxide init nushell | save --force ($vendor_dir | path join "zoxide.nu")
        success "zoxide.nu generated"
    } catch {
        warn "zoxide init generation failed"
    }
} else {
    warn "zoxide not found -- skipping zoxide.nu"
}

if (has-command "mise") {
    info "Generating mise.nu..."
    try {
        ^mise activate nu | save --force ($vendor_dir | path join "mise.nu")
        success "mise.nu generated"
    } catch {
        warn "mise init generation failed"
    }
} else {
    warn "mise not found -- skipping mise.nu"
}

if (has-command "starship") {
    info "Generating starship.nu..."
    try {
        ^starship init nu | save --force ($vendor_dir | path join "starship.nu")
        success "starship.nu generated"
    } catch {
        warn "starship init generation failed"
    }
} else {
    warn "starship not found -- skipping starship.nu"
}

# ── Summary ───────────────────────────────────────────────────────────────────

print ""
print "==> Provisioning complete"
print "  Restart your terminal to load Nushell config."
print ""
