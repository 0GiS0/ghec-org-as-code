# GitHub Organization Default Security Configuration
# This resource sets a specific security configuration as default for new repositories
# Uses the GitHub REST API since this functionality is not available in the Terraform GitHub provider

resource "null_resource" "github_default_security_config" {
  # This resource will re-run if the script changes, variables change, or on manual trigger
  triggers = {
    script_hash  = filemd5("${path.module}/scripts/terraform-integration/set_default_security_config.sh")
    organization = var.github_organization
    config_name  = var.default_security_configuration_name
    config_scope = var.default_security_configuration_scope
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/terraform-integration/set_default_security_config.sh \"${var.default_security_configuration_name}\" \"${var.default_security_configuration_scope}\""

    environment = {
      GITHUB_ORGANIZATION        = var.github_organization
      GITHUB_APP_ID              = var.github_app_id
      GITHUB_APP_INSTALLATION_ID = var.github_app_installation_id
      GITHUB_APP_PRIVATE_KEY     = var.github_app_private_key
    }

    # Use interpreter to ensure proper shell execution
    interpreter = ["/bin/bash", "-c"]
  }

  # Ensure this runs after organization settings are configured
  depends_on = [
    github_organization_settings.org_settings
  ]
}

# Output information about the security configuration setup
output "github_default_security_config" {
  description = "Information about the default security configuration setup"
  value = {
    enabled             = true
    script_location     = "${path.module}/scripts/terraform-integration/set_default_security_config.sh"
    organization        = var.github_organization
    configuration_name  = var.default_security_configuration_name
    configuration_scope = var.default_security_configuration_scope
    last_updated        = null
  }
}

