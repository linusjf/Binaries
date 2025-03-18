# Testing cleanuplogs with BATS

This repository includes automated tests for the `cleanuplogs` script using the Bash Automated Testing System (BATS).

## Prerequisites

1. Install BATS on your system:

   For Debian/Ubuntu:
   ```
   sudo apt-get install bats
   ```

   For Arch Linux:
   ```
   sudo pacman -S bats
   ```

   For macOS (using Homebrew):
   ```
   brew install bats-core
   ```

   Alternatively, you can install BATS manually:
   ```
   git clone https://github.com/bats-core/bats-core.git
   cd bats-core
   ./install.sh /usr/local
   ```

## Running the Tests

To run all tests:
