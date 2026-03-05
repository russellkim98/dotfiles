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
info "🔄 Updating git submodules and hooks..."
git submodule update --init --recursive
git config core.hooksPath .githooks

# 4. Link Dotfiles (before zgenom so .zshrc is in place for interactive zsh)
info "🔗 Linking dotfiles..."
chmod +x "$SCRIPT_DIR/symlink.sh"
"$SCRIPT_DIR/symlink.sh"

# 5. Install/Update Zgenom (Zsh Plugin Manager)
if [ ! -d "$HOME/.zgenom" ]; then
  info "🚀 Installing zgenom..."
  git clone https://github.com/jandamm/zgenom.git "$HOME/.zgenom"
fi

info "🔌 Updating Zsh plugins (zgenom)..."
zsh -i -c "zgenom selfupdate && zgenom update"

# 6. iTerm2 Profile
if [ -d "/Applications/iTerm.app" ]; then
    info "🎨 Installing iTerm2 profile..."
    ITERM_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    mkdir -p "$ITERM_PROFILES_DIR"

    # Wrap the profile JSON in Dynamic Profiles format
    python3 -c "
import json
with open('$SCRIPT_DIR/iterm2-theme.json') as f:
    profile = json.load(f)
profile['Dynamic Profile Parent Name'] = 'Default'
print(json.dumps({'Profiles': [profile]}, indent=2))
" > "$ITERM_PROFILES_DIR/dotfiles-profile.json"

    # Set as default profile
    defaults write com.googlecode.iterm2 "Default Bookmark Guid" "E7BCCD8D-730C-425D-A5DE-611342D95F3D"

    success "iTerm2 profile installed."
fi

# 7. MacOS Defaults (Optional)
if [ -f "$SCRIPT_DIR/.macos" ]; then
    info "🍎 Applying macOS defaults..."
    chmod +x "$SCRIPT_DIR/.macos"
    "$SCRIPT_DIR/.macos"
fi

success "✅ Setup complete! Restart your terminal."
