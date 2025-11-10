# Contributing to Toolkit

Thank you for contributing to the Toolkit project!

## Quick Start - Adding a Script

1. Create in `bin/`:
   ```bash
   cat > bin/my-script << 'EOF'
   #!/bin/bash
   # Brief description of what this script does
   
   set -euo pipefail
   source "${TOOLKIT_ROOT}/lib/common.sh"
   
   main() {
       # Your logic here
       success "Script works!"
   }
   
   main "$@"
   EOF
   ```

2. Make executable: `chmod +x bin/my-script`

3. Test: `source init.sh && my-script`

That's it! See sections below for best practices and patterns.

## Script Requirements

### Essentials

- **Shebang**: `#!/bin/bash` at top
- **Error handling**: `set -euo pipefail` near top
- **Documentation**: Comment explaining what script does
- **Executable**: `chmod +x bin/your-script`
- **Testing**: Verify it works from different directories

### Best Practices

- **Use common library**: Source `lib/common.sh` for logging and utilities
- **Use $TOOLKIT_ROOT**: Never hardcode paths to toolkit
- **Single purpose**: Keep scripts focused
- **Help text**: Add `--help` option if script takes arguments
- **Check dependencies**: Use `command_exists` or `require_command`
- **Return codes**: Exit 0 on success, non-zero on failure
- **POSIX-compatible**: Avoid bash-only features when possible

## Using Common Library Functions

Source `lib/common.sh` to access:

```bash
source "${TOOLKIT_ROOT}/lib/common.sh"

info "Information message"          # Info output
success "Operation successful"      # Success output
error "Something went wrong"        # Error output
warn "Be careful"                   # Warning output
debug "Debug info (if DEBUG=1)"     # Debug output
die "Fatal error - exit now"        # Print error and exit(1)

command_exists curl || die "curl required"          # Check if command exists
require_command jq && process_json               # Require command or fail
print_kv "Setting" "Value"                        # Pretty-print key-value
```

All output goes to stderr except print_kv which formats stdout.

## State Management (Persistent Storage)

Scripts can persist configuration, cache, or data across invocations. See [STATE_MANAGEMENT.md](STATE_MANAGEMENT.md) for complete guide.

### Quick Example

```bash
#!/bin/bash
set -euo pipefail
source "${TOOLKIT_ROOT}/lib/common.sh"

# 1. Initialize state directory
STATE_DIR="${TOOLKIT_ROOT}/.state/my-script"
mkdir -p "$STATE_DIR"
CONFIG_FILE="${STATE_DIR}/config.conf"

# 2. Load existing config
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# 3. Save new config
save_config() {
    echo "SETTING=$1" > "$CONFIG_FILE"
}

main() {
    case "${1:-}" in
        set)   save_config "$2" ;;
        get)   echo "Setting is: ${SETTING:-not set}" ;;
        clear) rm -f "$CONFIG_FILE" ;;
        *)     die "Usage: my-script {set|get|clear}" ;;
    esac
}

main "$@"
```

**Key points:**
- Each script gets its own `.state/{script-name}/` directory
- State is git-ignored automatically (.gitignore includes `.state/`)
- Survives shell restarts (unlike environment variables)
- No conflicts between scripts (isolated directories)

For detailed implementation patterns and best practices, see [STATE_MANAGEMENT.md](STATE_MANAGEMENT.md).

## Code Style

- **Variables**: lowercase with underscores (`my_var`, `config_file`)
- **Constants**: UPPERCASE (`MY_CONSTANT`, `DEBUG`)
- **Functions**: lowercase with underscores (`save_config`, `load_headers`)
- **Scripts**: lowercase with hyphens (`my-script`, `api-caller`)
- **Comments**: Explain the "why", not the "what"
- **Functions**: Keep single-purpose and focused

## Testing Your Script

```bash
# Test 1: Fresh run
source init.sh
my-script

# Test 2: With arguments
my-script --help
my-script arg1 arg2

# Test 3: From different directory
cd /tmp && my-script

# Test 4: With debug
DEBUG=1 my-script

# Test 5: Error conditions
my-script invalid-arg  # Should exit non-zero

# Test 6: Check syntax
bash -n bin/my-script
```

## Reporting Issues

Include:
- What you were trying to do
- What happened
- What you expected
- Your OS and shell version
- Error messages

## Pull Request Guidelines

- Keep PRs focused (one feature or fix)
- Clear commit messages
- Test thoroughly
- Update documentation
- Follow style guidelines

## Documentation

When adding features, update relevant docs:
- **New script**: Add to README.md's "Available Scripts" list
- **Complex script**: Consider dedicated guide in `/docs/`
- **New pattern**: Document in CONTRIBUTING.md
- **State management**: Reference STATE_MANAGEMENT.md

See [QUICKREF.md](QUICKREF.md) for command reference format.

---

Questions? Check [README.md](README.md) for project overview or [STATE_MANAGEMENT.md](STATE_MANAGEMENT.md) for state pattern details.
