# Brewfile: This file defines a consolidated list of Homebrew packages and casks to be installed.
# 
# Sections:
# - Core Command-Line Tools: Essential utilities for development and shell usage.
# - Tools for AstroNvim: Language servers, linters, and formatters recommended for a full-featured Neovim setup.
# - Shell Enhancement Tools: Utilities to enhance shell productivity and navigation.
# - Fonts (Casks): Recommended fonts for improved terminal and editor appearance.
#
# Usage:
#   Run `brew bundle` in the directory containing this Brewfile to install all listed packages and casks.
#
# Notes:
# - Duplicate entries (e.g., "eza") may be consolidated as needed.
# - Comments indicate the purpose of each tool and any relevant prerequisites.
# ------------------------------------------------------------------------------
# Brewfile: Consolidated List of Tools and Applications
# ------------------------------------------------------------------------------

# --- Core Command-Line Tools ---
brew "git"
brew "zsh"
brew "tmux"
brew "neovim"   # Prerequisite for AstroNvim
brew "starship"

# --- Tools for AstroNvim (LSPs, Linters, Formatters) ---
# These are highly recommended for a full-featured experience.
brew "lua-language-server" # For Lua development (e.g., configuring Neovim)
brew "prettier"            # A common code formatter
brew "stylua"              # A formatter for Lua
brew "ripgrep"             # For fuzzy finding with Telescope
brew "lazygit"             # A terminal UI for git, integrates well with AstroNvim

# --- Shell Enhancement Tools ---
brew "fzf"
brew "bat"                 # Cat replacement with syntax highlighting
brew "eza"                 # ls replacement with better formatting (successor to exa)
brew "tree"                # Directory tree visualization
brew "uv"                  # Python packaging and virtual environment management
brew "eza"                 # Modern replacement for 'ls' command
brew "zoxide"              # Utility to provide FZF functionality

# --- Fonts (Casks) ---
cask "font-fira-code-nerd-font"
