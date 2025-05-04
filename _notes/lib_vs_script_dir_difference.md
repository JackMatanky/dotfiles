# CLI Directory Structure: `lib/` vs `scripts/`

This document explains the purpose of the `lib/` and `scripts/` folders within a structured shell or dotfiles environment, and when each should be used.

---

## 🧩 `lib/`: Sourceable Shell Libraries

- **Purpose**: Contains reusable functions and configuration helpers.
- **Usage**: Files in this directory are meant to be **sourced**, not executed.
- **Characteristics**:
  - Typically **do not include a shebang** (`#!/usr/bin/env bash`).
  - Not marked as executable.
  - Sourced in `.bashrc`, `.zshrc`, or other shell entrypoints.

### 📁 Typical Contents

- `source_sh_files.sh` – a function to load multiple `.sh` files from a directory.
- `colors.sh` – defines color escape sequences for prompts.
- `logging.sh` – defines `log_info`, `log_error`, etc.
- `path.sh` – helpers to manipulate or construct `$PATH`.

### 📄 Example Usage

```sh
source "$XDG_CONFIG_HOME/cli/lib/source_sh_files.sh"
```

---

## ⚙️ `scripts/`: Executable Shell Commands

- **Purpose**: Self-contained scripts that perform specific tasks.
- **Usage**: Files in this directory are **executed** directly from the command line or other automation tools (e.g., cron).
- **Characteristics**:
  - Should **include a shebang** (`#!/usr/bin/env bash`).
  - Should be marked as executable (`chmod +x`).
  - May accept arguments, output logs, or interact with the system.

### 📁 Typical Contents

- `backup.sh` – backs up a directory to cloud storage.
- `convert-pdf.sh` – converts files to PDF format.
- `sync-notes.sh` – synchronizes a notes folder.

### 📄 Example Usage

```sh
./scripts/convert-pdf.sh input.md
```

---

## 🧠 Should `lib/` Files Include a Shebang?

Generally, **no**.

- `lib/` files are not meant to be executed directly.
- Including a shebang may confuse linters or imply the file should be run.
- Exception: If a file can be executed for testing or debugging purposes, a shebang may be added.

---

## ✅ Summary

| Folder     | Used For                        | Sourced or Executed | Shebang? | Executable? |
|------------|----------------------------------|---------------------|----------|-------------|
| `lib/`     | Helpers, utilities, config       | Sourced             | ❌       | ❌           |
| `scripts/` | CLI tools, automations           | Executed            | ✅       | ✅           |
