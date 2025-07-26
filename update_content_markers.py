#!/usr/bin/env python3
"""
Script to update Content field in JSON files, replacing $ with _ and * with |
"""

import json
import os
from pathlib import Path

def update_content_markers(json_file):
    """Update the Content field to replace $ with _ and * with |"""
    try:
        # Read JSON file
        with open(json_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Update Content field if it exists
        if "Content" in data:
            original_content = data["Content"]
            updated_content = original_content.replace("$", "_").replace("*", "|")
            
            if original_content != updated_content:
                data["Content"] = updated_content
                
                # Write updated JSON back to file
                with open(json_file, 'w', encoding='utf-8') as f:
                    json.dump(data, f, indent=4)
                
                return True, original_content, updated_content
        
        return False, None, None
        
    except Exception as e:
        raise Exception(f"Error processing file: {e}")

def process_directory(directory):
    """Process all JSON files in the directory and subdirectories."""
    directory_path = Path(directory)
    json_files = list(directory_path.rglob("*.json"))
    
    print(f"Found {len(json_files)} JSON files to process")
    print("=" * 80)
    
    updated_count = 0
    unchanged_count = 0
    error_count = 0
    
    for json_file in json_files:
        try:
            changed, original, updated = update_content_markers(json_file)
            
            if changed:
                updated_count += 1
                print(f"✓ Updated: {json_file.name}")
                if len(original) < 60 and len(updated) < 60:
                    print(f"  Old: {original}")
                    print(f"  New: {updated}")
            else:
                unchanged_count += 1
            
        except Exception as e:
            error_count += 1
            print(f"✗ Error processing {json_file.relative_to(directory_path)}: {e}")
    
    print("=" * 80)
    print(f"\nUpdate complete!")
    print(f"Files updated: {updated_count}")
    print(f"Files unchanged: {unchanged_count}")
    print(f"Errors: {error_count}")

if __name__ == "__main__":
    ref_dir = Path(__file__).parent / "ref_all_bricks"
    
    if not ref_dir.exists():
        print(f"Error: Directory {ref_dir} does not exist")
        exit(1)
    
    process_directory(ref_dir)
