#!/bin/bash
# QUICK START - Copy this script to test the toolkit

echo "=== Toolkit Quick Start Demo ==="
echo ""

# Get the directory where this script is
DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "1. Sourcing the toolkit..."
source "$DEMO_DIR/init.sh" 2>&1
echo ""

echo "2. Running hello-toolkit..."
hello-toolkit
echo ""

echo "3. Running sysinfo..."
sysinfo
echo ""

echo "4. Testing toolkit availability..."
echo "   Toolkit Root: $TOOLKIT_ROOT"
echo "   Scripts available:"
ls -1 "$TOOLKIT_ROOT/bin" | sed 's/^/     - /'
echo ""

echo "✓ Demo complete!"
echo ""
echo "Next steps:"
echo "  - source init.sh (temporary, current session only)"
echo "  - Add 'source $DEMO_DIR/init.sh' to your ~/.bashrc for permanent access"
echo "  - Create new scripts in the bin/ directory"
echo "  - See CONTRIBUTING.md for best practices"
