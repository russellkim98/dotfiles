# This file is sourced by all *interactive* zsh shells,
# and it exports language envs.
# Brew-related environments

# 3.10.0 should be the global as of Aug 26, 2023
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"


export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
# eval "$(rbenv init -)"

export JENV_ROOT="$HOME/.jenv"
export PATH="$JENV_ROOT/bin:$PATH"
# eval "$(jenv init -)"
#
export NODENV_ROOT="$HOME/.nodenv"
export PATH="$NODENV_ROOT/bin:$PATH"
eval "$(nodenv init -)"

# export POETRY_HOME="$HOME/.poetry"
# export PATH="$POETRY_HOME/bin:$PATH"
export POETRY_HOME="$HOME/.poetry"
export PATH="$POETRY_HOME/bin:$PATH"
