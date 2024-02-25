#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <source_path> <file_type> <target_path>"
  exit 1
fi

source_path=$1
file_type=$2
target_path=$3

# Create target directory if it doesn't exist
mkdir -p "$target_path"

# Find files in source path matching the given file type
find "$source_path" -type f -name "*.$file_type" | while read -r file; do
  # Calculate relative path using sed (alternative to realpath --relative-to)
  relative_path=$(echo "$file" | sed "s|^$source_path/||")

  # Create target directory structure if it doesn't exist
  mkdir -p "$target_path/$(dirname "$relative_path")"

  # Use rsync to copy the file to the target path while preserving directory structure
  rsync -a "$file" "$target_path/$relative_path"
done

echo "Files copied from $source_path to $target_path"
