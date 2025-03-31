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

# Check for required environment variables with optional exit behavior
#
# Arguments:
#   $1 - "warn" or "exit" (optional, default: "exit")
#   $@ - List of environment variable names to check
#
# Outputs:
#   Error message to STDERR if variables are unset or empty
#
# Returns:
#   0 - All variables are set and non-empty
#   1 - Missing variables found
function require_env_vars() {
  local behavior="exit"
  local missing_vars=()

  # Check if first argument is behavior specifier
  if [[ "$1" == "warn" || "$1" == "exit" ]]; then
    behavior="$1"
    shift
  fi

  for var_name in "$@"; do
    # Use indirect expansion and check if var is unset or empty
    if [[ -z "${!var_name-}" ]]; then
      missing_vars+=("${var_name}")
    fi
  done

  if [ ${#missing_vars[@]} -gt 0 ]; then
    printf "\033[1;31mError: The following required environment variables are not set or are empty:\033[0m\n" >&2
    for var_name in "${missing_vars[@]}"; do
      printf "  - \033[1;33m%s\033[0m\n" "$var_name" >&2
    done

    case "$behavior" in
      "warn")
        printf "\033[1;33mWarning: Missing environment variables detected, continuing anyway\033[0m\n" >&2
        return 1
        ;;
      "exit")
        printf "\033[1;31mError: Required environment variables missing, exiting\033[0m\n" >&2
        exit 1
        ;;
    esac
  fi
  return 0 # Return 0 explicitly on success
}

# Convenience function that only warns about missing environment variables
function require_env_vars_or_warn() {
  require_env_vars warn "$@"
}

# Convenience function that exits on missing environment variables
function require_env_vars_or_exit() {
  require_env_vars exit "$@"
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
  # We need to run this in a subshell to catch the exit
  echo "Testing require_or_exit with missing command..."
  if ( require_or_exit nonexistent_command ); then
    echo "require_or_exit test failed (did not exit)" >&2
    exit 1
  else
    echo "require_or_exit test passed (exited as expected)"
  fi

  # Test environment variable checks
  echo "Testing require_env_vars functionality..."
  export TEST_VAR_SET="value"
  unset TEST_VAR_UNSET || true # Ensure it's unset

  # Test with existing env var
  if require_env_vars TEST_VAR_SET; then
    echo "require_env_vars test passed (found existing var)"
  else
    echo "require_env_vars test failed (did not find existing var)" >&2
    exit 1
  fi

  # Test require_env_vars_or_warn with missing var
  if require_env_vars_or_warn TEST_VAR_UNSET; then
     echo "require_env_vars_or_warn test failed (returned 0 for missing var)" >&2
     exit 1
  else
     echo "require_env_vars_or_warn test passed (returned 1 for missing var)"
  fi

  # Test require_env_vars_or_exit with missing var (in subshell)
  echo "Testing require_env_vars_or_exit with missing var..."
   if ( require_env_vars_or_exit TEST_VAR_UNSET ); then
    echo "require_env_vars_or_exit test failed (did not exit)" >&2
    exit 1
  else
    echo "require_env_vars_or_exit test passed (exited as expected)"
  fi

  # Clean up test variable
  unset TEST_VAR_SET

  echo "All require tests passed."
fi
