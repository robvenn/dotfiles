$env.config.show_banner = false
$env.config.buffer_editor = "hx"

$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 100_000

$env.config.table.mode = "compact"
$env.config.table.header_on_separator = true
$env.config.table.index_mode = "always"
$env.config.table.abbreviated_row_count = 30

$env.config.completions.algorithm = "fuzzy"

# External completer — carapace for everything except z/zi, which keep zoxide's native completer.
let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines
}

$env.config.completions.external = {
    enable: true
    completer: {|spans|
        match $spans.0 {
            z | zi => $zoxide_completer
            _ => $carapace_completer
        } | do $in $spans
    }
}
