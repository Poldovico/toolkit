#!/bin/bash
# Common Library Functions
# Shared utilities for toolkit scripts

# Print an informational message
info() {
    echo "ℹ $*" >&2
}

# Print a success message
success() {
    echo "✓ $*" >&2
}

# Print an error message
error() {
    echo "✗ Error: $*" >&2
}

# Print a warning message
warn() {
    echo "⚠ Warning: $*" >&2
}

# Print a debug message (only if DEBUG=1)
debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "🐛 Debug: $*" >&2
    fi
}

# Exit with error
die() {
    error "$@"
    exit 1
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Require a command to exist
require_command() {
    local cmd="$1"
    command_exists "$cmd" || die "Required command not found: $cmd"
}

# Pretty print a key-value pair
print_kv() {
    local key="$1"
    local value="$2"
    printf "  %-20s %s\n" "$key:" "$value"
}
