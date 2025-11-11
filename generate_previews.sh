#!/bin/bash

set -e

# Generate previews for all .scad files
echo "Generating previews..."
find . -type f -name "*.scad" ! -path "*/modules/*" -print0 | while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
        preview_file="${file%.scad}_preview.png"
        if [ -f "$preview_file" ]; then
            echo "Preview already exists for $file, skipping..."
        else
            echo "Generating preview for $file..."
            openscad -o "$preview_file" "$file" \
                --enable predictible-output \
                --backend Manifold \
                --render=true \
                --view=axes
                # --colorscheme=BeforeDawn \
                # --view=axes,edges
        fi
    fi
done

echo ""
echo "Updating README.md..."

# Create temporary file for the new README content
temp_readme=$(mktemp)

# Copy everything before "## Parts" or "## Licensing" (whichever comes first)
awk '/^## Parts/{exit} /^## Licensing/{exit} {print}' README.md > "$temp_readme"

# Generate the Parts section
echo "## Parts" >> "$temp_readme"
echo "" >> "$temp_readme"

# Find all directories containing .scad files (excluding root directory and modules folder)
find . -mindepth 2 -type f -name "*.scad" ! -path "*/modules/*" -print0 | while IFS= read -r -d '' file; do
    echo "$(dirname "$file")"
done | sort -u | while read -r dir; do
    # Remove leading "./" and get folder name
    folder=$(echo "$dir" | sed 's|^\./||')
    
    # Extract title by removing the date prefix (YYYY.MM.DD - )
    title=$(echo "$folder" | sed 's/^[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\} - //')
    
    # URL-encode the folder path (replace spaces with %20)
    folder_encoded=$(echo "$folder" | sed 's/ /%20/g')
    
    # Add section header with link to folder
    echo "### [$title]($folder_encoded)" >> "$temp_readme"
    echo "" >> "$temp_readme"
    
    # Find all preview images in this folder
    find "$dir" -maxdepth 1 -name "*_preview.png" | sort | while read -r preview; do
        # Get relative path from root and URL-encode it
        preview_path=$(echo "$preview" | sed 's|^\./||' | sed 's/ /%20/g')
        echo "![Preview]($preview_path)" >> "$temp_readme"
    done
    
    echo "" >> "$temp_readme"
done

# Add the Licensing section and everything after it
awk '/^## Licensing/{flag=1} flag' README.md >> "$temp_readme"

# Replace the original README with the new content
mv "$temp_readme" README.md

echo "README.md has been updated successfully!"
