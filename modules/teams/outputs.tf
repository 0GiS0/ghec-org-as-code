# Outputs for the teams module

output "teams" {
  description = "Map of all created teams"
  value = {
    parent             = github_team.parent
    platform           = github_team.platform
    template_approvers = github_team.template_approvers
    security           = github_team.security
    read_only          = github_team.read_only
    developers         = github_team.developers
  }
}

output "team_ids" {
  description = "Map of team IDs"
  value = {
    parent             = github_team.parent.id
    platform           = github_team.platform.id
    template_approvers = github_team.template_approvers.id
    security           = github_team.security.id
    read_only          = github_team.read_only.id
    developers         = github_team.developers.id
  }
}