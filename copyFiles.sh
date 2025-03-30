#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <source_path> <file_type> <target_path>"
  exit 1
fi

source_path=$1
file_type=$2
target_path=$3

# Ensure cwebp is installed
if ! command -v cwebp &> /dev/null; then
  echo "Error: cwebp is not installed. Install it with 'brew install webp'"
  exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$target_path"

# Find files in source path matching the given file type
find "$source_path" -type f -name "*.$file_type" | while read -r file; do
  # Calculate relative path
  relative_path=$(echo "$file" | sed "s|^$source_path/||")
  
  # Change file extension to .webp
  webp_relative_path="${relative_path%.*}.webp"
  webp_target_path="$target_path/$webp_relative_path"

  # Create necessary directories
  mkdir -p "$(dirname "$webp_target_path")"

  # Convert the file to WebP
  cwebp -q 80 "$file" -o "$webp_target_path"

  echo "Converted: $file -> $webp_target_path"
done

echo "Conversion and copying completed."
