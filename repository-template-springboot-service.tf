# Spring Boot Service Template Repository Files
# This file contains all file resources specific to the Spring Boot Service template

locals {
  # Template-specific configuration
  springboot_service_key     = "backstage-template-springboot-service"
  springboot_service_enabled = contains(keys(var.template_repositories), local.springboot_service_key)

  # Dynamically list all skeleton files (fileset returns files only)
  springboot_service_skeleton_all = local.springboot_service_enabled ? fileset(path.module, "software_templates/springboot-service/skeleton/**") : []

  # Exclude unwanted directories (target, .idea, etc.) to avoid committing build output
  springboot_service_skeleton_all_filtered = [
    for f in local.springboot_service_skeleton_all : f
    if length(regexall("/target/", f)) == 0
    && length(regexall("/.idea/", f)) == 0
    && length(regexall("/.mvn/", f)) == 0
    && length(regexall("/bin/", f)) == 0
    && length(regexall("/obj/", f)) == 0
  ]

  # Separate template (.tpl) files vs regular files (after filtering)
  springboot_service_skeleton_template_raw = [for f in local.springboot_service_skeleton_all_filtered : f if endswith(f, ".tpl")]
  springboot_service_skeleton_regular_raw  = [for f in local.springboot_service_skeleton_all_filtered : f if !endswith(f, ".tpl")]

  # Map for regular skeleton files (destination keeps skeleton/ prefix)
  springboot_service_skeleton_regular_map = { for f in local.springboot_service_skeleton_regular_raw :
    replace(f, "software_templates/springboot-service/", "") => {
      source_file    = "${path.module}/${f}"
      commit_message = "Sync Spring Boot skeleton file ${replace(f, "software_templates/springboot-service/", "")}"
    }
  }

  # Map for templated skeleton files (.tpl) removing extension in destination
  springboot_service_skeleton_template_map = { for f in local.springboot_service_skeleton_template_raw :
    replace(replace(f, "software_templates/springboot-service/", ""), ".tpl", "") => {
      source_file      = "${path.module}/${f}"
      commit_message   = "Add templated Spring Boot skeleton file ${replace(replace(f, "software_templates/springboot-service/", ""), ".tpl", "")}"
      use_templatefile = true
      template_vars = {
        github_organization = var.github_organization
      }
    }
  }

  # Explicit template-level (non-skeleton) regular files
  springboot_service_template_level_files = local.springboot_service_enabled ? {
    "docs/index.md" = {
      source_file    = "${path.module}/software_templates/springboot-service/docs/index.md"
      commit_message = "Sync Spring Boot service template docs index"
    }
    "docs/template-usage.md" = {
      source_file    = "${path.module}/software_templates/springboot-service/docs/template-usage.md"
      commit_message = "Sync Spring Boot service template usage guide"
    }
    "mkdocs.yml" = {
      source_file    = "${path.module}/software_templates/springboot-service/mkdocs.yml"
      commit_message = "Sync Spring Boot service template mkdocs configuration"
    }
    ".github/dependabot.yml" = {
      source_file    = "${path.module}/software_templates/springboot-service/.github/dependabot.yml"
      commit_message = "Sync Spring Boot service template dependabot"
    }
  } : {}

  # Combine skeleton regular + template-level regular files
  springboot_service_files = local.springboot_service_enabled ? merge(
    local.springboot_service_skeleton_regular_map,
    local.springboot_service_template_level_files
  ) : {}

  # Template-level templated files + any skeleton .tpl files
  springboot_service_template_files = local.springboot_service_enabled ? merge(
    local.springboot_service_skeleton_template_map,
    {
      # Backstage root catalog-info remains templated
      "catalog-info.yaml" = {
        source_file      = "${path.module}/software_templates/springboot-service/catalog-info.yaml.tpl"
        commit_message   = "Add Spring Boot service template catalog-info.yaml for Backstage"
        use_templatefile = true
        template_vars = {
          github_organization = var.github_organization
          github_repository   = local.springboot_service_key
        }
      }

      "README.md" = {
        source_file      = "${path.module}/software_templates/springboot-service/README.md.tpl"
        commit_message   = "Add templated Spring Boot service README with dynamic badges"
        use_templatefile = true
        template_vars = {
          github_organization = var.github_organization
          repository_name     = local.springboot_service_key
        }
      }
    }
  ) : {}
}

# Regular file resources (direct file content)
resource "github_repository_file" "springboot_service_files" {
  for_each = local.springboot_service_files

  repository          = github_repository.templates[local.springboot_service_key].name
  branch              = "main"
  file                = each.key
  content             = file(each.value.source_file)
  commit_message      = each.value.commit_message
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}

# Template file resources (files that need template processing)
resource "github_repository_file" "springboot_service_template_files" {
  for_each = local.springboot_service_template_files

  repository = github_repository.templates[local.springboot_service_key].name
  branch     = "main"
  file       = each.key
  content = each.value.use_templatefile ? templatefile(
    each.value.source_file,
    each.value.template_vars
  ) : file(each.value.source_file)
  commit_message      = each.value.commit_message
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.templates]
}
