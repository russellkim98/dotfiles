ABBR_USER_ABBREVIATIONS_FILE="${DOTFILES}/zsh/plugins/abbreviations-store"
source "${DOTFILES}/zsh/plugins/zsh-abbr/zsh-abbr.zsh"
export MANPATH=${DOTFILES}/zsh/plugins/abbr/man:$MANPATH

# Ignore suggestions for abbreviations
ZSH_AUTOSUGGEST_HISTORY_IGNORE=${(j:|:)${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS}}
ZSH_AUTOSUGGEST_COMPLETION_IGNORE=${ZSH_AUTOSUGGEST_HISTORY_IGNORE}

