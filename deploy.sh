#!/bin/bash

set -e

GAME_NAME=cdgj-2026

# Resolve the project root relative to this script's location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR" && pwd)"

# gdot is the Godot CLI/binary
# More info: https://docs.godotengine.org/en/latest/tutorials/editor/command_line_tutorial.html

cd "$PROJECT_ROOT"
/Applications/Godot.app/Contents/MacOS/Godot --headless --export-release Web "$PROJECT_ROOT/export/index.html"

butler push "$PROJECT_ROOT/export/." "joltsmith/$GAME_NAME:html"
