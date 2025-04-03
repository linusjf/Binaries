#!/usr/bin/env bash

# --- Color Constants ---
if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]] && [[ "${TERM:-}" != "dumb" ]]; then
  readonly COLOR_RED="\033[0;31m"
  readonly COLOR_GREEN="\033[0;32m"
  readonly COLOR_YELLOW="\033[0;33m"
  readonly COLOR_NC="\033[0m"
else
  readonly COLOR_RED=""
  readonly COLOR_GREEN=""
  readonly COLOR_YELLOW=""
  readonly COLOR_NC=""
fi

# @description Print error message to STDERR
# @arg $1 string Error message
# @output Error message to STDERR
function print_error() {
  printf "${COLOR_RED}Error: %s${COLOR_NC}\n" "$1" >&2
}

# @description Print info message to STDOUT if verbose
# @arg $1 string Info message
# @output Info message to STDOUT if verbose enabled
function print_info() {
  [[ "${verbose:-false}" == true ]] && printf "${COLOR_GREEN}Info: %s${COLOR_NC}\n" "$1" || true
}

# @description Print warning message to STDERR
# @arg $1 string Warning message
# @output Warning message to STDERR
function print_warning() {
  printf "${COLOR_YELLOW}Warning: %s${COLOR_NC}\n" "$1" >&2
}
