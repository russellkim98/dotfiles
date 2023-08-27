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

brew install pyenv
brew install goenv
brew install rbenv
brew install jenv


# personal tools
brew install --cask iterm2
brew install neovim


