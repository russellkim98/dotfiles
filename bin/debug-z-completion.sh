#!/usr/bin/env zsh
# Debug script for z command completion

echo "Checking zsh-z configuration..."
echo "ZSHZ_COMPLETION=${ZSHZ_COMPLETION}"
echo "ZSHZ_CASE=${ZSHZ_CASE}"
echo "ZSHZ_UNCOMMON=${ZSHZ_UNCOMMON}"
echo "ZSHZ_TILDE=${ZSHZ_TILDE}"
echo "ZSHZ_DATA=${ZSHZ_DATA}"

echo "\nChecking if _zshz is in fpath..."
[[ -n ${fpath[(r)*zsh-z*]} ]] && echo "✅ zsh-z is in fpath" || echo "❌ zsh-z is NOT in fpath"

echo "\nChecking fzf-tab configuration for z..."
zstyle -L ':fzf-tab:complete:z:*'
zstyle -L ':fzf-tab:complete:zshz:*'

echo "\nChecking if z command is aliased..."
which z

echo "\nChecking for z completion file..."
ls -l ${DOTFILES}/zsh/plugins/zsh-z/_zshz

echo "\nChecking FZF_DEFAULT_OPTS..."
echo $FZF_DEFAULT_OPTS

echo "\nChecking if compinit was run..."
echo "zcompdump timestamp: $(ls -la ${XDG_CACHE_HOME}/zsh/compdump 2>/dev/null || echo 'Not found')"

echo "\nTry running: compinit -i && z<TAB> to see if completion works"