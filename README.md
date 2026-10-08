# Russell's Dotfiles

This repository contains the configuration files (dotfiles) that define my macOS development environment. It is designed to be **robust, automated, and self-healing**.

## Setup (Fresh Machine)

1. **Clone & Run:**

    ```bash
    git clone https://github.com/russellkim98/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./setup.sh
    ```

    *`setup.sh` installs Homebrew and the Brewfile, links config files, sets up zgenom, the iTerm2 profile and macOS defaults.*

## Structure

* **`symlink.sh`**: Scans the repo and symlinks everything to `$HOME`. Smart enough to ignore git files and handle backups.
* **`.zshrc`**: The shell configuration. Sources itself cleanly.
* **`Brewfile`**: The inventory of all installed software.
* **`.macos`**: Minimalist "defaults write" settings for UI tweaks.
* **`astronvim_template/`**: AstroNvim configuration (linked to `~/.config/nvim`). Custom plugins live in `lua/plugins/` — e.g. **cutlass.nvim**, so `d`/`c`/`x` no longer overwrite the clipboard (`m` is the dedicated cut key).
* **`iterm2-theme.json`**, **`nord.itermcolors`**: iTerm2 profile and color scheme, installed by `setup.sh`.
* **`.githooks/post-merge`**: After `git pull`, re-links dotfiles and updates zsh plugins if `.zshrc` changed.
