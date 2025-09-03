# Variables for the repository-permissions module

variable "template_repositories" {
  description = "Map of template repositories"
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

variable "backstage_repository_name" {
  description = "Name of the Backstage repository"
  type        = string
}

variable "reusable_workflows_repository_name" {
  description = "Name of the reusable workflows repository"
  type        = string
}

variable "team_ids" {
  description = "Map of team IDs from the teams module"
  type = object({
    parent             = number
    platform           = number
    template_approvers = number
    security           = number
    read_only          = number
    developers         = number
  })
}