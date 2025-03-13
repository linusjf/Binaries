#!/usr/bin/env bash
######################################################################
# @author      : Linus Fernandes (linusfernandes at gmail dot com)
# @file        : internet.sh
# @created     : Tuesday Mar 26, 2024 11:57:10 IST
# @description : Check for internet connectivity
# @modified    : Improved error handling, compatibility, and efficiency
######################################################################

# Check if the 'ping' command is available
if ! hash ping 2> /dev/null; then
  echo "Error: 'ping' command not found! Exiting..."
  exit 1
fi

# Function to check internet connectivity
checkinternet() {
  if ping -q -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    return 0
  else
    echo "Check your internet connection..."
    return 1
  fi
}

# Check internet and exit if no connection
if ! checkinternet; then
  exit 1
fi
