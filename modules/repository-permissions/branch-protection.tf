# Repository Permissions Module - Branch Protection Rules
# This module manages branch protection for all repositories

# Branch protection for template repositories
resource "github_branch_protection" "main" {
  for_each = var.template_repositories

  repository_id = var.repository_names[each.key]
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["ci-template", "lint", "docs-build", "codeql"]
  }

  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
  }

  enforce_admins = false

  allows_deletions    = false
  allows_force_pushes = false
}

# Branch protection for Backstage repository
resource "github_branch_protection" "backstage_main" {
  repository_id = var.backstage_repository_name
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["ci", "lint", "test", "security-scan"]
  }

  required_pull_request_reviews {
    required_approving_review_count = 2
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
  }

  enforce_admins = false

  allows_deletions    = false
  allows_force_pushes = false
}

# Branch protection for reusable workflows repository
resource "github_branch_protection" "reusable_workflows_main" {
  repository_id = var.reusable_workflows_repository_name
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["lint", "validate", "security-scan"]
  }

  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
  }

  enforce_admins = false

  allows_deletions    = false
  allows_force_pushes = false
}