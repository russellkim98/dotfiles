#!/bin/bash
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
