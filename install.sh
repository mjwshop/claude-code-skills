#!/bin/bash
# Install all Claude Code skills to your local environment

SKILLS_DIR="$(cd "$(dirname "$0")" && pwd)/skills"
TARGET_DIR="$HOME/.claude/commands"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

echo "Installing Claude Code skills..."
echo ""

count=0
for skill in "$SKILLS_DIR"/*.md; do
  [ -f "$skill" ] || continue
  filename=$(basename "$skill")
  cp "$skill" "$TARGET_DIR/$filename"
  echo "  Installed: $filename"
  count=$((count + 1))
done

echo ""
echo "Done! $count skill(s) installed to $TARGET_DIR"
echo "Run /discovery-prep [merchant] in Claude Code to try it out."
