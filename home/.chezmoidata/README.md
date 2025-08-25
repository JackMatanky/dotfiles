# `.chezmoidata` - Static Configuration Data

This directory contains static configuration data that is merged into the root of chezmoi's data dictionary. These files provide centralized configuration that doesn't change based on the system environment, following chezmoi best practices for declarative configuration management.

## 📁 File Structure

```
.chezmoidata/
├── README.md              # This documentation
├── applications.toml       # Static application configurations
├── defaults.json          # Default tool settings and preferences
├── packages.toml          # Package declarations (Brewfile-based)
├── paths.toml             # Directory structures and path mappings
└── repositories.toml      # Repository URLs and external resources
```

## 📋 Configuration Files

### `applications.toml`
**Purpose:** Static information about tools, applications, and their configurations

**Contains:**
- **Terminal configs:** Ghostty, Warp, Alacritty settings
- **Editor configs:** Neovim, Zed, VS Code configuration paths
- **Shell configs:** Zsh, Bash, Nushell file locations
- **Development tools:** Git, Docker, Kubernetes settings
- **Package managers:** Homebrew, Cargo, NPM configurations

**Example usage in templates:**
```bash
# Access terminal config
CONFIG_DIR="{{ .terminals.ghostty.config_dir }}"

# Get editor settings
EDITOR_CONFIG="{{ .editors.nvim.config_dir }}"
```

### `defaults.json`
**Purpose:** Default settings and preferences for various tools

**Contains:**
- **Shell defaults:** History size, completion settings
- **Editor defaults:** Tab size, auto-save, word wrap
- **Git defaults:** Default branch, pull strategy
- **Terminal defaults:** Scrollback, opacity, cursor settings
- **Package manager defaults:** Auto-update preferences

**Example usage in templates:**
```json
"tab_size": {{ .editor.tab_size }},
"history_size": {{ .shell.history_size }}
```

### `packages.toml`
**Purpose:** Declarative package list based exactly on `~/dotfiles/Brewfile`

**Contains:**
- **macOS packages:** Taps, brews, casks, MAS apps, VS Code extensions
- **Linux packages:** Flatpak, APT, and Snap equivalents
- **Cross-platform:** Minimal Cargo, NPM, Python packages

**Architecture:**
- **Brewfile as source of truth** - All macOS packages mirror the Brewfile
- **Linux equivalents** - Mapped from macOS packages where possible
- **Minimal cross-platform** - Only essential tools not available via system package managers

### `paths.toml`
**Purpose:** Standard directory structures and path mappings

**Contains:**
- **XDG directories:** Config, data, cache, state paths
- **Common directories:** Scripts, dotfiles, backup locations  
- **Development directories:** Projects, repositories, workspace
- **Config subdirectories:** Shell, editor, terminal, git, fonts
- **File type classifications:** Config, scripts, docs, data extensions

**Example usage in templates:**
```bash
CONFIG_HOME="{{ .xdg_dirs.config_home }}"
SCRIPTS_DIR="{{ .common_config_dirs.scripts }}"
```

### `repositories.toml`
**Purpose:** Repository URLs, documentation links, and API endpoints

**Contains:**
- **Personal repositories:** Dotfiles, Obsidian vault URLs
- **Documentation URLs:** Tool documentation, package registries
- **API endpoints:** GitHub, GitLab API base URLs (without secrets)

**Example usage in templates:**
```bash
DOTFILES_REPO="{{ .repositories.dotfiles.github }}"
DOCS_URL="{{ .urls.documentation.chezmoi }}"
```

## 🎯 Benefits of This Architecture

### **Static Data Separation**
- Configuration that doesn't change based on system environment
- Reduces template complexity by centralizing common data
- Follows chezmoi best practices for data organization

### **Template Simplification**
- Clean data references: `{{ .terminals.ghostty.name }}`
- No need to hardcode paths or URLs in templates
- Consistent data structure across all configurations

### **Maintainability**
- Single location to update URLs, paths, or default settings
- Easy to see all configuration data in one place
- Version controlled alongside template changes

### **Format Standards**
- **TOML preferred** for most configuration (human-readable)
- **JSON for complex nested data** (defaults.json)
- **No YAML files** (per project preferences)

## 🔧 Usage in Templates

Data from these files is automatically merged into the template data dictionary:

```go
# Direct access to any configuration
{{ .applications.editors.nvim.config_dir }}
{{ .defaults.git.default_branch }}
{{ .paths.xdg_dirs.config_home }}
{{ .repositories.dotfiles.github }}
```

## 📝 File Format Rules

1. **TOML preferred** - Use for most static configuration
2. **JSON for complex data** - When nested objects are needed
3. **No YAML** - Avoid per project standards
4. **No templates** - Files must be pure data (no `{{ }}` syntax)

## 🔗 Related

- [chezmoi data documentation](https://www.chezmoi.io/reference/special-directories/chezmoidata/)
- Templates using this data: `home/.chezmoiscripts/`
- Package management: `packages.toml`
