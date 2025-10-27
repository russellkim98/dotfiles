eval "$(starship init zsh)"
# --- iTerm2 Shell Integration ---
# This must be sourced for features like marks, badges, and directory tracking.
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi
# =================================================================
# Zsh Completion System Initialization
# =================================================================

# Initialize the completion system
autoload -Uz compinit
compinit

# =================================================================
# Zsh Plugin Management with Zgenom (Lightweight & Fast)
# =================================================================

# --- Load Zgenom ---
# Source the zgenom script if it exists
if [ -f "${HOME}/.zgenom/zgenom.zsh" ]; then
  source "${HOME}/.zgenom/zgenom.zsh"
fi

# --- Check if we need to regenerate the init script ---
# This will clone/update plugins and create a static init.zsh
if ! zgenom saved; then
    echo "Creating new zgenom init script"

    # --- List of Plugins ---
    # Load completions first
    zgenom load zsh-users/zsh-completions

    # Syntax highlighting
    zgenom load zsh-users/zsh-syntax-highlighting

    # Auto suggestions (type-ahead)
    zgenom load zsh-users/zsh-autosuggestions

    # fzf-tab (replaces standard completion with fzf)
    zgenom load Aloxaf/fzf-tab

    # Abbreviation manager
    zgenom load olets/zsh-abbr

    # Automatic environment loading
    zgenom load zsh-users/zsh-autoenv

    # Auto-closing quotes and brackets
    zgenom load ael-code/zsh-autopair

    # 'z' for frecent directory jumping
    zgenom load "rupa/z"

    # Save the plugin list to the init script
    zgenom save
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
# FZF Configuration for File Previews
# =================================================================

# Configure fzf to use bat for file previews
if command -v fzf &> /dev/null && command -v bat &> /dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi