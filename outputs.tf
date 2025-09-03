# Outputs for GHEC Organization as Code
# This file contains outputs from the main configuration using modules

# Summary for quick overview
output "summary" {
  description = "Quick summary of all created resources"
  value = {
    teams_count           = length(module.teams.team_ids)
    template_repositories = length(module.repositories.template_repository_names)
    total_repositories    = length(module.repositories.template_repository_names) + 2 # +2 for backstage and workflows
    organization          = var.github_organization
  }
}