#!/usr/bin/env bash

# Dependency checking utility
#
# Description:
#   This script provides a function to check for required commands
#   before executing a script.
#
# Functions:
#   require - Checks for required commands
#
# Globals:
#   None
#
# Arguments:
#   $@ - List of commands to check
#
# Returns:
#   0 - All dependencies are present
#   1 - Missing dependencies found

# Check for required commands
#
# Arguments:
#   $@ - List of commands to check
#
# Outputs:
#   Error message to STDERR if dependencies are missing
#
# Returns:
#   0 - All dependencies are present
#   1 - Missing dependencies found
function require() {
  local missing_deps=()

  for dep in "$@"; do
    if ! command -v "$dep" &> /dev/null; then
      missing_deps+=("$dep")
    fi
  done

  if [ ${#missing_deps[@]} -gt 0 ]; then
    printf "Error: The following dependencies were not found:\n" >&2
    for dep in "${missing_deps[@]}"; do
      printf "  - %s\n" "$dep" >&2
    done
    return 1
  fi
}
