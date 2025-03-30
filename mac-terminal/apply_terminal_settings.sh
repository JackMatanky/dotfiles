#!/bin/bash

set -euo pipefail

echo "[INFO] Importing Terminal.app settings..."

defaults import com.apple.Terminal "$(dirname "$0")/com.apple.Terminal.plist"

echo "[SUCCESS] Terminal.app settings applied."
