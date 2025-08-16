# .claude/create-dev-patterns

Generate a comprehensive development patterns reference covering coding standards, git workflow, and local development setup.

## Usage

```bash
claude < .claude/create-dev-patterns
```

## File Management

**Output Location**: `docs/codebase_ref/dev_patterns.md`

**Before Starting**: I will check if `docs/codebase_ref/dev_patterns.md` already exists and assess whether it needs updating based on:
- Recent commits that changed development tooling (package.json, pyproject.toml, etc.)
- Changes to CI/CD configuration files
- New or modified linting/formatting configuration
- Updates to development scripts or Makefiles

**Update Decision Process**:
1. **If file doesn't exist**: Create new comprehensive reference
2. **If file exists**: 
   - Read existing file and analyze timestamp/metadata
   - Check recent commits for development tooling changes
   - Compare current tool versions with documented versions
   - Ask whether you want to:
     - **Update**: Refresh specific sections while preserving structure
     - **Append**: Add new sections for new tools/patterns
     - **Regenerate**: Create completely fresh file
     - **Skip**: Keep existing file unchanged

## What This Command Creates

A `dev_patterns.md` file with:

### Section 1: Code Style Standards
- **Naming Conventions** - Actual examples from codebase with file references
- **Function/Class Patterns** - Common implementation patterns with line numbers
- **Import Organization** - How imports are structured across the project
- **Documentation Patterns** - Docstring examples and comment conventions
- **Type Hints** - Typing patterns used consistently in the codebase

### Section 2: Git Workflow
- **Branch Naming** - Conventions extracted from recent branch names
- **Commit Patterns** - Message format analysis from git history
- **PR Requirements** - Templates and review processes
- **Release Process** - Tagging and versioning patterns

### Section 3: Local Development Setup
- **Environment Setup** - Dependencies, virtual environments, tool versions
- **Development Commands** - Common tasks from Makefile, scripts, package.json
- **IDE Configuration** - Linting, formatting, and editor setup patterns
- **Debugging Approaches** - Common debugging patterns and tools used

### Section 4: Performance & Security Patterns
- **Optimization Patterns** - Caching, async/await, resource management examples
- **Security Practices** - Input validation, authentication patterns, secret management
- **Error Handling** - Exception patterns and logging conventions
- **Testing Integration** - How development practices integrate with testing

## Process

I'll analyze your codebase to extract development patterns by:

1. **File Existence Check** - Assess if update is needed
2. **Tool Configuration Analysis** - Examine config files for development setup
3. **Code Pattern Extraction** - Use ripgrep to find consistent patterns
4. **Git History Analysis** - Extract workflow conventions from commit/branch history
5. **Documentation Generation** - Create reference with concrete examples and file locations

## Commands Used

```bash
# Check existing file status and recent development changes
ls -la docs/codebase_ref/dev_patterns.md
git log --oneline -20 --name-only | rg "(pyproject|package\.json|Makefile|\.pre-commit|\.github)"

# Extract code style patterns
rg "class \w+|def \w+|async def \w+" --type py -A 2 -B 1 | head -20
rg "from \w+|import \w+" --type py -n | head -20
rg "\"\"\".*\"\"\"|'''.*'''" --type py -A 3 -B 1 | head -15
rg "# TODO|# FIXME|# NOTE|# HACK" --type py -n

# Development environment analysis
fd -g "requirements*.txt" -g "pyproject.toml" -g "Pipfile" -g "poetry.lock"
fd -g "package.json" -g "yarn.lock" -g "npm-shrinkwrap.json"
fd -g "Makefile" -g "justfile" -g "Taskfile*"
fd -g ".env*" -g "docker-compose*" -g "Dockerfile*"

# Configuration files for tools
fd -g ".pre-commit*" -g ".black" -g ".flake8" -g "pyproject.toml" -x head -10 {}
fd -g ".eslintrc*" -g ".prettierrc*" -g "tsconfig.json" -x head -10 {}

# Git workflow analysis
git log --oneline -50 | rg "feat|fix|refactor|docs|chore|test"
git branch -r | head -20
git log --pretty=format:"%s" -20

# Performance and security patterns
rg "cache|Cache|@lru_cache|@cached" --type py -n -A 2
rg "async def|await |asyncio\." --type py -n | head -15
rg "logging|logger|log\." --type py -n | head -15
rg "raise \w+Error|except \w+Error|try:" --type py -n | head -15
rg "os\.getenv|getenv|environ|settings\." --type py -n | head -10
```

## Output Format

The generated `dev_patterns.md` will include:

```markdown
<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
<!-- Tool Versions: Python X.Y, Node X.Y, etc. -->
<!-- Config Files: pyproject.toml, package.json, Makefile -->

# Development Patterns Reference

## Code Style Standards

### Naming Conventions
**Classes** - `src/models/user.py` L15: `class UserModel(BaseModel)`
**Functions** - `src/services/auth.py` L25: `async def authenticate_user()`
**Variables** - `src/config/settings.py` L10: `database_url: str`

### Import Organization  
Pattern from `src/api/routes/users.py` L1-10:
```python
# Standard library
import asyncio
from typing import List, Optional

# Third party
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

# Local imports
from src.models import User
from src.services import UserService
```

## Git Workflow

### Branch Naming
- **Features**: `feature/user-authentication`, `feat/add-caching`
- **Fixes**: `fix/login-validation`, `bugfix/memory-leak`
- **Refactoring**: `refactor/service-layer`, `cleanup/remove-deprecated`

### Commit Messages
Pattern analysis from recent commits:
- `feat: add user authentication endpoint`
- `fix: resolve memory leak in data processing`
- `refactor: extract service layer patterns`
- `docs: update API documentation`

[Additional sections...]
```

## Evaluation Criteria

A successful dev patterns reference should:

1. **Reflect Actual Practices**: All examples come from real codebase analysis
2. **Be Immediately Actionable**: New developers can follow patterns with specific file references
3. **Stay Current**: Captures current tool versions and recent workflow changes
4. **Guide Consistency**: Helps maintain established patterns across the team
5. **Integrate with Tools**: References actual configuration files and setup scripts

## Maintenance Strategy

**Update Triggers**:
- New development tools added (detected via config file changes)
- Significant changes to coding standards or workflow
- Major version updates to primary tools/frameworks
- Changes to CI/CD pipeline or development scripts

**Quick Staleness Check**:
```bash
# Check if major development files have changed recently
git log --since="30 days ago" --name-only | rg "(pyproject|Makefile|\.pre-commit|package\.json)" | wc -l
```