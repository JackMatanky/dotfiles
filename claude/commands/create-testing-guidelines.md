# .claude/create-testing-guidelines

Generate comprehensive testing patterns reference covering test organization, best practices, fixtures, mocking strategies, and testing workflows optimized for Claude Code development.

## Usage

```bash
claude < .claude/create-testing-guidelines
```

## Purpose

**Primary Goal**: Create a testing guidelines reference that enables Claude Code to:
- Follow consistent test organization and naming patterns
- Apply testing best practices automatically
- Create maintainable, readable test suites
- Navigate test files predictably using structure conventions
- Implement comprehensive test coverage including edge cases and error scenarios

**Key Focus**: This reference serves as both a patterns guide and a best practices instructor for AI-assisted development.

## File Management

**Output Location**: `docs/codebase_ref/testing_guidelines.md`

**Before Starting**: I will check if `docs/codebase_ref/testing_guidelines.md` already exists and assess whether it needs updating based on:
- Recent changes to test files or testing configuration
- Updates to testing dependencies or frameworks
- New testing patterns or fixture implementations
- Changes to CI/CD testing workflows
- Updates to test coverage or quality metrics

**Update Decision Process**:
1. **If file doesn't exist**: Create new comprehensive reference
2. **If file exists**: 
   - Read existing file and analyze timestamp/metadata
   - Check recent commits for testing-related changes
   - Compare current test patterns with documented patterns
   - Ask whether you want to:
     - **Update**: Refresh specific sections while preserving structure
     - **Append**: Add new patterns for new test types/features
     - **Regenerate**: Create completely fresh file
     - **Skip**: Keep existing file unchanged

## What This Command Creates

A comprehensive `testing_guidelines.md` file with the following structure:

### Section 1: Test Organization & Structure
- **Directory Structure** - How tests mirror codebase structure for predictable navigation
- **File Naming Conventions** - One class per file with descriptive naming patterns
- **Test Categories** - Unit, integration, end-to-end test separation and organization
- **Structure Compliance** - Ensuring every source file has corresponding tests

### Section 2: Testing Best Practices for Claude Code
- **Test Design Principles** - Single responsibility, descriptive naming, test isolation
- **Test Method Quality Standards** - Arrange-Act-Assert, boundary testing, error scenarios
- **Mock and Fixture Guidelines** - Dependency isolation and test data management
- **Performance and Maintainability** - Fast execution, deterministic tests, clear failure messages

### Section 3: Fixture Patterns & Setup
- **Database Fixtures** - Test database setup, migrations, data seeding
- **API Client Fixtures** - Test client configuration and dependency overrides
- **Mock Configurations** - External service mocking and test doubles
- **Environment Setup** - Test-specific configuration and isolation

### Section 4: Testing Patterns & Examples
- **Unit Test Patterns** - Testing individual functions, classes, methods
- **Integration Test Patterns** - Testing component interactions
- **API Testing** - Endpoint testing, request/response validation
- **Advanced Patterns** - Test builders, custom assertions, performance testing

### Section 5: Coverage & Quality Assurance
- **Coverage Metrics** - Line coverage, branch coverage, missing coverage areas
- **Test Quality Patterns** - Assertion patterns, test readability, maintainability
- **Error Scenario Testing** - Comprehensive exception and edge case coverage
- **CI/CD Integration** - Test execution, reporting, and quality gates

### Section 6: Tool Integration & Automation
- **IDE Configuration** - VS Code, debugging setup, test discovery
- **Test Runner Configuration** - pytest setup, coverage reporting
- **Automation Patterns** - Pre-commit hooks, structure compliance checking
- **Maintenance Strategies** - Keeping tests current and detecting staleness

## Process

I'll analyze your testing setup to extract patterns and create comprehensive guidelines by:

1. **File Existence Check** - Assess if update is needed based on recent testing changes
2. **Test Structure Discovery** - Find all test files and analyze organization patterns
3. **Pattern Analysis** - Examine test naming, fixture usage, and mocking strategies
4. **Best Practices Extraction** - Identify quality patterns and testing approaches
5. **Tool Configuration Review** - Document testing tool setup and CI/CD integration
6. **Documentation Generation** - Create comprehensive reference with concrete examples

## Commands Used

