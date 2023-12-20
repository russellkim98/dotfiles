#!/bin/bash
set -e
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
