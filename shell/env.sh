# Canonical environment variables (POSIX sh).
# Sourced by zsh (via zshenv) and non-interactive bash (via BASH_ENV).
# Nushell and other child processes inherit these from the parent shell.
# Windows equivalent: scripts/bootstrap.ps1 writes these to the registry.
#
# No PATH here (see zprofile). No output (breaks scp/rsync).

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="hx"
export VISUAL="$EDITOR"

export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/config"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"

# Machine-specific overrides (not tracked)
if [ -f "$XDG_CONFIG_HOME/shell/env.local.sh" ]; then
    . "$XDG_CONFIG_HOME/shell/env.local.sh"
fi
