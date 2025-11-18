# Electron Desktop App Template Repository Files
# This file contains all file resources specific to the Electron Desktop App template

locals {
  # Template-specific configuration
  electron_desktop_app_key     = "backstage-template-electron-desktop-app"
  electron_desktop_app_enabled = contains(keys(var.template_repositories), local.electron_desktop_app_key)

  # Dynamically list all skeleton files (fileset returns files only)
  electron_desktop_app_skeleton_all = local.electron_desktop_app_enabled ? fileset(path.module, "software_templates/electron-desktop-app/skeleton/**") : []

  # Exclude unwanted directories (node_modules, coverage, dist, etc.)
  electron_desktop_app_skeleton_all_filtered = [
    for f in local.electron_desktop_app_skeleton_all : f
    if length(regexall("/node_modules/", f)) == 0
    && length(regexall("/coverage/", f)) == 0
    && length(regexall("/dist/", f)) == 0
    && length(regexall("/dist-vite/", f)) == 0
    && length(regexall("/.DS_Store", f)) == 0
  ]

  # Separate template (.tpl) files vs regular files (after filtering)
  electron_desktop_app_skeleton_template_raw = [for f in local.electron_desktop_app_skeleton_all_filtered : f if endswith(f, ".tpl")]
  electron_desktop_app_skeleton_regular_raw  = [for f in local.electron_desktop_app_skeleton_all_filtered : f if !endswith(f, ".tpl")]

  # Map for regular skeleton files (destination keeps skeleton/ prefix)
  electron_desktop_app_skeleton_regular_map = { for f in local.electron_desktop_app_skeleton_regular_raw :
    replace(f, "software_templates/electron-desktop-app/", "") => {
      source_file    = "${path.module}/${f}"
      commit_message = "Sync Electron desktop app skeleton file ${replace(f, "software_templates/electron-desktop-app/", "")}"
    }
  }

  # Map for templated skeleton files (.tpl) removing extension in destination
  electron_desktop_app_skeleton_template_map = { for f in local.electron_desktop_app_skeleton_template_raw :
    replace(replace(f, "software_templates/electron-desktop-app/", ""), ".tpl", "") => {
      source_file      = "${path.module}/${f}"
      commit_message   = "Add templated Electron desktop app skeleton file ${replace(replace(f, "software_templates/electron-desktop-app/", ""), ".tpl", "")}"
      use_templatefile = true
      template_vars = {
        github_organization = var.github_organization
      }
    }
  }

  # Explicit template-level (non-skeleton) regular files
  electron_desktop_app_template_level_files = local.electron_desktop_app_enabled ? {
    "docs/index.md" = {
      source_file    = "${path.module}/software_templates/electron-desktop-app/docs/index.md"
      commit_message = "Sync Electron desktop app template docs index"
    }
    "mkdocs.yml" = {
      source_file    = "${path.module}/software_templates/electron-desktop-app/mkdocs.yml"
      commit_message = "Sync Electron desktop app template mkdocs configuration"
    }
  } : {}

  # Combine skeleton regular + template-level regular files
  electron_desktop_app_files = local.electron_desktop_app_enabled ? merge(
    local.electron_desktop_app_skeleton_regular_map,
    local.electron_desktop_app_template_level_files
  ) : {}

  # Explicit non-.tpl skeleton files that still require template processing + template-level templated files
  electron_desktop_app_template_files = local.electron_desktop_app_enabled ? merge(
    local.electron_desktop_app_skeleton_template_map,
    {
      # Backstage root catalog-info remains templated
      "catalog-info.yaml" = {
        source_file      = "${path.module}/software_templates/electron-desktop-app/catalog-info.yaml.tpl"
        commit_message   = "Add Electron desktop app template catalog-info.yaml for Backstage"
        use_templatefile = true
        template_vars = {
          github_organization = var.github_organization
          github_repository   = local.electron_desktop_app_key
        }
      }


    }
  ) : {}
}

# Regular file resources (direct file content)
resource "github_repository_file" "electron_desktop_app_files" {
  for_each = local.electron_desktop_app_files

  repository          = github_repository.templates[local.electron_desktop_app_key].name
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
resource "github_repository_file" "electron_desktop_app_template_files" {
  for_each = local.electron_desktop_app_template_files

  repository = github_repository.templates[local.electron_desktop_app_key].name
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
