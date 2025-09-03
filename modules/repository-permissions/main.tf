# Repository Permissions Module - Team Access and Branch Protection
# This module manages team repository permissions and branch protection rules

# Team repository permissions for template repositories
resource "github_team_repository" "platform_admin" {
  for_each = var.template_repositories

  team_id    = var.team_ids.platform
  repository = var.repository_names[each.key]
  permission = "admin"
}

resource "github_team_repository" "template_approvers_maintain" {
  for_each = var.template_repositories

  team_id    = var.team_ids.template_approvers
  repository = var.repository_names[each.key]
  permission = "maintain"
}

resource "github_team_repository" "security_pull" {
  for_each = var.template_repositories

  team_id    = var.team_ids.security
  repository = var.repository_names[each.key]
  permission = "pull"
}

resource "github_team_repository" "read_only_pull" {
  for_each = var.template_repositories

  team_id    = var.team_ids.read_only
  repository = var.repository_names[each.key]
  permission = "pull"
}

# Team repository permissions for Backstage repository
resource "github_team_repository" "backstage_platform_admin" {
  team_id    = var.team_ids.platform
  repository = var.backstage_repository_name
  permission = "admin"
}

resource "github_team_repository" "backstage_template_approvers_maintain" {
  team_id    = var.team_ids.template_approvers
  repository = var.backstage_repository_name
  permission = "maintain"
}

resource "github_team_repository" "backstage_security_pull" {
  team_id    = var.team_ids.security
  repository = var.backstage_repository_name
  permission = "pull"
}

resource "github_team_repository" "backstage_read_only_pull" {
  team_id    = var.team_ids.read_only
  repository = var.backstage_repository_name
  permission = "pull"
}

# Team repository permissions for reusable workflows repository
resource "github_team_repository" "reusable_workflows_platform_admin" {
  team_id    = var.team_ids.platform
  repository = var.reusable_workflows_repository_name
  permission = "admin"
}

resource "github_team_repository" "reusable_workflows_template_approvers_maintain" {
  team_id    = var.team_ids.template_approvers
  repository = var.reusable_workflows_repository_name
  permission = "maintain"
}

resource "github_team_repository" "reusable_workflows_security_pull" {
  team_id    = var.team_ids.security
  repository = var.reusable_workflows_repository_name
  permission = "pull"
}

resource "github_team_repository" "reusable_workflows_read_only_pull" {
  team_id    = var.team_ids.read_only
  repository = var.reusable_workflows_repository_name
  permission = "pull"
}