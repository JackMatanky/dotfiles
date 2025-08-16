# Claude Command: Commit

This command helps you create well-formatted commits with conventional commit messages and emoji, supporting both Python and Node.js projects with optimized support for Python projects using ruff and uv.

## Usage

To create a commit, just type:
```
/commit
```

Or with options:
```
/commit --no-verify
/commit --force-split
/commit --force-long
```

## What This Command Does

1. **Detects project type** by checking for project files (pyproject.toml, package.json, requirements.txt, etc.)
2. Unless specified with `--no-verify`, automatically runs pre-commit checks based on project type:
   
   **For Python projects (optimized for ruff + uv):**
   - `ruff check .` for linting (modern, fast linter)
   - `ruff format --check .` for code formatting verification
   - `uv run pytest --collect-only` to verify tests can be discovered
   - `uv run mypy .` for type checking (if mypy is configured)
   - Custom scripts defined in pyproject.toml or Makefile
   - **Fallbacks**: `flake8`, `black --check`, `python -m pytest --collect-only` if ruff/uv not available
   
   **For Node.js projects:**
   - `pnpm lint` or `npm run lint` or `yarn lint` to ensure code quality
   - `pnpm build` or `npm run build` or `yarn build` to verify the build succeeds
   - `pnpm generate:docs` or `npm run generate:docs` to update documentation
   
   **For projects with both:**
   - Runs checks for both ecosystems
   
   **Universal checks:**
   - `pre-commit run --all-files` if .pre-commit-config.yaml exists
   - `npx husky run pre-commit` if .husky directory exists

3. Checks which files are staged with `git status`
4. If 0 files are staged, automatically adds all modified and new files with `git add`
5. Performs a `git diff` to understand what changes are being committed
6. **Analyzes commit complexity** using intelligent decision tree to determine message format
7. If multiple distinct changes are detected, suggests breaking the commit into multiple smaller commits
8. For each commit (or the single commit if not split), creates a commit message using emoji conventional commit format

## Commit Message Decision Tree

The command uses intelligent analysis to determine appropriate commit message format:

### **Short Message Criteria** (Single line: `emoji type: description`)
- ≤3 related files changed
- Single logical change (atomic)
- Self-explanatory from diff
- No breaking changes
- Standard operations (common patterns)

### **Long Message Criteria** (Multi-line with detailed body)
- >3 files or multiple concerns
- Complex business logic or algorithms
- Breaking changes or deprecations
- Performance/security implications
- Non-atomic but necessary changes
- Dependencies between changes
- Closes multiple issues

### **Split Commit Recommendations**
When changes mix:
- Different types (feat + fix + docs + refactor)
- Different domains (auth + payments + UI + infrastructure)
- Independent functionality that could be reviewed separately
- Some changes are experimental while others are production-ready
- Different team members responsible for different parts

## Project Type Detection

The command automatically detects your project type by checking for these files:

**Python Project Indicators (prioritized for ruff + uv):**
- `pyproject.toml` with ruff configuration
- `uv.lock` file
- `requirements.txt`
- `requirements-dev.txt`
- `setup.py`
- `setup.cfg`
- `Pipfile`
- `poetry.lock`
- `.python-version`

**Node.js Project Indicators:**
- `package.json`
- `pnpm-lock.yaml`
- `yarn.lock`
- `package-lock.json`
- `node_modules/`

**Mixed Projects:**
- When both Python and Node.js indicators are present, runs checks for both ecosystems

## Pre-commit Checks by Project Type

### Python Projects (Optimized for ruff + uv)

**Primary toolchain (preferred):**
```bash
ruff check .                    # Fast, comprehensive linting
ruff format --check .           # Code formatting verification
uv run pytest --collect-only   # Test discovery verification
```

**Optional checks (if configured):**
```bash
uv run mypy .                   # Type checking (if mypy.ini exists)
uv run pre-commit run --all-files  # If .pre-commit-config.yaml exists
```

**Fallback tools (if ruff/uv not available):**
```bash
flake8                         # Traditional linter
black --check .                # Code formatting
python -m pytest --collect-only  # Test discovery
pylint src/                    # Comprehensive linting
```

**Custom Commands:**
```bash
# From pyproject.toml [tool.scripts] or Makefile:
make lint                      # If Makefile with lint target exists
make test                      # If Makefile with test target exists
python -m scripts.check        # Custom check scripts
```

### Node.js Projects

**Package Manager Detection:**
```bash
# Priority order - uses first available:
pnpm lint && pnpm build && pnpm generate:docs     # If pnpm-lock.yaml exists
npm run lint && npm run build && npm run generate:docs    # If package-lock.json exists  
yarn lint && yarn build && yarn generate:docs     # If yarn.lock exists
```

### Universal Checks

**Git Hooks:**
```bash
# If .pre-commit-config.yaml exists:
pre-commit run --all-files

# If .husky directory exists:
npx husky run pre-commit
```

## Best Practices for Commits

- **Verify before committing**: Ensure code is linted, builds correctly, and documentation is updated
- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Split large changes**: If changes touch multiple concerns, split them into separate commits
- **Conventional commit format**: Use the format `<type>: <description>` where type is one of:
  - `feat`: A new feature
  - `fix`: A bug fix
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc)
  - `refactor`: Code changes that neither fix bugs nor add features
  - `perf`: Performance improvements
  - `test`: Adding or fixing tests
  - `chore`: Changes to the build process, tools, etc.
- **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")
- **Concise first line**: Keep the first line under 72 characters
- **Emoji**: Each commit type is paired with an appropriate emoji:
  - ✨ `feat`: New feature
  - 🐛 `fix`: Bug fix
  - 📝 `docs`: Documentation
  - 💄 `style`: Formatting/style
  - ♻️ `refactor`: Code refactoring
  - ⚡️ `perf`: Performance improvements
  - ✅ `test`: Tests
  - 🔧 `chore`: Tooling, configuration
  - 🚀 `ci`: CI/CD improvements
  - 🗑️ `revert`: Reverting changes
  - 🧪 `test`: Add a failing test
  - 🚨 `fix`: Fix compiler/linter warnings
  - 🔒️ `fix`: Fix security issues
  - 👥 `chore`: Add or update contributors
  - 🚚 `refactor`: Move or rename resources
  - 🏗️ `refactor`: Make architectural changes
  - 🔀 `chore`: Merge branches
  - 📦️ `chore`: Add or update compiled files or packages
  - ➕ `chore`: Add a dependency
  - ➖ `chore`: Remove a dependency
  - 🌱 `chore`: Add or update seed files
  - 🧑‍💻 `chore`: Improve developer experience
  - 🧵 `feat`: Add or update code related to multithreading or concurrency
  - 🔍️ `feat`: Improve SEO
  - 🏷️ `feat`: Add or update types
  - 💬 `feat`: Add or update text and literals
  - 🌐 `feat`: Internationalization and localization
  - 👔 `feat`: Add or update business logic
  - 📱 `feat`: Work on responsive design
  - 🚸 `feat`: Improve user experience / usability
  - 🩹 `fix`: Simple fix for a non-critical issue
  - 🥅 `fix`: Catch errors
  - 👽️ `fix`: Update code due to external API changes
  - 🔥 `fix`: Remove code or files
  - 🎨 `style`: Improve structure/format of the code
  - 🚑️ `fix`: Critical hotfix
  - 🎉 `chore`: Begin a project
  - 🔖 `chore`: Release/Version tags
  - 🚧 `wip`: Work in progress
  - 💚 `fix`: Fix CI build
  - 📌 `chore`: Pin dependencies to specific versions
  - 👷 `ci`: Add or update CI build system
  - 📈 `feat`: Add or update analytics or tracking code
  - ✏️ `fix`: Fix typos
  - ⏪️ `revert`: Revert changes
  - 📄 `chore`: Add or update license
  - 💥 `feat`: Introduce breaking changes
  - 🍱 `assets`: Add or update assets
  - ♿️ `feat`: Improve accessibility
  - 💡 `docs`: Add or update comments in source code
  - 🗃️ `db`: Perform database related changes
  - 🔊 `feat`: Add or update logs
  - 🔇 `fix`: Remove logs
  - 🤡 `test`: Mock things
  - 🥚 `feat`: Add or update an easter egg
  - 🙈 `chore`: Add or update .gitignore file
  - 📸 `test`: Add or update snapshots
  - ⚗️ `experiment`: Perform experiments
  - 🚩 `feat`: Add, update, or remove feature flags
  - 💫 `ui`: Add or update animations and transitions
  - ⚰️ `refactor`: Remove dead code
  - 🦺 `feat`: Add or update code related to validation
  - ✈️ `feat`: Improve offline support

## Guidelines for Splitting Commits

When analyzing the diff, consider splitting commits based on these criteria:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Changes to different types of files (e.g., source code vs documentation vs configuration)
4. **Language ecosystems**: Changes to Python code vs Node.js code vs infrastructure
5. **Logical grouping**: Changes that would be easier to understand or review separately
6. **Size**: Very large changes that would be clearer if broken down
7. **Risk levels**: Critical fixes vs optional improvements
8. **Team responsibility**: Different team members responsible for different parts

## Commit Message Examples

### Short Messages (Atomic Changes)
```
✨ feat: add user authentication endpoint
🐛 fix: resolve memory leak in data processing  
📝 docs: update API documentation for v2 endpoints
🎨 style: format code with ruff
🔧 chore: update dependencies in pyproject.toml
🚨 fix: resolve ruff linting warnings in user service
🏷️ feat: add type hints to user service methods
🗃️ db: add migration for user preferences table
⚡️ perf: optimize database queries with eager loading
🔒️ fix: strengthen password hashing with bcrypt
```

