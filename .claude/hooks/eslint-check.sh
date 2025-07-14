#!/bin/bash

# ESLint hook for Claude Code
# Runs ESLint on JavaScript/TypeScript files after edits

# Read input from stdin
INPUT=$(cat)

# Extract file path from the tool input JSON
FILE_PATH=$(echo "$INPUT" | jq -r ".tool_input.file_path // empty")

# Check if file path exists and matches JS/TS extensions
if [[ -n "$FILE_PATH" && "$FILE_PATH" =~ \.(js|jsx|ts|tsx)$ ]]; then
    echo "[hook] Linting $FILE_PATH with ESLint"
    
    # Run ESLint and capture output
    ESLINT_OUTPUT=$(npx eslint "$FILE_PATH" 2>&1)
    ESLINT_EXIT_CODE=$?
    
    if [ $ESLINT_EXIT_CODE -ne 0 ]; then
        echo "[hook] ESLint failed for $FILE_PATH" >&2
        echo "$ESLINT_OUTPUT" >&2
        exit 2  # Blocking exit code
    else
        echo "[hook] ESLint passed"
    fi
fi

# Exit successfully if file doesn't match or no issues found
exit 0