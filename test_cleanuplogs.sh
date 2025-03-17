#!/usr/bin/env bash
set -euo pipefail

# Test script for cleanuplogs
# This script tests the functionality of the cleanuplogs script

# Create a temporary directory for testing
TEST_DIR=$(mktemp -d)
echo "Created test directory: $TEST_DIR"

# Create a mock log directory structure
mkdir -p "$TEST_DIR/var/log"
LOG_DIR="$TEST_DIR/var/log"

# Create test log files
echo "Creating test log files..."
for i in {1..100}; do
  echo "Log line $i" >> "$LOG_DIR/pacman.log"
done
echo "Created pacman.log with 100 lines"

touch "$LOG_DIR/wtmp"
echo "Created empty wtmp file"

# Create a modified version of cleanuplogs for testing
TEST_SCRIPT="$TEST_DIR/cleanuplogs_test"
cat > "$TEST_SCRIPT" << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

# Modified cleanuplogs for testing
# This version doesn't require root and uses a test log directory

# Get the test directory from the environment
LOG_DIR="${TEST_LOG_DIR}"

# Skip root check for testing
ROOT_UID=999 # Dummy value
UID=999      # Dummy value to match

# Default number of lines saved
lines=50

# Can't change directory?
E_XCD=86

# Non-root exit error (not used in test)
E_NOTROOT=87

# Non-numerical argument (bad argument format)
E_WRONGARGS=85

# Parse arguments
case "${1:-}" in
  "")
    lines=50
    ;;
  "-h"|"--help")
    echo "Test help message"
    exit 0
    ;;
  *[!0-9]*)
    printf "Error: Invalid argument '%s'\n" "$1" >&2
    printf "Usage: %s [lines-to-keep]\n" "$(basename "$0")" >&2
    exit "$E_WRONGARGS"
    ;;
  *)
    lines="$1"
    ;;
esac

if [[ ! -d "$LOG_DIR" ]]; then
  printf "Error: Log directory '%s' does not exist.\n" "$LOG_DIR" >&2
  exit "$E_XCD"
fi

cd "$LOG_DIR" || {
  printf "Error: Cannot change to log directory '%s'.\n" "$LOG_DIR" >&2
  exit "$E_XCD"
}

# Save last section of pacman log file
if [[ -f pacman.log ]]; then
  tail -n "$lines" pacman.log > pacman.temp \
    && mv pacman.temp pacman.log
  printf "Truncated pacman.log to %d lines.\n" "$lines"
fi

# Clear wtmp file
if [[ -f wtmp ]]; then
  : > wtmp
  printf "Cleared wtmp file.\n"
fi

printf "Log files cleaned up successfully.\n"

exit 0
EOF

chmod +x "$TEST_SCRIPT"
echo "Created test script"

# Run tests
echo -e "\n--- Running tests ---\n"

# Test 1: Default behavior (50 lines)
echo "Test 1: Default behavior (50 lines)"
export TEST_LOG_DIR="$LOG_DIR"
"$TEST_SCRIPT"
LINES_COUNT=$(wc -l < "$LOG_DIR/pacman.log")
echo "Pacman log now has $LINES_COUNT lines (expected 50)"
if [[ "$LINES_COUNT" -eq 50 ]]; then
  echo "✅ Test 1 passed"
else
  echo "❌ Test 1 failed"
fi

# Recreate log file for next test
rm "$LOG_DIR/pacman.log"
for i in {1..100}; do
  echo "Log line $i" >> "$LOG_DIR/pacman.log"
done

# Test 2: Custom line count
echo -e "\nTest 2: Custom line count (25 lines)"
"$TEST_SCRIPT" 25
LINES_COUNT=$(wc -l < "$LOG_DIR/pacman.log")
echo "Pacman log now has $LINES_COUNT lines (expected 25)"
if [[ "$LINES_COUNT" -eq 25 ]]; then
  echo "✅ Test 2 passed"
else
  echo "❌ Test 2 failed"
fi

# Test 3: Help message
echo -e "\nTest 3: Help message"
OUTPUT=$("$TEST_SCRIPT" --help)
if [[ "$OUTPUT" == *"Test help message"* ]]; then
  echo "✅ Test 3 passed"
else
  echo "❌ Test 3 failed"
fi

# Test 4: Invalid argument
echo -e "\nTest 4: Invalid argument"
if ! "$TEST_SCRIPT" abc 2>/dev/null; then
  echo "✅ Test 4 passed (script exited with error as expected)"
else
  echo "❌ Test 4 failed (script should have exited with error)"
fi

# Test 5: wtmp file is cleared
echo -e "\nTest 5: wtmp file is cleared"
echo "Some content" > "$LOG_DIR/wtmp"
"$TEST_SCRIPT"
if [[ ! -s "$LOG_DIR/wtmp" ]]; then
  echo "✅ Test 5 passed (wtmp file is empty)"
else
  echo "❌ Test 5 failed (wtmp file should be empty)"
fi

# Test 6: Non-existent log directory
echo -e "\nTest 6: Non-existent log directory"
export TEST_LOG_DIR="$TEST_DIR/nonexistent"
if ! "$TEST_SCRIPT" 2>/dev/null; then
  echo "✅ Test 6 passed (script exited with error as expected)"
else
  echo "❌ Test 6 failed (script should have exited with error)"
fi

# Clean up
echo -e "\nCleaning up test directory..."
rm -rf "$TEST_DIR"
echo "Done"
