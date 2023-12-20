#!/bin/bash
# A script to setup macOS dotfiles and development environment using Homebrew and a Brewfile.

# Exit immediately if any command exits with a non-zero status
set -e

# Function to check and install Xcode Command Line Tools
install_xcode_command_line_tools() {
	if ! xcode-select -p &>/dev/null; then
		echo "Installing Xcode Command Line Tools..."
		xcode-select --install
	else
		echo "Xcode Command Line Tools are already installed."
	fi
}

# Function to install Homebrew and update it
install_and_update_homebrew() {
	if ! command -v brew >/dev/null 2>&1; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	echo "Updating Homebrew..."
	brew update
}

# Function to handle the Brewfile installation
install_from_brewfile() {
	local BREWFILE="${DOTFILES}/Brewfile"

	if [ -f "${BREWFILE}" ]; then
		echo "Installing packages from the Brewfile..."
		brew bundle --file="${BREWFILE}"
	else
		echo "Creating an empty Brewfile..."
		touch "${BREWFILE}"
		echo "No Brewfile was found. An empty Brewfile has been created at ${BREWFILE}."
		echo "Please fill it with your desired packages and run the script again."
		exit 1
	fi
}

# Function to sync git submodules
sync_git_submodules() {
	echo "Syncing submodules..."
	git submodule sync >/dev/null
	git submodule update --init --recursive >/dev/null
	# Clean out only the submodules' directories
	git submodule foreach --recursive 'git clean -ffd'
	echo "  ...done"
}

# Function to symlink Neovim config
symlink_neovim_config() {
	local ASTRONVIM="$(git submodule | grep 'AstroNvim' | awk '{print $2}')"
	local ASTRONVIM_CONFIG="$(git submodule | grep 'my-astronvim-config' | awk '{print $2}')"

	zf_ln -snf "${DOTFILES}/${ASTRONVIM}" "${XDG_CONFIG_HOME}/nvim"
	zf_ln -snf "${DOTFILES}/${ASTRONVIM_CONFIG}" "${XDG_CONFIG_HOME}/nvim/lua/user"
}

# Function to compile zsh plugins
compile_zsh_plugins() {
	echo "Compiling zsh plugins..."
	emulate -LR zsh
	setopt local_options extended_glob
	autoload -Uz zrecompile
	for plugin_file in ${DOTFILES}/zsh/plugins/**/*.zsh; do
		echo "${plugin_file}"
		zrecompile -pq "${plugin_file}"
	done
	echo "  ...done"
}

# Function to install and setup fzf
install_fzf() {
	echo "Installing fzf..."
	pushd tools/fzf
	if ./install --bin &>/dev/null; then
		zf_ln -sf "${DOTFILES}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
		zf_ln -sf "${DOTFILES}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
		zf_ln -sf "${DOTFILES}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
		zf_ln -sf "${DOTFILES}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
		echo "  ...done"
	else
		echo "  ...failed. Probably unsupported architecture, please check fzf installation guide"
	fi
	popd
}

# Function to install poetry
install_poetry() {
	echo "Installing poetry..."
	curl -sSL https://install.python-poetry.org | python3 -
}

# Default XDG paths
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

# Get the current path of the dotfiles repository
DOTFILES="${0:A:h}"
echo "Dotfiles directory: ${DOTFILES}"

# Main installation sequence
install_xcode_command_line_tools
install_and_update_homebrew
install_from_brewfile
sync_git_submodules
symlink_neovim_config
compile_zsh_plugins
install_fzf
install_poetry
