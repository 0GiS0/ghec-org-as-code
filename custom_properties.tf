###############################################
# Organization Custom Properties Management
# Managed via GitHub REST API using curl
# Requires a token with organization custom properties: write permissions
###############################################

locals {
  # Prepare custom properties payload for API calls
  custom_properties_payloads = {
    for name, config in var.organization_custom_properties : name => jsonencode({
      property_name  = name
      description    = config.description
      value_type     = config.property_type
      required       = config.required
      default_value  = try(config.default_value, null)
      allowed_values = try(config.allowed_values, null)
    })
  }
}

# Create organization-level custom properties
resource "null_resource" "org_custom_properties" {
  for_each = var.enable_custom_properties ? var.organization_custom_properties : {}

  # Re-run when org, property config changes
  triggers = {
    org      = var.github_organization
    payload  = local.custom_properties_payloads[each.key]
    property = each.key
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "scripts/terraform-integration/custom_property.sh"
    environment = {
      ORG_NAME         = var.github_organization
      PROPERTY_NAME    = each.key
      PROPERTY_PAYLOAD = local.custom_properties_payloads[each.key]
      APP_ID           = var.github_app_id
      INSTALLATION_ID  = var.github_app_installation_id
      PEM_FILE         = abspath(var.github_app_pem_file)
      LOG_FILE         = "/tmp/custom-properties-${each.key}.log"
      NON_FATAL_404    = var.custom_properties_non_fatal_404 ? "true" : "false"
    }
  }
}

# Wait for organization custom properties to be available before applying repository values
resource "null_resource" "wait_org_custom_properties" {
  # Only run when feature enabled and strict mode (we are going to apply repo properties)
  count = (var.enable_custom_properties && !var.custom_properties_non_fatal_404) ? 1 : 0

  depends_on = [null_resource.org_custom_properties]

  triggers = {
    org        = var.github_organization
    properties = join(",", keys(var.organization_custom_properties))
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "scripts/terraform-integration/wait_custom_properties.sh"
    environment = {
      ORG_NAME            = var.github_organization
      APP_ID              = var.github_app_id
      INSTALLATION_ID     = var.github_app_installation_id
      PEM_FILE            = abspath(var.github_app_pem_file)
      LOG_FILE            = "/tmp/wait-custom-properties.log"
      REQUIRED_PROPERTIES = join(",", keys(var.organization_custom_properties))
    }
  }
}

# Apply custom properties to template repositories
resource "github_repository_custom_property" "template_properties" {
  for_each = (var.enable_custom_properties && !var.custom_properties_non_fatal_404) ? {
    for repo_name in keys(var.template_repositories) :
    "${repo_name}-service-tier" => {
      repository     = repo_name
      property_name  = "service-tier"
      property_type  = "single_select"
      property_value = [var.template_repository_custom_properties[repo_name].service_tier]
    }
  } : {}

  repository     = module.repositories.template_repositories[each.value.repository].name
  property_name  = each.value.property_name
  property_type  = each.value.property_type
  property_value = each.value.property_value

  depends_on = [
    module.repositories.template_repositories,
    null_resource.wait_org_custom_properties
  ]
}

resource "github_repository_custom_property" "template_team_owner" {
  for_each = (var.enable_custom_properties && !var.custom_properties_non_fatal_404) ? {
    for repo_name in keys(var.template_repositories) :
    "${repo_name}-team-owner" => {
      repository     = repo_name
      property_name  = "team-owner"
      property_type  = "string"
      property_value = [var.template_repository_custom_properties[repo_name].team_owner]
    }
  } : {}

  repository     = module.repositories.template_repositories[each.value.repository].name
  property_name  = each.value.property_name
  property_type  = each.value.property_type
  property_value = each.value.property_value

  depends_on = [
    module.repositories.template_repositories,
    null_resource.wait_org_custom_properties
  ]
}

# Apply custom properties to main repositories (Backstage and reusable-workflows)
resource "github_repository_custom_property" "backstage_service_tier" {
  count = (var.enable_custom_properties && !var.custom_properties_non_fatal_404) ? 1 : 0

  repository     = module.repositories.backstage_repository.name
  property_name  = "service-tier"
  property_type  = "single_select"
  property_value = ["tier-1"]

  depends_on = [
    module.repositories.backstage_repository,
    null_resource.wait_org_custom_properties
  ]
}

resource "github_repository_custom_property" "backstage_team_owner" {
  count = (var.enable_custom_properties && !var.custom_properties_non_fatal_404) ? 1 : 0

  repository     = module.repositories.backstage_repository.name
  property_name  = "team-owner"
  property_type  = "string"
  property_value = ["platform-team"]

  depends_on = [
    module.repositories.backstage_repository,
    null_resource.wait_org_custom_properties
  ]
}

resource "github_repository_custom_property" "reusable_workflows_service_tier" {
  count = (var.enable_custom_properties && !var.custom_properties_non_fatal_404) ? 1 : 0

  repository     = module.repositories.reusable_workflows_repository.name
  property_name  = "service-tier"
  property_type  = "single_select"
  property_value = ["tier-1"]

  depends_on = [
    module.repositories.reusable_workflows_repository,
    null_resource.wait_org_custom_properties
  ]
}

resource "github_repository_custom_property" "reusable_workflows_team_owner" {
  count = (var.enable_custom_properties && !var.custom_properties_non_fatal_404) ? 1 : 0

  repository     = module.repositories.reusable_workflows_repository.name
  property_name  = "team-owner"
  property_type  = "string"
  property_value = ["platform-team"]

  depends_on = [
    module.repositories.reusable_workflows_repository,
    null_resource.wait_org_custom_properties
  ]
}
