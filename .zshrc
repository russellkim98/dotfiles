# Locale, Homebrew and ~/.local/bin are set in ~/.zshenv (all shells).

# --- iTerm2 Shell Integration ---
# This must be sourced for features like marks, badges, and directory tracking.
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# =================================================================
# Zsh Completion System Initialization
# =================================================================

# Initialize the completion system BEFORE loading plugins (required for fzf-tab)
autoload -Uz compinit
compinit

# =================================================================
# Zsh Plugin Management with Zgenom (Lightweight & Fast)
# =================================================================

# --- Load Zgenom ---
if [ -f "${HOME}/.zgenom/zgenom.zsh" ]; then
  source "${HOME}/.zgenom/zgenom.zsh"

  # --- Check if we need to regenerate the init script ---
  if ! zgenom saved; then
      echo "Creating new zgenom init script"

      # Essential plugins for a clean, fast setup with zoxide
      zgenom load zsh-users/zsh-completions
      zgenom load Aloxaf/fzf-tab
      zgenom load zsh-users/zsh-autosuggestions
      zgenom load zsh-users/zsh-syntax-highlighting

      zgenom save
  fi
fi

# --- zoxide init ---
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# =================================================================
# End of Zgenom Configuration
# =================================================================

# =================================================================
# Aliases and Functions for Enhanced File Viewing
# =================================================================

# Better file viewing with syntax highlighting
if command -v bat &> /dev/null; then
    alias cat="bat"
    alias catp="bat --style=plain"  # Plain style without line numbers
    alias catl="bat --style=numbers" # With line numbers only
fi

# Better directory listing
if command -v eza &> /dev/null; then
    alias ls="eza --icons"
    alias ll="eza -la --icons --git"
    alias la="eza -a --icons --git"
    alias lt="eza -T --icons"
    alias tree="eza --tree --icons"
fi

# Quick file preview function
preview() {
    if [ -z "$1" ]; then
        echo "Usage: preview <file>"
        return 1
    fi
    
    if command -v bat &> /dev/null; then
        bat "$1"
    else
        cat "$1"
    fi
}

# =================================================================
# FZF Configuration
# =================================================================

if command -v fzf &> /dev/null && command -v bat &> /dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always {} | head -200'"
fi


# =================================================================
# Miscellaneous Settings
# =================================================================
alias v="nvim"

# Keep the Mac from idle-sleeping while an agy session runs (the display still dims and the
# lid still sleeps). agy has no hooks, so the hold lasts the session, not each turn.
# Claude Code holds per turn via agent-awake hooks; the Claude app via its own setting.
agy() { caffeinate -i command agy "$@"; }

export EDITOR="nvim"
export VISUAL="nvim"

# =================================================================
# Prompt Initialization
# =================================================================
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Added by LM Studio CLI (lms)
path+=("$HOME/.lmstudio/bin")
# End of LM Studio CLI section

# =================================================================
# Claude Code launchers + direnv
# =================================================================
# cs: projectless session in ~/claude.  cj: pick a project, load its .envrc, launch.
# cr: resume the last session in this dir. direnv exec is needed because direnv's hook
# runs at the prompt, not on a cd inside a function.
cs() { cd ~/claude && claude "$@"; }
cj() {
  local d
  d=$(print -l ~/code/mine/*(/N) ~/code/oss/*(/N) ~/dotfiles ~/personal ~/claude \
      | fzf --height 40% --preview 'eza -1 --icons {}') || return
  cd "$d" && direnv exec "$d" claude "$@"
}
alias cr='claude --continue'
command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

# =================================================================
# Machine-local config (untracked; machine-specific env lives here, secrets in Keychain)
# =================================================================
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
