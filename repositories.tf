# Repository Definitions
# This file contains all repository configurations for Backstage (templates and main IDP)

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
  topics = concat(var.backstage_repository.topics, local.common_topics)

  # Regular repository settings (NOT a template)
  is_template            = false
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

# Enable organization-wide access for reusable workflows
resource "github_actions_repository_access_level" "reusable_workflows" {
  repository   = github_repository.reusable_workflows.name
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

# Backstage IDP Repository - Team permissions
resource "github_team_repository" "backstage_platform_admin" {
  team_id    = github_team.platform.id
  repository = github_repository.backstage.name
  permission = local.repository_permissions.platform_team
}

resource "github_team_repository" "backstage_template_approvers_maintain" {
  team_id    = github_team.template_approvers.id
  repository = github_repository.backstage.name
  permission = local.repository_permissions.template_approvers
}

resource "github_team_repository" "backstage_security_pull" {
  team_id    = github_team.security.id
  repository = github_repository.backstage.name
  permission = local.repository_permissions.security
}

resource "github_team_repository" "backstage_read_only_pull" {
  team_id    = github_team.read_only.id
  repository = github_repository.backstage.name
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
    github_repository_file.template_ci,
    github_repository_file.catalog_info
  ]

  required_status_checks {
    strict   = true
    contexts = var.required_status_checks
  }

  required_pull_request_reviews {
    required_approving_review_count = var.required_pull_request_reviews
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    # Use node_id per provider docs to satisfy GraphQL API
    dismissal_restrictions = [
      github_team.platform.node_id,
      github_team.template_approvers.node_id
    ]
  }

  # Block force pushes
  allows_force_pushes = false
  allows_deletions    = false
}

# Branch protection rules for Backstage repository main branch
resource "github_branch_protection" "backstage_main" {
  repository_id  = github_repository.backstage.name
  pattern        = "main"
  enforce_admins = false

  # Ensure CODEOWNERS/README are created before protection
  depends_on = [
    github_repository_file.backstage_codeowners,
    github_repository_file.backstage_readme
  ]

  required_status_checks {
    strict   = true
    contexts = var.required_status_checks
  }

  required_pull_request_reviews {
    required_approving_review_count = var.required_pull_request_reviews
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    dismissal_restrictions = [
      github_team.platform.node_id,
      github_team.template_approvers.node_id
    ]
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
    github_repository_file.reusable_workflows_readme,
    github_repository_file.reusable_ci_workflow
  ]

  required_status_checks {
    strict   = true
    contexts = var.required_status_checks
  }

  required_pull_request_reviews {
    required_approving_review_count = var.required_pull_request_reviews
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    dismissal_restrictions = [
      github_team.platform.node_id,
      github_team.template_approvers.node_id
    ]
  }

  # Block force pushes
  allows_force_pushes = false
  allows_deletions    = false
}

# CODEOWNERS file for each repository
resource "github_repository_file" "codeowners" {
  for_each = var.template_repositories

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = ".github/CODEOWNERS"
  content = templatefile("${path.module}/templates/CODEOWNERS.tpl", {
    platform_team      = "@${github_team.platform.slug}"
    template_approvers = "@${github_team.template_approvers.slug}"
  })
  commit_message      = "Add CODEOWNERS file for template protection"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# CODEOWNERS file for Backstage repository
resource "github_repository_file" "backstage_codeowners" {
  repository = github_repository.backstage.name
  branch     = "main"
  file       = ".github/CODEOWNERS"
  content = templatefile("${path.module}/templates/CODEOWNERS-backstage.tpl", {
    platform_team      = "@${github_team.platform.slug}"
    template_approvers = "@${github_team.template_approvers.slug}"
  })
  commit_message      = "Add CODEOWNERS file for Backstage repository protection"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.backstage]
}

# README file for Backstage repository with setup instructions
resource "github_repository_file" "backstage_readme" {
  repository = github_repository.backstage.name
  branch     = "main"
  file       = "README.md"
  content = templatefile("${path.module}/templates/backstage-README.md.tpl", {
    organization = var.github_organization
  })
  commit_message      = "Add README with Backstage setup instructions"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.backstage]
}

# Reusable workflow file in the reusable-workflows repository
resource "github_repository_file" "reusable_ci_workflow" {
  repository          = github_repository.reusable_workflows.name
  branch              = "main"
  file                = ".github/workflows/ci-template.yml"
  content             = file("${path.module}/templates/reusable-ci-template.yml")
  commit_message      = "Add reusable CI/CD workflow for template validation"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.reusable_workflows]
}

# README file for the reusable-workflows repository
resource "github_repository_file" "reusable_workflows_readme" {
  repository = github_repository.reusable_workflows.name
  branch     = "main"
  file       = "README.md"
  content = templatefile("${path.module}/templates/reusable-workflows-README.md.tpl", {
    organization = var.github_organization
  })
  commit_message      = "Add README with reusable workflows documentation"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.reusable_workflows]
}

# CODEOWNERS file for the reusable-workflows repository
resource "github_repository_file" "reusable_workflows_codeowners" {
  repository = github_repository.reusable_workflows.name
  branch     = "main"
  file       = ".github/CODEOWNERS"
  content = templatefile("${path.module}/templates/CODEOWNERS.tpl", {
    platform_team      = "@${var.github_organization}/${github_team.platform.slug}"
    template_approvers = "@${var.github_organization}/${github_team.template_approvers.slug}"
  })
  commit_message      = "Add CODEOWNERS file for workflow protection"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.reusable_workflows]
}

# GitHub Actions workflow for CI/CD in template repositories
resource "github_repository_file" "template_ci" {
  for_each = var.manage_workflow_files ? var.template_repositories : {}

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = ".github/workflows/ci-template.yml"
  content = templatefile("${path.module}/templates/ci-template-caller.yml", {
    organization = var.github_organization
  })
  commit_message      = "Add CI/CD workflow caller for template validation"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates, github_repository_file.reusable_ci_workflow]
}

# Catalog info file for each template repository
resource "github_repository_file" "catalog_info" {
  for_each = var.template_repositories

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "catalog-info.yaml"
  content = templatefile("${path.module}/templates/catalog-info.yaml.tpl", {
    template_name        = local.template_name_mapping[each.key]
    template_title       = local.template_title_mapping[each.key]
    template_description = each.value.description
    template_tags        = each.value.topics
    template_type        = local.template_type_mapping[each.key]
    organization         = var.github_organization
  })
  commit_message      = "Add Backstage catalog-info.yaml for template registration"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# =============================================================================
# SKELETON FILES FOR TEMPLATE REPOSITORIES
# =============================================================================

# Node.js Service Skeleton Files
# Node.js Service Skeleton Files - Using processor for single source of truth
resource "github_repository_file" "node_service_package_skeleton" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "skeleton/package.json"
  content = file("${path.module}/templates/sources/node-service-package.json")
  commit_message      = "Add Node.js service skeleton package.json with Backstage template syntax"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Root-level package.json for Dependabot compatibility - Using templatefile with placeholder replacement
resource "github_repository_file" "node_service_package_dependabot" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "package.json"
  
  # Use templatefile to replace Backstage syntax with Dependabot-compatible placeholders
  content = replace(
    replace(
      replace(
        replace(
          file("${path.module}/templates/sources/node-service-package.json"),
          "${{values.name | replace(\"-\", \"_\")}}", "backstage-node-service-template"
        ),
        "${{values.description}}", "Backstage template for Node.js services - Dependabot managed"
      ),
      "${{values.owner}}", "Platform Team"
    ),
    "${{values.repoUrl}}", "https://github.com/${var.github_organization}/backstage-template-node-service"
  )
  
  commit_message      = "Add root package.json for Dependabot compatibility (auto-generated)"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "node_service_main" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/index.js"
  content             = file("${path.module}/templates/skeletons/node-service/src/index.js.tpl")
  commit_message      = "Add Node.js service skeleton main file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "node_service_devcontainer" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/.devcontainer/devcontainer.json"
  content             = file("${path.module}/templates/skeletons/node-service/.devcontainer/devcontainer.json.tpl")
  commit_message      = "Add Node.js service devcontainer configuration"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "node_service_excursion_model" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/models/Excursion.js"
  content             = file("${path.module}/templates/skeletons/node-service/src/models/Excursion.js.tpl")
  commit_message      = "Add Node.js service skeleton Excursion model"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "node_service_excursion_controller" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/controllers/ExcursionController.js"
  content             = file("${path.module}/templates/skeletons/node-service/src/controllers/ExcursionController.js.tpl")
  commit_message      = "Add Node.js service skeleton Excursion controller"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "node_service_excursion_routes" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/routes/excursions.js"
  content             = file("${path.module}/templates/skeletons/node-service/src/routes/excursions.js.tpl")
  commit_message      = "Add Node.js service skeleton excursions routes"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# FastAPI Service Skeleton Files  
resource "github_repository_file" "fastapi_service_main" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/app/main.py"
  content             = file("${path.module}/templates/skeletons/fastapi-service/app/main.py.tpl")
  commit_message      = "Add FastAPI service skeleton main file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "fastapi_service_requirements" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "skeleton/requirements.txt"
  content = templatefile("${path.module}/templates/skeletons/fastapi-service/requirements.txt.tpl", {
    parameters = {
      name = each.key
    }
  })
  commit_message      = "Add FastAPI service skeleton requirements"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "fastapi_service_excursion_model" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/app/models/excursion.py"
  content             = file("${path.module}/templates/skeletons/fastapi-service/app/models/excursion.py.tpl")
  commit_message      = "Add FastAPI service skeleton excursion model"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "fastapi_service_models_init" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/app/models/__init__.py"
  content             = file("${path.module}/templates/skeletons/fastapi-service/app/models/__init__.py.tpl")
  commit_message      = "Add FastAPI service skeleton models __init__.py"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "fastapi_service_excursion_router" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/app/routers/excursions.py"
  content             = file("${path.module}/templates/skeletons/fastapi-service/app/routers/excursions.py.tpl")
  commit_message      = "Add FastAPI service skeleton excursions router"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "fastapi_service_routers_init" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/app/routers/__init__.py"
  content             = file("${path.module}/templates/skeletons/fastapi-service/app/routers/__init__.py.tpl")
  commit_message      = "Add FastAPI service skeleton routers __init__.py"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# .NET Service Skeleton Files
resource "github_repository_file" "dotnet_service_program" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/Program.cs"
  content             = file("${path.module}/templates/skeletons/dotnet-service/src/Program.cs.tpl")
  commit_message      = "Add .NET service skeleton Program.cs"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_csproj" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/$${{values.name | replace(\"-\", \"_\")}}.csproj"
  content             = file("${path.module}/templates/skeletons/dotnet-service/src/$${{values.name | replace(\"-\", \"_\")}}.csproj.tpl")
  commit_message      = "Add .NET service skeleton project file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_readme" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/README.md"
  content             = file("${path.module}/templates/skeletons/dotnet-service/README.md.tpl")
  commit_message      = "Add .NET service skeleton README"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_hello_controller" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/Controllers/HelloController.cs"
  content             = file("${path.module}/templates/skeletons/dotnet-service/src/Controllers/HelloController.cs.tpl")
  commit_message      = "Add .NET service skeleton Hello controller"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_status_controller" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/Controllers/StatusController.cs"
  content             = file("${path.module}/templates/skeletons/dotnet-service/src/Controllers/StatusController.cs.tpl")
  commit_message      = "Add .NET service skeleton Status controller"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_excursions_controller" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/Controllers/ExcursionsController.cs"
  content             = file("${path.module}/templates/skeletons/dotnet-service/src/Controllers/ExcursionsController.cs.tpl")
  commit_message      = "Add .NET service skeleton Excursions controller"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_health_controller" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/Controllers/HealthController.cs"
  content             = file("${path.module}/templates/skeletons/dotnet-service/src/Controllers/HealthController.cs.tpl")
  commit_message      = "Add .NET service skeleton health controller"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_models" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/Models/ApiModels.cs"
  content             = file("${path.module}/templates/skeletons/dotnet-service/src/Models/ApiModels.cs.tpl")
  commit_message      = "Add .NET service skeleton API models"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_devcontainer" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/.devcontainer/devcontainer.json"
  content             = file("${path.module}/templates/skeletons/dotnet-service/.devcontainer/devcontainer.json.tpl")
  commit_message      = "Add .NET service skeleton devcontainer configuration"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_test_project" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/tests/$${{values.name | replace(\"-\", \"_\")}}.Tests.csproj"
  content             = file("${path.module}/templates/skeletons/dotnet-service/tests/$${{values.name | replace(\"-\", \"_\")}}.Tests.csproj.tpl")
  commit_message      = "Add .NET service skeleton test project file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

resource "github_repository_file" "dotnet_service_api_tests" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/tests/ApiTests.cs"
  content             = file("${path.module}/templates/skeletons/dotnet-service/tests/ApiTests.cs.tpl")
  commit_message      = "Add .NET service skeleton API tests"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Astro Frontend Skeleton Files
# Astro Frontend Skeleton Files - Using processor for single source of truth
resource "github_repository_file" "astro_frontend_package_skeleton" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-astro-frontend"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "skeleton/package.json"
  content = file("${path.module}/templates/sources/astro-frontend-package.json")
  commit_message      = "Add Astro frontend skeleton package.json with Backstage template syntax"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Root-level package.json for Dependabot compatibility - Using templatefile with placeholder replacement
resource "github_repository_file" "astro_frontend_package_dependabot" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-astro-frontend"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "package.json"
  
  # Use templatefile to replace Backstage syntax with Dependabot-compatible placeholders
  content = replace(
    file("${path.module}/templates/sources/astro-frontend-package.json"),
    "${{values.name | replace(\"-\", \"_\")}}", "backstage-astro-frontend-template"
  )
  
  commit_message      = "Add root package.json for Dependabot compatibility (auto-generated)"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Helm Base Skeleton Files
resource "github_repository_file" "helm_base_chart" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-helm-base"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/Chart.yaml"
  content             = file("${path.module}/templates/skeletons/helm-base/Chart.yaml.tpl")
  commit_message      = "Add Helm base skeleton Chart.yaml"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Gateway Skeleton Files
resource "github_repository_file" "gateway_kong_config" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-gateway"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/config/kong.yml"
  content             = file("${path.module}/templates/skeletons/gateway/config/kong.yml.tpl")
  commit_message      = "Add gateway skeleton Kong configuration"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# AI Assistant Skeleton Files
resource "github_repository_file" "ai_assistant_main" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-ai-assistant"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/src/main.py"
  content             = file("${path.module}/templates/skeletons/ai-assistant/src/main.py.tpl")
  commit_message      = "Add AI assistant skeleton main file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Environment Live Skeleton Files
resource "github_repository_file" "env_live_dev_config" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-env-live"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/environments/dev/config.yaml"
  content             = file("${path.module}/templates/skeletons/env-live/environments/dev/config.yaml.tpl")
  commit_message      = "Add environment live skeleton dev config"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# =============================================================================
# DEPENDABOT CONFIGURATION FILES FOR TEMPLATE REPOSITORIES
# =============================================================================

# Dependabot configuration for Node.js templates (node-service, astro-frontend)
resource "github_repository_file" "dependabot_npm" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if contains(["backstage-template-node-service", "backstage-template-astro-frontend"], key)
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = ".github/dependabot.yml"
  content = templatefile("${path.module}/templates/dependabot/npm.yml.tpl", {
    template_approvers = "@${var.github_organization}/template-approvers"
  })
  commit_message      = "Add Dependabot configuration for npm dependencies"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Dependabot configuration for Python templates (fastapi-service, ai-assistant)
resource "github_repository_file" "dependabot_pip" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if contains(["backstage-template-fastapi-service", "backstage-template-ai-assistant"], key)
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = ".github/dependabot.yml"
  content = templatefile("${path.module}/templates/dependabot/pip.yml.tpl", {
    template_approvers = "@${var.github_organization}/template-approvers"
  })
  commit_message      = "Add Dependabot configuration for pip dependencies"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Dependabot configuration for .NET template (dotnet-service)
resource "github_repository_file" "dependabot_nuget" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = ".github/dependabot.yml"
  content = templatefile("${path.module}/templates/dependabot/nuget.yml.tpl", {
    template_approvers = "@${var.github_organization}/template-approvers"
  })
  commit_message      = "Add Dependabot configuration for NuGet dependencies"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Dependabot configuration for Gateway template (docker dependencies)
resource "github_repository_file" "dependabot_docker" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-gateway"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = ".github/dependabot.yml"
  content = templatefile("${path.module}/templates/dependabot/docker.yml.tpl", {
    template_approvers = "@${var.github_organization}/template-approvers"
  })
  commit_message      = "Add Dependabot configuration for Docker dependencies"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Dependabot configuration for basic templates (helm-base, env-live)
resource "github_repository_file" "dependabot_basic" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if contains(["backstage-template-helm-base", "backstage-template-env-live"], key)
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = ".github/dependabot.yml"
  content = templatefile("${path.module}/templates/dependabot/basic.yml.tpl", {
    template_approvers = "@${var.github_organization}/template-approvers"
  })
  commit_message      = "Add Dependabot configuration for GitHub Actions dependencies"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# =============================================================================
# TECHDOCS CONFIGURATION FILES FOR TEMPLATE REPOSITORIES
# =============================================================================

# MkDocs configuration for template repositories (TechDocs)
resource "github_repository_file" "template_mkdocs" {
  for_each = var.template_repositories

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "mkdocs.yml"
  content = templatefile("${path.module}/templates/template-docs/mkdocs.yml.tpl", {
    template_name        = each.key
    template_description = each.value.description
    github_organization  = var.github_organization
  })
  commit_message      = "Add TechDocs MkDocs configuration for template repository"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Template repository documentation index
resource "github_repository_file" "template_docs_index" {
  for_each = var.template_repositories

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "docs/index.md"
  content = templatefile("${path.module}/templates/template-docs/docs/index.md.tpl", {
    template_name         = each.key
    template_description  = each.value.description
    template_type         = each.value.type
    github_organization   = var.github_organization
    related_templates     = [for k, v in var.template_repositories : k if k != each.key]
    template_descriptions = { for k, v in var.template_repositories : k => v.description }
  })
  commit_message      = "Add TechDocs documentation index for template repository"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Template repository usage documentation
resource "github_repository_file" "template_docs_usage" {
  for_each = var.template_repositories

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "docs/template-usage.md"
  content = templatefile("${path.module}/templates/template-docs/docs/template-usage.md.tpl", {
    template_name        = each.key
    template_description = each.value.description
    template_type        = each.value.type
    github_organization  = var.github_organization
  })
  commit_message      = "Add template usage documentation"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# =============================================================================
# TECHDOCS SKELETON FILES FOR GENERATED PROJECTS
# =============================================================================

# MkDocs configuration for generated projects (skeleton)
resource "github_repository_file" "skeleton_mkdocs" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/mkdocs.yml"
  content             = file("${path.module}/templates/skeletons/mkdocs.yml.tpl")
  commit_message      = "Add TechDocs MkDocs configuration for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Documentation index for generated projects
resource "github_repository_file" "skeleton_docs_index" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/docs/index.md"
  content             = file("${path.module}/templates/skeletons/docs/index.md.tpl")
  commit_message      = "Add TechDocs documentation index for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Getting Started documentation for generated projects
resource "github_repository_file" "skeleton_docs_getting_started" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/docs/getting-started.md"
  content             = file("${path.module}/templates/skeletons/docs/getting-started.md.tpl")
  commit_message      = "Add getting started documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Development documentation for generated projects
resource "github_repository_file" "skeleton_docs_development" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/docs/development.md"
  content             = file("${path.module}/templates/skeletons/docs/development.md.tpl")
  commit_message      = "Add development documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Architecture documentation for generated projects
resource "github_repository_file" "skeleton_docs_architecture" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/docs/architecture.md"
  content             = file("${path.module}/templates/skeletons/docs/architecture.md.tpl")
  commit_message      = "Add architecture documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# API Reference documentation for generated projects
resource "github_repository_file" "skeleton_docs_api_reference" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/docs/api-reference.md"
  content             = file("${path.module}/templates/skeletons/docs/api-reference.md.tpl")
  commit_message      = "Add API reference documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Deployment documentation for generated projects
resource "github_repository_file" "skeleton_docs_deployment" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/docs/deployment.md"
  content             = file("${path.module}/templates/skeletons/docs/deployment.md.tpl")
  commit_message      = "Add deployment documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Contributing documentation for generated projects
resource "github_repository_file" "skeleton_docs_contributing" {
  for_each = var.template_repositories

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/docs/contributing.md"
  content             = file("${path.module}/templates/skeletons/docs/contributing.md.tpl")
  commit_message      = "Add contributing documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Catalog info file for generated projects (skeleton)
resource "github_repository_file" "skeleton_catalog_info" {
  for_each = var.template_repositories

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "skeleton/catalog-info.yaml"
  content = templatefile("${path.module}/templates/skeletons/catalog-info.yaml.tpl", {
    template_type = each.value.type
  })
  commit_message      = "Add Backstage catalog-info.yaml with TechDocs annotation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# CODEOWNERS file for generated projects (skeleton)
resource "github_repository_file" "skeleton_codeowners" {
  for_each = var.template_repositories

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "skeleton/.github/CODEOWNERS"
  content = templatefile("${path.module}/templates/skeletons/CODEOWNERS.tpl", {
    developers_team = local.team_names.developers
    platform_team   = local.team_names.platform
  })
  commit_message      = "Add CODEOWNERS file for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}
