#!/bin/bash
set -e
# Function to install Homebrew and update it
install_and_update_homebrew() {
	if ! command -v brew >/dev/null 2>&1; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	echo "Updating Homebrew..."
	brew update
	echo "Upgrading Homebrew ..."
	brew upgrade
}
