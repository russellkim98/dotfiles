# XDG compliance
ZSHZ_DATA="${XDG_CACHE_HOME}/zsh/z"
# match to uncommon prefix
ZSHZ_UNCOMMON=1
# ignore case when lowercase, match case with uppercase
ZSHZ_CASE=smart
# Use frecent completion for better fzf-tab integration
ZSHZ_COMPLETION="frecent"
# Enable tab completion with fzf-tab
ZSHZ_TILDE=1

# Load zsh-z plugin
source "${DOTFILES}/zsh/plugins/zsh-z/zsh-z.plugin.zsh"

# Ensure the completion file is in fpath
fpath=("${DOTFILES}/zsh/plugins/zsh-z" $fpath)
