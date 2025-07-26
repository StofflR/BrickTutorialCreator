#!/usr/bin/env python3
"""
Script to convert JSON files in ref_all_bricks to the new format.
"""

import json
import os
from pathlib import Path

# Color mappings from DefaultColors.h
COLOR_MAP = {
    "blue": {
        "Color": "#408ac5",
        "Shade": "#27567c",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "cyan": {
        "Color": "#26a6ae",
        "Shade": "#2e7078",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "dark_blue": {
        "Color": "#395cab",
        "Shade": "#889dcd",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "gold": {
        "Color": "#95750c",
        "Shade": "#57452c",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "dark_green": {
        "Color": "#305716",
        "Shade": "#173718",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "green": {
        "Color": "#6b9c49",
        "Shade": "#486822",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "light_orange": {
        "Color": "#f99761",
        "Shade": "#a86d45",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "olive": {
        "Color": "#aea626",
        "Shade": "#7e7a30",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "orange": {
        "Color": "#cf5717",
        "Shade": "#7a3a18",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "yellow": {
        "Color": "#fccb41",
        "Shade": "#aa8832",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "violet": {
        "Color": "#8f4cba",
        "Shade": "#5d2d7c",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "pink": {
        "Color": "#cf7aa6",
        "Shade": "#935e7b",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "red": {
        "Color": "#f24e50",
        "Shade": "#ae2f2f",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "winered": {
        "Color": "#910d06",
        "Shade": "#750701",
        "Border": "#383838",
        "Text": "#ffffff"
    },
    "white": {
        "Color": "#ffffff",
        "Shade": "#a9b4cd",
        "Border": "#274383",
        "Text": "#0000ff"
    },
    "transparent_white": {
        "Color": "rgba(255, 255, 255, 1)",
        "Shade": "rgba(255, 255, 255, 1)",
        "Border": "rgba(255, 255, 255, 1)",
        "Text": "#000000"
    },
    "transparent_black": {
        "Color": "rgba(0, 0, 0, 1)",
        "Shade": "rgba(0, 0, 0, 1)",
        "Border": "rgba(0, 0, 0, 1)",
        "Text": "#ffffff"
    }
}

def convert_size(old_size):
    """Convert size format from '1h' to 'H1', '2h' to 'H2', etc."""
    if not old_size:
        return "H1"
    
    # Extract number from size (e.g., "1h" -> "1")
    size_num = old_size.replace('h', '')
    if size_num.isdigit():
        return f"H{size_num}"
    return "H1"

def determine_type(content):
    """Determine brick type based on content - simplified heuristic"""
    # This is a simple heuristic - you may need to adjust based on actual requirements
    return "Base"

def convert_json(old_data):
    """Convert old JSON format to new format."""
    base_type = old_data.get("base_type", "blue")
    
    # Get color data
    color_data = COLOR_MAP.get(base_type, COLOR_MAP["blue"])
    
    # Convert size
    old_size = old_data.get("size", "1h")
    new_size = convert_size(old_size)
    
    # Get content
    content = old_data.get("content", "content")
    
    # Replace $ with _ and * with | in content
    content = content.replace("$", "_").replace("*", "|")
    
    # Get x and y positions (use old values or defaults from scaling)
    x = old_data.get("x", 108.75)
    y = old_data.get("y", 53.72205835470631)
    
    # Create new JSON structure
    new_data = {
        "Border": color_data["Border"],
        "Color": color_data["Color"],
        "Content": content,
        "Shade": color_data["Shade"],
        "Size": new_size,
        "Text": color_data["Text"],
        "Type": determine_type(content),
        "Width": 1920,
        "X": x,
        "Y": y
    }
    
    return new_data

def process_directory(directory):
    """Process all JSON files in the directory and subdirectories."""
    directory_path = Path(directory)
    json_files = list(directory_path.rglob("*.json"))
    
    print(f"Found {len(json_files)} JSON files to process")
    
    converted_count = 0
    error_count = 0
    
    for json_file in json_files:
        try:
            # Read old JSON
            with open(json_file, 'r', encoding='utf-8') as f:
                old_data = json.load(f)
            
            # Convert to new format
            new_data = convert_json(old_data)
            
            # Write new JSON
            with open(json_file, 'w', encoding='utf-8') as f:
                json.dump(new_data, f, indent=4)
            
            converted_count += 1
            print(f"✓ Converted: {json_file.relative_to(directory_path)}")
            
        except Exception as e:
            error_count += 1
            print(f"✗ Error processing {json_file.relative_to(directory_path)}: {e}")
    
    print(f"\nConversion complete!")
    print(f"Successfully converted: {converted_count}")
    print(f"Errors: {error_count}")

if __name__ == "__main__":
    ref_dir = Path(__file__).parent / "ref_all_bricks"
    
    if not ref_dir.exists():
        print(f"Error: Directory {ref_dir} does not exist")
        exit(1)
    
    process_directory(ref_dir)
