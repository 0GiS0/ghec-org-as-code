# Variables for the teams module

variable "parent_team_name" {
  description = "Name of the parent team for all sub-teams"
  type        = string
}

variable "team_names" {
  description = "Map of team names"
  type = object({
    parent             = string
    platform           = string
    template_approvers = string
    security           = string
    read_only          = string
    developers         = string
  })
}

variable "platform_team_members" {
  description = "List of platform team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "platform_team_maintainers" {
  description = "List of platform team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "template_approvers_members" {
  description = "List of template approvers team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "template_approvers_maintainers" {
  description = "List of template approvers team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "security_team_members" {
  description = "List of security team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "security_team_maintainers" {
  description = "List of security team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "read_only_team_members" {
  description = "List of read-only team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "read_only_team_maintainers" {
  description = "List of read-only team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "developers_team_members" {
  description = "List of developers team members (GitHub usernames)"
  type        = list(string)
  default     = []
}

variable "developers_team_maintainers" {
  description = "List of developers team maintainers (GitHub usernames)"
  type        = list(string)
  default     = []
}