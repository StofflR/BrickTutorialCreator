#!/usr/bin/env python3
"""
Script to rename JSON files by removing numbers and special characters.
"""

import os
import re
from pathlib import Path

def clean_filename(filename):
    """Remove numbers and special characters from filename, keeping only letters and underscores."""
    # Get the name without extension
    name, ext = os.path.splitext(filename)
    
    # Replace special characters and numbers with empty string
    # Keep only letters, spaces, and underscores
    cleaned = re.sub(r'[^a-zA-Z_\s]', '', name)
    
    # Replace multiple spaces/underscores with single underscore
    cleaned = re.sub(r'[\s_]+', '_', cleaned)
    
    # Remove leading/trailing underscores
    cleaned = cleaned.strip('_')
    
    # Return with extension
    return cleaned + ext

def rename_files_in_directory(directory):
    """Rename all JSON files in the directory and subdirectories."""
    directory_path = Path(directory)
    json_files = list(directory_path.rglob("*.json"))
    
    print(f"Found {len(json_files)} JSON files to process")
    print("=" * 80)
    
    renamed_count = 0
    skipped_count = 0
    error_count = 0
    
    # Track renamed files to avoid conflicts
    renamed_files = {}
    
    for json_file in json_files:
        try:
            original_name = json_file.name
            new_name = clean_filename(original_name)
            
            if original_name == new_name:
                skipped_count += 1
                continue
            
            # Get the new path
            new_path = json_file.parent / new_name
            
            # Check if target already exists
            counter = 1
            base_new_path = new_path
            while new_path.exists():
                name_part = base_new_path.stem
                ext_part = base_new_path.suffix
                new_path = json_file.parent / f"{name_part}_{counter}{ext_part}"
                counter += 1
            
            # Rename the file
            json_file.rename(new_path)
            
            renamed_count += 1
            print(f"✓ Renamed:")
            print(f"  From: {original_name}")
            print(f"  To:   {new_path.name}")
            
        except Exception as e:
            error_count += 1
            print(f"✗ Error renaming {json_file.name}: {e}")
    
    print("=" * 80)
    print(f"\nRename complete!")
    print(f"Files renamed: {renamed_count}")
    print(f"Files skipped (no change needed): {skipped_count}")
    print(f"Errors: {error_count}")

if __name__ == "__main__":
    ref_dir = Path(__file__).parent / "resources" / "ref_all_bricks"
    
    if not ref_dir.exists():
        print(f"Error: Directory {ref_dir} does not exist")
        exit(1)
    
    rename_files_in_directory(ref_dir)
