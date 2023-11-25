# Determine own path if ZDOTDIR isn't set or home symlink exists
export ZDOTDIR="${0:a:h}"
# DOTFILES dir is parent to ZDOTDIR
export DOTFILES="${ZDOTDIR:h}"

# Disable global zsh configuration
# We're doing all configuration ourselves
unsetopt GLOBAL_RCS

# Source local env files
for envfile in "${ZDOTDIR}"/env.d/*; do
    source "${envfile}"
done
unset envfile
