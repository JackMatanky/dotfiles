# Homebrew Update Automation

> [!info]
> Modular and interactive Homebrew and Mac App Store package management, organized for flexibility and minimal system load.

This repository provides a clean and modular set of Justfile recipes to update Homebrew packages and Mac App Store applications across Linux and macOS.

The update workflow is split into small composable tasks, allowing fine-grained control over what gets updated, upgraded, or cleaned up.

---

## Structure

### Recipes

- **update-brew**
  Full interactive Homebrew update sequence. Prompts for upgrades and cleanup.
- **update-brew-mac** (macOS only)
  Upgrade Mac App Store applications using `mas upgrade`.
- **update-brew-outdated**
  Show a list of outdated Homebrew packages without upgrading.
- **upgrade-brew**
  Upgrade all outdated Homebrew packages without additional prompts.
- **cleanup-brew**
  Clean up Homebrew caches and old versions.

---

## Behavior

- `brew update` is always run first to fetch the latest package data.
- If on macOS, `mas upgrade` is run to update Mac App Store apps.
- `brew outdated` lists outdated packages for review.
- Informational banners are printed before each major operation to clarify progress (e.g., "Homebrew", "Homebrew Packages", "Mac App Store Applications").
- You are then prompted whether to:
  - Upgrade all outdated Homebrew packages
  - Run `brew cleanup` to remove old versions and free disk space
- Interactive prompts allow skipping actions as needed.

---

## Example Usage

Run the full update interactively:

```bash
just update-brew
```

Skip confirmations and upgrade automatically:

```bash
just --yes upgrade-brew
just --yes cleanup-brew
```

View only outdated packages without changing anything:

```bash
just update-brew-outdated
```

Update only Mac App Store apps (macOS):

```bash
just update-brew-mac
```

---

## Notes

> [!info]
> Fine-grained modular recipes minimize unnecessary upgrades and disk usage, helping maintain a faster, cleaner, and more stable system.

- Separate control over updating, upgrading, and cleanup.
- Prompts ensure upgrades are intentional, not automatic.
- Designed to work both interactively and in automation scripts.
