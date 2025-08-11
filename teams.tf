# Team Definitions
# This file contains all team configurations for the GHEC organization

# Parent team: canary-trips
resource "github_team" "parent" {
  name                      = local.team_names.parent
  description               = "Parent team for all platform and development teams"
  privacy                   = "closed"
  create_default_maintainer = false
}

# Platform team - maintainers of infrastructure
resource "github_team" "platform" {
  name                      = local.team_names.platform
  description               = "Platform team responsible for infrastructure and tooling"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Template approvers - review template changes
resource "github_team" "template_approvers" {
  name                      = local.team_names.template_approvers
  description               = "Team responsible for reviewing and approving template changes"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Security team - security reviews
resource "github_team" "security" {
  name                      = local.team_names.security
  description               = "Security team for security reviews and compliance"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Read-only team - auditing access
resource "github_team" "read_only" {
  name                      = local.team_names.read_only
  description               = "Read-only access team for auditing and monitoring"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Team memberships for platform team
resource "github_team_membership" "platform_maintainers" {
  count    = length(var.platform_team_maintainers)
  team_id  = github_team.platform.id
  username = var.platform_team_maintainers[count.index]
  role     = "maintainer"
}

resource "github_team_membership" "platform_members" {
  count    = length(var.platform_team_members)
  team_id  = github_team.platform.id
  username = var.platform_team_members[count.index]
  role     = "member"
}

# Team memberships for template approvers
resource "github_team_membership" "template_approvers_members" {
  count    = length(var.template_approvers_members)
  team_id  = github_team.template_approvers.id
  username = var.template_approvers_members[count.index]
  role     = "member"
}

# Team memberships for security team
resource "github_team_membership" "security_members" {
  count    = length(var.security_team_members)
  team_id  = github_team.security.id
  username = var.security_team_members[count.index]
  role     = "member"
}

# Team memberships for read-only team
resource "github_team_membership" "read_only_members" {
  count    = length(var.read_only_team_members)
  team_id  = github_team.read_only.id
  username = var.read_only_team_members[count.index]
  role     = "member"
}