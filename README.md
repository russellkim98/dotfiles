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
  1. **Phase 1 (Sequential)**: Syncs `~/dotfiles` **fast-forward only** and re-links via `symlink.sh`. If the repo is ahead, diverged, dirty-and-behind, offline or mid-rebase, the row turns yellow and you handle it; refresh never rebases or stashes.
  2. **Phase 2 (Parallel)**: Homebrew (`update`, `upgrade --greedy-auto-updates`, `bundle`, `autoremove`, `cleanup`), Zsh plugins (`zgenom`), Antigravity CLI (`agy update`), App Store (`mas outdated`; upgrades only when sudo is cached, otherwise a yellow "run `sudo mas upgrade`" row), and a macOS update check.
  3. **Phase 3 (Parallel, post-Homebrew)**: `uv` Python and tools, global `npm` packages, Claude CLI (`claude update`), Neovim (`Lazy`), then a cache trim (`uv cache prune`, `npm cache clean`).
  * Yellow rows mean "finished, needs attention" and don't fail the run. `tests/refresh_smoke.py` exercises all of this with fake subprocesses; the pre-commit hook runs it whenever `refresh` changes.
* **`bin/agent-awake`**, **`bin/sleepwhy`** (linked into `~/.local/bin`): keep the Mac awake only while an agent works (`caffeinate -i`, so the display still dims and a closed lid still sleeps), and explain what is holding it awake right now.
* **`symlink.sh`**: Scans the repo, symlinks dotfiles/mappings (`~/.config/nvim`, `~/.local/bin/refresh`) into `$HOME`, and cleans up stale symlinks.
* **`.zshrc`**: Zsh configuration with `zgenom`, `fzf-tab`, `zoxide`, `bat`, `eza`, and `starship`.
* **`Brewfile`**: Consolidated inventory of Homebrew formulae, casks, and Nerd Fonts.
* **`.macos`**: Minimalist "defaults write" UI tweaks, plus the pmset policy (idle sleep on; Power Nap off on battery).
* **`astronvim_template/`**: AstroNvim configuration (linked to `~/.config/nvim`). Custom plugins live in `lua/plugins/` — e.g. **cutlass.nvim**, so `d`/`c`/`x` no longer overwrite the clipboard (`m` is the dedicated cut key).
* **`iterm2-theme.json`**, **`nord.itermcolors`**: iTerm2 profile and color scheme, installed by `setup.sh`.
* **`.githooks/post-merge`**: After `git pull`, re-links dotfiles and updates zsh plugins if `.zshrc` changed.
* **`.githooks/pre-commit`**: Runs the refresh smoke test when `refresh` is staged, then gitleaks (this repo is public).
