# Login shells only. macOS /etc/zprofile runs path_helper AFTER ~/.zshenv, which moves the
# system dirs back in front of ours. Re-assert the order; .zshenv already set everything else.
typeset -U path PATH
path=("$HOME/.local/bin" ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin} ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin} $path)
