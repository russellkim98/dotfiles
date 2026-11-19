# Read by EVERY zsh (login, interactive, and agents' non-interactive `zsh -c`), so it holds
# what all of them need: locale, Homebrew and ~/.local/bin. Keep it fast and quiet.

# Locale: English messages for git, gettext and CLI tools (avoids the ko-KR fallback)
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US:en"

# PATH entries are unique, so re-sourcing never stacks duplicates
typeset -U path PATH

# Homebrew (sets HOMEBREW_PREFIX, PATH, MANPATH, INFOPATH)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv 2>/dev/null)"
fi

# Local binaries (refresh, agent-awake, sleepwhy, claude, agy, uv tools)
path=("$HOME/.local/bin" $path)
