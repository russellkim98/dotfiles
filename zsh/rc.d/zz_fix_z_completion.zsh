# This file fixes the z command tab completion with fzf-tab
# It needs to be loaded last (hence the zz_ prefix)

# Ensure zsh-z completion file is in fpath
fpath=("${DOTFILES}/zsh/plugins/zsh-z" $fpath)

# Force rebuild of zsh completion system to include z command
compinit -i

# Configure fzf-tab to work with z command completion
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls -la --color=always ${(Q)realpath}'
zstyle ':fzf-tab:complete:z:*' fzf-flags --height=60% --preview-window=right:60%
zstyle ':fzf-tab:complete:zshz:*' fzf-preview 'ls -la --color=always ${(Q)realpath}'
zstyle ':fzf-tab:complete:zshz:*' fzf-flags --height=60% --preview-window=right:60%