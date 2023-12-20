#!/bin/bash
# A script to setup macOS dotfiles and development environment using Homebrew and a Brewfile.

# Exit immediately if any command exits with a non-zero status
set -e

# Default XDG paths
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# Get the current path of the dotfiles repository
export DOTFILES="${0:A:h}"
echo "Dotfiles directory: ${DOTFILES}"

# Source and execute modular scripts
# shellcheck source-path=DOTFILES
source "${DOTFILES}/bin/install_xcode_command_line_tools.sh"
install_xcode_command_line_tools

source "${DOTFILES}/bin/install_and_update_homebrew.sh"
install_and_update_homebrew

source "${DOTFILES}/bin/install_from_brewfile.sh"
install_from_brewfile

source "${DOTFILES}/bin/sync_git_submodules.sh"
sync_git_submodules

source "${DOTFILES}/bin/symlink_neovim_config.sh"
symlink_neovim_config

source "${DOTFILES}/bin/compile_zsh_plugins.sh"
compile_zsh_plugins

source "${DOTFILES}/bin/install_fzf.sh"
install_fzf
