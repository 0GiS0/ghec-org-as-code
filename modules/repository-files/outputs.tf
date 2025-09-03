# Outputs for the repository-files module

output "template_files_created" {
  description = "Map of template.yaml files created"
  value       = github_repository_file.template_yaml
}

output "skeleton_files_count" {
  description = "Count of skeleton files created"
  value = length([
    for file in merge(
      github_repository_file.skeleton_docs_index,
      github_repository_file.skeleton_catalog_info,
      github_repository_file.skeleton_codeowners
    ) : file.id
  ])
}