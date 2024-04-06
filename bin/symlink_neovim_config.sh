#!/bin/bash
set -e
# Function to symlink Neovim config
symlink_neovim_config() {
	local ASTRONVIM="$(git submodule | grep 'astronvim' | awk '{print $2}')"

	zf_ln -snf "${DOTFILES}/${ASTRONVIM}" "${XDG_CONFIG_HOME}/nvim"
}
