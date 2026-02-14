# Dotfiles

Cross-platform dotfiles for Windows, macOS, and Linux.

Replaces my archived [mac dotfiles](https://github.com/robvenn/dotfiles-macos-old) with a unified, cross-platform setup built around modern CLI tools.

## Stack

- **[Dotter](https://github.com/SuperCuber/dotter)** for symlink management with plain git
- **[Nushell](https://www.nushell.sh/)** ([repo](https://github.com/nushell/nushell)) as primary interactive shell, with minimal bash/zsh/PowerShell configs maintained for compatibility with system tools

## Configs

| Path | Deploys to | Purpose |
|------|-----------|---------|
| `nushell/` | `~/.config/nushell/` | Shell config (delta overrides) |
| `git/` | `~/.config/git/` | Global git config, attributes, ignore |
| `editorconfig` | `~/.editorconfig` | Cross-editor LF + indent settings |
| `bat/` | `~/.config/bat/` | Output style and pager |
| `ripgrep/` | `~/.config/ripgrep/` | Smart-case, hidden files, glob exclusions |
| `fzf/` | `~/.config/fzf/` | Layout, border, bat preview |

## Conventions

- **[XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/)** for consistent config paths (`~/.config/`) across platforms
- **Delta configs over monoliths** — only override defaults, never track full generated configs
- **No dot prefix** — files stored without dots, Dotter maps to dotted targets
- **Flat layout** — tool folders at root, single-file tools as bare files
