# Outputs for the GHEC Organization as Code configuration

# Organization information
output "organization_name" {
  description = "GitHub organization name"
  value       = data.github_organization.current.orgname
}

output "organization_url" {
  description = "GitHub organization URL"
  value       = "https://github.com/${data.github_organization.current.orgname}"
}

# Team information
output "teams" {
  description = "Created teams information"
  value = {
    parent = {
      id   = github_team.parent.id
      name = github_team.parent.name
      slug = github_team.parent.slug
      url  = "https://github.com/orgs/${var.github_organization}/teams/${github_team.parent.slug}"
    }
    platform = {
      id   = github_team.platform.id
      name = github_team.platform.name
      slug = github_team.platform.slug
      url  = "https://github.com/orgs/${var.github_organization}/teams/${github_team.platform.slug}"
    }
    template_approvers = {
      id   = github_team.template_approvers.id
      name = github_team.template_approvers.name
      slug = github_team.template_approvers.slug
      url  = "https://github.com/orgs/${var.github_organization}/teams/${github_team.template_approvers.slug}"
    }
    security = {
      id   = github_team.security.id
      name = github_team.security.name
      slug = github_team.security.slug
      url  = "https://github.com/orgs/${var.github_organization}/teams/${github_team.security.slug}"
    }
    read_only = {
      id   = github_team.read_only.id
      name = github_team.read_only.name
      slug = github_team.read_only.slug
      url  = "https://github.com/orgs/${var.github_organization}/teams/${github_team.read_only.slug}"
    }
  }
}

# Template repositories information
output "template_repositories" {
  description = "Created template repositories information"
  value = {
    for k, v in github_repository.templates : k => {
      id          = v.id
      name        = v.name
      full_name   = v.full_name
      description = v.description
      url         = v.html_url
      clone_url   = v.http_clone_url
      ssh_url     = v.ssh_clone_url
      topics      = v.topics
      visibility  = v.visibility
    }
  }
}

# Repository URLs for quick access
output "repository_urls" {
  description = "Template repository URLs for quick access"
  value = {
    for k, v in github_repository.templates : k => v.html_url
  }
}

# Team memberships summary
output "team_memberships_summary" {
  description = "Summary of team memberships"
  value = {
    platform_maintainers           = var.platform_team_maintainers
    platform_members               = var.platform_team_members
    template_approvers_maintainers = var.template_approvers_maintainers
    template_approvers             = var.template_approvers_members
    security_members               = var.security_team_members
    read_only_members              = var.read_only_team_members
  }
}

# Backstage IDP repository information
output "backstage_repository" {
  description = "Backstage IDP repository information"
  value = {
    id          = github_repository.backstage.id
    name        = github_repository.backstage.name
    full_name   = github_repository.backstage.full_name
    description = github_repository.backstage.description
    url         = github_repository.backstage.html_url
    clone_url   = github_repository.backstage.http_clone_url
    ssh_url     = github_repository.backstage.ssh_clone_url
    topics      = github_repository.backstage.topics
    visibility  = github_repository.backstage.visibility
  }
}

# Organization security settings
output "organization_security_settings" {
  description = "GitHub Advanced Security settings for new repositories"
  value = {
    advanced_security_enabled               = var.advanced_security_enabled_for_new_repositories
    dependabot_alerts_enabled               = var.dependabot_alerts_enabled_for_new_repositories
    dependabot_security_updates_enabled     = var.dependabot_security_updates_enabled_for_new_repositories
    dependency_graph_enabled                = var.dependency_graph_enabled_for_new_repositories
    secret_scanning_enabled                 = var.secret_scanning_enabled_for_new_repositories
    secret_scanning_push_protection_enabled = var.secret_scanning_push_protection_enabled_for_new_repositories
  }

# Custom Properties information
output "organization_custom_properties" {
  description = "Organization custom properties configuration"
  value = var.enable_custom_properties ? {
    enabled    = var.enable_custom_properties
    properties = var.organization_custom_properties
  } : null
}

output "template_repositories_custom_properties" {
  description = "Custom properties applied to template repositories"
  value       = var.enable_custom_properties ? var.template_repository_custom_properties : null
}