#!/bin/bash

# Backstage Template Placeholder Processor
# This utility converts between Dependabot-compatible JSON and Backstage template syntax

set -euo pipefail

# Function to convert Backstage syntax to Dependabot-compatible placeholders
backstage_to_dependabot() {
    local input_file="$1"
    local output_file="$2"
    
    # Use simple string replacement approach
    python3 << 'EOF'
import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, 'r') as f:
    content = f.read()

# Simple string replacements for Backstage syntax
replacements = [
    ('${{values.name | replace("-", "_")}}', 'BACKSTAGE_TEMPLATE_NAME_PLACEHOLDER'),
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
    import json
    with open(output_file, 'r') as f:
        json.load(f)
    print("✓ Converted to valid Dependabot-compatible JSON:", output_file)
except json.JSONDecodeError as e:
    print("ERROR: Generated invalid JSON:", str(e))
    sys.exit(1)
EOF
    
    python3 - "$1" "$2"
}

# Function to convert Dependabot placeholders back to Backstage syntax
dependabot_to_backstage() {
    local input_file="$1"
    local output_file="$2"
    
    python3 << 'EOF'
import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, 'r') as f:
    content = f.read()

# Simple string replacements back to Backstage syntax
replacements = [
    ('BACKSTAGE_TEMPLATE_NAME_PLACEHOLDER', '${{values.name | replace("-", "_")}}'),
    ('BACKSTAGE_TEMPLATE_DESCRIPTION_PLACEHOLDER', '${{values.description}}'),
    ('BACKSTAGE_TEMPLATE_OWNER_PLACEHOLDER', '${{values.owner}}'),
    ('BACKSTAGE_TEMPLATE_REPO_URL_PLACEHOLDER', '${{values.repoUrl}}'),
    ('BACKSTAGE_TEMPLATE_NAME_RAW_PLACEHOLDER', '${{values.name}}')
]

for old_val, new_val in replacements:
    content = content.replace(old_val, new_val)

with open(output_file, 'w') as f:
    f.write(content)

print("✓ Converted to Backstage template syntax:", output_file)
EOF
    
    python3 - "$1" "$2"
}

# Function to validate JSON syntax
validate_json() {
    local file="$1"
    if ! python3 -m json.tool "$file" > /dev/null 2>&1; then
        echo "ERROR: Invalid JSON in $file"
        return 1
    fi
    echo "✓ Valid JSON: $file"
}

# Main function
main() {
    local command="${1:-help}"
    
    case "$command" in
        "to-dependabot")
            if [[ $# -ne 3 ]]; then
                echo "Usage: $0 to-dependabot <input_backstage_file> <output_dependabot_file>"
                exit 1
            fi
            backstage_to_dependabot "$2" "$3"
            ;;
        "to-backstage")
            if [[ $# -ne 3 ]]; then
                echo "Usage: $0 to-backstage <input_dependabot_file> <output_backstage_file>"
                exit 1
            fi
            dependabot_to_backstage "$2" "$3"
            ;;
        "validate")
            if [[ $# -ne 2 ]]; then
                echo "Usage: $0 validate <json_file>"
                exit 1
            fi
            validate_json "$2"
            ;;
        "help"|*)
            echo "Backstage Template Placeholder Processor"
            echo ""
            echo "Commands:"
            echo "  to-dependabot <input> <output>  Convert Backstage template to Dependabot-compatible JSON"
            echo "  to-backstage <input> <output>   Convert Dependabot JSON back to Backstage template"
            echo "  validate <file>                 Validate JSON syntax"
            echo ""
            echo "Examples:"
            echo "  $0 to-dependabot skeleton/package.json.tpl package.json"
            echo "  $0 to-backstage package.json skeleton/package.json.tpl"
            echo "  $0 validate package.json"
            echo ""
            echo "This solves the Dependabot synchronization issue by allowing a single"
            echo "source file that can be processed into both formats as needed."
            ;;
    esac
}

main "$@"