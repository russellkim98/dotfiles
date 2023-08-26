#!/bin/bash

set -e

zmodload -m -F zsh/files b:zf_\*

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"

# Check if Homebrew exists
if ! command -v brew &>/dev/null; then
  echo "Homebrew does not exist. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check if Git exists
if ! command -v git &>/dev/null; then
  echo "Git does not exist. Installing..."
  brew install git
fi


##!/usr/bin/env zsh
# Link zshenv if needed
print "Checking for ZDOTDIR env variable..."
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "  ...present and valid, skipping .zshenv symlink"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "  ...failed to match this script dir, symlinking .zshenv"
fi

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "  ...done"


print "${SCRIPT_DIR}"
print "Compiling zsh plugins..."
{
    emulate -LR zsh
    setopt local_options extended_glob
    autoload -Uz zrecompile
    for plugin_file in ${SCRIPT_DIR}/zsh/plugins/**/*.zsh
    do
        print "${plugin_file}"
        zrecompile -pq "${plugin_file}"
    done
}
print "  ...done"



