#!/usr/bin/env zsh

# Script to create symlinks for dotfiles
# This can be run independently to update symlinks without full setup

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Helper Functions for Logging ---
info() { printf "\033[1;34m%s\033[0m\n" "$1"; }
success() { printf "\033[1;32m%s\033[0m\n" "$1"; }
warning() { printf "\033[1;33m%s\033[0m\n" "$1"; }
fail() { printf "\033[1;31m%s\033[0m\n" "$1"; exit 1; }

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

info "Setting up symbolic links for dotfiles..."

# Function to create symlink with backup
create_symlink() {
  local source="$1"
  local target="$2"
  local target_dir="$(dirname "$target")"
  
  # Validate source exists
  if [ ! -e "$source" ]; then
    warning "Source does not exist: $source - skipping"
    return
  fi
  
  # Create target directory if it doesn't exist
  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
    info "Created directory: $target_dir"
  fi
  
  # If target exists and is not a symlink, backup it
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$target" "$backup_name"
    warning "Backed up existing $target to $backup_name"
  fi
  
  # Remove existing symlink if it exists
  if [ -L "$target" ]; then
    rm "$target"
    info "Removed existing symlink: $target"
  fi
  
  # Create the symlink
  ln -s "$source" "$target"
  success "Linked $source -> $target"
}

# --- Symlink Configuration Files ---

# Neovim configuration (AstroNvim)
create_symlink "$SCRIPT_DIR/astronvim_template" "$HOME/.config/nvim"


# Add other dotfiles here as you create them:
# create_symlink "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
# create_symlink "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
# create_symlink "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"

success "All symlinks created successfully!"
info "Remember to restart your terminal or source ~/.zshrc for changes to take effect."