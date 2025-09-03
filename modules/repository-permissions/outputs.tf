# Outputs for the repository-permissions module

output "branch_protections" {
  description = "Map of created branch protections"
  value = {
    templates           = github_branch_protection.main
    backstage          = github_branch_protection.backstage_main
    reusable_workflows = github_branch_protection.reusable_workflows_main
  }
}

output "team_permissions_count" {
  description = "Count of team repository permissions created"
  value = length([
    for perm in merge(
      github_team_repository.platform_admin,
      github_team_repository.template_approvers_maintain,
      github_team_repository.security_pull,
      github_team_repository.read_only_pull
    ) : perm.id
  ])
}