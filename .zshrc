eval "$(starship init zsh)"
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
fi

# --- Check if we need to regenerate the init script ---
if ! zgenom saved; then
    echo "Creating new zgenom init script"

    # Essential plugins for a clean, fast setup with zoxide
    zgenom load zsh-users/zsh-completions
    zgenom load zsh-users/zsh-syntax-highlighting
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load Aloxaf/fzf-tab

    zgenom save
fi

# --- zoxide init ---
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# =================================================================
# End of Zgenom Configuration
# =================================================================

# =================================================================
# uv (Python toolchain)
# =================================================================

export UV_HOME=$HOME/.uv
export PATH=$UV_HOME/bin:$PATH

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
    alias ll="eza -l --icons --git"
    alias la="eza -la --icons --git"
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
# Eza settings and aliases
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias la="eza -a --icons --git"
alias lt="eza -T --icons"

export EDITOR="nvim"
export VISUAL="nvim"

# --- Local Override ---
# This file is ignored by Git. Use it for local secrets/exports.
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
