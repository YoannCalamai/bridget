#!/bin/sh
# safeDelete.sh - A script to safely delete a file with security checks
# Usage: ./safeDelete.sh <file_path>
# For web application use - no interactive confirmations, single log output

set -e # Exit immediately if a command exits with non-zero status
set -u # Treat unset variables as an error
set -o pipefail # Exit if any command in a pipeline fails

# Function to display usage information
show_usage() {
    echo "Usage: $0 <file_path>"
    echo "Safely deletes a file after performing security checks."
    exit 1
}

# Function for the single log message at the end
log_result() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Check if a file path was provided
if [ $# -ne 1 ]; then
    log_result "Error: Exactly one argument is required."
    exit 1
fi

FILE_PATH="$1"

# Security checks
# Check if the file exists
if [ ! -e "$FILE_PATH" ]; then
    log_result "Error: File '$FILE_PATH' does not exist."
    exit 2
fi

# Check if the file is a regular file (not a directory, symbolic link, etc.)
if [ ! -f "$FILE_PATH" ]; then
    log_result "Error: '$FILE_PATH' is not a regular file."
    exit 3
fi

# Check if the file is writable
if [ ! -w "$FILE_PATH" ]; then
    log_result "Error: You don't have write permission for '$FILE_PATH'."
    exit 4
fi

# Check for absolute path beginning with / and check for parent directory traversal
if [ "$(echo "$FILE_PATH" | cut -c1)" = "/" ]; then
    # Get the absolute path
    ABSOLUTE_PATH=$(readlink -f "$FILE_PATH")
else
    # Convert relative path to absolute path
    ABSOLUTE_PATH=$(readlink -f "$(pwd)/$FILE_PATH")
fi

# Check if the file is in a system directory but allow /var/www/AttachedDocument explicitly
check_system_dir() {
    for DIR in "/bin" "/sbin" "/usr/bin" "/usr/sbin" "/etc" "/var" "/lib" "/boot"; do
        case "$FILE_PATH" in
            "$DIR"/* | "$DIR")
                # Check if it's our allowed exception: /var/www/AttachedDocument
                case "$FILE_PATH" in
                    "/var/www/AttachedDocument"/* | "/var/www/AttachedDocument")
                        # This is our explicitly allowed directory - continue processing
                        return 0
                        ;;
                    *)
                        # This is a restricted system directory
                        log_result "Error: Cannot delete files in system directory '$DIR'."
                        exit 5
                        ;;
                esac
                ;;
        esac
    done
    return 0
}
check_system_dir

# Check if it's a system critical file
case "$ABSOLUTE_PATH" in
    "/etc/passwd" | "/etc/shadow" | "/etc/hosts" | "/etc/fstab")
        log_result "Error: Cannot delete critical system file '$ABSOLUTE_PATH'."
        exit 6
        ;;
esac

# Securely delete the file (if shred is available)
if command -v shred >/dev/null 2>&1; then
    shred -uz "$FILE_PATH" 2>/dev/null
else
    rm -f "$FILE_PATH" 2>/dev/null
fi

# Verify deletion
if [ ! -e "$FILE_PATH" ]; then
    log_result "Success: File '$FILE_PATH' has been deleted."
    exit 0
else
    log_result "Error: Failed to delete '$FILE_PATH'."
    exit 7
fi