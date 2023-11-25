#!/bin/bash
#
#
#
#
# Install xcode dev tools
xcode-select --install

zmodload -m -F zsh/files b:zf_\*

# install brew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

# https://formulae.brew.sh/formula/git
brew install git
brew install zsh

# Env management, priority no. 1
brew install -q pyenv, goenv, rbenv, jenv

# personal tools
brew install --cask iterm2
brew install spaceship
brew install neovim

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}" || exit

echo "script directory"
echo "${SCRIPT_DIR}"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable..."
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
	print "  ...present and valid, skipping .zshenv symlink"
else
	ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
	print "  ...failed to match this script dir, symlinking .zshenv"
fi

echo "${SCRIPT_DIR}"

# make sure configs are symlinked
zf_ln -sf "${SCRIPT_DIR}/configs/nvim" "${XDG_CONFIG_HOME}"

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync >/dev/null
git submodule update --init --recursive >/dev/null
git clean -ffd
print "  ...done"

print "${DOTFILES}"
print "Compiling zsh plugins..."
{
	emulate -LR zsh
	setopt local_options extended_glob
	autoload -Uz zrecompile
	for plugin_file in ${DOTFILES}/zsh/plugins/**/*.zsh; do
		print "${plugin_file}"
		zrecompile -pq "${plugin_file}"
	done
}
print "  ...done"

# poetry
curl -sSL https://install.python-poetry.org | python3 -
