# This file is sourced by all *interactive* zsh shells,
# and it exports language envs.
# Brew-related environments

# 3.10.0 should be the global as of Aug 26, 2023
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
pyenv init - >/dev/null

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
goenv init - >/dev/null

export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
rbenv init - >/dev/null

export JENV_ROOT="$HOME/.jenv"
export PATH="$JENV_ROOT/bin:$PATH"
jenv init - >/dev/null

export POETRY_HOME="$HOME/.poetry"
export PATH="$POETRY_HOME/bin:$PATH"
