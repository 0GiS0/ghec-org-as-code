# Custom Properties Implementation

This document describes the implementation of GitHub custom properties for repositories created through Backstage templates and managed by Terraform.

## Overview

Custom properties provide a way to add metadata to repositories for better organization, compliance, and operational support. This implementation includes:

1. **Organization-level custom properties** - Defined at the GitHub organization level
2. **Repository-level custom property values** - Applied to specific repositories
3. **Backstage template integration** - Custom properties can be set when creating repositories from templates

## Custom Properties Defined

### service-tier
- **Type**: Single select
- **Options**: tier-1, tier-2, tier-3, experimental
- **Purpose**: Service tier classification for operational support
- **Required**: Yes

### team-owner
- **Type**: String
- **Purpose**: Team responsible for maintaining the repository
- **Required**: Yes

## Implementation Details

### Terraform Configuration

#### Organization-level Properties
Custom properties are created at the organization level using GitHub's REST API via `null_resource` (similar to the codespaces configuration pattern):

```hcl
# Enable/disable custom properties management
variable "enable_custom_properties" {
  description = "Enable managing organization-wide custom properties via GitHub REST API"
  type        = bool
  default     = true
}

# Define the custom properties
variable "organization_custom_properties" {
  description = "Map of custom properties to create at organization level"
  type = map(object({
    description      = string
    property_type    = string # string, single_select, multi_select, true_false
    required         = bool
    default_value    = optional(string)
    allowed_values   = optional(list(string))
  }))
}
```

#### Repository-level Property Values
Repository custom property values are set using the `github_repository_custom_property` resource:

```hcl
resource "github_repository_custom_property" "template_properties" {
  repository     = github_repository.templates[each.value.repository].name
  property_name  = each.value.property_name
  property_type  = each.value.property_type
  property_value = each.value.property_value
}
```

### Backstage Template Integration

#### Form Fields
The Backstage templates include form fields for custom properties:

```yaml
serviceTier:
  title: Service Tier
  type: string
  description: Service tier classification for operational support
  default: tier-3
  enum:
    - tier-1
    - tier-2
    - tier-3
    - experimental
  enumNames:
    - "Tier 1 (Critical)"
    - "Tier 2 (Important)"
    - "Tier 3 (Standard)"
    - "Experimental"

teamOwner:
  title: Team Owner
  type: string
  description: Team responsible for maintaining this repository
  default: platform-team
  ui:field: MyGroupsPicker
```

#### Repository Creation
The template uses a multi-step approach:

1. **Create Repository**: `github:repo:create` action
2. **Push Content**: `github:repo:push` action  
3. **Set Custom Properties**: `http:backstage:request` action to call GitHub API

```yaml
- id: set-custom-properties
  name: Set Custom Properties
  action: http:backstage:request
  input:
    method: PATCH
    url: ${{ steps['publish'].output.remoteUrl | replace('https://github.com/', 'https://api.github.com/repos/') }}/properties/values
    headers:
      Authorization: token ${{ secrets.USER_OAUTH_TOKEN }}
      Accept: application/vnd.github+json
      X-GitHub-Api-Version: 2022-11-28
    body:
      properties:
        - property_name: service-tier
          value: ${{ parameters.serviceTier }}
        - property_name: team-owner  
          value: ${{ parameters.teamOwner }}
```

## Default Property Values

### Template Repositories
All template repositories are assigned:
- **service-tier**: tier-2 or tier-3 (depending on template type)
- **team-owner**: platform-team

### Main Repositories
Core infrastructure repositories (backstage, reusable-workflows):
- **service-tier**: tier-1
- **team-owner**: platform-team

## Usage

### Enabling Custom Properties
Set the feature flag in `terraform.tfvars`:

```hcl
enable_custom_properties = true
```

### Customizing Properties
Modify the `organization_custom_properties` variable to add or change properties:

```hcl
organization_custom_properties = {
  "service-tier" = {
    description    = "Service tier classification for operational support"
    property_type  = "single_select"
    required       = true
    allowed_values = ["tier-1", "tier-2", "tier-3", "experimental"]
  }
  "team-owner" = {
    description   = "Team responsible for maintaining this repository"
    property_type = "string"
    required      = true
  }
  # Add more properties as needed
}
```

### Setting Repository Values
Update `template_repository_custom_properties` to change default values for template repositories:

```hcl
template_repository_custom_properties = {
  "backstage-template-node-service" = {
    service_tier = "tier-3"
    team_owner   = "platform-team"
  }
}
```

## Testing

### Local Template Validation
Use the local validation script to test template rendering:

```bash
cd .local-validate
./render.sh service
```

### Terraform Validation
```bash
terraform fmt
terraform validate
terraform plan
```

## Troubleshooting

### Custom Properties Not Created
Check the log files:
```bash
tail -f /tmp/custom-properties-*.log
```

Common issues:
- GitHub App lacks custom properties permissions
- Property already exists with different configuration
- Invalid property type or values

### Backstage Template Issues
- Verify the `http:backstage:request` action is available
- Check that `USER_OAUTH_TOKEN` secret is configured
- Ensure custom properties exist at organization level before using in templates

## Future Enhancements

1. **Additional Properties**: Environment, compliance status, data classification
2. **Validation Rules**: Enforce property requirements based on repository type
3. **Automated Updates**: Sync property values based on repository metadata
4. **Reporting**: Dashboard showing property distribution across repositories