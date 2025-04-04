#!/usr/bin/env bash

## Git utility functions
## Can be sourced by other scripts to provide common git functionality

#######################################
# Check if current directory is a git repository
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes error messages to STDERR
# Returns:
#   0 if git repo, 1 otherwise
#######################################
function is_git_repository() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    print_error "'$(basename "${PWD}")' - Not a Git repository."
    return 1
  fi
  return 0
}

#######################################
# Get current git branch name
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes branch name to STDOUT
# Returns:
#   0 if successful, non-zero on error
#######################################
function get_current_branch() {
  git branch --show-current 2> /dev/null || {
    print_error "Failed to get current branch"
    return 1
  }
}

#######################################
# Verify git is installed and available
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes error messages to STDERR
# Returns:
#   0 if git available, 1 otherwise
#######################################
function require_git() {
  if ! command -v git > /dev/null 2>&1; then
    print_error "Git is not installed or not in PATH"
    return 1
  fi
  return 0
}

#######################################
# Get the root directory of git repository
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes root path to STDOUT
# Returns:
#   0 if successful, non-zero on error
#######################################
function git_root() {
  git rev-parse --show-toplevel 2> /dev/null || {
    print_error "Not inside a git repository"
    return 1
  }
}

#######################################
# Check if git repository has uncommitted changes
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes status messages to STDERR
# Returns:
#   0 if clean, 1 if dirty
#######################################
function git_is_clean() {
  if ! git diff-index --quiet HEAD --; then
    print_warning "Repository has uncommitted changes"
    return 1
  fi
  return 0
}
