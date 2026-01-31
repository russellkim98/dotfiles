# Russell's Dotfiles

This repository contains the configuration files (dotfiles) that define my macOS development environment. It is designed to be **robust, automated, and self-healing**.

## 🛠️ Setup (Fresh Machine)

1. **Clone & Run:**

    ```bash
    git clone https://github.com/russellkim98/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./setup.sh
    ```

    *`setup.sh` automatically installs Homebrew, dependencies, updates submodules, and links config files.*

## 📂 Structure

* **`symlink.sh`**: Scans the repo and symlinks everything to `$HOME`. Smart enough to ignore git files and handle backups.
* **`.zshrc`**: The shell configuration. Sources itself cleanly.
* **`Brewfile`**: The inventory of all installed software.
* **`.macos`**: Minimalist "defaults write" settings for UI tweaks.
* **`astronvim_template/`**: AstroNvim configuration (linked to `~/.config/nvim`).

## 🤖 Automation

* **Daily Updates:** A GitHub Action (`.github/workflows/submodules.yml`) runs daily to fetch the latest upstream changes for submodules (like AstroNvim) and commits them back to this repo.

---
*Maintained by Atlas 🌍*
