# Toolkit Repository Requirements

This document outlines the requirements and specifications for maintaining and developing the Toolkit repository.

**Note for AI Agents**: 
- When working on toolkit tasks, be concise with summaries. Avoid repeating detailed recaps of completed work unless specifically requested. Focus on clarity and actionable information rather than verbose repetition.
- **All git operations (add, commit, push, etc.) must be performed by the user.** Never automatically run git commands. Prepare changes and inform the user when they are ready to commit, allowing the user to decide when and how to commit.

## Repository Overview

**Purpose**: A portable, git-cloneable collection of Linux shell scripts that can be sourced to add scripts to PATH without system-wide installation.

**Target Users**: Linux/Unix administrators, developers, DevOps engineers, and power users

**License**: MIT

## Core Requirements

### R1: Initialization System

**Requirement**: Users must be able to source a single script to make all toolkit scripts available in their PATH.

**Specifications**:
- Single entry point: `init.sh` in repository root
- Must work when sourced from any directory
- Must detect toolkit root regardless of current working directory
- Must not require any dependencies beyond standard shell builtins
- Must work with Bash and Zsh (minimum versions: Bash 4.0+, Zsh 5.0+)

**Implementation Details**:
- Use `BASH_SOURCE[0]` for Bash detection
- Use `ZSH_VERSION` for Zsh detection
- Fallback to `$0` for other shells
- Export `$TOOLKIT_ROOT` variable for scripts to reference
- Add `$TOOLKIT_ROOT/bin` to PATH at the beginning to ensure priority

**Testing**: 
- [ ] `source init.sh` from repository root
- [ ] `source ~/path/to/toolkit/init.sh` from home directory
- [ ] Scripts are callable after sourcing
- [ ] Works in new Bash and Zsh shells

### R2: Script Directory Structure

**Requirement**: Executable scripts must be organized in a predictable location.

**Specifications**:
- All executable scripts in `bin/` directory at repository root
- All scripts must be executable (`755` permissions)
- All scripts must have a proper shebang line (`#!/bin/bash`)
- No nested subdirectories in `bin/`
- Script names must be descriptive and lowercase with hyphens (e.g., `my-script`, not `MyScript` or `myscript`)

**Additional**:
- Scripts should be independently functional
- Scripts should be safe to run on any Linux system
- Scripts should not create system-wide side effects

### R3: Shared Library System

**Requirement**: Scripts must have access to common utility functions for consistent behavior.

**Specifications**:
- All common functions in `lib/common.sh`
- Library file automatically sourced by `init.sh`
- Functions must be shell-compatible (POSIX-preferred)
- Library must provide standard logging functions:
  - `info()` - Information messages
  - `success()` - Success messages
  - `error()` - Error messages
  - `warn()` - Warning messages
  - `debug()` - Debug messages (with DEBUG environment variable support)
- Library must provide utility functions:
  - `die()` - Print error and exit with code 1
  - `command_exists()` - Check command availability
  - `require_command()` - Assert command exists or die
  - `print_kv()` - Pretty-print key-value pairs

**Implementation Details**:
- All library functions must use stderr for output (`>&2`)
- Functions must support being called multiple times
- No global state pollution
- Functions must be well-documented with comments

### R4: Error Handling

**Requirement**: All scripts must handle errors gracefully and fail safely.

**Specifications**:
- All scripts must use `set -euo pipefail` (or equivalent) near the top
- Scripts must validate input before processing
- Scripts must provide meaningful error messages
- Scripts must exit with appropriate codes:
  - 0 for success
  - 1 for general errors
  - 2 for usage/argument errors
- No silent failures

**Implementation Details**:
- Use `die()` function for fatal errors
- Use `error()` for non-fatal issues
- Use `require_command()` to validate dependencies
- Wrap dangerous operations in error traps

### R5: Documentation

**Requirement**: Repository must have comprehensive documentation for users and developers.

**Documentation Files**:
- **README.md**: Quick start, usage patterns, project overview
- **CONTRIBUTING.md**: Developer guide, contribution process, code standards
- **STATE_MANAGEMENT.md**: State pattern implementation guide
- **HCURL.md**: hcurl script reference
- **QUICKREF.md**: Command quick reference
- **LICENSE**: MIT license (or specified license)
- **agents.md**: This file (requirements and specifications)

**Inline Documentation**:
- All scripts must have a comment header describing purpose and usage
- All functions must have descriptive comments
- Complex logic must be commented
- Environment variables must be documented

**Quality Standards**:
- Documentation must be accurate and up-to-date
- Examples must be tested and working
- All features must be documented

### R6: Version Control

**Requirement**: Repository must be Git-ready and follow version control best practices.

**Specifications**:
- `.gitignore` file must exclude:
  - IDE directories (`.vscode/`, `.idea/`)
  - Temporary files (`.tmp`, `*.log`, `tmp/`)
  - Build artifacts
  - Environment files (`.venv/`, `node_modules/`)
- Clean commit history
- Meaningful commit messages
- No sensitive information in commits

**Implementation Details**:
- `.gitignore` at repository root
- Use semantic versioning when creating releases
- Tag releases in Git

### R7: Code Quality Standards

**Requirement**: All code must meet consistent quality standards.

