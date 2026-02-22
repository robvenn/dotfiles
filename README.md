# Dotfiles

Cross-platform dotfiles for Windows, macOS, and Linux.

Replaces my archived [mac dotfiles](https://github.com/robvenn/dotfiles-macos-old) with a unified, cross-platform setup built around modern CLI tools.

## Stack

- **[Dotter](https://github.com/SuperCuber/dotter)** — symlink management with plain git
- **[Nushell](https://www.nushell.sh/)** + **[Starship](https://starship.rs/)** — shell and prompt
- **[Helix](https://helix-editor.com/)** + **[Zed](https://zed.dev/)** — terminal and GUI editors
- **Git ecosystem**: [delta](https://github.com/dandavison/delta), [difftastic](https://github.com/Wilfred/difftastic), [mergiraf](https://mergiraf.org/)
- **CLI tools**: [bat](https://github.com/sharkdp/bat), [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [fzf](https://github.com/junegunn/fzf), [sd](https://github.com/chmln/sd), [eza](https://github.com/eza-community/eza), [zoxide](https://github.com/ajeetdsouza/zoxide), [bottom](https://github.com/ClementTsang/bottom)
- **Tooling**: [topgrade](https://github.com/topgrade-rs/topgrade), [taplo](https://taplo.tamasfe.dev/), [Biome](https://biomejs.dev/), [marksman](https://github.com/artempyanykh/marksman)

## Package management

| Tool | Scope | Platforms |
|------|-------|-----------|
| [Scoop](https://scoop.sh/) (`scoopfile.json`) | CLI / dev tools | Windows |
| [winget](https://learn.microsoft.com/en-us/windows/package-manager/) | GUI / system tools | Windows |
| [Homebrew](https://brew.sh/) (`Brewfile`) | CLI / dev tools | macOS, Linux |
| [mise](https://mise.jdx.dev/) (`mise/config.toml`) | Node.js, npm globals, Go tools | All |
| [uv](https://github.com/astral-sh/uv) | Python versions, venvs, packages | All |
| [rustup](https://rustup.rs/) | Rust toolchain | All |

[topgrade](https://github.com/topgrade-rs/topgrade) orchestrates everything in one command: package managers → toolchains → `mise install` for ecosystem tools.

## Conventions

- **[XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/)** — consistent config paths (`~/.config/`) across platforms
- **Deltas not defaults** — only override defaults, never track full generated configs
- **No dot prefix** — files stored without dots, Dotter maps to dotted targets
- **Flat layout** — tool folders at root, single-file tools as bare files

## Bootstrap

> [!WARNING]
> This installs a large set of packages tailored to my personal setup. Review [`scripts/bootstrap.ps1`](scripts/bootstrap.ps1) or [`scripts/bootstrap.sh`](scripts/bootstrap.sh) before running.

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/robvenn/dotfiles/main/scripts/bootstrap.ps1 | iex
```

**macOS/Linux (bash):**

```bash
curl -fsSL https://raw.githubusercontent.com/robvenn/dotfiles/main/scripts/bootstrap.sh | bash
```
