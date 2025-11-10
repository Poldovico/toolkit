# Contributing to Toolkit

Thank you for your interest in contributing to the Toolkit project!

## Adding New Scripts

### Steps

1. Create your script in the `bin/` directory:
   ```bash
   touch bin/your-script-name
   ```

2. Add the shebang and your code:
   ```bash
   #!/bin/bash
   # Description of what your script does
   
   set -euo pipefail
   
   # Your code here
   ```

3. Make it executable:
   ```bash
   chmod +x bin/your-script-name
   ```

4. Test it locally:
   ```bash
   source init.sh
   your-script-name
   ```

5. Update this README with usage instructions if needed

### Best Practices

- **Error Handling**: Use `set -euo pipefail` at the top of scripts
- **Documentation**: Add comments explaining what your script does
- **Portability**: Avoid bash-only features; stick to POSIX-compliant code when possible
- **Exit Codes**: Return appropriate exit codes (0 for success, non-zero for failure)
- **Help Text**: Add a `--help` option to your script if it accepts arguments
- **Reusable Code**: Extract common functions to `lib/` and source them

### Using the Common Library

Many utility functions are available in `lib/common.sh`. Source it in your script:

```bash
#!/bin/bash
source "${TOOLKIT_ROOT}/lib/common.sh"

# Now you can use:
# - info "message"
# - success "message"
# - error "message"
# - warn "message"
# - debug "message"
# - die "message"
# - command_exists "command"
# - require_command "command"
# - print_kv "key" "value"
```

### State Management Pattern

Some scripts need to maintain state across invocations (configuration, cache, runtime data, etc.). Follow these guidelines:

#### Directory Structure

All script state should be stored in the `.state/` directory at the repository root:

```
toolkit/
├── .state/                           # Git-ignored state directory
│   ├── script-name/                  # Per-script state directory
│   │   ├── config.conf
│   │   ├── cache.json
│   │   └── data.txt
│   └── another-script/
│       └── ...
├── .gitignore                        # Contains .state/ to prevent version control pollution
└── bin/
    └── script-name
```

#### Implementation Pattern

1. **Set state directory in your script**:
   ```bash
   STATE_DIR="${TOOLKIT_ROOT}/.state/your-script-name"
   mkdir -p "$STATE_DIR"
   ```

2. **Store configuration/state files** in that directory:
   ```bash
   CONFIG_FILE="${STATE_DIR}/config.conf"
   ```

3. **Read/write state as needed** for your script's functionality

#### Example: Custom Header Storage

The `hcurl` script demonstrates this pattern:

```bash
STATE_DIR="${TOOLKIT_ROOT}/.state/hcurl"
HEADERS_FILE="${STATE_DIR}/headers.conf"

# Ensure state directory exists
mkdir -p "$STATE_DIR"

# Save headers
save_headers() {
    : > "$HEADERS_FILE"  # Truncate file
    for key in "${!headers_map[@]}"; do
        echo "${key}=${headers_map[$key]}" >> "$HEADERS_FILE"
    done
}

# Load headers
load_headers() {
    declare -gA headers_map
    [[ -f "$HEADERS_FILE" ]] || return 0
    while IFS='=' read -r key value; do
        [[ -z "$key" ]] && continue
        headers_map["$key"]="$value"
    done < "$HEADERS_FILE"
}
```

#### Best Practices

- **Isolate state**: Each script gets its own directory to avoid conflicts
- **Document format**: Add comments explaining the format of state files
- **Handle missing state**: Scripts should work even if state files don't exist yet
- **Clean on demand**: Provide commands to clear/reset state (e.g., `script-name clear-all`)
- **Persistent**: State survives script and shell restarts (unlike environment variables)
- **Git-safe**: The `.state/` directory is in `.gitignore` to prevent accidental commits

### Script Template

```bash
#!/bin/bash
# Brief description of your script
# Usage: script-name [options]

set -euo pipefail

# Source common library
source "${TOOLKIT_ROOT}/lib/common.sh"

main() {
    # Your main logic here
    success "Script completed successfully"
}

main "$@"
```

## Code Style

- Use lowercase for variable names
- Use UPPERCASE for environment variables and constants
- Use descriptive variable names
- Add comments for complex logic
- Keep functions focused and single-purpose

## Testing

Before submitting:

1. Test your script directly
2. Test it from a different directory
3. Test with various input scenarios
4. Verify error handling

## Reporting Issues

When reporting bugs, please include:

- What you were trying to do
- What happened
- What you expected to happen
- Your environment (OS, shell, toolkit location)
- Any error messages

## Pull Request Guidelines

- Keep PRs focused on a single feature or fix
- Provide clear commit messages
- Test your changes thoroughly
- Update documentation as needed
