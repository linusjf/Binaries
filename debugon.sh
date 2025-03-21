#!/usr/bin/env bash

# Debug mode activation script
#
# Description:
#   This script enables debug mode when DEBUG is true
#
# Globals:
#   DEBUG - Controls debug mode (default: false)
#
# Outputs:
#   Debug information to STDOUT if enabled

readonly DEBUG="${DEBUG:-false}"

if "$DEBUG"; then
  printf "DEBUG mode on.\n"
  set -xve
  PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]-""}() '
fi
