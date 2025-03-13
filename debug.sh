#!/usr/bin/env bash
function debug() {
  printf "Executing: %s\n" "$*"
  eval "$*"
}
