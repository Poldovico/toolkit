# Toolkit - Portable Linux Shell Scripts

A collection of useful Linux shell scripts that can be easily cloned and used without system-wide installation.

## Quick Start

Clone this repository and source the toolkit:

```bash
git clone <repo-url> ~/toolkit
source ~/toolkit/init.sh
```

## Usage

After sourcing `init.sh`, all scripts in the toolkit's `bin/` directory will be available in your PATH for the current shell session.

### Temporary Use (Current Session Only)

```bash
source ~/toolkit/init.sh
my-script-name
```

### Persistent Use (Add to Shell Config)

To make the toolkit available in all future shell sessions, add this line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
source ~/toolkit/init.sh
```

## Project Structure

```
toolkit/
├── init.sh          # Source this file to add scripts to PATH
├── bin/             # Directory containing all executable scripts
│   ├── example-script
│   └── (add more scripts here)
├── lib/             # Optional: Shared library functions
├── README.md        # This file
└── LICENSE          # License file
```

## Creating New Scripts

1. Create your script in the `bin/` directory
2. Make it executable: `chmod +x bin/your-script`
3. Add a shebang line and your script logic
4. The script will be automatically available after sourcing `init.sh`

### Script Template

```bash
#!/bin/bash
# Script description here

# Your script logic here
echo "Hello from your script!"
```

## Notes

- Scripts are only added to PATH for the current shell session
- No system-wide installation needed
- Safe to use alongside system scripts (be mindful of naming conflicts)
- Each new shell session requires sourcing `init.sh` (or add it to your shell config)
