# Unified Git Workflow Integration

This document outlines how the `/commit` command integrates with the git-workflow-manager agent to create a seamless, intelligent version control workflow optimized for Python development with ruff and uv.

## System Architecture

```
Development Work Completed
         ↓
Git Workflow Manager Agent (Detects Changes)
         ↓
Automatic Quality Checks & Commit Decision
         ↓
┌─────────────────┬─────────────────┬─────────────────┐
│   Standard      │     Complex     │    Custom       │
│   Changes       │    Changes      │   Operations    │
│                 │                 │                 │
│ /commit         │ /commit         │ Manual Git      │
│ (automatic)     │ (with analysis) │ Commands        │
└─────────────────┴─────────────────┴─────────────────┘
         ↓                ↓                ↓
   Short Message    Long Message     Custom Logic
         ↓                ↓                ↓
    Quality Gate    Quality Gate    Quality Gate
         ↓                ↓                ↓
      Commit          Commit          Commit
```

## Workflow Decision Matrix

| Scenario              | Detection                   | Action            | Tool                     | Message Type |
| --------------------- | --------------------------- | ----------------- | ------------------------ | ------------ |
| **Simple fix**        | Single file, obvious change | Automatic commit  | `/commit`                | Short        |
| **Feature addition**  | Multiple related files      | Automatic commit  | `/commit`                | Auto-detect  |
| **Complex feature**   | Many files, mixed types     | Analyze & commit  | `/commit`                | Long         |
| **Mixed changes**     | Different domains/types     | Suggest splitting | `/commit`                | Multiple     |
| **Emergency fix**     | Any changes, skip checks    | Force commit      | `/commit --no-verify`    | Short        |
| **Partial staging**   | Selective file changes      | Manual staging    | `git add -p` + `/commit` | Auto-detect  |
| **Merge conflicts**   | Git conflicts               | Manual resolution | Manual git commands      | Custom       |
| **Branch operations** | Branch management needed    | Manual operations | Manual git commands      | N/A          |

## Implementation Details

### 1. Agent Trigger Conditions

The git-workflow-manager agent should activate when:

```python
# Pseudo-logic for agent activation
def should_activate_git_agent():
    return (
        # Code changes detected
        files_modified() or files_created() or files_deleted() or

        # Explicit git operations requested
        user_mentions_commit() or user_mentions_branch() or

        # Task completion indicators
        task_completed() or feature_implemented() or bug_fixed() or

        # Repository state changes needed
        needs_branch_creation() or needs_merge() or needs_tag()
    )
```

### 2. Command Selection Logic

```python
def select_git_operation(context):
    if context.has_uncommitted_changes():
        if context.is_simple_change():
            return "invoke_commit_command()"
        elif context.is_complex_change():
            return "invoke_commit_command_with_analysis()"
        elif context.needs_partial_staging():
            return "manual_staging_then_commit()"
        else:
            return "invoke_commit_command()"

    elif context.needs_branch_operation():
        return "manual_git_branch_operations()"

    elif context.needs_merge_or_rebase():
        return "manual_git_merge_operations()"

    else:
        return "status_check_and_recommendations()"
```

### 3. Quality Gate Integration

```bash
#!/bin/bash
# Quality gate implementation for Python projects

function run_quality_checks() {
    echo "🔍 Running pre-commit quality checks..."

    # Primary checks (ruff + uv)
    if command -v ruff &> /dev/null; then
        echo "  📝 Running ruff linting..."
        ruff check . || return 1

        echo "  🎨 Checking code formatting..."
        ruff format --check . || return 1
    fi

    # Test discovery
    if command -v uv &> /dev/null && [ -f "pyproject.toml" ]; then
        echo "  🧪 Verifying test discovery..."
        uv run pytest --collect-only -q || return 1
    fi

    # Optional type checking
    if [ -f "mypy.ini" ] || grep -q "mypy" pyproject.toml 2>/dev/null; then
        echo "  🏷️  Running type checking..."
        uv run mypy . || echo "  ⚠️  Type checking failed (non-blocking)"
    fi

    echo "✅ All quality checks passed!"
    return 0
}
```

