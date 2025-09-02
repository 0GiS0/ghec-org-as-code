#!/usr/bin/env python3

import sys
import json

def backstage_to_dependabot(input_file, output_file):
    """Convert Backstage template syntax to Dependabot-compatible JSON"""
    
    with open(input_file, 'r') as f:
        content = f.read()
    
    # Simple string replacements for Backstage syntax  
    replacements = [
        ('${{values.name | replace(\\"-\\", \\"_\\")}}', 'BACKSTAGE_TEMPLATE_NAME_PLACEHOLDER'),
        ('${{values.description}}', 'BACKSTAGE_TEMPLATE_DESCRIPTION_PLACEHOLDER'),
        ('${{values.owner}}', 'BACKSTAGE_TEMPLATE_OWNER_PLACEHOLDER'),
        ('${{values.repoUrl}}', 'BACKSTAGE_TEMPLATE_REPO_URL_PLACEHOLDER'),
        ('${{values.name}}', 'BACKSTAGE_TEMPLATE_NAME_RAW_PLACEHOLDER')
    ]
    
    for old_val, new_val in replacements:
        content = content.replace(old_val, new_val)
    
    # Write the modified content
    with open(output_file, 'w') as f:
        f.write(content)
    
    # Validate the resulting JSON
    try:
        with open(output_file, 'r') as f:
            json.load(f)
        print(f"✓ Converted to valid Dependabot-compatible JSON: {output_file}")
    except json.JSONDecodeError as e:
        print(f"ERROR: Generated invalid JSON: {str(e)}")
        sys.exit(1)

def dependabot_to_backstage(input_file, output_file):
    """Convert Dependabot placeholders back to Backstage syntax"""
    
    with open(input_file, 'r') as f:
        content = f.read()
    
    # Simple string replacements back to Backstage syntax
    replacements = [
        ('BACKSTAGE_TEMPLATE_NAME_PLACEHOLDER', '${{values.name | replace(\\"-\\", \\"_\\")}}'),
        ('BACKSTAGE_TEMPLATE_DESCRIPTION_PLACEHOLDER', '${{values.description}}'),
        ('BACKSTAGE_TEMPLATE_OWNER_PLACEHOLDER', '${{values.owner}}'),
        ('BACKSTAGE_TEMPLATE_REPO_URL_PLACEHOLDER', '${{values.repoUrl}}'),
        ('BACKSTAGE_TEMPLATE_NAME_RAW_PLACEHOLDER', '${{values.name}}')
    ]
    
    for old_val, new_val in replacements:
        content = content.replace(old_val, new_val)
    
    with open(output_file, 'w') as f:
        f.write(content)
    
    print(f"✓ Converted to Backstage template syntax: {output_file}")

def validate_json(file_path):
    """Validate JSON syntax"""
    try:
        with open(file_path, 'r') as f:
            json.load(f)
        print(f"✓ Valid JSON: {file_path}")
    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON in {file_path}: {str(e)}")
        return False
    except FileNotFoundError:
        print(f"ERROR: File not found: {file_path}")
        return False
    return True

def main():
    if len(sys.argv) < 2:
        print_help()
        return
    
    command = sys.argv[1]
    
    if command == "to-dependabot":
        if len(sys.argv) != 4:
            print("Usage: backstage-processor.py to-dependabot <input_backstage_file> <output_dependabot_file>")
            sys.exit(1)
        backstage_to_dependabot(sys.argv[2], sys.argv[3])
    
    elif command == "to-backstage":
        if len(sys.argv) != 4:
            print("Usage: backstage-processor.py to-backstage <input_dependabot_file> <output_backstage_file>")
            sys.exit(1)
        dependabot_to_backstage(sys.argv[2], sys.argv[3])
    
    elif command == "validate":
        if len(sys.argv) != 3:
            print("Usage: backstage-processor.py validate <json_file>")
            sys.exit(1)
        if not validate_json(sys.argv[2]):
            sys.exit(1)
    
    else:
        print_help()

def print_help():
    print("Backstage Template Placeholder Processor")
    print("")
    print("Commands:")
    print("  to-dependabot <input> <output>  Convert Backstage template to Dependabot-compatible JSON")
    print("  to-backstage <input> <output>   Convert Dependabot JSON back to Backstage template")
    print("  validate <file>                 Validate JSON syntax")
    print("")
    print("Examples:")
    print("  python3 backstage-processor.py to-dependabot skeleton/package.json.tpl package.json")
    print("  python3 backstage-processor.py to-backstage package.json skeleton/package.json.tpl")
    print("  python3 backstage-processor.py validate package.json")
    print("")
    print("This solves the Dependabot synchronization issue by allowing a single")
    print("source file that can be processed into both formats as needed.")

if __name__ == "__main__":
    main()