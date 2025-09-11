# `dot_config/` - Application Configuration Files

This directory contains configuration files for various applications and tools, following the XDG Base Directory specification. When applied by chezmoi, these files are placed in `~/.config/` and provide customized settings for development tools, editors, and system utilities.

## 📁 Directory Structure

```
dot_config/
├── README.md              # This documentation
├── git/                   # Git version control configuration
├── zed/                   # Zed editor configuration
├── nvim/                  # Neovim editor configuration
├── starship/              # Starship shell prompt configuration
├── zsh/                   # Zsh shell configuration
├── tmux/                  # Tmux terminal multiplexer configuration
├── alacritty/            # Alacritty terminal emulator configuration
└── ...                   # Additional application configurations
```

## 🛠️ Application Categories

### **Editors & IDEs**

#### **Zed Editor (`zed/`)**
**Modern code editor with focus on performance and collaboration**

**Key files:**
- `settings.json` - Core editor settings and preferences
- `keymap.json` - Custom keyboard shortcuts
- `tasks.json` - Task automation and build configurations
- `debug.json` - Debug configuration for various languages

**Features configured:**
- **Theme**: Catppuccin theme for consistent visual experience
- **Language support**: Enhanced support for Rust, Python, JavaScript, etc.
- **Extensions**: AI assistance, Git integration, language servers
- **Collaboration**: Real-time collaboration settings
- **Performance**: Optimized for large codebases

#### **Neovim (`nvim/`)**
**Vim-based modal editor with modern Lua configuration**

**Configuration approach:**
- **Lua-based**: Modern Lua configuration instead of VimScript
- **Plugin manager**: Lazy.nvim for efficient plugin loading
- **LSP integration**: Full Language Server Protocol support
- **Tree-sitter**: Advanced syntax highlighting and code understanding
- **Modular structure**: Organized in logical modules

**Key areas:**
- **Core settings**: Editor behavior, UI, keymaps
- **Plugin ecosystem**: Carefully curated plugin selection
- **Language support**: Comprehensive language server configurations
- **Development workflow**: Git integration, debugging, testing

### **Shell & Terminal**

#### **Zsh Configuration (`zsh/`)**
**Z shell configuration with modern enhancements**

**Features:**
- **Completion system**: Advanced command completion
- **History management**: Intelligent history search and sharing
- **Plugin integration**: Oh My Zsh and custom plugin support
- **Environment variables**: Development environment setup
- **Aliases**: Productivity-focused command aliases

#### **Starship Prompt (`starship/`)**
**Fast, customizable shell prompt**

**Configuration highlights:**
- **Git integration**: Comprehensive Git status display
- **Language detection**: Automatic detection of project languages
- **Performance**: Fast prompt rendering
- **Customization**: Tailored symbols and colors
- **Cross-platform**: Consistent appearance across systems

#### **Tmux (`tmux/`)**
**Terminal multiplexer for session management**

**Features configured:**
- **Session management**: Persistent terminal sessions
- **Window/pane management**: Efficient workspace organization
- **Key bindings**: Vim-inspired navigation
- **Status bar**: Informative status line with system info
- **Plugin system**: TPM (Tmux Plugin Manager) integration

### **Development Tools**

#### **Git Configuration (`git/`)**
**Version control system configuration**

**Key configurations:**
- **User identity**: Global user name and email
- **Aliases**: Productivity shortcuts for common Git operations
- **Merge tools**: Integration with preferred merge/diff tools
- **Signing**: GPG signing configuration for commits
- **Hooks**: Global Git hooks for consistency

**Enhanced features:**
- **Delta pager**: Beautiful diff viewing with syntax highlighting
- **Conventional commits**: Support for conventional commit format
- **Credential management**: Secure credential storage
- **Large file support**: Git LFS configuration

### **Terminal Emulators**

#### **Alacritty (`alacritty/`)**
**GPU-accelerated terminal emulator**

**Configuration areas:**
- **Performance**: GPU acceleration settings
- **Appearance**: Font, colors, transparency
- **Key bindings**: Custom keyboard shortcuts
- **Shell integration**: Optimal shell compatibility
- **Cross-platform**: Consistent behavior across platforms

## 🎨 Theming & Consistency

### **Catppuccin Theme**
**Consistent theme across all applications**

**Applications themed:**
- **Editors**: Zed, Neovim, VS Code
- **Terminal**: Alacritty, tmux, shell prompts
- **Development tools**: Git diff, bat, fzf
- **System tools**: Various CLI utilities

**Benefits:**
- **Visual consistency**: Same color palette across tools
- **Eye strain reduction**: Carefully crafted colors for readability
- **Professional appearance**: Clean, modern aesthetic
- **Accessibility**: Good contrast ratios for visibility

### **Font Configuration**
**Nerd Fonts for enhanced terminal experience**

**Fonts used:**
- **JetBrains Mono Nerd Font**: Primary programming font
- **Fira Code Nerd Font**: Alternative with ligatures
- **Hack Nerd Font**: Compact option for smaller screens

**Features:**
- **Programming ligatures**: Enhanced code readability
- **Icon support**: Rich icon set for file types and Git status
- **Unicode support**: Comprehensive character coverage
- **Consistent metrics**: Uniform spacing and sizing