### 4. Intelligent Commit Analysis

```python
class CommitAnalyzer:
    def __init__(self):
        self.diff_stats = self.get_diff_stats()
        self.file_changes = self.get_changed_files()
        self.change_types = self.detect_change_types()

    def should_use_short_message(self):
        return (
            len(self.file_changes) <= 3 and
            len(self.change_types) == 1 and
            not self.has_breaking_changes() and
            not self.has_complex_logic() and
            self.is_standard_operation()
        )

    def should_split_commit(self):
        return (
            self.has_mixed_domains() or
            self.has_mixed_change_types() or
            self.has_independent_changes() or
            len(self.file_changes) > 10
        )

    def generate_commit_message(self):
        if self.should_use_short_message():
            return self.generate_short_message()
        else:
            return self.generate_long_message()
```

## Integration Examples

### Example 1: Simple Bug Fix Workflow

```bash
# User completes bug fix
# Git agent detects changes and automatically triggers:

git status
# Output: 1 file modified (src/auth/validator.py)

/commit
# Output:
# 🔍 Running pre-commit quality checks...
# ✅ All quality checks passed!
# 📝 Analyzing changes...
# 📋 Detected: Simple bug fix (1 file, validation logic)
# 🚀 Creating commit with short message...
#
# Commit message: 🐛 fix: handle empty email validation correctly
#
# ✅ Committed successfully: abc1234
```

### Example 2: Complex Feature Implementation

```bash
# User completes feature implementation
# Git agent detects changes and automatically triggers:

git status
# Output: 8 files modified, 3 files added

/commit
# Output:
# 🔍 Running pre-commit quality checks...
# ✅ All quality checks passed!
# 📝 Analyzing changes...
# 📊 Detected: Complex feature (11 files, multiple domains)
# 📋 Analysis:
#   - API endpoints: 3 files
#   - Data models: 2 files
#   - Business logic: 4 files
#   - Tests: 2 files
# 🔄 Recommending detailed commit message...
#
# Generated commit message:
# ✨ feat: implement user preference management system
#
# - Add UserPreference model with Pydantic validation
# - Create preference API endpoints (GET, POST, PUT, DELETE)
# - Implement Redis caching layer for frequently accessed preferences
# - Add comprehensive test coverage for preference operations
# - Update user dashboard to display personalized settings
#
# This feature allows users to customize their experience and improves
# performance by caching preference data. The caching layer reduces
# database queries by approximately 60% for preference lookups.
#
# Closes #123, #145
#
# ✅ Proceed with this commit? (y/n): y
# ✅ Committed successfully: def5678
```

### Example 3: Mixed Changes Requiring Split

```bash
# User has multiple unrelated changes
# Git agent detects changes and automatically triggers:

git status
# Output: 6 files modified (auth, payments, docs)

/commit
# Output:
# 🔍 Running pre-commit quality checks...
# ✅ All quality checks passed!
# 📝 Analyzing changes...
# ⚠️  Detected mixed concerns - recommending split:
#
# 📋 Suggested commits:
# 1. Authentication changes (3 files):
#    - src/auth/service.py
#    - src/auth/models.py
#    - tests/test_auth.py
#
# 2. Payment processing (2 files):
#    - src/payments/processor.py
#    - tests/test_payments.py
#
# 3. Documentation updates (1 file):
#    - README.md
#
# 🔄 Would you like to:
# [1] Split into separate commits (recommended)
# [2] Commit all together with detailed message
# [3] Manual staging with git add -p
#
# Choice: 1
#
# 🚀 Creating commit 1/3: Authentication changes
# Commit message: ✨ feat: add JWT token refresh mechanism
# ✅ Committed: ghi9012
#
# 🚀 Creating commit 2/3: Payment processing
# Commit message: 🐛 fix: resolve payment validation edge case
# ✅ Committed: jkl3456
#
# 🚀 Creating commit 3/3: Documentation
# Commit message: 📝 docs: update authentication setup instructions
# ✅ Committed: mno7890
#
# ✅ All commits completed successfully!
```

