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
brew install pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

brew install goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"

brew install rbenv
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"

brew install jenv
export JENV_ROOT="$HOME/.jenv"
export PATH="$JENV_ROOT/bin:$PATH"


# personal tools
brew install --cask iterm2
brew install neovim


