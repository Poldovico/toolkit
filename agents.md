# Toolkit - Agent Guide

Simple collection of shell scripts with git-cloneable init system. MIT licensed.

## For AI Agents

- **Keep it brief.** Summaries should be clear and concise. Skip the play-by-play unless asked.
- **User does git.** Never run `git add`, `commit`, `push`. Just tell the user when changes are ready.
- **Validate before saying "done".** Check that code works, tests pass, no hardcoded paths.

## What Scripts Should Do

Scripts live in `bin/`. They should:
- Have `#!/bin/bash` shebang and `set -euo pipefail` 
- Use `$TOOLKIT_ROOT` instead of hardcoded paths
- Source `lib/common.sh` for logging (`info`, `success`, `error`, `warn`, `debug`, `die`)
- Check dependencies with `command_exists` or `require_command`
- Return 0 on success, non-zero on failure
- Have a comment explaining what they do

If they need persistent state (config, cache, data), use `.state/{script-name}/` directory (git-ignored).

## Scripts Must Have

- Proper shebang: `#!/bin/bash`
- Error handling: `set -euo pipefail`
- Comments explaining what the script does
- Executable permissions: `chmod +x`
- Work from any directory
- Use `$TOOLKIT_ROOT`, not hardcoded paths
