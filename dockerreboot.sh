#!/usr/bin/env bash

######################################################################
# @author      : Linus Fernandes (linusfernandes at gmail dot com)
# @file        : dockerreboot
# @created     : Monday Sep 22, 2025 14:11:41 IST
#
# @description :
####################################################################
docker compose down --volumes && docker compose up --build
