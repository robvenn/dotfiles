# Dotfiles

Cross-platform dotfiles for Windows, macOS, and Linux.

Replaces my archived [mac dotfiles](https://github.com/robvenn/dotfiles-macos-old) with a unified, cross-platform setup built around modern CLI tools.

## Stack

- **[Dotter](https://github.com/SuperCuber/dotter)** for symlink management with plain git
- **[Nushell](https://www.nushell.sh/)** as primary interactive shell, with **[Starship](https://starship.rs/)** prompt
- **[Helix](https://helix-editor.com/)** and **[Zed](https://zed.dev/)** as editors
- **[mise](https://mise.jdx.dev/)** for Node.js version management
- **Git ecosystem**: [delta](https://github.com/dandavison/delta), [difftastic](https://github.com/Wilfred/difftastic), [mergiraf](https://mergiraf.org/)
- **CLI tools**: [bat](https://github.com/sharkdp/bat), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [fzf](https://github.com/junegunn/fzf), [sd](https://github.com/chmln/sd), [eza](https://github.com/eza-community/eza), [zoxide](https://github.com/ajeetdsouza/zoxide), [bottom](https://github.com/ClementTsang/bottom)
- **Tooling**: [topgrade](https://github.com/topgrade-rs/topgrade), [taplo](https://taplo.tamasfe.dev/), [Biome](https://biomejs.dev/), [marksman](https://github.com/artempyanykh/marksman)

## Bootstrap

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/robvenn/dotfiles/main/scripts/bootstrap.ps1 | iex
```

**macOS/Linux (bash):**

```bash
curl -fsSL https://raw.githubusercontent.com/robvenn/dotfiles/main/scripts/bootstrap.sh | bash
```

## Conventions

- **[XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/)** for consistent config paths (`~/.config/`) across platforms
- **Delta configs over monoliths** — only override defaults, never track full generated configs
- **No dot prefix** — files stored without dots, Dotter maps to dotted targets
- **Flat layout** — tool folders at root, single-file tools as bare files
