# 01-aliases.nu — Shell aliases for interactive use
# Loaded after config.nu via user autoload

# eza — never alias ls (Nushell's ls returns structured data)
alias ll = ^eza -l --icons --group-directories-first --git
alias la = ^eza -la --icons --group-directories-first --git
alias lt = ^eza --tree --level=2 --icons

# bat as cat — safe in Nushell (no built-in cat to shadow)
alias cat = ^bat
