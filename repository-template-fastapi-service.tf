# FastAPI Service Template Repository Files
# This file contains all file resources specific to the FastAPI Service template

locals {
  # Template-specific configuration
  fastapi_service_key = "backstage-template-fastapi-service"

  # Check if the FastAPI service template is enabled
  fastapi_service_enabled = contains(keys(var.template_repositories), local.fastapi_service_key)

  # Template-specific file mappings
  fastapi_service_files = local.fastapi_service_enabled ? {
    # Dependabot configurations
    "skeleton/.github/dependabot.yml" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/.github/dependabot.yml"
      commit_message = "Add Dependabot configuration for pip dependencies to skeleton"
    }
    ".github/dependabot.yml" = {
      source_file    = "${path.module}/software_templates/fastapi-service/.github/dependabot.yaml"
      commit_message = "Add Dependabot configuration for template repository"
    }

    # CI/CD workflow
    "skeleton/.github/workflows/ci.yml" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/.github/workflows/ci.yml"
      commit_message = "Add CI workflow for FastAPI service template to skeleton"
    }

    # Development configuration
    "skeleton/.gitignore" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/.gitignore"
      commit_message = "Add FastAPI service skeleton .gitignore"
    }
    "skeleton/.devcontainer/devcontainer.json" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/.devcontainer/devcontainer.json"
      commit_message = "Add FastAPI service devcontainer configuration"
    }

    # Application files
    "skeleton/requirements.txt" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/requirements.txt"
      commit_message = "Add FastAPI service skeleton requirements"
    }
    "skeleton/requirements-dev.txt" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/requirements-dev.txt"
      commit_message = "Add FastAPI service skeleton dev requirements"
    }
    "skeleton/.env.example" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/.env.example"
      commit_message = "Add FastAPI service skeleton environment example"
    }
    "skeleton/app/main.py" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/app/main.py"
      commit_message = "Add FastAPI service skeleton main application"
    }
    "skeleton/app/__init__.py" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/app/__init__.py"
      commit_message = "Add FastAPI service skeleton app __init__.py"
    }
    "skeleton/app/models/__init__.py" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/app/models/__init__.py"
      commit_message = "Add FastAPI service skeleton models __init__.py"
    }
    "skeleton/app/models/meme.py" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/app/models/meme.py"
      commit_message = "Add FastAPI service skeleton meme model"
    }
    "skeleton/app/routers/__init__.py" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/app/routers/__init__.py"
      commit_message = "Add FastAPI service skeleton routers __init__.py"
    }
    "skeleton/app/routers/memes.py" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/app/routers/memes.py"
      commit_message = "Add FastAPI service skeleton memes router"
    }
    "skeleton/tests/test_api.py" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/tests/test_api.py"
      commit_message = "Add FastAPI service skeleton API tests"
    }

    # Documentation and metadata
    "skeleton/README.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/README.md"
      commit_message = "Add FastAPI service skeleton README"
    }
    "skeleton/api.http" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/api.http"
      commit_message = "Add FastAPI service skeleton API tests"
    }
    "skeleton/AGENTS.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/AGENTS.md"
      commit_message = "Add FastAPI service skeleton AI agents documentation"
    }
    "skeleton/catalog-info.yaml" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/catalog-info.yaml"
      commit_message = "Add FastAPI service skeleton Backstage catalog info"
    }
    "skeleton/mkdocs.yml" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/mkdocs.yml"
      commit_message = "Add FastAPI service skeleton MkDocs configuration"
    }

    # Documentation files
    "skeleton/docs/index.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/docs/index.md"
      commit_message = "Add FastAPI service skeleton documentation index"
    }
    "skeleton/docs/api-reference.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/docs/api-reference.md"
      commit_message = "Add FastAPI service skeleton API reference documentation"
    }
    "skeleton/docs/getting-started.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/skeleton/docs/getting-started.md"
      commit_message = "Add FastAPI service skeleton getting started documentation"
    }

    # Template metadata
    "README.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/README.md"
      commit_message = "Add FastAPI service template documentation"
    }
    "catalog-info.yaml" = {
      source_file    = "${path.module}/software_templates/fastapi-service/catalog-info.yaml.tpl"
      commit_message = "Add FastAPI service template catalog-info.yaml for Backstage"
      is_template    = true
    }

    # Template documentation
    "docs/index.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/docs/index.md"
      commit_message = "Add FastAPI service template documentation index"
    }
    "docs/template-usage.md" = {
      source_file    = "${path.module}/software_templates/fastapi-service/docs/template-usage.md"
      commit_message = "Add FastAPI service template usage guide"
    }
    "mkdocs.yml" = {
      source_file    = "${path.module}/software_templates/fastapi-service/mkdocs.yml"
      commit_message = "Add FastAPI service template mkdocs configuration"
    }
  } : {}
}

# Create files for FastAPI Service template
resource "github_repository_file" "fastapi_service_files" {
  for_each = local.fastapi_service_files

  repository = github_repository.templates[local.fastapi_service_key].name
  branch     = "main"
  file       = each.key

  # Handle template files differently
  content = try(each.value.is_template, false) ? templatefile(
    each.value.source_file,
    {
      github_organization = var.github_organization
      github_repository   = local.fastapi_service_key
    }
  ) : file(each.value.source_file)

  commit_message      = each.value.commit_message
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}
