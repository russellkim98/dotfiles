# Russell's Dotfiles

This repository contains the configuration files (dotfiles) that define my macOS development environment. It is designed to be **robust, automated, and self-healing**.

## 🛠️ Setup (Fresh Machine)

1. **Clone the repo:**

    ```bash
    git clone https://github.com/russellkim98/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2. **Link the configurations:**
    (This script creates symlinks for all dotfiles, backing up existing ones automatically)

    ```bash
    chmod +x symlink.sh
    ./symlink.sh
    ```

3. **Install dependencies:**
    (Installs Homebrew packages, Casks, and Fonts)

    ```bash
    brew bundle
    ```

4. **Apply macOS defaults (Optional):**

    ```bash
    ./.macos
    ```

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