```bash
# Check existing file and recent testing changes
ls -la docs/codebase_ref/testing_guidelines.md
git log --oneline -20 --name-only | rg "(test|spec|fixture|mock)"

# Test organization and structure discovery
fd -g "*test*" -g "*spec*" | head -30
fd -t d -g "*test*" | head -15
rg "def test_|class Test|describe\(|it\(" --type py -n | head -30
rg "import pytest|import unittest|from.*test" --type py -n | head -20

# Test structure analysis - check if tests mirror source structure
fd -g "test_*.py" tests/ | head -20
fd . src/ -e py | head -20
# Compare directory structures
fd -t d . src/ | sed 's/src\///' | sort > /tmp/src_dirs.txt
fd -t d . tests/unit/ | sed 's/tests\/unit\///' | sort > /tmp/test_dirs.txt

# File mapping pattern detection
fd . src/ -e py --exec echo "src/{} → tests/unit/test_{/}" | head -15
fd . tests/unit/ -g "test_*.py" --exec echo "tests/unit/{} ← src/{/.}" | head -15

# Test configuration and setup
fd -g "pytest.ini" -g "pyproject.toml" -g "setup.cfg" -x rg "test" {} -A 5
fd -g "conftest.py" -x head -20 {}
rg "@pytest\.|pytest\." --type py -n -A 2 | head -20
rg "TestCase|unittest\." --type py -n -A 2 | head -15

# Fixture patterns
rg "@fixture|@pytest\.fixture" --type py -n -A 5 | head -20
rg "yield |return.*fixture|setup|teardown" --type py -n -A 3 | head -15
rg "scope=|autouse=|params=" --type py -n -A 2 | head -10

# Database testing patterns
rg "test.*db|test.*database|TestDatabase" --type py -n -A 5 | head -15
rg "transaction|rollback|commit.*test" --type py -n -A 3 | head -10
rg "memory|sqlite|:memory:" --type py -n -A 2 | head -10

# Mocking patterns
rg "mock|Mock|patch|@patch" --type py -n -A 3 | head -20
rg "mocker\.|monkeypatch\." --type py -n -A 2 | head -15
rg "side_effect|return_value|call_count" --type py -n -A 2 | head -15
rg "requests_mock|httpx_mock|aioresponses" --type py -n -A 3 | head -10

# API testing patterns
rg "client\.|test_client|TestClient" --type py -n -A 3 | head -15
rg "\.get\(|\.post\(|\.put\(|\.delete\(" --type py -n -A 2 | head -20
rg "status_code|json\(\)|response\." --type py -n -A 2 | head -15

# Assertion patterns
rg "assert |assertEqual|assertRaises|expect\(" --type py -n -A 1 | head -20
rg "assert.*==|assert.*in|assert.*is" --type py -n | head -15
rg "raises|pytest\.raises|assertRaises" --type py -n -A 2 | head -10

# Test coverage and quality
fd -g ".coverage*" -g "coverage.*" -g "htmlcov" | head -10
rg "coverage|pytest-cov|--cov" --type py -n -A 2 | head -10
rg "# pragma: no cover|# noqa|# type: ignore" --type py -n | head -10

# CI/CD testing patterns
fd -g ".github" -g ".gitlab-ci*" -g "Jenkinsfile" -x rg "test|pytest|coverage" {} -A 3
fd -g "tox.ini" -g "noxfile.py" -x head -15 {}
rg "test.*command|pytest.*args|test.*script" -i -A 2 | head -10

# Performance and load testing
rg "benchmark|performance|load.*test|stress.*test" --type py -n -A 3 | head -10
rg "pytest-benchmark|locust|artillery" --type py -n -A 2 | head -5

# Best practices pattern detection
rg "# TODO|# FIXME|# NOTE|# HACK" tests/ --type py -n | head -10
rg "AAA|Arrange.*Act.*Assert|Given.*When.*Then" tests/ --type py -n -A 3 | head -10
rg "test.*should|test.*must|test.*when.*then" tests/ --type py -n | head -15
```

## Output Format

The generated `testing_guidelines.md` will include:

```markdown
<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
<!-- Test Framework: pytest/unittest/etc. -->
<!-- Coverage Tool: pytest-cov/coverage.py -->
<!-- Total Test Files: XX -->
<!-- Source-to-Test Mapping: Verified/Issues Found -->

# Testing Guidelines Reference

## Overview

This document provides comprehensive testing guidelines optimized for Claude Code development, ensuring consistent test organization, maintainable patterns, and high-quality test coverage across the entire codebase.

## Table of Contents
1. [Test Organization & Structure](#test-organization--structure)
2. [Testing Best Practices](#testing-best-practices-for-claude-code)
3. [Fixture Patterns & Setup](#fixture-patterns)
4. [Testing Patterns & Examples](#testing-patterns)
5. [Advanced Testing Techniques](#advanced-testing-patterns-for-claude-code)
6. [Coverage & Quality Assurance](#coverage--quality-patterns)
7. [Tool Integration](#ide-and-tooling-integration-patterns)
8. [Maintenance & Compliance](#maintenance-strategy)

## 1. Test Organization & Structure

### Directory Structure (Mirrors Source Code)
**Core Pattern**: Tests mirror `src/` structure exactly for predictable navigation

```
src/                         tests/
├── models/                  └── unit/
│   ├── user.py                 ├── models/
│   ├── order.py                │   ├── test_user_model.py        # Tests src/models/user.py
│   └── product.py              │   ├── test_order_model.py       # Tests src/models/order.py
├── services/                   │   └── test_product_model.py     # Tests src/models/product.py
│   ├── user_service.py         ├── services/
│   ├── order_service.py        │   ├── test_user_service.py      # Tests src/services/user_service.py
│   └── auth_service.py         │   ├── test_order_service.py     # Tests src/services/order_service.py
├── api/                        │   └── test_auth_service.py      # Tests src/services/auth_service.py
│   └── routes/                 ├── api/
│       ├── users.py            │   └── routes/
│       └── orders.py           │       ├── test_users_routes.py  # Tests src/api/routes/users.py
└── utils/                      │       └── test_orders_routes.py # Tests src/api/routes/orders.py
    ├── helpers.py              ├── utils/
    └── validators.py           │   ├── test_helpers_utils.py     # Tests src/utils/helpers.py
                               │   └── test_validators_utils.py  # Tests src/utils/validators.py
                               ├── integration/               # Integration tests (also mirrors structure)
                               ├── e2e/                       # End-to-end tests (feature-based)
                               ├── fixtures/                  # Shared test data
                               ├── conftest.py               # Shared configuration
                               └── utils/                    # Test utilities
