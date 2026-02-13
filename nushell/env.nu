# env.nu — Environment variables and PATH
# Runs before vendor autoload and config.nu
# See: https://www.nushell.sh/book/configuration.html

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------

$env.EDITOR = "hx"
$env.VISUAL = $env.EDITOR
