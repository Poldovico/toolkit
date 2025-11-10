# State Management Pattern - Implementation Guide

This document describes the state management pattern used in the toolkit for scripts that need to persist configuration, cache, or runtime data across invocations.

## Overview

The toolkit provides a clean, git-safe mechanism for scripts to store persistent state without polluting version control or system configuration.

### Key Principles

1. **Isolated Storage** - Each script gets its own directory under `.state/`
2. **Git-Safe** - The `.state/` directory is in `.gitignore` 
3. **Persistent** - State survives shell restarts (unlike environment variables)
4. **Clean** - Predictable location for state files
5. **No Side Effects** - Doesn't affect other scripts or the system

## Implementation Pattern

### 1. Initialize State Directory

Every script using state should start with:

```bash
#!/bin/bash
set -euo pipefail

# Source common library
source "${TOOLKIT_ROOT}/lib/common.sh"

# Initialize state directory - each script gets its own
STATE_DIR="${TOOLKIT_ROOT}/.state/your-script-name"
mkdir -p "$STATE_DIR"

# Define your state files
CONFIG_FILE="${STATE_DIR}/config.conf"
CACHE_FILE="${STATE_DIR}/cache.json"
```

### 2. Directory Structure

After running, your state structure will look like:

```
toolkit/
├── .state/                    # git-ignored root for all state
│   ├── script-one/            # Per-script subdirectory
│   │   ├── config.conf
│   │   ├── cache.json
│   │   └── runtime.txt
│   ├── script-two/
│   │   └── settings.conf
│   └── hcurl/             # Example: curl wrapper state
│       └── headers.conf
├── .gitignore                 # Contains: .state/
└── bin/
    ├── script-one
    ├── script-two
    └── hcurl
```

### 3. Reading State

Safely read state files that might not exist yet:

```bash
# Load configuration with defaults
load_config() {
    local key="$1"
    local default="${2:-}"
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "$default"
        return 0
    fi
    
    grep "^${key}=" "$CONFIG_FILE" | cut -d= -f2- || echo "$default"
}

# Usage
username=$(load_config "USERNAME" "anonymous")
api_token=$(load_config "API_TOKEN" "")
```

### 4. Writing State

Safely write state files:

```bash
# Save a single value
save_config() {
    local key="$1"
    local value="$2"
    local temp_file="${CONFIG_FILE}.tmp"
    
    # Create temp file with updated config
    : > "$temp_file"
    
    if [[ -f "$CONFIG_FILE" ]]; then
        grep -v "^${key}=" "$CONFIG_FILE" >> "$temp_file" || true
    fi
    
    echo "${key}=${value}" >> "$temp_file"
    mv "$temp_file" "$CONFIG_FILE"
}

# Usage
save_config "USERNAME" "john"
save_config "API_TOKEN" "xyz123"
```

### 5. Clearing State

Provide commands to reset state:

```bash
cmd_reset() {
    rm -rf "$STATE_DIR"
    mkdir -p "$STATE_DIR"
    success "State cleared"
}

# Or selectively
cmd_clear_cache() {
    rm -f "$CACHE_FILE"
    success "Cache cleared"
}
```

## Real-World Example: hcurl

The `hcurl` script demonstrates the full pattern:

```bash
# 1. Initialize state
STATE_DIR="${TOOLKIT_ROOT}/.state/hcurl"
HEADERS_FILE="${STATE_DIR}/headers.conf"
mkdir -p "$STATE_DIR"

# 2. Load state
load_headers() {
    [[ -f "$HEADERS_FILE" ]] || return 0
    while IFS='=' read -r key value; do
        [[ -z "$key" ]] && continue
        # Process header
    done < "$HEADERS_FILE"
}

# 3. Save state
set_header_value() {
    local key="$1"
    local value="$2"
    local temp_file="${HEADERS_FILE}.tmp"
    
    : > "$temp_file"
    # Build new file with updated header
    mv "$temp_file" "$HEADERS_FILE"
}

# 4. Clear state
cmd_clear_all() {
    : > "$HEADERS_FILE"
    success "All headers cleared"
}
```

## Common State File Formats

### Key-Value Pairs (Simple)

