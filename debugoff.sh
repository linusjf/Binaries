#!/usr/bin/env bash

# Debug mode deactivation script
#
# Description:
#   This script disables debug mode when DEBUG is set
#
# Globals:
#   DEBUG - Controls debug mode
#
# Outputs:
#   None

if [ "$DEBUG" ]; then
  set +xve
fi
