# Toolkit Quick Reference

## Getting Started

```bash
# Clone and initialize
git clone <toolkit-repo> ~/toolkit
source ~/toolkit/init.sh

# Or add to shell config for permanent access
echo 'source ~/toolkit/init.sh' >> ~/.bashrc
```

## Available Scripts

### hcurl - HTTP Client with Header Injection

Configure custom headers once, inject on every request:

```bash
# Configure headers
hcurl set-header "X-API-Key" "your-key"
hcurl set-header "Authorization" "Bearer token"

# Use curl normally - headers injected automatically
hcurl https://api.example.com/data
hcurl -X POST https://api.example.com/data -d '{"key":"value"}'

# Manage headers
hcurl list-headers              # Show all
hcurl get-header "X-API-Key"    # Get one
hcurl clear-header "X-API-Key"  # Remove one
hcurl clear-all                 # Reset all

# Debug
DEBUG=1 hcurl https://api.example.com  # See header injection
```

### sysinfo - System Information Display

Display system information with formatted output:

```bash
sysinfo
```

Shows: OS, kernel, hostname, CPU cores, uptime, disk usage, memory usage

### hello-toolkit - Welcome Script

Simple demo showing toolkit features:

```bash
hello-toolkit
```

## Common Tasks

### Add a New Script

1. Create file in `bin/`:
   ```bash
   cat > bin/my-script << 'EOF'
   #!/bin/bash
   source "${TOOLKIT_ROOT}/lib/common.sh"
   success "My script works!"
   EOF
   ```

2. Make executable:
   ```bash
   chmod +x bin/my-script
   ```

3. Test:
   ```bash
   source init.sh
   my-script
   ```

### Add Script State (Persistent Config)

```bash
#!/bin/bash
# In your script:

STATE_DIR="${TOOLKIT_ROOT}/.state/my-script"
mkdir -p "$STATE_DIR"

CONFIG_FILE="${STATE_DIR}/config.conf"

# Save config
echo "KEY=value" >> "$CONFIG_FILE"

# Load config
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi
```

State is automatically git-ignored (see `.state/` in .gitignore).

### Use Common Library Functions

```bash
#!/bin/bash
source "${TOOLKIT_ROOT}/lib/common.sh"

info "Information message"
success "Success message"
error "Error message"
warn "Warning message"
debug "Debug message (if DEBUG=1)"
die "Error and exit"

command_exists curl || die "curl is required"

print_kv "Setting" "Value"
```

### Debug a Script

```bash
# Enable debug output
DEBUG=1 my-script

# Trace execution
bash -x bin/my-script

# Check script syntax
bash -n bin/my-script
```

## Directory Structure

```
toolkit/
├── init.sh                 # Source this first
├── bin/                    # All scripts go here
│   ├── hcurl
│   ├── hello-toolkit
│   └── sysinfo
├── lib/
│   └── common.sh          # Shared functions
├── .state/                # Git-ignored state (auto-created)
├── README.md              # Usage guide
├── CONTRIBUTING.md        # Developer guide
├── HCURL.md          # hcurl reference
├── STATE_MANAGEMENT.md   # State pattern guide
├── agents.md             # Requirements spec
└── .gitignore
```

## Documentation

- **README.md** - Quick start and overview
- **CONTRIBUTING.md** - How to add scripts, best practices, state pattern
- **HCURL.md** - Complete hcurl guide with examples
- **STATE_MANAGEMENT.md** - How to implement persistent state in scripts
- **agents.md** - Requirements and specifications (for AI assistance)
- **SUMMARY.md** - Architecture and advanced features

## Key Concepts

### Initialization (init.sh)

- Adds `bin/` to PATH
- Sets `$TOOLKIT_ROOT` environment variable
- Auto-sources library files from `lib/`
- Works from any directory
- Compatible with Bash and Zsh

### State Management Pattern

Scripts can store persistent state in `.state/{script-name}/`:

```bash
STATE_DIR="${TOOLKIT_ROOT}/.state/my-script"
CONFIG_FILE="${STATE_DIR}/config.conf"
```

- Isolated per-script (no conflicts)
- Git-safe (in .gitignore)
- Survives shell restarts
- Documented in STATE_MANAGEMENT.md

### Common Library (lib/common.sh)

Provides:
- `info()`, `success()`, `error()`, `warn()`, `debug()` - Logging
- `die()` - Error and exit
- `command_exists()` - Check if command available
- `require_command()` - Require command or fail
- `print_kv()` - Pretty-print key-value pairs

## Environment Variables

After sourcing `init.sh`:

- `$TOOLKIT_ROOT` - Path to toolkit root directory
- `$PATH` - Updated to include `$TOOLKIT_ROOT/bin`
- `$DEBUG` - Set to "1" to enable debug output in scripts

## Tips

- Use `$TOOLKIT_ROOT` not hardcoded paths in scripts
- Source common library at top of your scripts
- Always use `set -euo pipefail` in scripts
- Provide `--help` option for complex scripts
- Use `command_exists` to check for dependencies
- Store state in `.state/{script-name}/`
- Test scripts from different directories
- Keep scripts focused and single-purpose

## Troubleshooting

**Scripts not found after sourcing init.sh?**
```bash
# Verify PATH was updated
echo $PATH | grep toolkit

# Re-source init.sh
source init.sh
```

**State files not persisting?**
```bash
# Check .state directory exists
ls -la ~/.state/your-script/

# Verify .state is gitignored
cat .gitignore | grep .state
```

**Script not executable?**
```bash
# Make executable
chmod +x bin/your-script

# Verify
ls -l bin/your-script  # Should show x permission
```

**hcurl not injecting headers?**
```bash
# Check configured headers
hcurl list-headers

# Enable debug to see injection
DEBUG=1 hcurl https://example.com

# Verify headers file
cat ~/.state/hcurl/headers.conf
```

---

For more details, see the full documentation files in the toolkit directory.
