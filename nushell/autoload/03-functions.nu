# 03-functions.nu — Shell functions for interactive use

# fe — find & edit (fd → fzf → $EDITOR).
def fe [] {
    let file = (fd --type f | fzf --preview 'bat --color=always {}')
    if ($file | is-not-empty) { ^$env.EDITOR ($file | str trim) }
}

# rgi — rg interactive with live-reload (fzf re-runs rg as you type).
def rgi [query?: string = ""] {
    let rg_prefix = "rg --column --line-number --no-heading --color=always --smart-case "
    let result = (
        ^fzf --ansi --disabled --query $query
            --bind $"start:reload:($rg_prefix){q}"
            --bind $"change:reload:sleep 0.1; ($rg_prefix){q} || true"
            --delimiter ":"
            --preview 'bat --color=always --highlight-line {2} {1}'
            --preview-window 'up,60%,+{2}+3/3,~3'
        | complete
    )
    if $result.exit_code != 0 { return }
    let pick = ($result.stdout | str trim | split row ":")
    if ($pick | length) < 2 { return }
    let file = ($pick | get 0)
    let line = ($pick | get 1)
    let col = (try { $pick | get 2 } catch { "1" })
    ^$env.EDITOR $"($file):($line):($col)"
}