# .NET Library Template Repository Files
# This file contains all file resources specific to the .NET Library template

locals {
  # Template-specific configuration
  dotnet_library_key     = "backstage-template-dotnet-library"
  dotnet_library_enabled = contains(keys(var.template_repositories), local.dotnet_library_key)

  # Dynamically list all skeleton files
  dotnet_library_skeleton_all = local.dotnet_library_enabled ? fileset(path.module, "software_templates/dotnet-library/skeleton/**") : []

  # Exclude unwanted directories (bin, obj, etc.)
  dotnet_library_skeleton_all_filtered = [
    for f in local.dotnet_library_skeleton_all : f
    if length(regexall("/bin/", f)) == 0
    && length(regexall("/obj/", f)) == 0
    && length(regexall("/\\.vs/", f)) == 0
    && length(regexall("/Debug/", f)) == 0
    && length(regexall("/Release/", f)) == 0
    && !endswith(f, ".user")
    && !endswith(f, ".suo")
    && !endswith(f, ".cache")
  ]

  # Separate template (.tpl) files vs regular files
  dotnet_library_skeleton_template_raw = [for f in local.dotnet_library_skeleton_all_filtered : f if endswith(f, ".tpl")]
  dotnet_library_skeleton_regular_raw  = [for f in local.dotnet_library_skeleton_all_filtered : f if !endswith(f, ".tpl")]

  # Map for regular skeleton files
  dotnet_library_skeleton_regular_map = { for f in local.dotnet_library_skeleton_regular_raw :
    replace(f, "software_templates/dotnet-library/", "") => {
      source_file    = "${path.module}/${f}"
      commit_message = "Sync .NET library skeleton file ${replace(f, "software_templates/dotnet-library/", "")}"
    }
  }

  # Map for templated skeleton files (.tpl)
  dotnet_library_skeleton_template_map = { for f in local.dotnet_library_skeleton_template_raw :
    replace(replace(f, "software_templates/dotnet-library/", ""), ".tpl", "") => {
      source_file      = "${path.module}/${f}"
      commit_message   = "Add templated .NET library skeleton file ${replace(replace(f, "software_templates/dotnet-library/", ""), ".tpl", "")}"
      use_templatefile = true
      template_vars = {
        github_organization           = var.github_organization
        reusable_workflows_repository = var.reusable_workflows_repository.name
        platform_team                 = github_team.platform.slug
        template_approvers            = github_team.template_approvers.slug
      }
    }
  }

  # Template-level (non-skeleton) regular files
  dotnet_library_template_level_files = local.dotnet_library_enabled ? {
    "docs/index.md" = {
      source_file    = "${path.module}/software_templates/dotnet-library/docs/index.md"
      commit_message = "Sync .NET library template docs index"
    }
    "docs/template-usage.md" = {
      source_file    = "${path.module}/software_templates/dotnet-library/docs/template-usage.md"
      commit_message = "Sync .NET library template usage guide"
    }
    "mkdocs.yml" = {
      source_file    = "${path.module}/software_templates/dotnet-library/mkdocs.yml"
      commit_message = "Sync .NET library template mkdocs configuration"
    }
  } : {}

  # Combine skeleton regular + template-level regular files
  dotnet_library_files = local.dotnet_library_enabled ? merge(
    local.dotnet_library_skeleton_regular_map,
    local.dotnet_library_template_level_files
  ) : {}

  # Template files (catalog-info.yaml and README)
  dotnet_library_template_files = local.dotnet_library_enabled ? merge(
    local.dotnet_library_skeleton_template_map,
    {
      "catalog-info.yaml" = {
        source_file      = "${path.module}/software_templates/dotnet-library/catalog-info.yaml.tpl"
        commit_message   = "Add .NET library template catalog-info.yaml for Backstage"
        use_templatefile = true
        template_vars = {
          github_organization = var.github_organization
          github_repository   = local.dotnet_library_key
        }
      }

      "README.md" = {
        source_file      = "${path.module}/software_templates/dotnet-library/README.md"
        commit_message   = "Add .NET library template README"
        use_templatefile = false
        template_vars    = {}
      }
    }
  ) : {}
}

# Regular file resources (direct file content)
resource "github_repository_file" "dotnet_library_files" {
  for_each = local.dotnet_library_files

  repository          = github_repository.templates[local.dotnet_library_key].name
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
resource "github_repository_file" "dotnet_library_template_files" {
  for_each = local.dotnet_library_template_files

  repository = github_repository.templates[local.dotnet_library_key].name
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