```

### File Naming Convention
**Core Pattern**: One test class per file, mirroring source structure

**Option 1: Descriptive Prefix Pattern** (Recommended)
```
# Source file with single class
src/models/user.py (contains UserModel class)
→ tests/unit/models/test_user_model.py (contains TestUserModel class)

src/services/user_service.py (contains UserService class)  
→ tests/unit/services/test_user_service.py (contains TestUserService class)

src/api/routes/users.py (contains user route handlers)
→ tests/unit/api/routes/test_users_routes.py (contains TestUsersRoutes class)
```

**Option 2: Dedicated Folder Pattern** (For complex modules)
```
# When source file functionality is complex or has multiple concerns
src/services/user_service.py (contains UserService class with auth, profile, notification methods)

→ tests/unit/services/user_service/
    ├── test_authentication.py     (contains TestUserServiceAuthentication class)
    ├── test_profile_management.py (contains TestUserServiceProfileManagement class)
    └── test_notifications.py      (contains TestUserServiceNotifications class)
```

**Naming Rules**:
- **Test file**: `test_[source_class]_[concise_description].py` 
- **Test class**: `Test[SourceClass][ConciseDescription]`
- **Test method**: `test_[method_name]_[scenario]_[expected_outcome]`

[Additional sections continue with detailed patterns, examples, and best practices...]
```

**Key Features of Generated Output**:
- **Logical progression** from organization → best practices → implementation → advanced techniques
- **Clear section headers** with consistent formatting and navigation
- **Concrete examples** from actual codebase analysis with file references
- **Best practices integration** throughout all sections
- **Tool configuration** and automation setup
- **Maintenance procedures** for keeping guidelines current

## Evaluation Criteria

A successful testing guidelines reference should:

1. **Enforce Structure Consistency**: Every source file has a predictably located test file
2. **Enable Rapid Navigation**: Claude Code can instantly locate tests for any source file
3. **Standardize Patterns**: Fixture usage, mocking approaches, and test structure are consistent
4. **Maintain Quality**: Clear expectations for test quality and maintainability  
5. **Support CI/CD**: Integration with automated pipelines and coverage requirements
6. **Facilitate Refactoring**: Test organization makes code changes and moves predictable

## Maintenance Strategy

**Update Triggers**:
- New source files added (ensure corresponding tests created)
- Changes to test organization or structure patterns
- Updates to testing frameworks or tools
- New mocking patterns or fixture approaches
- Changes to CI/CD testing workflows

**Structure Compliance Monitoring**:
```bash
# Run structure compliance tests regularly
pytest tests/test_structure_compliance.py -v

# Check for missing test files
python -c "
import sys
from pathlib import Path

src_files = list(Path('src').rglob('*.py'))
src_files = [f for f in src_files if f.name != '__init__.py']

missing = []
for src_file in src_files:
    rel_path = src_file.relative_to('src')
    test_path = Path('tests/unit') / rel_path.parent / f'test_{rel_path.name}'
    if not test_path.exists():
        missing.append(str(test_path))

if missing:
    print('Missing test files:')
    for m in missing: print(f'  {m}')
    sys.exit(1)
else:
    print('All source files have corresponding tests ✓')
"
```

**Quick Staleness Check**:
```bash
# Check for recent testing-related changes
git log --since="30 days ago" --name-only | rg "(test|spec|fixture)" | wc -l

# Verify structure compliance
fd -e py src/ | wc -l  # Count source files
fd -g "test_*.py" tests/unit/ | wc -l  # Count unit test files
# These numbers should be close (accounting for __init__.py files)
```