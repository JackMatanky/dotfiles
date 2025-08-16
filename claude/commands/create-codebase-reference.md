# .claude/create-codebase-reference

This command creates a comprehensive codebase reference index optimized for Claude Code to understand your project architecture, locate relevant files, and make informed decisions without scanning the entire codebase on every run.

## Usage

```bash
claude < .claude/create-codebase-reference
```

## Purpose

**Primary Goal**: Create a structured reference that enables Claude Code to:

- Quickly understand the codebase architecture and organization
- Locate specific functionality without exhaustive file searching
- Make informed decisions about where to implement changes
- Understand dependencies and relationships between components
- Follow established patterns and conventions consistently

**Key Difference**: This is not documentation for humans—it's a technical reference optimized for AI consumption and rapid decision-making.

## File Management

**Output Location**: `docs/codebase_ref/codebase_reference.md`

**Before Starting**: I will check if `docs/codebase_ref/codebase_reference.md` already exists and assess whether it needs updating based on:

- Recent changes to project structure or architecture
- New major components, services, or directories added
- Updates to core abstractions, patterns, or conventions
- Changes to build configuration, dependencies, or tooling
- Modifications to entry points or main execution flows

**Update Decision Process**:

1. **If file doesn't exist**: Create new comprehensive reference
2. **If file exists**:
   - Read existing file and analyze timestamp/metadata
   - Check recent commits for architectural changes
   - Compare current structure patterns with documented patterns
   - Ask whether you want to:
     - **Update**: Refresh specific sections while preserving structure
     - **Append**: Add new sections for new components/patterns
     - **Regenerate**: Create completely fresh file
     - **Skip**: Keep existing file unchanged

## What This Command Creates

A comprehensive `codebase_reference.md` file with the following structure:

### Section 1: Architecture Overview & Entry Points

- **Project structure summary** - High-level organization and architectural patterns
- **Entry points identification** - Main execution files, CLI interfaces, web app initialization
- **Core abstractions** - Base classes, protocols, and key interfaces

### Section 2: Quick Reference Tables & Task Patterns

- **Component lookup tables** - Rapid navigation to functionality by domain
- **Common task patterns** - Where to implement specific types of changes
- **Architecture boundaries** - Layer responsibilities and dependencies

### Section 3: Component Classification & Dependencies

- **File catalog with line references** - Key files with specific line number guidance
- **Configuration and infrastructure** - Environment, deployment, and tooling setup
- **Integration points** - How components connect and communicate

### Section 4: Implementation Patterns with Examples

- **Code patterns** - Actual examples from the codebase with file references
- **Naming conventions** - Established patterns for consistency
- **Common workflows** - Step-by-step guidance for typical development tasks

### Section 5: Maintenance & Integration Guidelines

- **Change detection strategies** - How to identify when reference needs updating
- **Quality standards** - Criteria for high-value vs low-value information
- **Claude Code integration** - Usage patterns and context loading strategies

## Interactive Process

When you run this command, I will:

1. Guide you through capturing the complete directory structure with technical metadata
2. Identify the **decision-critical information** Claude Code needs most frequently
3. Ask clarifying questions about:
   - **Entry points and core workflows** that Claude Code should understand first
   - **Architectural boundaries** and where different types of changes belong
   - **Critical dependencies** and integration points between components
   - **Coding patterns and conventions** that should be consistently followed
   - **Common modification scenarios** and where they typically occur
4. Create a reference optimized for rapid lookup and architectural understanding
5. Structure the output for easy integration into future Claude Code sessions

## Input Requirements

Before running this command, prepare:

1. **Target directory path** and access to run structure commands
2. **Primary use cases** for Claude Code (feature development, debugging, refactoring)
3. **Architectural decision records** or conventions documentation (if available)

## Process

I'll create an AI-optimized codebase reference through:

