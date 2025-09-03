# Variables for the repositories module

variable "template_repositories" {
  description = "Map of template repositories to create"
  type = map(object({
    description = string
    topics      = list(string)
    type        = string
  }))
}

variable "backstage_repository" {
  description = "Configuration for the main Backstage repository"
  type = object({
    name        = string
    description = string
    topics      = list(string)
  })
}

variable "reusable_workflows_repository" {
  description = "Configuration for the reusable workflows repository"
  type = object({
    name        = string
    description = string
    topics      = list(string)
  })
}

variable "common_topics" {
  description = "Common topics to apply to all repositories"
  type        = list(string)
  default     = []
}