# Contributing to Toolkit

Add a script to `bin/`. Here's what it needs:

## Quick Start

```bash
cat > bin/my-script << 'EOF'
#!/bin/bash
set -euo pipefail
source "${TOOLKIT_ROOT}/lib/common.sh"

# Your code here
success "Works!"
EOF

chmod +x bin/my-script
source init.sh && my-script
```

## Requirements

- `#!/bin/bash` shebang
- `set -euo pipefail` for error handling
- Use `$TOOLKIT_ROOT`, not hardcoded paths
- Source `lib/common.sh` for logging functions
- Comment explaining what it does
- Make it executable: `chmod +x`
- Test it from different directories

## Common Library

Available functions:

```bash
info "msg"                    # Info message
success "msg"                 # Success message
error "msg"                   # Error message
warn "msg"                    # Warning message
debug "msg"                   # Debug (if DEBUG=1)
die "msg"                     # Error and exit

command_exists curl           # Check if command exists
require_command jq            # Require or fail
print_kv "key" "value"        # Pretty print
```

All go to stderr except `print_kv`.

## Persistent State

Store config/cache in `.state/{script-name}/`:

```bash
STATE_DIR="${TOOLKIT_ROOT}/.state/my-script"
mkdir -p "$STATE_DIR"
CONFIG_FILE="${STATE_DIR}/config.conf"

# Read
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# Write
echo "KEY=value" > "$CONFIG_FILE"
```

See [STATE_MANAGEMENT.md](STATE_MANAGEMENT.md) for full details.

## Style

- Variables: `lowercase_with_underscores`
- Constants: `UPPERCASE`
- Functions: `lowercase_with_underscores`
- Scripts: `lowercase-with-hyphens`
- Comments explain why, not what
- Keep functions focused

## Testing

```bash
# Fresh run
source init.sh
my-script

# With arguments
my-script --help
my-script arg1 arg2

# Different directory
cd /tmp && my-script

# Debug
DEBUG=1 my-script

# Error handling
my-script bad-arg  # Should fail

# Syntax check
bash -n bin/my-script
```

## Before Pushing

- Script runs without errors
- Works from different directories
- Error handling works
- No hardcoded paths
- Code is readable
- Comments explain complex logic

## Issues & PRs

**Reporting a bug:**
- What you did
- What happened
- What you expected
- OS and shell version
- Any errors

**Making a PR:**
- One feature or fix per PR
- Clear commit message
- Test it
- Update docs if needed
- Follow the style guide

## Docs

If you add something new:
- Add to README.md's script list
- Document in CONTRIBUTING.md (here)
- Use STATE_MANAGEMENT.md for state stuff
- Reference QUICKREF.md for command format

---

Questions? See [README.md](README.md) or [STATE_MANAGEMENT.md](STATE_MANAGEMENT.md).
