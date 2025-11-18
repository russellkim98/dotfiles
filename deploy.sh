#!/usr/bin/env zsh

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions for Logging ---
info() { printf "\033[1;34m%s\033[0m\n" "$1"; }
success() { printf "\033[1;32m%s\033[0m\n" "$1"; }
fail() { printf "\033[1;31m%s\033[0m\n" "$1"; exit 1; }

# --- 1. Install Homebrew ---
info "Checking for Homebrew installation..."
if ! command -v brew &> /dev/null; then
  info "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
  success "Homebrew installed successfully."
else
  success "Homebrew is already installed."
fi

# --- 2. Set up Homebrew Environment ---
if [[ "$(uname -m)" == "arm64" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
else
  HOMEBREW_PREFIX="/usr/local"
fi
eval "$("$HOMEBREW_PREFIX"/bin/brew shellenv)"

# Get the directory of the script to reliably find other files
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- 3. Install iTerm2 Shell Integration ---
info "Installing iTerm2 Shell Integration..."
# This command is idempotent - it just re-downloads the latest version.
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
success "iTerm2 Shell Integration script is in place."

# --- 4. Install Zsh Plugin Manager (Zgenom) ---
info "Cloning Zgenom for Zsh plugin management..."
if [ ! -d "${ZDOTDIR:-$HOME}/.zgenom" ]; then
  git clone https://github.com/jandamm/zgenom.git "${ZDOTDIR:-$HOME}/.zgenom"
  success "Zgenom installed."
else
  success "Zgenom is already installed."
fi

# --- 5. Apply macOS defaults ---
info "Applying macOS defaults from .macos file..."
if [ -f "$SCRIPT_DIR/.macos" ]; then
  source "$SCRIPT_DIR/.macos"
  success "macOS defaults applied."
else
  info "No .macos file found. Skipping."
fi

# --- 6. Update Homebrew and Install from Brewfile ---
info "Updating Homebrew..."
if brew update; then
  success "Homebrew updated successfully."
else
  fail "Homebrew update failed."
fi

info "Installing packages from Brewfile..."
if [ -f "$SCRIPT_DIR/Brewfile" ]; then
  # Use --verbose to see detailed progress
  if brew bundle --file="$SCRIPT_DIR/Brewfile" --verbose; then
    success "Brewfile packages installed successfully."
  else
    fail "Brew bundle command failed. Please check the output above."
  fi
else
  info "No Brewfile found. Skipping."
fi

# --- 7. Initialize and update git submodules ---
info "Initializing and updating git submodules..."
if git -C "$SCRIPT_DIR" submodule update --init --recursive; then
  success "Git submodules updated successfully."
else
  info "No git submodules found or update failed. Continuing..."
fi

# --- 8. Create symbolic links for dotfiles ---
info "Setting up symbolic links for dotfiles..."

# Function to create symlink with backup
create_symlink() {
  local source="$1"
  local target="$2"
  local target_dir="$(dirname "$target")"
  
  # Create target directory if it doesn't exist
  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
    info "Created directory: $target_dir"
  fi
  
  # If target exists and is not a symlink, backup it
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    info "Backed up existing $target"
  fi
  
  # Remove existing symlink if it exists
  if [ -L "$target" ]; then
    rm "$target"
  fi
  
  # Create the symlink
  ln -s "$source" "$target"
  success "Linked $source -> $target"
}

# Symlink Neovim configuration (AstroNvim)
if [ -d "$SCRIPT_DIR/template" ]; then
  create_symlink "$SCRIPT_DIR/template" "$HOME/.config/nvim"
fi


# Create ~/.zshrc that sources the repo .zshrc and sets Homebrew path
info "Setting up ~/.zshrc to source dotfiles/.zshrc and set Homebrew path..."
ZSHRC_PATH="$HOME/.zshrc"
REPO_ZSHRC="$SCRIPT_DIR/.zshrc"

# Backup existing ~/.zshrc if it exists and is not a symlink
if [ -e "$ZSHRC_PATH" ] && [ ! -L "$ZSHRC_PATH" ]; then
  mv "$ZSHRC_PATH" "${ZSHRC_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
  info "Backed up existing $ZSHRC_PATH"
fi

# Write new ~/.zshrc
cat > "$ZSHRC_PATH" <<EOF
export PATH="/opt/homebrew/bin:$PATH"
source "$REPO_ZSHRC"
EOF
success "~/.zshrc created to source $REPO_ZSHRC and set Homebrew path."

# Add other dotfiles here as needed
# Examples:
# create_symlink "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
# create_symlink "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

success "All done! Restart your terminal for all changes to take effect."