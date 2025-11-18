# System Template Repository Files
# This file contains all file resources specific to the System template

# Template catalog-info.yaml (main template file)
resource "github_repository_file" "system_template_catalog" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository = github_repository.templates[each.key].name
  branch     = "main"
  file       = "catalog-info.yaml"
  content = templatefile(
    "${path.module}/software_templates/system/catalog-info.yaml.tpl",
    {
      github_organization = var.github_organization
    }
  )
  commit_message      = "Add System template catalog-info.yaml for Backstage"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Skeleton catalog-info.yaml (for generated repositories)
resource "github_repository_file" "system_template_skeleton_catalog" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/catalog-info.yaml"
  content             = file("${path.module}/software_templates/system/skeleton/catalog-info.yaml")
  commit_message      = "Add System skeleton catalog-info.yaml"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Template README.md (main template documentation)
resource "github_repository_file" "system_template_readme" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "README.md"
  content             = file("${path.module}/software_templates/system/README.md")
  commit_message      = "Add System template documentation"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Skeleton README.md (for generated repositories)
resource "github_repository_file" "system_template_skeleton_readme" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/README.md"
  content             = file("${path.module}/software_templates/system/skeleton/README.md")
  commit_message      = "Add System skeleton README"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Skeleton .gitignore
resource "github_repository_file" "system_template_skeleton_gitignore" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "skeleton/.gitignore"
  content             = file("${path.module}/software_templates/system/skeleton/.gitignore")
  commit_message      = "Add System skeleton .gitignore"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Template documentation - main index
resource "github_repository_file" "system_docs_index" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "docs/index.md"
  content             = file("${path.module}/software_templates/system/docs/index.md")
  commit_message      = "Add System template documentation index"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Template documentation - usage guide
resource "github_repository_file" "system_docs_usage" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "docs/template-usage.md"
  content             = file("${path.module}/software_templates/system/docs/template-usage.md")
  commit_message      = "Add System template usage guide"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Template mkdocs.yml configuration
resource "github_repository_file" "system_mkdocs" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-system"
  }

  repository          = github_repository.templates[each.key].name
  branch              = "main"
  file                = "mkdocs.yml"
  content             = file("${path.module}/software_templates/system/mkdocs.yml")
  commit_message      = "Add System template mkdocs configuration"
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}
