#!/usr/bin/env bash
# setup.sh - The One-Click Installer
# Installs Xcode tools, Homebrew, packages, updates submodules, and links dotfiles.

set -e

# --- Helper Functions ---
info() { printf "\033[1;34m%s\033[0m\n" "$1"; }
success() { printf "\033[1;32m%s\033[0m\n" "$1"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 0. Install Xcode Command Line Tools (Prerequisite for git & brew)
info "🛠️  Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  # Wait for install to finish
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  success "Xcode Tools installed."
else
  success "Xcode Tools already installed."
fi

# 1. Install Homebrew (if missing)
if ! command -v brew &> /dev/null; then
  info "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add brew to PATH for this session (Apple Silicon vs Intel logic)
  if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 2. Update Homebrew & Install Packages
info "📦 Updating Homebrew and installing packages..."
brew update
brew upgrade
brew bundle --file="$SCRIPT_DIR/Brewfile" --verbose

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
    chmod +x "$SCRIPT_DIR/.macos"
    "$SCRIPT_DIR/.macos"
fi

success "✅ Setup complete! Restart your terminal."
