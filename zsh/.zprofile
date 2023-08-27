# Taken from Arch, most of default zsh configurations don't do this
# Skip it on macOS to disallow path_helper run
if [[ -r /etc/profile ]] && [[ "${OSTYPE}" != darwin* ]]; then
    emulate sh -c 'source /etc/profile'
fi




# Where  Homebrew starts
eval "$(/usr/local/bin/brew shellenv)"

# Prefered editor and pager
export VISUAL=nvim
export EDITOR=nvim

# PYENV, for python
# 3.8.18 should be the global as of Aug 26, 2023
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
