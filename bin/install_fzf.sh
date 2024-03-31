#!/bin/bash
set -e
# Function to install and setup fzf
install_fzf() {
	echo "Installing fzf..."
	pushd tools/fzf
	if ./install --bin &>/dev/null; then

		mkdir -p "${HOME}/.local/bin/fzf"
		zf_ln -sf "${DOTFILES}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
		
		mkdir -p "${HOME}/.local/bin/fzf-tmux"
		zf_ln -sf "${DOTFILES}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
		
		mkdir -p "${XDG_DATA_HOME}/man/man1"
		zf_ln -sf "${DOTFILES}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
		zf_ln -sf "${DOTFILES}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
		echo "  ...done"
	else
		echo "  ...failed. Probably unsupported architecture, please check fzf installation guide"
	fi
	popd
}