```bash
# headers.conf, config.conf, etc.
USERNAME=john
API_TOKEN=xyz123
DEBUG=1
```

**When to use**: Simple configuration with a few values

**Reading**:
```bash
value=$(grep "^KEY=" file.conf | cut -d= -f2-)
```

**Writing**:
```bash
echo "KEY=value" >> file.conf
```

### JSON (Complex)

```bash
# cache.json, data.json, etc.
{
  "user": "john",
  "tokens": ["token1", "token2"],
  "settings": {
    "debug": true,
    "timeout": 30
  }
}
```

**When to use**: Complex nested data, arrays, or multiple data types

**Reading**:
```bash
user=$(jq -r '.user' cache.json)
```

**Writing**:
```bash
jq '.tokens += ["newtoken"]' cache.json > cache.json.tmp
mv cache.json.tmp cache.json
```

### Line-Based (Multiple Entries)

```bash
# entries.txt
id|name|status
1|task1|completed
2|task2|pending
3|task3|failed
```

**When to use**: Multiple similar records or CSV-like data

**Reading**:
```bash
while IFS='|' read -r id name status; do
    # Process line
done < entries.txt
```

**Writing**:
```bash
echo "4|task4|pending" >> entries.txt
```

## Best Practices

### ✅ DO

- **Create state directory at startup**: Ensures it always exists
- **Handle missing files**: Don't fail if state doesn't exist yet
- **Use atomic writes**: Write to temp file, then move (prevents corruption)
- **Document state format**: Add comments explaining the format
- **Provide clear commands**: `clear`, `reset`, `export` commands for state management
- **Use consistent naming**: `STATE_DIR`, `CONFIG_FILE`, etc.
- **Provide defaults**: Return sensible defaults if state is missing

### ❌ DON'T

- **Don't use multiple temp files**: Stick to one temp file approach
- **Don't commit state files**: `.gitignore` prevents this, but verify before pushing
- **Don't store secrets directly**: Use environment variables or secure storage
- **Don't assume state exists**: Always check `[[ -f "$FILE" ]]` first
- **Don't store large files**: Consider disk usage for caches
- **Don't share state between scripts**: Each script gets its own directory
- **Don't forget to document format**: Future maintainers need to understand the file format

## Debugging State

Enable debug mode to see state operations:

```bash
# Show when state is loaded/saved
DEBUG=1 your-script

# In script:
if [[ "${DEBUG:-0}" == "1" ]]; then
    echo "Loading state from: $STATE_DIR" >&2
fi
```

### Inspect State

```bash
# See what state a script has created
ls -lah ~/.state/

# Show script's state directory contents
cat ~/.state/your-script-name/config.conf

# Check state file format
file ~/.state/your-script-name/cache.json
```

### Troubleshoot

```bash
# Reset a script's state completely
rm -rf ~/.state/your-script-name

# Export state for backup
cp -r ~/.state/your-script-name ~/.state/your-script-name.backup

# Compare states between sessions
diff ~/.state/script.old ~/.state/script.new
```

## Testing Scripts with State

When testing scripts with state:

```bash
# Test 1: Fresh run (no state exists)
rm -rf ~/.state/your-script-name
your-script

# Test 2: Verify state was created
ls -la ~/.state/your-script-name/

# Test 3: Run again (state should load)
your-script

# Test 4: Modify state manually and test recovery
echo "corrupted data" > ~/.state/your-script-name/config.conf
your-script  # Should handle gracefully

# Test 5: Clean up
rm -rf ~/.state/your-script-name
```

## Migration and Versioning

If you need to change state format:

```bash
# Add version to state
STATE_VERSION="1.0"

# On load, check version
if [[ ! -f "$STATE_DIR/.version" ]]; then
    # Migrate from old format
    migrate_from_v0_to_v1
    echo "$STATE_VERSION" > "$STATE_DIR/.version"
fi
```

## Examples in Toolkit

- **hcurl**: Stores headers in `KEY=VALUE` format
- **Future scripts**: Will follow this same pattern

See `hcurl` for a complete, production-ready implementation.

---

**Next**: When adding new scripts, use this pattern to store any persistent data or configuration.
