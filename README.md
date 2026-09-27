# Russell's Dotfiles

This repository contains the configuration files (dotfiles) that define my macOS development environment. It is designed to be **robust, automated, and self-healing**.

## Setup (Fresh Machine)

1. **Clone & Run:**

    ```bash
    git clone https://github.com/russellkim98/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./setup.sh
    ```

    *`setup.sh` automatically installs Xcode Command Line Tools, Homebrew, `Brewfile` dependencies, links config files, and configures Zsh/iTerm2/macOS defaults.*

## Structure

* **`setup.sh`**: Fresh-machine one-click bootstrap script.
* **`refresh`**: Single-command system updater (linked to `~/.local/bin/refresh`). Runs a 3-phase pipeline:
  1. **Phase 1 (Sequential)**: Pulls `~/dotfiles` and re-links configurations via `symlink.sh`.
  2. **Phase 2 (Parallel)**: Updates Homebrew (`brew update`, `upgrade --greedy-auto-updates`, `bundle`, `autoremove`, `cleanup`), Zsh plugins (`zgenom`), Antigravity CLI (`agy`), App Store apps (`mas`), and checks macOS software updates.
  3. **Phase 3 (Parallel, post-Homebrew)**: Updates `uv` Python versions & tools, OpenClaw, global `npm` packages, `pip`, Neovim (`Lazy`), GitHub CLI extensions, and VS Code extensions.
* **`symlink.sh`**: Scans the repo, symlinks dotfiles/mappings (`~/.config/nvim`, `~/.local/bin/refresh`) into `$HOME`, and cleans up stale symlinks.
* **`.zshrc`**: Zsh configuration with `zgenom`, `fzf-tab`, `zoxide`, `bat`, `eza`, and `starship`.
* **`Brewfile`**: Consolidated inventory of Homebrew formulae, casks, and Nerd Fonts.
* **`.macos`**: Minimalist "defaults write" settings for UI tweaks.
* **`astronvim_template/`**: AstroNvim configuration (linked to `~/.config/nvim`). Custom plugins live in `lua/plugins/` — e.g. **cutlass.nvim**, so `d`/`c`/`x` no longer overwrite the clipboard (`m` is the dedicated cut key).
* **`iterm2-theme.json`**, **`nord.itermcolors`**: iTerm2 profile and color scheme, installed by `setup.sh`.
* **`.githooks/post-merge`**: After `git pull`, re-links dotfiles and updates zsh plugins if `.zshrc` changed.
