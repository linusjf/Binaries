#!/usr/bin/env bash

# Define a function to check for dependencies
function require() {
  local missing_deps=()
  for dep in "$@"; do
    if ! command -v "$dep" &> /dev/null; then
      missing_deps+=("$dep")
    fi
  done

  if [ ${#missing_deps[@]} -gt 0 ]; then
    printf "Error: The following dependencies were not found:\n"
    for dep in "${missing_deps[@]}"; do
      printf "  - %s\n" "$dep"
    done
    exit 1
  fi
}