### Long Messages (Complex Changes)
```
✨ feat: implement user preference management system

- Add UserPreference model with Pydantic validation
- Create preference API endpoints (GET, POST, PUT, DELETE)
- Implement Redis caching layer for frequently accessed preferences
- Add comprehensive test coverage for preference operations
- Update user dashboard to display personalized settings

This allows users to customize their experience and improves
performance by caching preference data. The caching layer
reduces database queries by ~60% for preference lookups.

Closes #123, #145
```

### Non-Atomic Commits (When Splitting Isn't Possible)
```
🔄 refactor: modernize authentication system

This commit includes several interconnected changes:

- Migrate from session-based to JWT authentication
- Update all API endpoints to use new auth middleware  
- Modify frontend to handle JWT tokens
- Update database schema for user sessions
- Add backward compatibility for existing sessions

These changes are interdependent and cannot be split without
breaking functionality. The refactor improves security and
reduces server memory usage.

BREAKING CHANGE: Session-based auth deprecated in favor of JWT
```

### Mixed Ecosystem Example
```
🚀 feat: implement full-stack user dashboard

Backend changes:
- Add FastAPI endpoints for dashboard data (Python)
- Implement caching with Redis for performance
- Add comprehensive API tests with pytest

Frontend changes:
- Create React dashboard components (TypeScript)
- Add real-time updates with WebSocket connection
- Implement responsive design with Tailwind CSS

Infrastructure:
- Update Docker configuration for new services
- Add environment variables for dashboard features
- Update CI/CD pipeline for full-stack deployment

This feature provides users with a real-time view of their
account activity and system status. The caching layer improves
response times by 70% for dashboard data.
```

## Examples of Splitting Commits

Good commit splitting for Python projects:
- First commit: ✨ feat: add new Pydantic model for user preferences
- Second commit: 📝 docs: update API documentation for preferences endpoint
- Third commit: 🔧 chore: update pyproject.toml dependencies
- Fourth commit: 🏷️ feat: add type hints for new preference service
- Fifth commit: 🧵 feat: add async support for preference operations
- Sixth commit: 🚨 fix: resolve ruff linting issues in new code
- Seventh commit: ✅ test: add pytest tests for preference service
- Eighth commit: 🔒️ fix: update dependencies with security vulnerabilities

Mixed ecosystem splitting:
- First commit: ✨ feat: add Python FastAPI backend endpoints
- Second commit: ✨ feat: add React frontend components
- Third commit: 🔧 chore: update Python dependencies in pyproject.toml
- Fourth commit: 🔧 chore: update Node.js dependencies in package.json
- Fifth commit: 📝 docs: update README with full-stack setup instructions

## Command Options

- `--no-verify`: Skip running the pre-commit checks (lint, build, generate:docs, type checking, etc.)
- `--force-split`: Always analyze for potential commit splits, even for simple changes
- `--force-long`: Use detailed commit message format regardless of complexity analysis

## Important Notes

- **Project detection**: Automatically detects Python, Node.js, or mixed projects
- **Tool optimization**: Prioritizes ruff + uv for Python projects, with graceful fallbacks
- **Graceful fallbacks**: If primary tools aren't available, falls back to alternatives
- **Mixed projects**: For full-stack projects, runs checks for both ecosystems
- **Failure handling**: If pre-commit checks fail, asks whether to proceed or fix issues first
- **Smart staging**: If specific files are staged, commits only those; otherwise stages all changes
- **Intelligent analysis**: Reviews diff content to suggest appropriate commit splits
- **Context-aware messages**: Generates commit messages based on actual changes detected
- **Cross-platform**: Works on Windows, macOS, and Linux with appropriate tool detection

## Configuration Files Recognized

**Python:**
- `pyproject.toml` - Modern Python project configuration
- `setup.cfg` - Legacy Python configuration
- `.flake8` - Flake8 linter configuration
- `mypy.ini` - MyPy type checker configuration
- `pytest.ini` - Pytest configuration
- `tox.ini` - Tox testing configuration
- `Makefile` - Build automation

**Node.js:**
- `package.json` - Node.js project configuration
- `.eslintrc.*` - ESLint configuration
- `.prettierrc.*` - Prettier configuration
- `tsconfig.json` - TypeScript configuration

**Git Hooks:**
- `.pre-commit-config.yaml` - Pre-commit framework
- `.husky/` - Husky git hooks
- `.githooks/` - Custom git hooks

## Integration with Git Workflow Manager

This command is designed to work seamlessly with automated git workflow management:

- **Automatic invocation**: Can be called by git workflow agents after code changes
- **Quality enforcement**: Ensures all commits meet coding standards before acceptance
- **Intelligent formatting**: Automatically chooses appropriate commit message style based on change analysis
- **Error handling**: Provides clear feedback when pre-commit checks fail with recovery options
- **Workflow integration**: Supports both automated agent-driven and manual developer-initiated git operations
- **Context preservation**: Maintains development context while ensuring commit quality and consistency