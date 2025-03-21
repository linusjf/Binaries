#!/usr/bin/env bash

# Debug execution utility
#
# Description:
#   This script provides a function to execute commands with debug output
#
# Functions:
#   debug_command - Executes command with debug output
#
# Globals:
#   None
#
# Arguments:
#   $@ - Command to execute
#
# Returns:
#   Exit status of executed command

# Execute a command with debug output
#
# Arguments:
#   $@ - Command to execute
#
# Outputs:
#   Debug information to STDOUT
#   Error messages to STDERR
#
# Returns:
#   Exit status of executed command
function debug_command() {
  printf "Executing: %s\n" "$*"

  if ! eval "$*"; then
    printf "Error: Debug command failed: %s\n" "$*" >&2
    return 1
  fi
}