1. **Phase 0: Complete Structure Mapping** - Capture full hierarchy with metadata
2. **Phase 1: Architectural Intelligence** - Identify patterns, boundaries, and decision points
3. **Phase 2: Component Classification** - Categorize by function, not just structure
4. **Phase 3: Decision-Critical Documentation** - Focus on information Claude Code needs for rapid decision-making
5. **Phase 4: Reference Optimization** - Structure for maximum lookup efficiency

## Technical Implementation Guide

### Phase 0: Systematic File Discovery

```bash
# === STRUCTURE ANALYSIS ===
# Check existing file and recent architectural changes
ls -la docs/codebase_ref/codebase_reference.md
git log --oneline -20 --name-only | rg "(src|lib|app|core|api|service)"

# Capture complete structure with metadata
eza --tree --level=12 --long --git --icons -I "__pycache__|*.pyc|.pytest_cache|node_modules|.venv" > codebase_structure.txt

# Identify key file types for categorization using fd and ripgrep
fd -e py . src/ | head -20  # Core source files
fd -e toml -e yaml -e json | rg "(pyproject|setup|config)"  # Config files
fd -g "*test*" -g "*spec*" | head -10  # Test files
fd -g "main.py" -g "app.py" -g "__main__.py"  # Entry points

# === PATTERN DETECTION ===
# Find key patterns and imports using ripgrep
rg "class.*Service" --type py -n | head -10  # Service classes with line numbers
rg "class.*Model" --type py -n | head -10   # Data model classes
rg "from.*import|import.*" --type py -l | head -15  # Files with imports (dependency mapping)
rg "@app\.|@router\." --type py -n | head -10  # API endpoints with line numbers
rg "def test_" --type py -n | head -10  # Test functions with line numbers
```

**File Classification Strategy:**

- **Entry Points**: Main execution files, app initializers, CLI interfaces
- **Core Logic**: Business logic, domain models, services (detected via class patterns)
- **Integration**: APIs, database, external service interfaces (detected via decorators)
- **Configuration**: Settings, environment, build configs (by file extension and naming)
- **Testing**: Test files, fixtures, test utilities (by naming patterns and test functions)
- **Infrastructure**: Deployment, CI/CD, development tools

### Phase 1: Architectural Intelligence Extraction

Focus on extracting architectural patterns using ripgrep for fast code analysis:

```bash
# Dependency flow analysis
rg "from\s+\w+\.\w+" --type py -n | head -20  # Import patterns with line numbers
rg "import\s+\w+\.\w+" --type py -n | head -20  # Module dependencies

# Entry point identification
rg "if __name__ == ['\"]__main__['\"]" --type py -l  # Script entry points
rg "@app\.|@router\.|app\s*=" --type py -n  # Web app initialization
rg "def main\(|async def main\(" --type py -n  # Main functions

# Core abstractions discovery
rg "class.*\(.*Base.*\)" --type py -n | head -15  # Classes inheriting from base classes
rg "class.*Protocol|@protocol" --type py -n  # Interface definitions
rg "@dataclass|class.*\(.*Model.*\)" --type py -n | head -15  # Data structures

# Configuration patterns
rg "os\.getenv|getenv|environ" --type py -n | head -10  # Environment variable usage
rg "config\.|settings\.|Config\(" --type py -n | head -10  # Configuration objects

# Error handling approaches
rg "raise\s+\w+Error|except\s+\w+Error" --type py -n | head -15  # Exception patterns
rg "logger\.|logging\.|log\." --type py -n | head -10  # Logging patterns
```

### Phase 2: Functional Component Mapping

```markdown
# Template for component classification

## Core Components

- **[Component]**: Primary responsibility, key files, integration points
- **[Component]**: Primary responsibility, key files, integration points

## Integration Points

- **[Interface/API]**: Purpose, location, key methods/endpoints
- **[Interface/API]**: Purpose, location, key methods/endpoints

## Common Modification Patterns

- **[Change Type]**: Typical files affected, related components to check
- **[Change Type]**: Typical files affected, related components to check
```

## Commands Used

