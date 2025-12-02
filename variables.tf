# GitHub Organization Variables
variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

# GitHub App Authentication Variables
variable "github_app_id" {
  description = "GitHub App ID for authentication"
  type        = string
  sensitive   = true
}

variable "backstage_app_id" {
  description = "Backstage GitHub App ID for authentication. This is important because if you don't provide it, Backstage won't be able to push content to the repositories it creates because of the rulesets."
  type        = string
  sensitive   = true
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID for the organization"
  type        = string
  sensitive   = true
}

variable "github_app_private_key" {
  description = "GitHub App private key content (PEM format)"
  type        = string
  sensitive   = true

  validation {
    condition     = var.github_app_private_key != ""
    error_message = "The github_app_private_key variable must be provided with the GitHub App private key content."
  }
}

# GitHub Security Configuration Variables
variable "default_security_configuration_name" {
  description = "Name of the code security configuration to set as default for the organization"
  type        = string
  default     = "GitHub recommended"

  validation {
    condition     = length(var.default_security_configuration_name) > 0
    error_message = "The default_security_configuration_name must not be empty."
  }
}

variable "default_security_configuration_scope" {
  description = "Scope for the default security configuration (public, private, or public_and_private)"
  type        = string
  default     = "all"

  validation {
    condition = contains([
      "all",
      "none",
      "public",
      "private_and_internal"
    ], var.default_security_configuration_scope)
    error_message = "The default_security_configuration_scope must be one of: public, private, public_and_private."
  }
}

# Team Configuration Variables
variable "parent_team_name" {
  description = "Name of the parent team for all sub-teams"
  type        = string
  default     = "canary-trips"
}

