#!/bin/bash

# Prettier hook for Claude Code
# Formats files with prettier after edits

# Read input from stdin
INPUT=$(cat)

# Extract file path from the tool input JSON
FILE_PATH=$(echo "$INPUT" | jq -r ".tool_input.file_path // empty")

# Check if file path exists and matches supported extensions
if [[ -n "$FILE_PATH" && "$FILE_PATH" =~ \.(js|jsx|ts|tsx|json|css|scss|html|md|yaml|yml)$ ]]; then
    echo "[hook] Formatting $FILE_PATH with prettier"
    npx prettier --write "$FILE_PATH" 2>/dev/null || echo "[hook] prettier failed or not available"
fi

# Exit successfully
exit 0