# Configuration for z command with fzf-tab integration
# This must be loaded after both fzf-tab and z

# Set up fzf preview for z command completions with nice formatting
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls -l --color=always ${(Q)realpath}'
zstyle ':fzf-tab:complete:z:*' fzf-flags --height=60% --min-height=20 --preview-window=right:60%

# Apply same settings to zshz if that command is used
zstyle ':fzf-tab:complete:zshz:*' fzf-preview 'ls -l --color=always ${(Q)realpath}'
zstyle ':fzf-tab:complete:zshz:*' fzf-flags --height=60% --min-height=20 --preview-window=right:60%

# Ensure completions for z are loaded properly
[[ -f "${DOTFILES}/zsh/plugins/zsh-z/_zshz" ]] && fpath+="${DOTFILES}/zsh/plugins/zsh-z"

# Force rebuild of completion system to ensure z completion is available
autoload -U compinit && compinit -i