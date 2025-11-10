````markdown
# Toolkit - Portable Linux Shell Scripts

A collection of Linux shell scripts that can be easily cloned and used without system-wide installation.

## Quick Start

```bash
git clone <repo-url> ~/toolkit
source ~/toolkit/init.sh
```

To make scripts available in all future sessions:
```bash
echo 'source ~/toolkit/init.sh' >> ~/.bashrc  # or ~/.zshrc
```

## Available Scripts

- **hcurl** - HTTP client with persistent header injection
- **sysinfo** - Display system information
- **hello-toolkit** - Welcome/demo script

See [HCURL.md](HCURL.md) for complete hcurl reference. Add your own scripts to `bin/` following [CONTRIBUTING.md](CONTRIBUTING.md).

## Project Structure

```
toolkit/
├── init.sh              # Source this first
├── bin/                 # Your scripts go here
├── lib/common.sh        # Shared functions
├── .state/              # Git-ignored state (auto-created per script)
├── README.md            # This file
├── CONTRIBUTING.md      # How to add scripts
├── STATE_MANAGEMENT.md  # Persistent state guide
├── HCURL.md             # hcurl reference
└── QUICKREF.md          # Command quick reference
```

## How It Works

Sourcing `init.sh`:
1. Sets `$TOOLKIT_ROOT` environment variable
2. Adds `bin/` to PATH for current session
3. Auto-sources library functions from `lib/`

Works with Bash 4.0+ and Zsh 5.0+. To suppress output: `source init.sh 2>/dev/null`

## Documentation

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to add scripts, best practices, code style
- **[STATE_MANAGEMENT.md](STATE_MANAGEMENT.md)** - Persistent state pattern for scripts
- **[HCURL.md](HCURL.md)** - Complete hcurl guide with examples
- **[QUICKREF.md](QUICKREF.md)** - Command quick reference

## Environment Variables

After sourcing `init.sh`:
- `$TOOLKIT_ROOT` - Path to toolkit directory
- `$DEBUG` - Set to "1" for debug output in scripts

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Scripts not found | Check PATH: `echo $PATH \| grep toolkit` |
| State not persisting | Verify: `ls -la .state/` |
| Headers not injecting (hcurl) | Debug: `DEBUG=1 hcurl https://example.com` |

---

New to toolkit? Start with [CONTRIBUTING.md](CONTRIBUTING.md) to understand how scripts work. See [QUICKREF.md](QUICKREF.md) for a command cheat sheet.

````
