#!/bin/bash

# Find .scad files recursively and generate preview for each.
find . -name "*.scad" -print0 | while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
        echo "Generating preview for $file..."
        openscad -o "${file%.scad}_preview.png" "$file" --enable predictible-output --backend Manifold --render=true
        echo "Generate preview for rendered mesh from $file..."
    fi
done