### Example 4: Emergency Hotfix Workflow

```bash
# Critical production issue requires immediate fix
# User signals urgency

/commit --no-verify
# Output:
# ⚠️  EMERGENCY MODE: Skipping pre-commit checks
# 📝 Analyzing changes...
# 🚨 Detected: Critical fix (1 file modified)
#
# Commit message: 🚑️ fix: patch critical authentication bypass vulnerability
#
# ✅ Emergency commit completed: pqr4567
# ⚠️  Remember to run quality checks post-commit:
#   ruff check .
#   ruff format --check .
#   uv run pytest
```

### Example 5: Branch Management Integration

```bash
# User starts new feature work
# Agent detects need for branch creation

# Current: main branch
# User: "I need to work on the payment integration"

# Git agent response:
git checkout -b feature/payment-integration
# Output: Switched to a new branch 'feature/payment-integration'

# ... development work happens ...

# User completes feature
/commit
# Output: [normal commit process]

# When feature is complete:
git checkout main
git merge feature/payment-integration --no-ff
git branch -d feature/payment-integration
git push origin --delete feature/payment-integration

# Agent provides summary:
# ✅ Feature integration complete:
#   - 5 commits made on feature branch
#   - Successfully merged to main
#   - Branch cleaned up locally and remotely
#   - Ready for next feature development
```

## Configuration Integration

### Project Setup Integration

The workflow should automatically detect and configure based on project structure:

```python
# Project detection logic
class ProjectDetector:
    def detect_project_type(self):
        if self.has_file("pyproject.toml") and self.has_ruff_config():
            return "python_ruff_uv"
        elif self.has_file("package.json"):
            return "nodejs"
        elif self.has_file("requirements.txt"):
            return "python_legacy"
        else:
            return "generic"

    def get_commit_config(self):
        project_type = self.detect_project_type()
        return {
            "python_ruff_uv": {
                "pre_commit": ["ruff check .", "ruff format --check .", "uv run pytest --collect-only"],
                "commit_style": "conventional_with_emoji",
                "split_threshold": 3,
                "prefer_atomic": True
            },
            "nodejs": {
                "pre_commit": ["npm run lint", "npm run build"],
                "commit_style": "conventional_with_emoji",
                "split_threshold": 5,
                "prefer_atomic": True
            }
        }[project_type]
```

### Error Handling and Recovery

```bash
# Error recovery scenarios

function handle_commit_failure() {
    case $1 in
        "lint_failed")
            echo "🚨 Linting failed. Options:"
            echo "[1] Fix issues and retry"
            echo "[2] Commit with --no-verify (not recommended)"
            echo "[3] Stage specific files only"
            ;;
        "test_failed")
            echo "🧪 Test discovery failed. Options:"
            echo "[1] Fix test issues and retry"
            echo "[2] Skip test check for this commit"
            echo "[3] Review and fix test configuration"
            ;;
        "merge_conflict")
            echo "🔀 Merge conflict detected:"
            echo "[1] Resolve conflicts manually"
            echo "[2] Abort merge and review changes"
            echo "[3] Use merge tool: git mergetool"
            ;;
    esac
}
```

## Monitoring and Metrics

The unified workflow should track:

- **Commit quality metrics**: Message length, conventional format compliance
- **Pre-commit success rate**: How often checks pass vs fail
- **Split recommendations**: Acceptance rate of split suggestions
- **Time to commit**: Efficiency of the automated workflow
- **Error patterns**: Common failure points for improvement

## Best Practices for Teams

1. **Onboarding**: New team members get consistent commit patterns automatically
2. **Code review**: Reviewers can trust commit message accuracy
3. **Release management**: Conventional commits enable automated changelog generation
4. **Rollback safety**: Atomic commits make selective rollbacks easier
5. **CI/CD integration**: Quality gates ensure only clean code reaches pipelines

This unified workflow creates a seamless bridge between development work and version control, ensuring every code change is properly tracked with high-quality commit messages while maintaining development velocity.
