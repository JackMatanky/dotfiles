# `.chezmoitemplates` - Shared Template Library

This directory contains reusable templates that can be included in any chezmoi template file. These templates provide common functionality, reduce code duplication, and ensure consistency across all configuration files.

## 📁 Directory Structure

```
.chezmoitemplates/
├── README.md              # This documentation
├── logging.sh              # Shared logging functions for scripts
└── espanso/               # Espanso text expansion templates
    ├── espanso_match_*.yml # Various text expansion rules
    └── ...                # Additional espanso configurations
```

## 🛠️ Core Templates

### `logging.sh`
**Purpose:** Shared logging functions for package management scripts

**Features:**
- **Colored output**: Different colors for different log levels
- **Consistent formatting**: Standardized log message format
- **Multiple log levels**: Info, success, warning, error, header

**Functions provided:**
```bash
log_info()     # Blue [INFO] messages
log_success()  # Green [SUCCESS] messages  
log_warning()  # Yellow [WARNING] messages
log_error()    # Red [ERROR] messages
log_header()   # Purple headers with decorative lines
```

**Usage in scripts:**
```bash
{{ template "logging.sh" . }}

log_header "🍺 HOMEBREW PACKAGES"
log_info "Installing packages..."
log_success "✅ Installation completed!"
log_warning "Some packages may need manual configuration"
log_error "Failed to install package"
```

**Benefits:**
- **Consistency**: All scripts use the same logging format
- **Maintenance**: Update logging behavior in one place
- **Readability**: Clear, colored output for better user experience
- **Standards**: Follows shell scripting best practices

## 📝 Espanso Templates (`espanso/`)

**Purpose:** Text expansion rules and configurations for the Espanso text expander

**Contains:**
- **Autocorrect rules**: Common spelling corrections
- **Date/time expansions**: Quick date and time insertion
- **Address expansions**: Personal address information
- **Symbol expansions**: Mathematical symbols, Greek letters
- **Superscript/subscript**: Scientific notation helpers
- **Custom abbreviations**: Personal shortcuts and expansions

**File patterns:**
```
espanso_match_*.yml  # Various expansion rule categories
```

**Examples of expansions:**
```yaml
# Date expansions
":date" → "2025-01-25"
":time" → "14:30:25"

# Address expansions  
":addr" → "Your full address"

# Symbol expansions
":alpha" → "α"
":beta" → "β"
":sum" → "∑"

# Autocorrect
"teh" → "the"
"recieve" → "receive"
```

## 🔧 Template Usage

### **Including Templates**
Templates are included using the `{{ template "name" . }}` syntax:

```go
{{/* Include logging functions */}}
{{ template "logging.sh" . }}

{{/* Now use the functions */}}
log_info "Starting process..."
```

### **Template Context**
The `.` at the end of template inclusion passes the current context (all data) to the included template.

### **Template Naming**
- **No prefix needed**: Files in `.chezmoitemplates/` are automatically available
- **Use descriptive names**: `logging.sh`, `utility-functions.sh`, etc.
- **Organize by purpose**: Group related templates in subdirectories

## 🎯 Benefits

### **Code Reuse**
- **DRY principle**: Don't Repeat Yourself across multiple scripts
- **Shared functionality**: Common operations defined once
- **Consistency**: Same behavior across all templates

### **Maintainability** 
- **Single source**: Update shared code in one place
- **Testing**: Test shared functions independently
- **Documentation**: Central location for shared functionality

### **Organization**
- **Clean separation**: Shared code separate from specific templates
- **Modular design**: Include only what you need
- **Logical grouping**: Related functions grouped together

## 📋 Template Development Guidelines

### **Creating New Templates**

1. **Identify common patterns** across multiple files
2. **Create template file** in `.chezmoitemplates/`
3. **Use clear naming** that describes the template's purpose
4. **Document parameters** and usage in comments
5. **Test thoroughly** across different scenarios

### **Template Best Practices**

- **Make templates pure**: No side effects, return/output only
- **Use parameters**: Accept data through template context
- **Add error handling**: Check for required parameters
- **Document usage**: Add comments explaining how to use
- **Keep focused**: One template per logical function

### **Example Template Structure**
```bash
{{/* 
Template: utility-functions.sh
Purpose: Common utility functions for shell scripts
Usage: {{ template "utility-functions.sh" . }}
*/}}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Get OS type
get_os() {
    echo "{{ .chezmoi.os }}"
}
```

## 🔗 Usage Examples

### **In Package Management Scripts**
```bash
#!/usr/bin/env bash
{{ template "logging.sh" . }}

log_header "Installing Packages"
# ... installation logic ...
log_success "Installation complete!"
```

### **In Configuration Files**
```yaml
# Using espanso templates for text expansion
matches:
  - trigger: ":addr"
    replace: "{{ .personal.address }}"
```

### **Custom Templates**
```bash
{{/* Custom template for common paths */}}
{{ define "common-paths" }}
CONFIG_DIR="{{ .chezmoi.homeDir }}/.config"
DATA_DIR="{{ .chezmoi.homeDir }}/.local/share"
{{ end }}

{{/* Usage in other templates */}}
{{ template "common-paths" }}
```

## 🔍 Template Debugging

### **Test Template Rendering**
```bash
# Test a template file
chezmoi execute-template < .chezmoitemplates/logging.sh

# Test template inclusion
chezmoi execute-template --init < some-script.tmpl
```

### **View Available Data**
```bash
# See all available template data
chezmoi data

# Test data access in templates
chezmoi execute-template '{{ .chezmoi.os }}'
```

## 📚 Related Documentation

- **chezmoi templates**: https://www.chezmoi.io/user-guide/templating/
- **Go template syntax**: https://pkg.go.dev/text/template
- **Template functions**: https://www.chezmoi.io/reference/templates/functions/
- **Script templates**: `home/.chezmoiscripts/README.md`

## 🎨 Espanso Configuration

The espanso templates provide text expansion capabilities:

- **Installation**: Espanso must be installed via package manager
- **Configuration**: Templates generate espanso match files
- **Customization**: Edit templates to add personal expansions
- **Categories**: Organized by expansion type (dates, symbols, corrections)

## 🔧 Maintenance

### **Adding New Shared Functions**
1. Identify repeated code across templates
2. Create new template in `.chezmoitemplates/`
3. Update existing templates to use shared function
4. Test all affected templates

### **Updating Existing Templates**
1. Make changes to template file
2. Test all templates that include it
3. Update documentation if interface changes
4. Commit changes with clear description
