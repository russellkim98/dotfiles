#!/usr/bin/env zsh
# Universal Dotfile Linker
# Automatically symlinks all dotfiles/folders in this repo to $HOME.

set -e

# --- Helper Functions ---
info() { printf "\033[1;34m%s\033[0m\n" "$1"; }
success() { printf "\033[1;32m%s\033[0m\n" "$1"; }
warning() { printf "\033[1;33m%s\033[0m\n" "$1"; }
fail() { printf "\033[1;31m%s\033[0m\n" "$1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  info "🔎 STARTING DRY RUN (No changes will be made)"
fi

# --- Configuration ---
# Files/Folders to completely ignore
IGNORES=("." ".." ".git" ".gitmodules" ".gitignore" ".DS_Store" ".macos" "README.md" "LICENSE" "symlink.sh" "deploy.sh" "Brewfile" "GEMINI.md" ".github" "astronvim_template")

# Explicit mapping for things that don't map 1:1 (Source -> Target relative to HOME)
# Format: "source_in_repo:target_path_from_home"
declare -A MAPPINGS
MAPPINGS[astronvim_template]=".config/nvim"

# Function to check if array contains element
containsElement() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# --- Core Linker Logic ---
link_file() {
  local src="$1"
  local target="$2"
  local target_dir="$(dirname "$target")"

  if $DRY_RUN; then
    info "[DRY] Would link: $src -> $target"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      warning "      (Existing file at $target would be backed up)"
    fi
    return
  fi

  # Ensure target dir exists
  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
    info "Created dir: $target_dir"
  fi

  # Backup existing file (if not a symlink)
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$target" "$backup"
    warning "Backed up: $target -> $backup"
  fi

  # Remove existing symlink/broken link
  if [ -L "$target" ]; then
    rm "$target"
  fi

  ln -s "$src" "$target"
  success "Linked: $src -> $target"
}

info "🔗 synchronizing dotfiles..."

# 1. Process Automatic Links (files in root)
for src_path in "$SCRIPT_DIR"/.* "$SCRIPT_DIR"/*; do
  name=$(basename "$src_path")
  
  # Skip ignored files
  if containsElement "$name" "${IGNORES[@]}"; then
    continue
  fi

  # Skip glob expansion failures
  if [ ! -e "$src_path" ]; then continue; fi

  link_file "$src_path" "$HOME/$name"
done

# 2. Process Explicit Mappings
for src_name in "${(@k)MAPPINGS}"; do
  src_path="$SCRIPT_DIR/$src_name"
  target_path="$HOME/${MAPPINGS[$src_name]}"
  
  if [ -e "$src_path" ]; then
    link_file "$src_path" "$target_path"
  else
    warning "Skipping mapping: $src_name (not found in repo)"
  fi
done

if $DRY_RUN; then
  success "✅ Dry run complete."
else
  success "✅ Dotfiles linked successfully."
fi
