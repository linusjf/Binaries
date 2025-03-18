#!/usr/bin/env bats

# Setup - runs before each test
setup() {
  # Create a temporary directory for our test logs
  export TEST_DIR="$(mktemp -d)"
  export TEST_LOG_DIR="${TEST_DIR}/var/log"
  mkdir -p "$TEST_LOG_DIR"
  
  # Save the original PREFIX value and set it to our test directory
  export ORIGINAL_PREFIX="${PREFIX:-}"
  export PREFIX="$TEST_DIR"
  
  # Create test log files
  echo -e "$(seq 1 100 | tr '\n' '\r')" > "$TEST_LOG_DIR/pacman.log"
  echo "test data" > "$TEST_LOG_DIR/wtmp"
  
  # Mock the root check by setting UID to 0 for tests
  export MOCK_UID=0
}

# Teardown - runs after each test
teardown() {
  # Restore original PREFIX
  export PREFIX="$ORIGINAL_PREFIX"
  
  # Clean up test directory
  rm -rf "$TEST_DIR"
  unset TEST_DIR TEST_LOG_DIR ORIGINAL_PREFIX MOCK_UID
}

# Helper function to run the script with mocked UID
run_script() {
  # Run the script with arguments, mocking the UID
  UID=$MOCK_UID bash -c "$(cat "$(dirname "$BATS_TEST_DIRNAME")/cleanuplogs") $*"
}

# Test default behavior (50 lines)
@test "cleanuplogs truncates pacman.log to 50 lines by default" {
  run run_script
  
  [ "$status" -eq 0 ]
  [ -f "$TEST_LOG_DIR/pacman.log" ]
  
  # Count lines in the truncated file
  line_count=$(wc -l < "$TEST_LOG_DIR/pacman.log")
  [ "$line_count" -eq 50 ]
}

# Test with custom line count
@test "cleanuplogs truncates pacman.log to specified number of lines" {
  run run_script 25
  
  [ "$status" -eq 0 ]
  [ -f "$TEST_LOG_DIR/pacman.log" ]
  
  # Count lines in the truncated file
  line_count=$(wc -l < "$TEST_LOG_DIR/pacman.log")
  [ "$line_count" -eq 25 ]
}

# Test wtmp file clearing
@test "cleanuplogs clears wtmp file" {
  run run_script
  
  [ "$status" -eq 0 ]
  [ -f "$TEST_LOG_DIR/wtmp" ]
  
  # Check if wtmp is empty
  file_size=$(wc -c < "$TEST_LOG_DIR/wtmp")
  [ "$file_size" -eq 0 ]
}

# Test help message
@test "cleanuplogs displays help message with -h flag" {
  run run_script -h
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"Truncates log files"* ]]
}

# Test help message with --help
@test "cleanuplogs displays help message with --help flag" {
  run run_script --help
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"Truncates log files"* ]]
}

# Test non-root user error
@test "cleanuplogs fails when not run as root" {
  # Set mock UID to non-root
  MOCK_UID=1000
  
  run run_script
  
  [ "$status" -eq 87 ]
  [[ "$output" == *"Error: Must be root"* ]]
}

# Test invalid argument error
@test "cleanuplogs fails with non-numeric argument" {
  run run_script abc
  
  [ "$status" -eq 85 ]
  [[ "$output" == *"Error: Invalid argument"* ]]
}

# Test missing log directory
@test "cleanuplogs fails when log directory doesn't exist" {
  # Remove the log directory
  rm -rf "$TEST_LOG_DIR"
  
  run run_script
  
  [ "$status" -eq 86 ]
  [[ "$output" == *"Error: Log directory"* ]]
}
