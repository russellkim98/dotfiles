# Highlighting plugin
source "${ZDOTDIR}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp cursor)
# Highlight known abbrevations
typeset -A ZSH_HIGHLIGHT_REGEXP
