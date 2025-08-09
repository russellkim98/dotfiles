export FZF_DEFAULT_OPTS="--ansi --height=50% --min-height=20 --reverse --bind=ctrl-f:page-down,ctrl-b:page-up"
# Try to use fd or ag, if available as default fzf command
if (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
elif (( ${+commands[ag]} )); then
    export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"

# Use fzf for tab completions
source "${DOTFILES}/zsh/plugins/fzf-tab/fzf-tab.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
zstyle ':fzf-tab:*' prefix ''

# Configure fzf-tab for zsh-z completions
zstyle ':fzf-tab:complete:(z|zshz):*' fzf-preview 'ls -la ${(Q)realpath}'
zstyle ':fzf-tab:complete:(z|zshz):*' fzf-flags --height=50%
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:z:argument-rest' fzf-flags --preview-window=right:60%
