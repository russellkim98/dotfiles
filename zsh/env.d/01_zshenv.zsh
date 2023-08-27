# Enable profiling, if requested via env var
# do `ZSH_ZPROF_ENABLE=1 exec zsh`
if [[ -v ZSH_ZPROF_ENABLE ]]; then
    zmodload zsh/zprof
fi

# Load zsh/files module to provide some builtins for file modifications
zmodload -F -m zsh/files b:zf_\*

# Basically this is going to be mac = brew + zsh philsophy. Buy what you can.

# Taken from Arch, most of default zsh configurations don't do this
# Skip it on macOS to disallow path_helper run
if [[ -r /etc/profile ]] && [[ "${OSTYPE}" != darwin* ]]; then
    emulate sh -c 'source /etc/profile'
fi


# Where  Homebrew starts
eval "$(/usr/local/bin/brew shellenv)"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
pyenv init - >/dev/null

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
goenv init - >/dev/null

export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
rbenv init - >/dev/null

export JENV_ROOT="$HOME/.jenv"
export PATH="$JENV_ROOT/bin:$PATH"
jenv init - >/dev/null

export POETRY_HOME="$HOME/.poetry"
export PATH="$POETRY_HOME/bin:$PATH"



