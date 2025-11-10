# Quick Reference - Toolkit Commands

See [README.md](README.md) for complete documentation.

## Initialization

```bash
source ~/toolkit/init.sh
```

## hcurl Commands

```bash
hcurl set-header KEY "VALUE"       # Add header
hcurl get-header KEY               # Get header
hcurl list-headers                 # List all
hcurl clear-header KEY             # Remove one
hcurl clear-all                    # Clear all
DEBUG=1 hcurl URL                  # Debug request
```

## Script Development

**Create script:**
```bash
cat > bin/my-script << 'EOF'
#!/bin/bash
source "${TOOLKIT_ROOT}/lib/common.sh"
success "Works!"
EOF
chmod +x bin/my-script
```

**Common functions:**
```bash
info "msg"           success "msg"         error "msg"
warn "msg"           debug "msg"           die "msg"
command_exists curl  require_command curl  print_kv "k" "v"
```

**Persistent state:**
```bash
STATE_DIR="${TOOLKIT_ROOT}/.state/my-script"
mkdir -p "$STATE_DIR"
# Use $STATE_DIR for config files
```

## Debugging

```bash
DEBUG=1 script-name           # Enable debug output
bash -x bin/script-name       # Trace execution
bash -n bin/script-name       # Check syntax
```

---

See full docs in README.md and contributing guides in CONTRIBUTING.md
