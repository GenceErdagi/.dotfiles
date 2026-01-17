#!/usr/bin/env bash

# Log execution
LOG_FILE="/tmp/yazi_zellij_debug.log"
echo "Script triggered at $(date)" >> "$LOG_FILE"
echo "Argument: $1" >> "$LOG_FILE"

# Resolve the absolute path of the selected file
FILE_PATH=$(readlink -f "$1")
echo "Resolved Path: $FILE_PATH" >> "$LOG_FILE"

# 1. Move focus from Yazi (left) to Helix (right)
zellij action move-focus right >> "$LOG_FILE" 2>&1
# Ensure we are in the top pane (Helix) if we landed in the bottom one (Terminal)
zellij action move-focus up >> "$LOG_FILE" 2>&1

# 2. Loop through all files and open them
for FILE in "$@"; do
    # Resolve absolute path
    FILE_PATH=$(readlink -f "$FILE")

    # Send commands to Helix: ESC -> :open path -> Enter
    zellij action write 27 >> "$LOG_FILE" 2>&1
    zellij action write-chars ":open $FILE_PATH" >> "$LOG_FILE" 2>&1
    zellij action write 13 >> "$LOG_FILE" 2>&1
    
    # Small delay to ensure Helix catches up
    sleep 0.1
done
