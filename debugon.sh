#!/usr/bin/env bash
if "$DEBUG"; then
  printf "DEBUG mode on.\n"
  set -xve
  PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}() '
fi
