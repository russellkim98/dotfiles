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
