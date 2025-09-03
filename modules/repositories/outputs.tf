# Outputs for the repositories module

output "template_repositories" {
  description = "Map of created template repositories"
  value       = github_repository.templates
}

output "backstage_repository" {
  description = "The main Backstage repository"
  value       = github_repository.backstage
}

output "reusable_workflows_repository" {
  description = "The reusable workflows repository"
  value       = github_repository.reusable_workflows
}

output "template_repository_names" {
  description = "List of template repository names"
  value       = [for repo in github_repository.templates : repo.name]
}

output "template_repository_names_map" {
  description = "Map of template repository names"
  value       = { for key, repo in github_repository.templates : key => repo.name }
}