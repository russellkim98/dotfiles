# Include interactive rc files
echo "${DOTFILES}"
for conffile in "${DOTFILES}"/zsh/rc.d/*; do
    source "${conffile}"
done

unset conffile

