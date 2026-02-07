# Dotfiles

Cross-platform dotfiles for Windows, macOS, and Linux.

Replaces my archived [mac dotfiles](https://github.com/robvenn/dotfiles-macos-old) with a unified, cross-platform setup built around modern CLI tools.

## Architecture

- **[Dotter](https://github.com/SuperCuber/dotter)** for symlink management with plain git
- **[XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/)** standard for consistent config paths across platforms
- **[Nushell](https://www.nushell.sh/)** ([repo](https://github.com/nushell/nushell)) as primary interactive shell, with minimal bash/zsh/PowerShell configs maintained for compatibility with system tools
