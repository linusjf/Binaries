#!/usr/bin/env bash

# @file color.sh
# @brief Provides color utilities for terminal output
# @description Contains functions for colored output and constants for common colors.
# Colors are automatically disabled when output is not a terminal or when NO_COLOR is set.
# shellcheck disable=SC2034
# --- Color Constants ---
if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]] && [[ "${TERM:-}" != "dumb" ]]; then
  readonly COLOR_RED="\033[0;31m"
  readonly COLOR_GREEN="\033[0;32m"
  readonly COLOR_YELLOW="\033[0;33m"
  readonly COLOR_BLUE="\033[0;34m"
  readonly COLOR_MAGENTA="\033[0;35m"
  readonly COLOR_CYAN="\033[0;36m"
  readonly COLOR_NC="\033[0m" # No Color
else
  readonly COLOR_RED=""
  readonly COLOR_GREEN=""
  readonly COLOR_YELLOW=""
  readonly COLOR_BLUE=""
  readonly COLOR_MAGENTA=""
  readonly COLOR_CYAN=""
  readonly COLOR_NC=""
fi

#######################################
# Print error message to STDERR
# Globals:
#   COLOR_RED
#   COLOR_NC
# Arguments:
#   $1 - Error message
# Outputs:
#   Writes colored error message to STDERR
#######################################
function print_error() {
  printf "${COLOR_RED}Error: %s${COLOR_NC}\n" "$1" >&2
}

#######################################
# Print info message to STDOUT if verbose
# Globals:
#   COLOR_GREEN
#   COLOR_NC
#   verbose
# Arguments:
#   $1 - Info message
# Outputs:
#   Writes colored info message to STDOUT if verbose enabled
#######################################
function print_info() {
  [[ "${verbose:-false}" == true ]] && printf "${COLOR_GREEN}Info: %s${COLOR_NC}\n" "$1" || true
}

#######################################
# Print warning message to STDERR
# Globals:
#   COLOR_YELLOW
#   COLOR_NC
# Arguments:
#   $1 - Warning message
# Outputs:
#   Writes colored warning message to STDERR
#######################################
function print_warning() {
  printf "${COLOR_YELLOW}Warning: %s${COLOR_NC}\n" "$1" >&2
}

#######################################
# Print debug message to STDOUT if debug
# Globals:
#   COLOR_BLUE
#   COLOR_NC
#   debug
# Arguments:
#   $1 - Debug message
# Outputs:
#   Writes colored debug message to STDOUT if debug enabled
#######################################
function print_debug() {
  [[ "${debug:-false}" == true ]] && printf "${COLOR_BLUE}Debug: %s${COLOR_NC}\n" "$1" || true
}

#######################################
# Print success message to STDOUT
# Globals:
#   COLOR_GREEN
#   COLOR_NC
# Arguments:
#   $1 - Success message
# Outputs:
#   Writes colored success message to STDOUT
#######################################
function print_success() {
  printf "${COLOR_GREEN}Success: %s${COLOR_NC}\n" "$1"
}