```bash
# === STRUCTURE ANALYSIS ===
# Check existing file and recent architectural changes
ls -la docs/codebase_ref/codebase_reference.md
git log --oneline -20 --name-only | rg "(src|lib|app|core|api|service)"

# Capture complete structure with metadata
eza --tree --level=12 --long --git --icons -I "__pycache__|*.pyc|.pytest_cache|node_modules|.venv" > codebase_structure.txt

# File type categorization
fd -e py . src/ | head -20  # Core source files
fd -e toml -e yaml -e json | rg "(pyproject|setup|config)"  # Config files
fd -g "*test*" -g "*spec*" | head -10  # Test files
fd -g "main.py" -g "app.py" -g "__main__.py"  # Entry points

# === PATTERN DETECTION ===
# Key patterns and class discovery
rg "class.*Service" --type py -n | head -10  # Service classes with line numbers
rg "class.*Model" --type py -n | head -10   # Data model classes
rg "from.*import|import.*" --type py -l | head -15  # Files with imports (dependency mapping)
rg "@app\.|@router\." --type py -n | head -10  # API endpoints with line numbers
rg "def test_" --type py -n | head -10  # Test functions with line numbers

# Architectural pattern analysis
rg "from\s+\w+\.\w+" --type py -n | head -20  # Import patterns with line numbers
rg "import\s+\w+\.\w+" --type py -n | head -20  # Module dependencies
rg "if __name__ == ['\"]__main__['\"]" --type py -l  # Script entry points
rg "@app\.|@router\.|app\s*=" --type py -n  # Web app initialization
rg "def main\(|async def main\(" --type py -n  # Main functions

# Core abstractions and patterns
rg "class.*\(.*Base.*\)" --type py -n | head -15  # Classes inheriting from base classes
rg "class.*Protocol|@protocol" --type py -n  # Interface definitions
rg "@dataclass|class.*\(.*Model.*\)" --type py -n | head -15  # Data structures

# Configuration and environment
rg "os\.getenv|getenv|environ" --type py -n | head -10  # Environment variable usage
rg "config\.|settings\.|Config\(" --type py -n | head -10  # Configuration objects

# Error handling and logging
rg "raise\s+\w+Error|except\s+\w+Error" --type py -n | head -15  # Exception patterns
rg "logger\.|logging\.|log\." --type py -n | head -10  # Logging patterns

# === CHANGE DETECTION ===
# Generate structure hash for comparison
eza --tree --level=10 -I "__pycache__|*.pyc|.venv" | shasum -a 256

# Quick architectural pattern check (for validating reference accuracy)
rg "class.*Service|class.*Model|@app\.|def main" --type py -c  # Count key patterns
fd -e py | wc -l  # Total Python files count

# Detect new entry points or major changes
fd -g "main.py" -g "app.py" -g "__main__.py" -x ls -la  # Entry point file details
rg "if __name__ == ['\"]__main__['\"]" --type py --files-with-matches  # All script entry points
```

## Output Format

**Primary Deliverable**: `docs/codebase_ref/codebase_reference.md` - A timestamped, version-controlled reference optimized for Claude Code.

**File Header Format:**

```markdown
<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
<!-- Codebase: [PROJECT_NAME] -->
<!-- Structure Hash: [eza output hash for change detection] -->
<!-- Pattern Count: [class.*Service|Model|@app count for architectural change detection] -->
<!-- File Count: [total Python files for scale detection] -->
```

### Section 1: Quick Reference Tables

