#!/usr/bin/env zsh
# setup.sh - The One-Click Installer
# Installs Homebrew, packages, updates submodules, and links dotfiles.

set -e

# --- Helper Functions ---
info() { printf "\033[1;34m%s\033[0m\n" "$1"; }
success() { printf "\033[1;32m%s\033[0m\n" "$1"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Install Homebrew (if missing)
if ! command -v brew &> /dev/null; then
  info "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Install Packages
info "📦 Installing packages from Brewfile..."
brew bundle --verbose

# 3. Update Submodules
info "🔄 Updating git submodules..."
git submodule update --init --recursive

# 4. Link Dotfiles
info "🔗 Linking dotfiles..."
chmod +x "$SCRIPT_DIR/symlink.sh"
"$SCRIPT_DIR/symlink.sh"

# 5. MacOS Defaults (Optional)
if [ -f "$SCRIPT_DIR/.macos" ]; then
    info "🍎 Applying macOS defaults..."
    "$SCRIPT_DIR/.macos"
fi

success "✅ Setup complete! Restart your terminal."
