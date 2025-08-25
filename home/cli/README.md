# `cli/` - Command-Line Automation Tools

This directory contains command-line automation tools, task runners, and installation scripts that provide a unified interface for common development and system management tasks.

## 📁 Directory Structure

```
cli/
├── README.md              # This documentation  
├── justfile.tmpl          # Task automation with Just
└── scripts/               # Standalone installation scripts
    ├── executable_setup.sh.tmpl       # Enhanced system setup script
    ├── install-homebrew.sh            # Homebrew installation
    ├── install-just.sh                 # Just task runner installation  
    ├── install-rust.sh                 # Rust toolchain installation
    └── ...                            # Additional utility scripts
```

## 🛠️ Core Components

### `justfile.tmpl`
**Purpose:** Cross-platform task automation using the [Just](https://just.systems/) command runner

**Features:**
- **Platform detection**: Automatically adapts to macOS/Linux
- **Package management**: Unified commands for different package managers
- **Development workflows**: Common development tasks automated
- **Homebrew integration**: Seamless integration with Homebrew commands

**Key commands provided:**
```bash
just --list              # Show all available commands
just install-all         # Complete system setup
just update-all          # Update all package managers
just setup-dev           # Setup development environment
just clean-dev           # Clean development caches
just apply-dotfiles      # Apply chezmoi configurations
```

**Architecture:**
- **Template-based**: Uses chezmoi templating for cross-platform compatibility
- **Data-driven**: Leverages `.chezmoidata/` for configuration
- **Modular**: Separate tasks for different package managers
- **Error handling**: Robust error handling and user feedback

### `scripts/` Directory

**Purpose:** Standalone installation and setup scripts for specific tools

#### `executable_setup.sh.tmpl`
**Advanced system setup script with full chezmoi templating**

**Features:**
- **Multi-platform**: Supports macOS and Linux
- **Dependency detection**: Automatically installs required dependencies
- **Package manager integration**: Works with Homebrew, Flatpak, APT
- **User preferences**: Adapts to user's preferred tools and settings
- **Repository cloning**: Can clone dotfiles and other repositories

**Capabilities:**
- Install system dependencies (Xcode tools, build essentials)
- Setup and configure Homebrew
- Install packages from Brewfile
- Configure shell environment
- Setup development tools

#### `install-homebrew.sh`
**Standalone Homebrew installation script**

**Features:**
- **Cross-platform**: Works on both macOS and Linux
- **Architecture detection**: Handles ARM64 vs Intel differences
- **Path configuration**: Sets up proper shell integration
- **Idempotent**: Safe to run multiple times

#### `install-just.sh` 
**Just task runner installation script**

**Features:**
- **Multi-method installation**: Tries multiple installation methods
- **Fallback support**: Falls back to alternative methods if needed
- **Verification**: Verifies successful installation

#### `install-rust.sh`
**Rust toolchain installation script**

**Features:**
- **Official installer**: Uses rustup official installation method
- **Toolchain management**: Installs stable Rust toolchain
- **Environment setup**: Configures shell environment for Rust

## 🎯 Use Cases

### **System Bootstrap**
```bash
# Quick system setup
./scripts/setup.sh

# Or using Just
just install-all
```

### **Package Management**
```bash
# Update all packages
just update-all

# Install specific package manager packages
just brew-install
just cargo-install
just flatpak-install  # Linux only
```

### **Development Environment**
```bash
# Setup development tools
just setup-dev

# Clean development caches
just clean-dev
```

### **Dotfiles Management**
```bash
# Apply dotfiles configurations
just apply-dotfiles

# Edit dotfiles
just edit-dotfiles
```

## 🔧 Configuration Integration

### **chezmoi Data Integration**
The `justfile.tmpl` leverages data from `.chezmoidata/`:

```bash
# Uses repositories.toml
DOTFILES_REPO="{{ .repositories.dotfiles.github }}"

# Uses platform data
HOMEBREW_PREFIX="{{ .platform.homebrew_prefix }}"

# Uses preferences
EDITOR="{{ .preferences.editor }}"
```

### **Platform Detection**
Automatic adaptation to different platforms:

```bash
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific commands
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific commands  
{{- end }}
```

### **Package Manager Integration**
Unified interface for different package managers:

```bash
# macOS: Uses Homebrew
just brew-install

# Linux: Uses multiple managers in priority order
just flatpak-install  # GUI apps
just apt-install      # CLI tools  
just snap-install     # Fallback packages
```

## 📋 Available Just Tasks

### **Main Commands**
- `just` or `just --list` - Show all available commands
- `just install-all` - Complete system setup with all packages
- `just update-all` - Update all package managers

### **Package Management**
- `just install-homebrew` - Install Homebrew if not present
- `just brew-install` - Install packages from Brewfile
- `just brew-update` - Update Homebrew and packages
- `just brew-cleanup` - Clean up Homebrew caches

### **Language-Specific**
- `just install-rust` - Install Rust if not present  
- `just cargo-install` - Install Cargo packages
- `just cargo-update` - Update Cargo packages

### **Development**
- `just setup-dev` - Setup development environment
- `just clean-dev` - Clean development caches and temporary files

### **System Management**
- `just apply-dotfiles` - Apply chezmoi configurations
- `just edit-dotfiles` - Edit chezmoi configurations with apply
- `just check-deps` - Check system dependencies
- `just backup` - Backup important configurations (planned)

## 🛡️ Error Handling

### **Graceful Degradation**
- Commands check for required tools before proceeding
- Missing package managers are handled gracefully
- Clear error messages guide users on next steps

### **User Guidance**
```bash
# Example error handling
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Install with:"
    echo "just install-homebrew"
    exit 1
fi
```

### **Logging and Feedback**
- Consistent output formatting using shared colors
- Progress indicators for long-running operations
- Summary information after completion

## 📊 Platform Support

### **macOS**
- **Primary**: Homebrew-based package management
- **Architecture**: ARM64 (Apple Silicon) and Intel support
- **Integration**: Seamless integration with macOS-specific tools

### **Linux**  
- **Package managers**: APT, Flatpak, Snap support
- **Distributions**: Debian/Ubuntu focus, with Arch/Fedora support
- **Homebrew**: Linux Homebrew support for consistency

### **Cross-Platform**
- **Language tools**: Rust, Node.js, Python, Go support
- **Consistent commands**: Same commands work across platforms
- **Adaptive behavior**: Platform-specific optimizations

## 🔍 Debugging and Troubleshooting

### **Verbose Output**
```bash
just --verbose install-all  # Show command execution
```

### **Dry Run Testing**
```bash
# Test justfile template rendering
chezmoi execute-template < justfile.tmpl

# Check for syntax errors
just --dry-run install-all
```

### **Manual Script Execution**
```bash
# Run scripts directly for debugging
./scripts/install-homebrew.sh
./scripts/setup.sh
```

## 🔗 Integration Points

### **With chezmoi Scripts**
- Scripts complement the modular `.chezmoiscripts/` system
- Can be used for manual system setup or recovery
- Provides alternative interface to package management

### **With Package Management**
- Works alongside automated package installation scripts
- Can trigger chezmoi apply for configuration updates
- Integrates with package lists in `.chezmoidata/packages.toml`

### **With Development Workflow**
- Streamlines common development tasks
- Integrates with version control workflows
- Supports project bootstrapping and environment setup

## 🎨 Customization

### **Adding New Tasks**
1. Edit `justfile.tmpl` to add new task
2. Use template syntax for cross-platform compatibility
3. Test on target platforms
4. Update documentation

### **Custom Scripts**
1. Add new script to `scripts/` directory
2. Make executable with proper shebang
3. Use consistent error handling patterns
4. Integration with Just tasks if needed

## 📚 Related

- **Just documentation**: https://just.systems/
- **Package management**: `home/.chezmoiscripts/README.md`
- **Static configuration**: `home/.chezmoidata/README.md`
- **Template system**: `home/.chezmoitemplates/README.md`
