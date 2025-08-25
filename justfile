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

# Package Management (Manual)
# =============================

# Update all packages (macOS)
update-packages-macos:
    #!/usr/bin/env bash
    echo "📦 Updating macOS packages..."
    brew update && brew upgrade
    brew cleanup --prune=all
    mas upgrade
    
# Update all packages (Linux)
update-packages-linux:
    #!/usr/bin/env bash
    echo "📦 Updating Linux packages..."
    sudo apt update && sudo apt upgrade -y
    flatpak update -y
    sudo snap refresh
    
# Update cross-platform packages
update-packages-common:
    #!/usr/bin/env bash
    echo "📦 Updating cross-platform packages..."
    # Rust packages
    if command -v cargo-install-update &> /dev/null; then
        cargo install-update --all
    else
        echo "Install cargo-update with: cargo install cargo-update"
    fi
    # NPM packages
    if command -v npm &> /dev/null; then
        npm update -g
    fi
    # Python packages  
    if command -v pip3 &> /dev/null; then
        pip3 list --user --outdated | tail -n +3 | awk '{print $1}' | xargs -r pip3 install --user --upgrade
    fi

# Update all packages for current OS
update-packages:
    #!/usr/bin/env bash
    case "$(uname -s)" in
        Darwin)
            just update-packages-macos
            ;;
        Linux)
            just update-packages-linux
            ;;
    esac
    just update-packages-common
