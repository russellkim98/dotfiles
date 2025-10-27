eval "$(starship init zsh)"
# --- iTerm2 Shell Integration ---
# This must be sourced for features like marks, badges, and directory tracking.
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi
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