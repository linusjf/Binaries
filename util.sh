#!/usr/bin/env bash

# @file util.sh
# @brief General utility functions for bash scripting
# @description Contains common utility functions for output, debugging, and system operations.

#######################################
# Output functions
#######################################

out() { printf %s\\n "$*"; }
export -f out
err() { >&2 printf %s\\n "$*"; }
export -f err
die() {
  >&2 printf %s\\n "$*"
  exit 1
}
export -f die
big() { printf \\n###\\n#\\n#\ %s\\n#\\n###\\n\\n "$*"; }
export -f big
log() { printf '%s %s %s\n' "$(now)" $$ "$*"; }
export -f log

#######################################
# Time functions
#######################################

now() { date -u "+%Y-%m-%dT%H:%M:%S.%NZ"; }
export -f now
sec() { date -u "+%s"; }
export -f sec

#######################################
# Random ID generation
#######################################

zid() { hexdump -n 16 -v -e '16/1 "%02x" "\n"' /dev/random; }
export -f zid

#######################################
# Command checking
#######################################

cmd() { command -v "$1" > /dev/null 2>&1; }
export -f cmd

#######################################
# Assertion functions
#######################################

assert_empty() { [ -z "$1" ] || err $FUNCNAME "$@"; }
export -f assert_empty
assert_equal() { [ "$1" = "$2" ] || err $FUNCNAME "$@"; }
export -f assert_equal

#######################################
# Temporary directory functions
#######################################

temp_home() { out "$(mktemp -d -t "${1:-$(zid)}")"; }
export -f temp_home
temp_dir() { out "$(temp_home "$(basename "$0")")"; }
export -f temp_dir

#######################################
# Program information
#######################################

program() {
  printf "%s\n" "$(basename "$0")"
}
export -f program

#######################################
# PostgreSQL utility functions
#######################################

psql_user_names() { psql -tAc "SELECT usename FROM pg_catalog.pg_user;"; }
export -f psql_user_names
psql_user_name_exist() { [ "$(psql -tAc "SELECT 1 FROM pg_catalog.pg_user WHERE usename='$1'")" = '1' ]; }
export -f psql_user_name_exist
psql_database_names() { psql -tAc "SELECT datname FROM pg_database;"; }
export -f psql_database_names
psql_database_name_exist() { [ "$(psql -tAc "SELECT 1 FROM pg_database WHERE datname='$1'")" = '1' ]; }
export -f psql_database_name_exist
