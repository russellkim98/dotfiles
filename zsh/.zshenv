# Disable global zsh configuration
# We're doing all configuration ourselves
unsetopt GLOBAL_RCS

# Source local env files
for envfile in "${DOTFILES}"/zsh/env.d/*; do
    source "${envfile}"
done
unset envfile
