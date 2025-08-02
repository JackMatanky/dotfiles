#!/usr/bin/env just --justfile
# Chezmoi dotfiles repository utilities

# Show available commands
default:
    @just --list

# Apply all configurations with verbose output
apply:
    chezmoi apply -v

# Preview changes before applying
diff:
    chezmoi diff

# Add a new file to chezmoi management
add FILE:
    chezmoi add "{{ FILE }}"

# Edit a file managed by chezmoi
edit FILE:
    chezmoi edit "{{ FILE }}"

# Update from source repository
update:
    chezmoi update

# Re-run all scripts (useful after changes)
re-run-scripts:
    chezmoi state delete-bucket --bucket=scriptState
    chezmoi apply -v

# Execute template to see output
execute-template FILE:
    chezmoi execute-template < "{{ FILE }}"

# Validate chezmoi data and templates
validate:
    chezmoi data

# Status of managed files
status:
    chezmoi status

# Show chezmoi data variables
show-data:
    chezmoi data

# Format all shell scripts with shfmt
format-shell:
    find . -name "*.sh" -exec shfmt -w {} \;

# Run shellcheck on all shell scripts
lint-shell:
    find . -name "*.sh" -exec shellcheck {} \;

# Clean up chezmoi state and re-apply
clean-apply:
    chezmoi state reset
    chezmoi apply -v