```markdown
# Codebase Reference Index

<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->

## Entry Points & Core Files

| Function         | File                 | Key Components                                       |
| ---------------- | -------------------- | ---------------------------------------------------- |
| Main Application | `src/main.py`        | App initialization (L15-30), config loading (L45-60) |
| API Server       | `src/api/app.py`     | FastAPI app (L20), route registration (L35-50)       |
| CLI Interface    | `src/cli/main.py`    | Command parsing (L25), subcommands (L40-80)          |
| Core Models      | `src/models/base.py` | BaseModel (L15), validation (L30-45)                 |

## Common Task Patterns

| Task              | Primary Files                      | Related Files                      | Pattern Example                           |
| ----------------- | ---------------------------------- | ---------------------------------- | ----------------------------------------- |
| Add API Endpoint  | `src/api/routes/[domain].py`       | `src/models/`, `src/schemas/`      | See `src/api/routes/users.py` L25-40      |
| Add Data Model    | `src/models/[entity].py`           | `src/migrations/`, `src/schemas/`  | Follow `src/models/user.py` pattern       |
| Add Service Logic | `src/services/[domain]_service.py` | `src/models/`, `src/repositories/` | See `src/services/user_service.py` L15-30 |

## Architecture Boundaries

| Layer          | Directory           | Key Interfaces                         | Dependencies         |
| -------------- | ------------------- | -------------------------------------- | -------------------- |
| Domain         | `src/models/`       | BaseModel, Entity protocols            | None (pure domain)   |
| Services       | `src/services/`     | Service protocols in `src/interfaces/` | models, repositories |
| API            | `src/api/`          | FastAPI routers                        | services, schemas    |
| Infrastructure | `src/repositories/` | Repository protocols                   | models, database     |
```

### Section 2: File Catalog with Line References

```markdown
## Core Source Files

**Domain Models** - `src/models/base.py` (BaseModel L15-45), `src/models/user.py` (User entity L20-60)
**Service Layer** - `src/services/base.py` (BaseService L10-30), `src/services/user_service.py` (CRUD operations L25-80)
**API Routes** - `src/api/routes/users.py` (CRUD endpoints L15-90), error handling pattern L95-110
**Database** - `src/repositories/base.py` (Repository pattern L20-50), `src/database/session.py` (connection setup L15-35)

## Configuration & Infrastructure

**Environment** - `.env.example` (all variables), `src/config/settings.py` (Pydantic settings L15-60)
**Database** - `src/database/migrations/` (Alembic), `src/database/models.py` (SQLAlchemy setup L10-25)
**Testing** - `tests/conftest.py` (fixtures L15-40), `tests/utils.py` (test helpers L20-50)
**Deployment** - `docker-compose.yml` (services), `Dockerfile` (build steps L15-30)
```

### Section 3: Implementation Patterns

````markdown
## Code Patterns with Examples

**Service Pattern** - From `src/services/user_service.py` L25-40:

```python
class UserService(BaseService[User]):
    def __init__(self, repository: UserRepository):
        super().__init__(repository)

    async def create_user(self, data: UserCreate) -> User:
        # Pattern: validate → transform → persist → return
```
````

**API Route Pattern** - From `src/api/routes/users.py` L30-45:

```python
@router.post("/", response_model=UserResponse)
async def create_user(
    user_data: UserCreate,
    service: UserService = Depends(get_user_service)
) -> UserResponse:
    # Pattern: inject service → call service → handle errors
```

````

## Examples

### Example 1: FastAPI + SQLAlchemy Project Reference

**Claude Code Scenario**: "Add user authentication endpoint"

**Reference Enables**:
```markdown
## Quick Decision Path
1. **API Endpoint**: Add to `api/routes/auth.py` (follows pattern in existing routes)
2. **Business Logic**: Create in `services/auth_service.py` (matches user_service.py pattern)
3. **Data Models**: Extend `core/models/user.py` (User model already exists)
4. **Dependencies**: Will need `core/schemas/auth.py` for request/response models
5. **Tests**: Add to `tests/api/test_auth.py` and `tests/services/test_auth_service.py`

## Related Files to Review
- `api/routes/user.py` — Similar endpoint patterns
- `services/user_service.py` — Service layer patterns
- `core/models/user.py` — User model for auth integration
- `core/schemas/user.py` — Schema patterns to follow
````

### Example 2: React Component Library Reference

**Claude Code Scenario**: "Add new UI component with styling"

**Reference Enables**:

```markdown
## Component Creation Pattern

1. **Component File**: `src/components/[Category]/ComponentName.tsx`
2. **Styling**: `src/components/[Category]/ComponentName.module.css`
3. **Types**: Export from `src/types/components.ts`
4. **Stories**: `src/stories/ComponentName.stories.tsx`
5. **Tests**: `src/components/[Category]/__tests__/ComponentName.test.tsx`

