# README for dotfiles

Your `.zprofile` should look like this:

```sh
export BREW="/usr/local/bin/brew"
export DOTFILES="${HOME}/.local/dotfiles"
source "${DOTFILES}/zsh/.zprofile"
```

Your `.zshenv` should look like this:

```sh
export BREW="/usr/local/bin/brew"
export DOTFILES="${HOME}/.local/dotfiles"
source "${DOTFILES}/zsh/.zshenv"
```

Your `.zshrc` should look like this:

```sh
source "${DOTFILES}/zsh/.zshrc"
```
