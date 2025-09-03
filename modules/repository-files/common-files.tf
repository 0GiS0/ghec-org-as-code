# Repository Files Module - Common Files
# This module manages files that are common to all templates

# CODEOWNERS file for template repositories
resource "github_repository_file" "codeowners" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "CODEOWNERS"
  content             = file("${path.root}/templates/CODEOWNERS.tpl")
  commit_message      = "Add CODEOWNERS file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# README file for template repositories
resource "github_repository_file" "readme" {
  for_each = var.template_repositories

  repository = var.repository_names[each.key]
  branch     = "main"
  file       = "README.md"
  content = templatefile("${path.root}/templates/README.md.tpl", {
    name        = local.template_name_mapping[each.key]
    title       = local.template_title_mapping[each.key]
    description = each.value.description
  })
  commit_message      = "Add README documentation"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# Docs directory and files for generated projects (skeleton)
resource "github_repository_file" "skeleton_mkdocs" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/mkdocs.yml"
  content             = file("${path.root}/templates/skeletons/mkdocs.yml.tpl")
  commit_message      = "Add MkDocs configuration for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# Documentation files for skeleton
resource "github_repository_file" "skeleton_docs_index" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/docs/index.md"
  content             = file("${path.root}/templates/skeletons/docs/index.md.tpl")
  commit_message      = "Add index documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "skeleton_docs_getting_started" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/docs/getting-started.md"
  content             = file("${path.root}/templates/skeletons/docs/getting-started.md.tpl")
  commit_message      = "Add getting started documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "skeleton_docs_development" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/docs/development.md"
  content             = file("${path.root}/templates/skeletons/docs/development.md.tpl")
  commit_message      = "Add development documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "skeleton_docs_architecture" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/docs/architecture.md"
  content             = file("${path.root}/templates/skeletons/docs/architecture.md.tpl")
  commit_message      = "Add architecture documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "skeleton_docs_api_reference" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/docs/api-reference.md"
  content             = file("${path.root}/templates/skeletons/docs/api-reference.md.tpl")
  commit_message      = "Add API reference documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "skeleton_docs_deployment" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/docs/deployment.md"
  content             = file("${path.root}/templates/skeletons/docs/deployment.md.tpl")
  commit_message      = "Add deployment documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "skeleton_docs_contributing" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/docs/contributing.md"
  content             = file("${path.root}/templates/skeletons/docs/contributing.md.tpl")
  commit_message      = "Add contributing documentation for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# Catalog info file for generated projects (skeleton)
resource "github_repository_file" "skeleton_catalog_info" {
  for_each = var.template_repositories

  repository = var.repository_names[each.key]
  branch     = "main"
  file       = "skeleton/catalog-info.yaml"
  content = templatefile("${path.root}/templates/skeletons/catalog-info.yaml.tpl", {
    template_type = each.value.type
  })
  commit_message      = "Add catalog-info.yaml for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# CODEOWNERS file for generated projects (skeleton)
resource "github_repository_file" "skeleton_codeowners" {
  for_each = var.template_repositories

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/CODEOWNERS"
  content             = file("${path.root}/templates/skeletons/CODEOWNERS.tpl")
  commit_message      = "Add CODEOWNERS file for generated projects"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}