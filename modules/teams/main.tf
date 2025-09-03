# Teams Module - GitHub Team Management
# This module manages all GitHub teams and their relationships

# Parent team
resource "github_team" "parent" {
  name                      = var.parent_team_name
  description               = "Parent team for all organizational teams"
  privacy                   = "closed"
  create_default_maintainer = false
}

# Platform team (sub-team of parent)
resource "github_team" "platform" {
  name                      = var.team_names.platform
  description               = "Platform Engineering team - responsible for infrastructure, CI/CD, and developer tools"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Template approvers team (sub-team of parent)
resource "github_team" "template_approvers" {
  name                      = var.team_names.template_approvers
  description               = "Team responsible for reviewing and approving Backstage template changes"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Security team (sub-team of parent)
resource "github_team" "security" {
  name                      = var.team_names.security
  description               = "Security team - responsible for security reviews and compliance"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Read-only team (sub-team of parent)
resource "github_team" "read_only" {
  name                      = var.team_names.read_only
  description               = "Read-only access team for auditing and monitoring"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Developers team (sub-team of parent)
resource "github_team" "developers" {
  name                      = var.team_names.developers
  description               = "Application developers team"
  privacy                   = "closed"
  parent_team_id            = github_team.parent.id
  create_default_maintainer = false
}

# Team memberships
resource "github_team_membership" "platform_members" {
  for_each = toset(var.platform_team_members)

  team_id  = github_team.platform.id
  username = each.value
  role     = "member"
}

resource "github_team_membership" "platform_maintainers" {
  for_each = toset(var.platform_team_maintainers)

  team_id  = github_team.platform.id
  username = each.value
  role     = "maintainer"
}

resource "github_team_membership" "template_approvers_members" {
  for_each = toset(var.template_approvers_members)

  team_id  = github_team.template_approvers.id
  username = each.value
  role     = "member"
}

resource "github_team_membership" "template_approvers_maintainers" {
  for_each = toset(var.template_approvers_maintainers)

  team_id  = github_team.template_approvers.id
  username = each.value
  role     = "maintainer"
}

resource "github_team_membership" "security_members" {
  for_each = toset(var.security_team_members)

  team_id  = github_team.security.id
  username = each.value
  role     = "member"
}

resource "github_team_membership" "security_maintainers" {
  for_each = toset(var.security_team_maintainers)

  team_id  = github_team.security.id
  username = each.value
  role     = "maintainer"
}

resource "github_team_membership" "read_only_members" {
  for_each = toset(var.read_only_team_members)

  team_id  = github_team.read_only.id
  username = each.value
  role     = "member"
}

resource "github_team_membership" "read_only_maintainers" {
  for_each = toset(var.read_only_team_maintainers)

  team_id  = github_team.read_only.id
  username = each.value
  role     = "maintainer"
}

resource "github_team_membership" "developers_members" {
  for_each = toset(var.developers_team_members)

  team_id  = github_team.developers.id
  username = each.value
  role     = "member"
}

resource "github_team_membership" "developers_maintainers" {
  for_each = toset(var.developers_team_maintainers)

  team_id  = github_team.developers.id
  username = each.value
  role     = "maintainer"
}