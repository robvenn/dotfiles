# env.nu — Environment variables and PATH
# Runs before vendor autoload and config.nu
# See: https://www.nushell.sh/book/configuration.html

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------

$env.EDITOR = "hx"
$env.VISUAL = $env.EDITOR

# ---------------------------------------------------------------------------
# Tool config paths
# ---------------------------------------------------------------------------

$env.BAT_CONFIG_PATH = ($nu."home-dir" | path join ".config" "bat" "config")
$env.RIPGREP_CONFIG_PATH = ($nu."home-dir" | path join ".config" "ripgrep" "config")
$env.FZF_DEFAULT_OPTS_FILE = ($nu."home-dir" | path join ".config" "fzf" "config")
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"

# ---------------------------------------------------------------------------
# Starship
# ---------------------------------------------------------------------------

mkdir ($nu.cache-dir | path join "starship")
starship init nu | save -f ($nu.cache-dir | path join "starship" "init.nu")