#!/bin/bash
set -e
# Function to symlink Neovim config
symlink_neovim_config() {
	local ASTRONVIM="$(git submodule | grep 'AstroNvim' | awk '{print $2}')"
	local ASTRONVIM_CONFIG="$(git submodule | grep 'my-astronvim-config' | awk '{print $2}')"

	zf_ln -snf "${DOTFILES}/${ASTRONVIM}" "${XDG_CONFIG_HOME}/nvim"
	zf_ln -snf "${DOTFILES}/${ASTRONVIM_CONFIG}" "${XDG_CONFIG_HOME}/nvim/lua/user"
}
