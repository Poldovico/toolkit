#!/bin/bash
# Toolkit Init Script
# This script adds the toolkit's bin directory to PATH
# Source this file to make all toolkit scripts available

# Get the directory where this script is located
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [[ -n "${ZSH_VERSION}" ]]; then
    TOOLKIT_ROOT="$(cd "$(dirname "${0}")" && pwd)"
else
    # Fallback for other shells
    TOOLKIT_ROOT="$(cd "$(dirname "${0}")" && pwd)"
fi

# Add the bin directory to PATH if not already present
TOOLKIT_BIN="${TOOLKIT_ROOT}/bin"
if [[ ":${PATH}:" != *":${TOOLKIT_BIN}:"* ]]; then
    export PATH="${TOOLKIT_BIN}:${PATH}"
fi

# Export TOOLKIT_ROOT for scripts that might need it
export TOOLKIT_ROOT

# Optional: Source any library files
if [[ -d "${TOOLKIT_ROOT}/lib" ]]; then
    for lib_file in "${TOOLKIT_ROOT}"/lib/*.sh; do
        if [[ -f "$lib_file" ]]; then
            source "$lib_file"
        fi
    done
fi

# Print confirmation message (can be silenced by redirecting stderr)
if [[ -t 1 ]]; then
    echo "✓ Toolkit initialized: $TOOLKIT_BIN added to PATH" >&2
fi
