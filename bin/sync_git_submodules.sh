#!/bin/bash
set -e
# Function to sync git submodules
sync_git_submodules() {
	echo "Syncing submodules..."
	git submodule sync >/dev/null
	git submodule update --init --recursive >/dev/null
	# Clean out only the submodules' directories
	git submodule foreach --recursive 'git clean -ffd'
	echo "  ...done"
}