## Integration Requirements

- Export from `src/components/index.ts`
- Follow prop patterns in `src/types/components.ts`
- Use design tokens from `src/styles/tokens.css`
```

## Evaluation Criteria

A successful codebase reference should enable Claude Code to:

1. **Instant File Location**: Find specific functionality in <5 seconds using file references
2. **Pattern Replication**: Copy established patterns using concrete code examples
3. **Architecture Compliance**: Follow project boundaries using reference tables
4. **Change Impact**: Understand modification scope using dependency mappings
5. **Token Efficiency**: Consume minimal context while providing maximum actionable information

## Reference Quality Standards

### High-Value Content (Include)

- **Concrete file paths** with line numbers for key functions
- **Actual code patterns** extracted from the codebase
- **Entry points and main flows** with specific file references
- **Architectural boundaries** with enforcement examples
- **Common task patterns** with step-by-step file locations
- **Configuration patterns** with actual file examples

### Low-Value Content (Minimize)

- Abstract architectural explanations without file references
- Generic code examples not from your codebase
- Historical context or decision rationale
- Detailed implementation explanations (Claude Code can read the files)
- Redundant information available in file docstrings

## Maintenance Strategy

**Change Detection using fd and ripgrep:**

```bash
# Generate structure hash for comparison
eza --tree --level=10 -I "__pycache__|*.pyc|.venv" | shasum -a 256

# Quick architectural pattern check (for validating reference accuracy)
rg "class.*Service|class.*Model|@app\.|def main" --type py -c  # Count key patterns
fd -e py | wc -l  # Total Python files count

# Detect new entry points or major changes
fd -g "main.py" -g "app.py" -g "__main__.py" -x ls -la  # Entry point file details
rg "if __name__ == ['\"]__main__['\"]" --type py --files-with-matches  # All script entry points
```

**Update Triggers:**

- **Structure changes**: New top-level directories (detected via eza hash change)
- **Pattern changes**: New architectural patterns (detected via ripgrep pattern counts)
- **Entry point changes**: New main files or CLI modifications (detected via fd search)
- **Dependency changes**: New major imports or frameworks (detected via ripgrep import analysis)

**Partial Update Process:**

```bash
# Re-run targeted discovery for specific areas
fd -t d . src/ | head -10  # New directories
rg "^class\s+\w+.*:" --type py -n src/newmodule/  # New classes in specific module
fd -e py -x rg -l "^def\s+test_" {}  # Files with new tests
```

## Claude Code Integration

### Recommended Usage Pattern

1. **Create reference once** using this workflow
2. **Include in Claude Code context** for all sessions working on this codebase
3. **Update reference** when major architectural changes occur
4. **Version reference** alongside codebase changes

### Context Prompt Integration

```markdown
You are working with a codebase that follows these architectural patterns:
[Include Architecture Summary section]

For common tasks, refer to this lookup table:
[Include Component Lookup table]

When making changes, consider these architectural boundaries:
[Include key decision points]
```

## Related Resources

- **fd documentation**: https://github.com/sharkdp/fd - Fast file finding
- **ripgrep documentation**: https://github.com/BurntSushi/ripgrep - Fast text search
- **eza documentation**: https://eza.rocks/ - Modern ls replacement with tree view
- **Alternative commands**:
  ```bash
  # If fd/rg not available, fallback to find/grep
  find . -name "*.py" | head -20
  grep -r "class.*Service" --include="*.py" src/ | head -10
  ```
- **Useful fd/rg patterns for different languages**:

  ```bash
  # JavaScript/TypeScript projects
  fd -e js -e ts | rg "export.*class|export.*function" -n
  rg "import.*from|require\(" --type js --type ts -n

  # Go projects
  fd -e go | rg "func.*main|type.*struct" -n
  rg "import\s*\(" --type go -n

  # Rust projects
  fd -e rs | rg "fn main|struct.*{|impl.*{" -n
  rg "use\s+\w+" --type rust -n
  ```
