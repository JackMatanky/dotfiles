#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/git/shrink_repo.sh
# Description: Interactively reduce Git repository size by removing selected
#              files and paths from history using git-filter-repo.
#              Includes optional backup and force-push prompts.
# -----------------------------------------------------------------------------

set -euo pipefail  # Exit on error, unset variable, or failed pipeline

# ------------------------- Constants ------------------------ #
# Commands for install suggestion
INSTALL_BREW='brew install git-filter-repo'
INSTALL_PIP='pip install git-filter-repo'

# Full message shown when git-filter-repo is not installed
INSTALL_MSG_BREW="Install with \`${INSTALL_BREW}\` or \`${INSTALL_PIP}\`."

# Example path-glob arguments for usage and help
GLOB_EXAMPLE="--path-glob '*.mp3' --path-glob '.cache/'"
USAGE_MSG="Usage: \$0 /path/to/repo [${GLOB_EXAMPLE}]"
FILTER_REMINDER="Example: \$0 /path/to/repo ${GLOB_EXAMPLE}"

# Prompts and messaging constants
ABORT_MSG="❌ Aborted."
FILTER_PROMPT="❓ Proceed with removing these paths from history using git-filter-repo?"
BACKUP_PROMPT="💾 Do you want to back up the entire repository before rewriting history?"
PUSH_PROMPT="☁️ Do you want to force-push this rewritten history to your remote?"

# --------------------- Helper Functions --------------------- #
# confirm: Prompt the user and return true if they answer yes (case-insensitive)
confirm() {
  read -r -p "${1} [y/N] " response
  [[ "${response}" =~ ^[Yy]$ ]]
}

# error: Print an error message and exit
error() {
  echo "❌ ${1}"
  exit 1
}

# ---------------------- Input Arguments --------------------- #
# Capture the first argument as the path to the Git repo
REPO_DIR="${1:-}"
shift || true  # Shift off the first argument (if provided) to leave only path-globs

# Validate presence of a repo path
if [[ -z "${REPO_DIR}" ]]; then
  error "${USAGE_MSG}"
fi

# Check that the given path is a Git repo
if [[ ! -d "${REPO_DIR}/.git" ]]; then
  error "Directory '${REPO_DIR}' is not a Git repository."
fi

# Ensure git-filter-repo is installed
if ! command -v git-filter-repo &>/dev/null; then
  error "git-filter-repo not found. ${INSTALL_MSG_BREW}"
fi

# Capture all remaining arguments (should be path-globs)
FILTER_ARGS=("$@")
if [[ ${#FILTER_ARGS[@]} -eq 0 ]]; then
  echo "⚠️  No --path or --path-glob arguments provided."
  echo "   ${FILTER_REMINDER}"
  exit 1
fi

# ------------------- Show Planned Changes ------------------- #
# Inform user of the repository being altered and the paths to be removed
echo "🔍 Target repository: ${REPO_DIR}"
echo "📦 Paths to be removed from Git history:"
for arg in "${FILTER_ARGS[@]}"; do
  echo "  ${arg}"
done

# Ask for confirmation before applying changes
if ! confirm "${FILTER_PROMPT}"; then
  echo "${ABORT_MSG}"
  exit 1
fi

# --------------------- Backup Directory --------------------- #
# Create a timestamp for the backup folder
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="${REPO_DIR}_backup_${TIMESTAMP}"

# Ask whether the user wants to create a full backup of the repo
if confirm "${BACKUP_PROMPT}"; then
  echo "📁 Backing up to: ${BACKUP_DIR}"
  cp -r "${REPO_DIR}" "${BACKUP_DIR}"
  echo "✅ Backup complete."
else
  echo "⚠️  Proceeding without backup."
fi

# -------------------- Run git-filter-repo ------------------- #
# Change to the repo directory and run git-filter-repo with the specified globs
echo "🧹 Running git-filter-repo..."
cd "${REPO_DIR}"
git filter-repo "${FILTER_ARGS[@]}" --invert-paths

# -------------------------- Cleanup ------------------------- #
# Run Git garbage collection to remove orphaned objects and reduce repo size
echo "🧼 Running cleanup..."
git reflog expire --expire=now --all
git gc --aggressive --prune=now

# Show the final .git directory size after cleanup
echo "📏 Final .git directory size:"
du -sh .git

# ------------------- Optional: Force Push ------------------- #
# Ask whether to push the rewritten history to the remote repo
if confirm "${PUSH_PROMPT}"; then
  echo "🚀 Pushing..."
  git push origin --force --all
  git push origin --force --tags
else
  echo "✅ Done. You can force-push manually if needed."
fi

# -------------------- Completion Message -------------------- #
# Final confirmation message
echo "🎉 Repository cleanup complete."
