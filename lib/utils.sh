#!/usr/bin/env bash

# --- Helper Functions ---
info() { printf "\033[1;34m%s\033[0m\n" "$1"; }
success() { printf "\033[1;32m%s\033[0m\n" "$1"; }
warning() { printf "\033[1;33m%s\033[0m\n" "$1"; }
fail() { printf "\033[1;31m%s\033[0m\n" "$1"; exit 1; }

# Function to check if array contains element
containsElement() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}