## 🔧 Configuration Management

### **Template Integration**
Many configuration files use chezmoi templating:

```json
{
  "user.name": "{{ .name }}",
  "user.email": "{{ .email }}",
  "core.editor": "{{ .preferences.editor }}"
}
```

### **Platform Adaptation**
Configurations adapt to different platforms:

```toml
{{- if eq .chezmoi.os "darwin" }}
font_size = 14.0
{{- else }}
font_size = 12.0
{{- end }}
```

### **Data-Driven Configuration**
Leverages `.chezmoidata/` for consistent settings:

```yaml
theme: "{{ .theme.colorscheme }}"
font_family: "{{ .defaults.editor.font_family }}"
```

## 📋 Application-Specific Features

### **Language Server Protocol (LSP)**
**Comprehensive language support across editors**

**Languages configured:**
- **Rust**: rust-analyzer with full feature set
- **Python**: Basedpyright/Pylsp with type checking
- **JavaScript/TypeScript**: TypeScript language server
- **Go**: gopls with comprehensive Go support
- **Lua**: lua-language-server for Neovim configuration
- **Markdown**: marksman for documentation editing

### **Development Workflow Integration**
**Seamless integration with development tools**

**Features:**
- **Git workflow**: Enhanced Git integration in all editors
- **Task runners**: Integration with Just, Make, npm scripts
- **Debugging**: Debug configurations for multiple languages
- **Testing**: Test runner integration and coverage display
- **Linting**: Comprehensive linting and formatting setup

### **Productivity Enhancements**
**Tools and configurations for enhanced productivity**

**Features:**
- **Fuzzy finding**: FZF integration across applications
- **Quick navigation**: Efficient file and symbol navigation
- **Snippet management**: Code snippet systems
- **Project management**: Project-specific configurations
- **Session management**: Workspace and session persistence

## 🛡️ Security & Privacy

### **Credential Management**
**Secure handling of sensitive information**

**Approaches:**
- **Git credentials**: Secure credential storage
- **API keys**: Environment variable based key management
- **SSH keys**: Proper SSH key configuration
- **GPG integration**: Commit signing and encryption support

### **Private Files**
**Sensitive configurations are marked private**

**Private file patterns:**
- `private_*` - Files containing sensitive data
- `encrypted_*` - Encrypted files (if using age/GPG)
- `.gitignore` patterns for local-only files

## 🔄 Synchronization & Backup

### **Cross-Device Sync**
**Consistent configuration across multiple devices**

**Benefits:**
- **chezmoi management**: Version-controlled configurations
- **Selective application**: Choose which configs to apply
- **Machine-specific**: Adapt to different machine capabilities
- **Conflict resolution**: Handle configuration conflicts gracefully

### **Backup Strategy**
**Protection against configuration loss**

**Approaches:**
- **Version control**: Full history of configuration changes
- **Branching**: Machine-specific branches when needed
- **Export capabilities**: Easy export of specific configurations
- **Recovery procedures**: Well-defined recovery processes

## 🔍 Troubleshooting

### **Common Issues**
**Solutions for typical configuration problems**

**Application not reading config:**
- Check file placement in `~/.config/`
- Verify file permissions and ownership
- Validate configuration file syntax

**Template rendering issues:**
- Test template syntax with `chezmoi execute-template`
- Check data availability with `chezmoi data`
- Verify template context and variables

**Performance issues:**
- Review plugin/extension configurations
- Check for conflicting settings
- Profile application startup times

### **Debugging Tools**
**Tools for configuration debugging**

**chezmoi commands:**
```bash
chezmoi apply --dry-run     # Preview changes
chezmoi diff               # See configuration differences
chezmoi doctor            # Check chezmoi health
chezmoi execute-template  # Test template rendering
```

**Application-specific debugging:**
```bash
zed --version             # Check Zed version and plugins
nvim --startuptime       # Profile Neovim startup
tmux info                # Display tmux information
git config --list       # Show all Git configuration
```

## 🔗 Related Documentation

### **Application Documentation**
- **Zed**: https://zed.dev/docs
- **Neovim**: https://neovim.io/doc/
- **Starship**: https://starship.rs/
- **Tmux**: https://github.com/tmux/tmux/wiki
- **Alacritty**: https://github.com/alacritty/alacritty

### **chezmoi Integration**
- **Templating**: `home/.chezmoitemplates/README.md`
- **Data sources**: `home/.chezmoidata/README.md`
- **Package management**: `home/.chezmoiscripts/README.md`

## 📝 Customization Guide

### **Adding New Applications**
1. Create application directory in `dot_config/`
2. Add configuration files (may use `.tmpl` extension)
3. Use chezmoi templating for dynamic content
4. Test configuration on target platforms
5. Document application-specific features

### **Modifying Existing Configs**
1. Edit configuration files in chezmoi source
2. Use `chezmoi apply --dry-run` to preview changes
3. Apply changes with `chezmoi apply`
4. Test functionality with target applications
5. Commit changes to version control

### **Theme Customization**
1. Update theme data in `.chezmoidata/defaults.json`
2. Modify application-specific theme files
3. Ensure consistency across all applications
4. Test theme in different lighting conditions
5. Update documentation as needed
