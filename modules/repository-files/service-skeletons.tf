# Repository Files Module - Service-specific Skeleton Files
# This module manages skeleton files specific to different service types

# Node.js Service Skeleton Files
resource "github_repository_file" "node_service_main" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/src/index.js"
  content             = file("${path.root}/templates/skeletons/node-service/src/index.js.tpl")
  commit_message      = "Add Node.js service skeleton main file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "node_service_package_json" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository = var.repository_names[each.key]
  branch     = "main"
  file       = "skeleton/package.json"
  content = templatefile("${path.root}/templates/skeletons/node-service/package.json.tpl", {
    parameters = {
      name = each.key
    }
  })
  commit_message      = "Add Node.js service skeleton package.json"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "node_service_routes" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/src/routes/excursions.js"
  content             = file("${path.root}/templates/skeletons/node-service/src/routes/excursions.js.tpl")
  commit_message      = "Add Node.js service skeleton excursions routes"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "node_service_devcontainer" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-node-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/.devcontainer/devcontainer.json"
  content             = file("${path.root}/templates/skeletons/node-service/.devcontainer/devcontainer.json.tpl")
  commit_message      = "Add Node.js service skeleton devcontainer configuration"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# FastAPI Service Skeleton Files
resource "github_repository_file" "fastapi_service_main" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/app/main.py"
  content             = file("${path.root}/templates/skeletons/fastapi-service/app/main.py.tpl")
  commit_message      = "Add FastAPI service skeleton main file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "fastapi_service_requirements" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository = var.repository_names[each.key]
  branch     = "main"
  file       = "skeleton/requirements.txt"
  content = templatefile("${path.root}/templates/skeletons/fastapi-service/requirements.txt.tpl", {
    parameters = {
      name = each.key
    }
  })
  commit_message      = "Add FastAPI service skeleton requirements"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "fastapi_service_excursion_model" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/app/models/excursion.py"
  content             = file("${path.root}/templates/skeletons/fastapi-service/app/models/excursion.py.tpl")
  commit_message      = "Add FastAPI service skeleton excursion model"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "fastapi_service_routes" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-fastapi-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/app/routes/excursions.py"
  content             = file("${path.root}/templates/skeletons/fastapi-service/app/routes/excursions.py.tpl")
  commit_message      = "Add FastAPI service skeleton excursions routes"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}