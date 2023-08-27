#!/bin/bash
#
#
#
#
# Install xcode dev tools
xcode-select --install

# install brew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh


# https://formulae.brew.sh/formula/git
brew install git                                                                                      
brew install zsh 

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"


# Env management, priority no. 1
brew install -q pyenv, goenv, rbenv, jenv


# personal tools
brew install --cask iterm2
brew install spaceship
brew install neovim

# poetry
curl -sSL https://install.python-poetry.org | python3 -

