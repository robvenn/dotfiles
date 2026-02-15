# Dotfiles

Cross-platform dotfiles for Windows, macOS, and Linux.

Replaces my archived [mac dotfiles](https://github.com/robvenn/dotfiles-macos-old) with a unified, cross-platform setup built around modern CLI tools.

## Stack

- **[Dotter](https://github.com/SuperCuber/dotter)** for symlink management with plain git
- **[Nushell](https://www.nushell.sh/)** ([repo](https://github.com/nushell/nushell)) as primary interactive shell, with minimal bash/zsh/PowerShell configs maintained for compatibility with system tools
- **[mise](https://mise.jdx.dev/)** for Node.js version management
- **Core CLI tools**: [bat](https://github.com/sharkdp/bat), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [fzf](https://github.com/junegunn/fzf), [zoxide](https://github.com/ajeetdsouza/zoxide)

## Configs

| Path | Tool |
|------|------|
| `nushell/` | Primary interactive shell |
| `git/` | Version control (config, attributes, global ignore) |
| `helix/` | Terminal editor + language server configs |
| `zed/` | Desktop editor |
| `bat/` | `cat` replacement with syntax highlighting |
| `ripgrep/` | Fast text search |
| `fzf/` | Fuzzy finder |
| `mise/` | Node.js version management |
| `editorconfig` | Cross-editor formatting defaults |

## Conventions

- **[XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/)** for consistent config paths (`~/.config/`) across platforms
- **Delta configs over monoliths** — only override defaults, never track full generated configs
- **No dot prefix** — files stored without dots, Dotter maps to dotted targets
- **Flat layout** — tool folders at root, single-file tools as bare files
