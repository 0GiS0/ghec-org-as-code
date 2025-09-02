# Backstage Template Placeholder Processor

This utility solves the Dependabot synchronization issue by providing a single-file approach for maintaining `package.json` files that work with both Dependabot and Backstage.

## Problem Solved

Previously, we had two separate `package.json` files:
- `skeleton/package.json` - Contains Backstage template syntax like `${{values.name | replace("-", "_")}}`
- `package.json` (root level) - Contains static, valid JSON that Dependabot can parse

**The Issue**: When Dependabot updates dependencies in the root `package.json`, the `skeleton/package.json` doesn't get updated automatically, leading to dependency version mismatches.

## Solution

This utility provides a **single source of truth** approach:

1. **Source files** (`templates/sources/`) contain Backstage template syntax
2. **Processor script** converts between formats on-demand
3. **Terraform** uses the processor to generate both versions automatically
4. **No manual synchronization** required

## Usage

### Convert Backstage template to Dependabot-compatible JSON
```bash
python3 templates/scripts/backstage-processor.py to-dependabot \
  templates/sources/node-service-package.json \
  package.json
```

### Convert Dependabot JSON back to Backstage template
```bash
python3 templates/scripts/backstage-processor.py to-backstage \
  package.json \
  skeleton/package.json.tpl
```

### Validate JSON syntax
```bash
python3 templates/scripts/backstage-processor.py validate package.json
```

## How It Works

### Placeholder Mapping

| Backstage Template Syntax | Placeholder |
|---------------------------|-------------|
| `${{values.name \| replace("-", "_")}}` | `BACKSTAGE_TEMPLATE_NAME_PLACEHOLDER` |
| `${{values.description}}` | `BACKSTAGE_TEMPLATE_DESCRIPTION_PLACEHOLDER` |
| `${{values.owner}}` | `BACKSTAGE_TEMPLATE_OWNER_PLACEHOLDER` |
| `${{values.repoUrl}}` | `BACKSTAGE_TEMPLATE_REPO_URL_PLACEHOLDER` |
| `${{values.name}}` | `BACKSTAGE_TEMPLATE_NAME_RAW_PLACEHOLDER` |

### Example Transformation

**Source (Backstage syntax):**
```json
{
  "name": "${{values.name | replace(\"-\", \"_\")}}",
  "description": "${{values.description}}",
  "dependencies": {
    "express": "^5.1.0"
  }
}
```

**Generated (Dependabot-compatible):**
```json
{
  "name": "BACKSTAGE_TEMPLATE_NAME_PLACEHOLDER", 
  "description": "BACKSTAGE_TEMPLATE_DESCRIPTION_PLACEHOLDER",
  "dependencies": {
    "express": "^5.1.0"
  }
}
```

## Benefits

✅ **Single source of truth** - One file to maintain dependency versions  
✅ **Dependabot compatibility** - Generated files are valid JSON that Dependabot can parse  
✅ **Backstage functionality preserved** - Users still get dynamic name replacement  
✅ **Automatic synchronization** - Terraform generates both versions from the same source  
✅ **No breaking changes** - Existing Backstage templates continue to work  

## Integration with Terraform

The Terraform configuration has been updated to:

1. Use source files with Backstage syntax (`templates/sources/`)
2. Generate Dependabot-compatible root `package.json` files using the processor
3. Generate Backstage template files (`skeleton/package.json.tpl`) using the processor
4. Ensure both versions stay synchronized automatically

This approach eliminates the manual synchronization burden while maintaining full compatibility with both tools.