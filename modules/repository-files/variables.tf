# Variables for the repository-files module

variable "template_repositories" {
  description = "Map of template repositories configuration"
  type = map(object({
    description = string
    topics      = list(string)
    type        = string
  }))
}

variable "repository_names" {
  description = "Map of repository names from the repositories module"
  type        = map(string)
}

variable "github_organization" {
  description = "GitHub organization name for commit emails"
  type        = string
}

variable "template_repositories_dependency" {
  description = "Dependency to ensure repositories are created first"
  type        = any
}