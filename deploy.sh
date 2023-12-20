#!/bin/bash
# A script to setup macOS dotfiles and development environment using Homebrew and a Brewfile.

# Exit immediately if any command exits with a non-zero status
set -e

## Check if Xcode Command Line Tools are already installed by looking for the presence of the 'xcode-select' executable
if ! xcode-select -p &>/dev/null; then
    # Install Xcode Command Line Tools
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
else
    echo "Xcode Command Line Tools are already installed."
fi

# Default XDG paths
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

# Install Homebrew (if not already installed) and update it
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "Updating Homebrew..."
brew update

# Define directories
# Get the current path
DOTFILES="${0:A:h}"
cd "${DOTFILES}" || exit
echo "Dotfiles directory: ${DOTFILES}"

### BREWFILE SECTION ####
BREWFILE="${DOTFILES}/Brewfile"
# Check if Brewfile exists
if [ -f "${BREWFILE}" ]; then
    # Install everything from the existing Brewfile
    echo "Installing packages from the Brewfile..."
    brew bundle --file="${BREWFILE}"
else
    # Create an empty Brewfile and instruct user to fill it
    echo "Creating an empty Brewfile..."
    touch "${BREWFILE}"
    echo "No Brewfile was found. An empty Brewfile has been created at ${BREWFILE}."
    echo "Please fill it with your desired packages and run the script again."
    exit 1
fi
### END BREWFILE SECTION ####

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync >/dev/null
git submodule update --init --recursive >/dev/null
# Iterate over each submodule and set the ignore option to 'untracked'
git submodule foreach 'git config submodule."$name".ignore untracked'
git clean -ffd
print "  ...done"

# make sure neovim config is symlinked
ASTRONVIM="$(git submodule | grep 'AstroNvim' | awk '{print $2}')"
zf_ln -snf "${DOTFILES}/${ASTRONVIM}" "${XDG_CONFIG_HOME}/nvim"

ASTRONVIM_CONFIG="$(git submodule | grep 'my-astronvim-config' | awk '{print $2}')"
zf_ln -snf "${DOTFILES}/${ASTRONVIM_CONFIG}" "${XDG_CONFIG_HOME}/nvim/lua/user"


print "${DOTFILES}"
print "Compiling zsh plugins..."
{
    emulate -LR zsh
    setopt local_options extended_glob
    autoload -Uz zrecompile
    for plugin_file in ${DOTFILES}/zsh/plugins/**/*.zsh; do
        print "${plugin_file}"
        zrecompile -pq "${plugin_file}"
    done
}
print "  ...done"

print "Installing fzf..."
pushd tools/fzf
if ./install --bin &>/dev/null; then
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
    print "  ...done"
else
    print "  ...failed. Probably unsupported architecture, please check fzf installation guide"
fi
popd

# poetry
curl -sSL https://install.python-poetry.org | python3 -
