# hcurl - curl with Persistent Header Injection

Configure custom headers once and have them automatically injected on every request using curl's native `-K` (config file) option.

## Quick Start

```bash
# Configure headers
hcurl set-header "X-API-Key" "your-key"
hcurl set-header "Authorization" "Bearer token"

# Use curl normally - headers are automatically injected
hcurl https://api.example.com/endpoint
hcurl -X POST https://api.example.com/data -d '{"key":"value"}'

# Manage headers
hcurl list-headers
hcurl get-header "X-API-Key"
hcurl clear-header "X-API-Key"
hcurl clear-all
```

## Commands

| Command | Usage |
|---------|-------|
| `set-header KEY VALUE` | Store a header for injection |
| `get-header KEY` | Retrieve a header's value |
| `list-headers` | Show all configured headers |
| `clear-header KEY` | Remove a specific header |
| `clear-all` | Remove all headers |
| *(curl args)* | Pass through to curl with headers injected |

## How It Works

Headers are stored in `.state/hcurl/curl.config` using curl's native config format:

```
header = "X-API-Key: secret123"
header = "Authorization: Bearer token"
```

When you run `hcurl`, it invokes: `curl -K .state/hcurl/curl.config [arguments]`

This uses curl's built-in facilities directly - no custom argument parsing.

## Examples

**API Testing:**
```bash
hcurl set-header "X-Debug-Mode" "true"
hcurl set-header "X-Request-ID" "test-123"
hcurl https://api.example.com/endpoint
```

**Multiple Headers:**
```bash
hcurl set-header "Authorization" "Bearer token"
hcurl set-header "X-API-Key" "key123"
hcurl set-header "X-Client-Version" "1.2.3"
hcurl list-headers
```

**Temporary vs Permanent:**
```bash
# Temporary (current session only)
hcurl set-header "X-Custom" "value"

# Permanent (add to ~/.bashrc or ~/.zshrc)
source ~/toolkit/init.sh
hcurl set-header "X-API-Key" "permanent-key"
```

## Debugging

```bash
DEBUG=1 hcurl https://api.example.com/endpoint
```

Shows the generated curl config and headers being used.

## Notes

- Headers persist across shell restarts (stored in `.state/`)
- Multiple headers supported
- State is git-ignored (won't pollute version control)
- Works with all curl options and flags
- If header names conflict with `-H` arguments, the `-H` takes precedence


See `CONTRIBUTING.md` for more details on the state management pattern and how to implement similar patterns in other scripts.
