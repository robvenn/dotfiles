$env.config.show_banner = false
$env.config.buffer_editor = "hx"

$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 100_000

# ---------------------------------------------------------------------------
# Starship
# ---------------------------------------------------------------------------

source ($nu.cache-dir | path join "starship" "init.nu")