// Main configuration file for GHEC Organization as Code
// This file serves as the entry point and orchestrates all modules

// Data source to get current organization information
data "github_organization" "current" {
  name = var.github_organization
}

// Organization security settings
resource "github_organization_settings" "org_settings" {
  # Required fields
  billing_email = var.github_organization_billing_email

  # Security settings for new repositories
  advanced_security_enabled_for_new_repositories               = var.advanced_security_enabled_for_new_repositories
  dependabot_alerts_enabled_for_new_repositories               = var.dependabot_alerts_enabled_for_new_repositories
  dependabot_security_updates_enabled_for_new_repositories     = var.dependabot_security_updates_enabled_for_new_repositories
  dependency_graph_enabled_for_new_repositories                = var.dependency_graph_enabled_for_new_repositories
  secret_scanning_enabled_for_new_repositories                 = var.secret_scanning_enabled_for_new_repositories
  secret_scanning_push_protection_enabled_for_new_repositories = var.secret_scanning_push_protection_enabled_for_new_repositories
}

// Local values for reusable configurations
locals {
  // Common tags for all resources
  common_topics = ["ghec", "terraform", "iac"]

  // Team names
  team_names = {
    parent             = var.parent_team_name
    platform           = "platform-team"
    template_approvers = "template-approvers"
    security           = "security"
    read_only          = "read-only"
    developers         = "cosmic-devs"
  }

  // Repository permissions for teams
  repository_permissions = {
    platform_team      = "admin"
    template_approvers = "maintain"
    security           = "pull"
    read_only          = "pull"
  }

  // Template type mapping for catalog-info.yaml
  template_type_mapping = {
    "backstage-template-system"          = "system"
    "backstage-template-domain"          = "domain"
    "backstage-template-node-service"    = "service"
    "backstage-template-fastapi-service" = "service"
    "backstage-template-dotnet-service"  = "service"
    "backstage-template-gateway"         = "service"
    "backstage-template-ai-assistant"    = "service"
    "backstage-template-astro-frontend"  = "website"
    "backstage-template-helm-base"       = "library"
    "backstage-template-env-live"        = "resource"
  }

  // Helper function to convert repository name to template name
  template_name_mapping = {
    for key, value in var.template_repositories :
    key => replace(key, "backstage-template-", "")
  }

  // Helper function to create template titles
  template_title_mapping = {
    "backstage-template-system"          = "🧩 System"
    "backstage-template-domain"          = "🏷️ Domain"
    "backstage-template-node-service"    = "🟢 Node.js Service"
    "backstage-template-fastapi-service" = "⚡ FastAPI Service"
    "backstage-template-dotnet-service"  = "🟣 .NET Service"
    "backstage-template-gateway"         = "🚦 API Gateway"
    "backstage-template-ai-assistant"    = "🤖 AI Assistant Service"
    "backstage-template-astro-frontend"  = "☄️ Astro Frontend"
    "backstage-template-helm-base"       = "⚓ Helm Chart"
    "backstage-template-env-live"        = "🌍 Environment Configuration"
  }
}

// Teams Module
module "teams" {
  source = "./modules/teams"

  parent_team_name               = var.parent_team_name
  team_names                     = local.team_names
  platform_team_members          = var.platform_team_members
  platform_team_maintainers      = var.platform_team_maintainers
  template_approvers_members     = var.template_approvers_members
  template_approvers_maintainers = var.template_approvers_maintainers
  security_team_members          = var.security_team_members
  security_team_maintainers      = var.security_team_maintainers
  read_only_team_members         = var.read_only_team_members
  read_only_team_maintainers     = var.read_only_team_maintainers
  developers_team_members        = var.developers_team_members
  developers_team_maintainers    = var.developers_team_maintainers
}

// Repositories Module
module "repositories" {
  source = "./modules/repositories"

  template_repositories         = var.template_repositories
  backstage_repository          = var.backstage_repository
  reusable_workflows_repository = var.reusable_workflows_repository
  common_topics                 = local.common_topics
}

// Repository Files Module
// Repository Files Module - COMMENTED OUT due to missing template files
// TODO: Complete template files before enabling this module
/*
module "repository_files" {
  source = "./modules/repository-files"

  template_repositories            = var.template_repositories
  repository_names                 = module.repositories.template_repository_names_map
  github_organization              = var.github_organization
  template_repositories_dependency = module.repositories.template_repositories

  depends_on = [module.repositories]
}
*/

// Repository Permissions Module
module "repository_permissions" {
  source = "./modules/repository-permissions"

  template_repositories              = var.template_repositories
  repository_names                   = module.repositories.template_repository_names_map
  backstage_repository_name          = module.repositories.backstage_repository.name
  reusable_workflows_repository_name = module.repositories.reusable_workflows_repository.name
  team_ids                           = module.teams.team_ids

  depends_on = [module.repositories, module.teams]
}
