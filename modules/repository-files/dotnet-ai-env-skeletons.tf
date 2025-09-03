# Repository Files Module - .NET Service Skeleton Files
# This module manages skeleton files specific to .NET services

resource "github_repository_file" "dotnet_service_csproj" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository = var.repository_names[each.key]
  branch     = "main"
  file       = "skeleton/src/project.csproj"
  content = templatefile("${path.root}/templates/skeletons/dotnet-service/src/project.csproj.tpl", {
    parameters = {
      name = each.key
    }
  })
  commit_message      = "Add .NET service skeleton project file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "dotnet_service_program" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/src/Program.cs"
  content             = file("${path.root}/templates/skeletons/dotnet-service/src/Program.cs.tpl")
  commit_message      = "Add .NET service skeleton program file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "dotnet_service_controller" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/src/Controllers/ExcursionsController.cs"
  content             = file("${path.root}/templates/skeletons/dotnet-service/src/Controllers/ExcursionsController.cs.tpl")
  commit_message      = "Add .NET service skeleton excursions controller"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "dotnet_service_health_controller" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/src/Controllers/HealthController.cs"
  content             = file("${path.root}/templates/skeletons/dotnet-service/src/Controllers/HealthController.cs.tpl")
  commit_message      = "Add .NET service skeleton health controller"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "dotnet_service_models" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-dotnet-service"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/src/Models/ApiModels.cs"
  content             = file("${path.root}/templates/skeletons/dotnet-service/src/Models/ApiModels.cs.tpl")
  commit_message      = "Add .NET service skeleton API models"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# AI Assistant Service Skeleton Files
resource "github_repository_file" "ai_assistant_main" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-ai-assistant"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/src/main.py"
  content             = file("${path.root}/templates/skeletons/ai-assistant/src/main.py.tpl")
  commit_message      = "Add AI assistant skeleton main file"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

# Environment Live Skeleton Files
resource "github_repository_file" "env_live_dev_config" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-env-live"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/environments/dev/config.yaml"
  content             = file("${path.root}/templates/skeletons/env-live/environments/dev/config.yaml.tpl")
  commit_message      = "Add environment live skeleton dev config"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}

resource "github_repository_file" "env_live_prod_config" {
  for_each = {
    for key, value in var.template_repositories : key => value
    if key == "backstage-template-env-live"
  }

  repository          = var.repository_names[each.key]
  branch              = "main"
  file                = "skeleton/environments/prod/config.yaml"
  content             = file("${path.root}/templates/skeletons/env-live/environments/prod/config.yaml.tpl")
  commit_message      = "Add environment live skeleton prod config"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}