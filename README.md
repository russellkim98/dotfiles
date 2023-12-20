# README for dotfiles

Your `${HOME}.zprofile` should look like this:

```sh
export DOTFILES="${HOME}/.local/dotfiles"
source "${DOTFILES}/zsh/.zprofile"
```

Your `${HOME}.zshenv` should look like this:

```sh
export DOTFILES="${HOME}/.local/dotfiles"
source "${DOTFILES}/zsh/.zshenv"
```

Your `${HOME}.zshrc` should look like this:

```sh
source "${DOTFILES}/zsh/.zshrc"
# Add any other code you want
```
