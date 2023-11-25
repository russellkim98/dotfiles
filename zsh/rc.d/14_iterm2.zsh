# iTerm2 integration
if [[ -v ITERM_PROFILE ]] || [[ -v ITERM_SESSION ]]; then
    source "${ZDOTDIR}/plugins/iTerm2-shell-integration/shell_integration/zsh"
    path=(${ZDOTDIR}/plugins/iTerm2-shell-integration/utilities $path)
fi

