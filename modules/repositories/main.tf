# Repository Module - Template Repositories
# This module manages repository definitions and settings

# Template repositories
resource "github_repository" "templates" {
  for_each = var.template_repositories

  name        = each.key
  description = each.value.description
  visibility  = "private"
  auto_init   = true

  # Repository topics
  topics = concat(each.value.topics, var.common_topics)

  # Template repository settings
  is_template            = true
  allow_merge_commit     = false
  allow_squash_merge     = true
  allow_rebase_merge     = false
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  has_downloads          = false
  vulnerability_alerts   = true

  # Security settings
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
    advanced_security {
      status = "enabled"
    }
  }
}

# Main Backstage IDP Repository
resource "github_repository" "backstage" {
  name        = var.backstage_repository.name
  description = var.backstage_repository.description
  visibility  = "private"
  auto_init   = true

  # Repository topics
  topics = concat(var.backstage_repository.topics, var.common_topics)

  # Repository settings
  allow_merge_commit     = false
  allow_squash_merge     = true
  allow_rebase_merge     = false
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  has_downloads          = false
  vulnerability_alerts   = true

  # Security settings
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
    advanced_security {
      status = "enabled"
    }
  }
}

# Reusable Workflows Repository
resource "github_repository" "reusable_workflows" {
  name        = var.reusable_workflows_repository.name
  description = var.reusable_workflows_repository.description
  visibility  = "private"
  auto_init   = true

  # Repository topics
  topics = concat(var.reusable_workflows_repository.topics, var.common_topics)

  # Repository settings
  allow_merge_commit     = false
  allow_squash_merge     = true
  allow_rebase_merge     = false
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  has_downloads          = false
  vulnerability_alerts   = true

  # Security settings
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
    advanced_security {
      status = "enabled"
    }
  }
}

# Actions repository access level
resource "github_actions_repository_access_level" "reusable_workflows" {
  access_level = "organization"
  repository   = github_repository.reusable_workflows.name
}