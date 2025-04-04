#!/usr/bin/env bash

######################################################################
# @author      : linusjf (linusjf@JuliusCaesar)
# @file        : postgre
# @created     : Friday Apr 04, 2025 19:16:08 IST
#
# @description :
######################################################################

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
