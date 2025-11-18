# Repository Definitions

# Template repositories
resource "github_repository" "templates" {
  for_each = var.template_repositories

  name        = each.key
  description = each.value.description
  visibility  = "private"
  auto_init   = true

  # Repository topics
  topics = concat(each.value.topics, local.common_topics)

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
  # security_and_analysis {
  #   secret_scanning {
  #     status = "enabled"
  #   }
  #   secret_scanning_push_protection {
  #     status = "disabled"
  #   }
  #   advanced_security {
  #     status = "disabled"
  #   }
  # }
}


# Reusable Workflows Repository
resource "github_repository" "reusable_workflows" {
  name        = var.reusable_workflows_repository.name
  description = var.reusable_workflows_repository.description
  visibility  = "private"
  auto_init   = true

  # Repository topics
  topics = concat(var.reusable_workflows_repository.topics, local.common_topics)

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
  # security_and_analysis {
  #   secret_scanning {
  #     status = "disabled"
  #   }
  #   secret_scanning_push_protection {
  #     status = "disabled"
  #   }
  #   advanced_security {
  #     status = "disabled"
  #   }
  # }
}

# Enable organization-wide access for reusable workflows
resource "github_actions_repository_access_level" "reusable_workflows" {
  repository   = github_repository.reusable_workflows.name
  access_level = "organization"
}

# Enable organization-wide access for required-workflows so its reusable workflows
# can be referenced by other repositories (prevents 'actions sharing disabled' errors)
resource "github_actions_repository_access_level" "required_workflows" {
  repository   = github_repository.required_workflows.name
  access_level = "organization"
}

# Repository collaborators - Team permissions
resource "github_team_repository" "platform_admin" {
  for_each = var.template_repositories

  team_id    = github_team.platform.id
  repository = github_repository.templates[each.key].name
  permission = local.repository_permissions.platform_team
}

resource "github_team_repository" "template_approvers_maintain" {
  for_each = var.template_repositories

  team_id    = github_team.template_approvers.id
  repository = github_repository.templates[each.key].name
  permission = local.repository_permissions.template_approvers
}

resource "github_team_repository" "security_pull" {
  for_each = var.template_repositories

  team_id    = github_team.security.id
  repository = github_repository.templates[each.key].name
  permission = local.repository_permissions.security
}

resource "github_team_repository" "read_only_pull" {
  for_each = var.template_repositories

  team_id    = github_team.read_only.id
  repository = github_repository.templates[each.key].name
  permission = local.repository_permissions.read_only
}

# Reusable Workflows Repository - Team permissions
resource "github_team_repository" "reusable_workflows_platform_admin" {
  team_id    = github_team.platform.id
  repository = github_repository.reusable_workflows.name
  permission = local.repository_permissions.platform_team
}

resource "github_team_repository" "reusable_workflows_template_approvers_maintain" {
  team_id    = github_team.template_approvers.id
  repository = github_repository.reusable_workflows.name
  permission = local.repository_permissions.template_approvers
}

resource "github_team_repository" "reusable_workflows_security_pull" {
  team_id    = github_team.security.id
  repository = github_repository.reusable_workflows.name
  permission = local.repository_permissions.security
}

resource "github_team_repository" "reusable_workflows_read_only_pull" {
  team_id    = github_team.read_only.id
  repository = github_repository.reusable_workflows.name
  permission = local.repository_permissions.read_only
}

# Branch protection rules for main branch
resource "github_branch_protection" "main" {
  for_each = var.template_repositories

  repository_id  = github_repository.templates[each.key].name
  pattern        = "main"
  enforce_admins = false

  # Ensure required files/workflows exist before enforcing protection
  depends_on = [
    github_repository_file.codeowners,
    github_repository_file.template_ci
  ]

  required_status_checks {
    strict   = true
    contexts = ["ci-template", "lint", "docs-build"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
    restrict_dismissals             = false
  }

  # Block force pushes
  allows_force_pushes = false
  allows_deletions    = false
}

# Branch protection rules for reusable workflows repository main branch
resource "github_branch_protection" "reusable_workflows_main" {
  repository_id  = github_repository.reusable_workflows.name
  pattern        = "main"
  enforce_admins = false

  # Ensure required files are created before protection
  depends_on = [
    github_repository_file.reusable_workflows_codeowners,
    github_repository_file.reusable_workflows_readme
  ]

  required_status_checks {
    strict   = true
    contexts = ["ci", "lint", "docs-build", "codeql"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 2
    restrict_dismissals             = false
  }

  # Block force pushes
  allows_force_pushes = false
  allows_deletions    = false
}



# Required Workflows Repository
resource "github_repository" "required_workflows" {
  name        = var.required_workflows_repository.name
  description = var.required_workflows_repository.description
  visibility  = "private"
  auto_init   = true

  # Repository topics
  topics = concat(var.required_workflows_repository.topics, local.common_topics)

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
  # security_and_analysis {
  #   secret_scanning {
  #     status = "disabled"
  #   }
  #   secret_scanning_push_protection {
  #     status = "disabled"
  #   }
  #   advanced_security {
  #     status = "disabled"
  #   }
  # }
}

# Organization-wide configuration repository
resource "github_repository" "github_config" {
  name        = ".github"
  description = "Organization-wide GitHub configuration, agents, and shared workflows"
  visibility  = "private"
  auto_init   = true

  # Repository topics
  topics = concat(["ghec", "config", "agents", "terraform"], local.common_topics)

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
}