variable "platform_team_members" {
  description = "List of platform team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "platform_team_maintainers" {
  description = "List of platform team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "template_approvers_members" {
  description = "List of template approvers team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

# New: Template approvers maintainers (users with elevated rights on the team)
variable "template_approvers_maintainers" {
  description = "List of template approvers team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "security_team_members" {
  description = "List of security team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "read_only_team_members" {
  description = "List of read-only team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

# Developers Team Variables
variable "developers_team_maintainers" {
  description = "List of developers team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}

# Repository Configuration Variables
variable "template_repositories" {
  description = "Map of template repositories to create"
  type = map(object({
    description = string
    topics      = list(string)
    type        = string
  }))
  default = {
    "backstage-template-system" = {
      description = "Backstage template for System entities"
      topics      = ["backstage", "template", "catalog", "system"]
      type        = "system"
    }
    "backstage-template-domain" = {
      description = "Backstage template for Domain entities"
      topics      = ["backstage", "template", "catalog", "domain"]
      type        = "domain"
    }
    "backstage-template-node-service" = {
      description = "Backstage template for Node.js services"
      topics      = ["backstage", "template", "nodejs", "service"]
      type        = "service"
    }
    "backstage-template-fastapi-service" = {
      description = "Backstage template for FastAPI services"
      topics      = ["backstage", "template", "fastapi", "python", "service"]
      type        = "service"
    }
    "backstage-template-dotnet-service" = {
      description = "Backstage template for .NET services"
      topics      = ["backstage", "template", "dotnet", "csharp", "service"]
      type        = "service"
    }
    "backstage-template-ai-assistant" = {
      description = "Backstage template for AI Assistant services"
      topics      = ["backstage", "template", "ai", "assistant", "service"]
      type        = "service"
    }
    "backstage-template-mcp-server-node" = {
      description = "Backstage template for MCP Server in Node.js"
      topics      = ["backstage", "template", "nodejs", "mcp", "service"]
      type        = "service"
    }
    "backstage-template-astro-frontend" = {
      description = "Backstage template for Astro frontend applications"
      topics      = ["backstage", "template", "astro", "frontend"]
      type        = "website"
    }
    "backstage-template-electron-desktop-app" = {
      description = "Backstage template for Electron desktop applications"
      topics      = ["backstage", "template", "electron", "desktop", "app"]
      type        = "app"
    }
    "backstage-template-kubernetes-gitops" = {
      description = "Backstage template for Kubernetes GitOps repositories"
      topics      = ["backstage", "template", "kubernetes", "gitops", "infrastructure"]
      type        = "infrastructure"
    }
    "backstage-template-vue-frontend" = {
      description = "Backstage template for Vue.js frontend applications"
      topics      = ["backstage", "template", "vue", "vuejs", "frontend"]
      type        = "website"
    }
  }
}

# Required workflows Configuration
variable "required_workflows_repository" {
  description = "Centralized repository for required GitHub Actions workflows"
  type = object({
    name        = string
    description = string
    topics      = list(string)
  })
  default = {
    name        = "required-workflows"
    description = "Centralized repository for required GitHub Actions workflows"
    topics      = ["github-actions", "workflows", "ci-cd", "required"]
  }
}

# Reusable Workflows Repository Configuration
variable "reusable_workflows_repository" {
  description = "Configuration for the reusable workflows repository"
  type = object({
    name        = string
    description = string
    topics      = list(string)
  })
  default = {
    name        = "reusable-workflows"
    description = "Centralized repository for reusable GitHub Actions workflows"
    topics      = ["github-actions", "workflows", "ci-cd", "reusable"]
  }
}

# Branch Protection Variables
variable "required_status_checks" {
  description = "List of required status checks for branch protection"
  type        = list(string)
  default     = ["ci-template", "lint", "docs-build"]
}

variable "required_pull_request_reviews" {
  description = "Number of required pull request reviews"
  type        = number
  default     = 1
}

# Feature toggle: manage workflow files (.github/workflows)
variable "manage_workflow_files" {
  description = "Whether to manage CI workflow files in template repositories. Set false if the GitHub App lacks Actions: Read & write temporarily."
  type        = bool
  default     = true
}

# Optional: Organization Codespaces access control
variable "enable_codespaces_org_access" {
  description = "Enable managing organization-wide Codespaces access via GitHub REST API (requires appropriate token permissions)."
  type        = bool
  default     = false
}

variable "codespaces_visibility" {
  description = "Who can access Codespaces in the organization. One of: disabled, selected_members, all_members, all_members_and_outside_collaborators"
  type        = string
  default     = "all_members"

  validation {
    condition = contains([
      "disabled",
      "selected_members",
      "all_members",
      "all_members_and_outside_collaborators"
    ], var.codespaces_visibility)
    error_message = "codespaces_visibility must be one of: disabled, selected_members, all_members, all_members_and_outside_collaborators."
  }
}

variable "codespaces_selected_usernames" {
  description = "Usernames to grant Codespaces access when visibility = selected_members. Ignored otherwise."
  type        = list(string)
  default     = []
}

# Organization Security Settings Variables
variable "advanced_security_enabled_for_new_repositories" {
  description = "Whether or not GitHub Advanced Security is enabled for new repositories by default"
  type        = bool
  default     = true
}

# Custom Properties Configuration
variable "enable_custom_properties" {
  description = "Enable managing organization-wide custom properties via GitHub REST API (requires appropriate token permissions)."
  type        = bool
  default     = true
}

variable "dependabot_alerts_enabled_for_new_repositories" {
  description = "Whether or not Dependabot alerts are enabled for new repositories by default"
  type        = bool
  default     = true
}

variable "dependabot_security_updates_enabled_for_new_repositories" {
  description = "Whether or not Dependabot security updates are enabled for new repositories by default"
  type        = bool
  default     = true
}

variable "dependency_graph_enabled_for_new_repositories" {
  description = "Whether or not dependency graph is enabled for new repositories by default"
  type        = bool
  default     = true
}

variable "secret_scanning_enabled_for_new_repositories" {
  description = "Whether or not secret scanning is enabled for new repositories by default"
  type        = bool
  default     = true
}

variable "secret_scanning_push_protection_enabled_for_new_repositories" {
  description = "Whether or not secret scanning push protection is enabled for new repositories by default"
  type        = bool
  default     = true
}

# Organization billing email (required for organization settings)
variable "github_organization_billing_email" {
  description = "Billing email address for the GitHub organization"
  type        = string
  default     = ""
}
variable "organization_custom_properties" {
  description = "Map of custom properties to create at organization level"
  type = map(object({
    description    = string
    property_type  = string # string, single_select, multi_select, true_false
    required       = bool
    default_value  = optional(string)
    allowed_values = optional(list(string))
  }))
  default = {
    "service-tier" = {
      description    = "Service tier classification for operational support"
      property_type  = "single_select"
      required       = true
      default_value  = "tier-1"
      allowed_values = ["tier-1", "tier-2", "tier-3", "experimental"]
    }
    "team-owner" = {
      description   = "Team responsible for maintaining this repository"
      property_type = "string"
      required      = true
      default_value = "platform-team"
    }
    "demo" = {
      description    = "Indicates if the repository is for demonstration purposes"
      property_type  = "single_select"
      required       = false
      allowed_values = ["yes", "no"]
    }
  }
}

variable "custom_properties_non_fatal_404" {
  description = "If true, a 404 when calling the custom properties API (feature not enabled / permission missing) will be treated as a warning and not fail the apply."
  type        = bool
  default     = true
}

variable "template_repository_custom_properties" {
  description = "Default custom property values for template repositories"
  type = map(object({
    service_tier = string
    team_owner   = string
  }))
  default = {
    "backstage-template-system" = {
      service_tier = "tier-2"
      team_owner   = "platform-team"
    }
    "backstage-template-domain" = {
      service_tier = "tier-2"
      team_owner   = "platform-team"
    }
    "backstage-template-node-service" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
    "backstage-template-fastapi-service" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
    "backstage-template-dotnet-service" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
    "backstage-template-ai-assistant" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
    "backstage-template-mcp-server-node" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
    "backstage-template-astro-frontend" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
    "backstage-template-electron-desktop-app" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
    "backstage-template-kubernetes-gitops" = {
      service_tier = "tier-2"
      team_owner   = "platform-team"
    }
    "backstage-template-vue-frontend" = {
      service_tier = "tier-3"
      team_owner   = "platform-team"
    }
  }
}