**Specifications**:
- Shell scripts must be valid and executable
- Scripts must be tested before commit
- Scripts must have appropriate error handling
- No hardcoded paths (use `$TOOLKIT_ROOT` instead)
- Use descriptive variable and function names

**Naming Conventions**:
- Variables: lowercase with underscores (`my_var`)
- Constants: UPPERCASE (`MY_CONSTANT`)
- Functions: lowercase with underscores (`my_function`)
- Scripts: lowercase with hyphens (`my-script`)

**Security Considerations**:
- Scripts must validate all input
- Scripts must not run arbitrary code from untrusted sources
- Scripts must not require elevated privileges unless documented
- No credentials or secrets in code

### R8: Portability

**Requirement**: Toolkit must work across different Linux distributions and Unix systems.

**Specifications**:
- Must work on Debian/Ubuntu
- Must work on RHEL/CentOS
- Must work on Alpine Linux
- Must work on macOS when possible
- Must use POSIX-compatible shell syntax when possible
- Must gracefully handle missing optional commands

**Implementation Details**:
- Use `command_exists()` before using external commands
- Provide fallbacks for unavailable tools
- Document system requirements
- Test on multiple systems before release

### R9: Demo and Testing

**Requirement**: Repository must provide a way to quickly test and demonstrate functionality.

**Specifications**:
- `demo.sh` script to showcase toolkit features
- Demo must:
  - Source init.sh
  - Run all example scripts
  - Display toolkit information
  - Verify PATH configuration
  - Provide next steps for users
- Demo must be safe to run multiple times
- Demo must provide clear output

**Testing Standards**:
- All scripts must be manually tested before commit
- Test from different directories
- Test with different shell configurations
- Test error conditions

### R10: Extensibility

**Requirement**: The toolkit must be designed for easy expansion with new scripts.

**Specifications**:
- Adding new scripts must be simple:
  1. Create script in `bin/`
  2. Make executable
  3. Add to repository
- Scripts must not interfere with each other
- Scripts must be able to call other scripts
- Scripts must be able to use library functions
- No build or compilation step required

**Implementation Details**:
- Provide script templates in CONTRIBUTING.md
- Document library usage clearly
- Example scripts demonstrate best practices
- Clear naming conventions

## Non-Functional Requirements

### NFR1: Performance

- Initialization (sourcing `init.sh`) must complete in < 100ms
- Each script must execute its primary function promptly
- PATH modification must not impact existing command resolution significantly

### NFR2: Maintainability

- Code must be easy to understand and modify
- Functions should be single-purpose
- Documentation should be kept up-to-date
- Changes should be backward compatible when possible

### NFR3: Reliability

- Scripts must work consistently across multiple runs
- No random failures or race conditions
- Clear error messages for troubleshooting
- Predictable behavior in edge cases

### NFR4: Usability

- Installation should be one command: `git clone` + `source init.sh`
- Scripts should have intuitive names
- Help information should be available
- Error messages should guide users to solutions

## Acceptance Criteria

A toolkit installation is considered successful when:

- [ ] `source init.sh` executes without errors
- [ ] `$TOOLKIT_ROOT` is set correctly
- [ ] `$PATH` includes `$TOOLKIT_ROOT/bin`
- [ ] All scripts in `bin/` are executable
- [ ] At least two example scripts are present and functional
- [ ] Common library functions are accessible to scripts
- [ ] `demo.sh` runs successfully
- [ ] Documentation is complete and accurate

## Agent Validation Checklist

Before informing the user that changes are ready to commit, verify:

- ✅ All code changes are syntactically valid
- ✅ Scripts run without errors
- ✅ Tested from different directories
- ✅ Error handling works correctly
- ✅ Documentation is accurate and linked properly
- ✅ No hardcoded paths (uses $TOOLKIT_ROOT)
- ✅ Code follows style guidelines
- ✅ Comments explain complex logic
- ✅ No breaking changes to existing functionality
- ✅ Changes align with R1-R10 requirements

## Future Enhancements

Potential future features to consider:

- **Package Manager Integration**: Install toolkit via apt, homebrew, etc.
- **Auto-Update**: Mechanism to update scripts from repository
- **Script Marketplace**: Central location to discover and install community scripts
- **Configuration File**: Optional config for script customization
- **Hook System**: Pre/post execution hooks for scripts
- **Logging Framework**: Optional centralized logging
- **Script Dependencies**: Auto-detect and validate script dependencies
- **Interactive Installer**: GUI or TUI setup wizard

## Maintenance Guidelines

### Regular Tasks

- [ ] Test on latest Bash and Zsh versions quarterly
- [ ] Review and update documentation semi-annually
- [ ] Test scripts on latest Linux distributions
- [ ] Check for security vulnerabilities
- [ ] Review open issues and pull requests

### Release Process

1. Update version in documentation
2. Run full test suite
3. Update CHANGELOG
4. Create Git tag
5. Push to repository
6. Create release notes

### Issue Triage

- Bugs: Must document reproduction steps
- Features: Must follow R10 (extensibility) guidelines
- Documentation: Must maintain accuracy and clarity

---

**Document Version**: 1.0  
**Last Updated**: November 10, 2025  
**Status**: Active
