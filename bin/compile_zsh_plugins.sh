#!/bin/bash
set -e
# Function to compile zsh plugins
compile_zsh_plugins() {
	echo "Compiling zsh plugins..."
	emulate -LR zsh
	setopt local_options extended_glob
	autoload -Uz zrecompile
	for plugin_file in "${DOTFILES}"/zsh/plugins/**/*.zsh; do
		echo "${plugin_file}"
		zrecompile -pq "${plugin_file}"
	done
	echo "  ...done"
}
