#!/usr/bin/env bash

# Enhanced dependency checking utility
#
# Description:
#   This script provides a function to check for required commands
#   with improved cross-platform compatibility and better error handling
#
# Functions:
#   require - Checks for required commands
#   require_or_warn - Checks for commands but only warns if missing
#   require_or_exit - Checks for commands and exits if missing
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

# Check for required commands with optional exit behavior
#
# Arguments:
#   $1 - "warn" or "exit" (optional, default: "exit")
#   $@ - List of commands to check
#
# Outputs:
#   Error message to STDERR if dependencies are missing
#
# Returns:
#   0 - All dependencies are present
#   1 - Missing dependencies found
function require() {
  local behavior="exit"
  local missing_deps=()

  # Check if first argument is behavior specifier
  if [[ "$1" == "warn" || "$1" == "exit" ]]; then
    behavior="$1"
    shift
  fi

  for dep in "$@"; do
    if ! command -v "$dep" &> /dev/null; then
      missing_deps+=("$dep")
    fi
  done

  if [ ${#missing_deps[@]} -gt 0 ]; then
    printf "\033[1;31mError: The following dependencies were not found:\033[0m\n" >&2
    for dep in "${missing_deps[@]}"; do
      printf "  - \033[1;33m%s\033[0m\n" "$dep" >&2
    done

    case "$behavior" in
      "warn")
        printf "\033[1;33mWarning: Missing dependencies detected, continuing anyway\033[0m\n" >&2
        return 1
        ;;
      "exit")
        printf "\033[1;31mError: Required dependencies missing, exiting\033[0m\n" >&2
        exit 1
        ;;
    esac
  fi
}

# Convenience function that only warns about missing dependencies
function require_or_warn() {
  require warn "$@"
}

# Convenience function that exits on missing dependencies
function require_or_exit() {
  require exit "$@"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # If executed directly, run tests
  echo "Testing require functionality..."

  # Test with existing commands
  if require ls cd; then
    echo "Basic require test passed"
  else
    echo "Basic require test failed" >&2
    exit 1
  fi

  # Test with non-existent command (should exit)
  echo "Testing require_or_exit with missing command..."
  if require_or_exit nonexistent_command; then
    echo "require_or_exit test failed" >&2
    exit 1
  fi
fi
