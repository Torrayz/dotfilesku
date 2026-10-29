#!/usr/bin/env bash
set -euo pipefail

# DMS owns the keybinding UI. Keep this wrapper for existing Hyprland bindings.
exec dms ipc call keybinds toggle hyprland
