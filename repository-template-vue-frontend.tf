locals {
  vue_frontend_key     = "backstage-template-vue-frontend"
  vue_frontend_enabled = contains(keys(var.template_repositories), local.vue_frontend_key)

  # Dynamically discover all files in the template directory
  vue_frontend_template_files = local.vue_frontend_enabled ? fileset(path.module, "software_templates/vue-frontend/**") : []

  # Create a map of files to deploy
  vue_frontend_files = local.vue_frontend_enabled ? merge(
    # Files that need templatefile processing
    {
      for file in [
        "catalog-info.yaml.tpl",
      ] :
      replace(file, ".tpl", "") => {
        source_file      = "${path.module}/software_templates/vue-frontend/${file}"
        use_templatefile = true
        commit_message   = "Add ${file}"
      }
      if contains(local.vue_frontend_template_files, "software_templates/vue-frontend/${file}")
    },
    # All other files (copy as-is)
    {
      for file in local.vue_frontend_template_files :
      trimprefix(file, "software_templates/vue-frontend/") => {
        source_file    = "${path.module}/${file}"
        commit_message = "Add ${basename(file)}"
      }
      if !endswith(file, ".tpl") && !contains([
        "software_templates/vue-frontend/catalog-info.yaml.tpl",
      ], file) && !startswith(basename(file), ".") && !strcontains(file, "node_modules/") && !strcontains(file, "package-lock.json") && !endswith(file, ".ico") && !endswith(file, ".png") && !endswith(file, ".jpg") && !endswith(file, ".gif") && !endswith(file, ".woff") && !endswith(file, ".woff2") && !endswith(file, ".ttf") && !endswith(file, ".eot")
    }
  ) : {}
}

resource "github_repository_file" "vue_frontend_files" {
  for_each = local.vue_frontend_files

  repository = github_repository.templates[local.vue_frontend_key].name
  branch     = "main"
  file       = each.key
  content = try(each.value.use_templatefile, false) ? templatefile(each.value.source_file, {
    template_owner      = "platform-team"
    github_organization = var.github_organization
  }) : file(each.value.source_file)
  commit_message      = each.value.commit_message
  commit_author       = local.template_commit_config.commit_author
  commit_email        = local.template_commit_config.commit_email
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      commit_author,
      commit_email,
    ]
  }
}
