locals {
  kubernetes_gitops_key     = "backstage-template-kubernetes-gitops"
  kubernetes_gitops_enabled = contains(keys(var.template_repositories), local.kubernetes_gitops_key)

  # Dynamically discover all files in the template directory
  kubernetes_gitops_template_files = local.kubernetes_gitops_enabled ? fileset(path.module, "software_templates/kubernetes-gitops/**") : []

  # Create a map of files to deploy
  kubernetes_gitops_files = local.kubernetes_gitops_enabled ? merge(
    # Files that need templatefile processing
    {
      for file in [
        "catalog-info.yaml.tpl",
      ] :
      replace(file, ".tpl", "") => {
        source_file      = "${path.module}/software_templates/kubernetes-gitops/${file}"
        use_templatefile = true
        commit_message   = "Add ${file}"
      }
      if contains(local.kubernetes_gitops_template_files, "software_templates/kubernetes-gitops/${file}")
    },
    # All other files (copy as-is)
    {
      for file in local.kubernetes_gitops_template_files :
      trimprefix(file, "software_templates/kubernetes-gitops/") => {
        source_file    = "${path.module}/${file}"
        commit_message = "Add ${basename(file)}"
      }
      if !endswith(file, ".tpl") && !contains([
        "software_templates/kubernetes-gitops/catalog-info.yaml.tpl",
      ], file) && !startswith(basename(file), ".")
    }
  ) : {}
}

resource "github_repository_file" "kubernetes_gitops_files" {
  for_each = local.kubernetes_gitops_files

  repository = github_repository.templates[local.kubernetes_gitops_key].name
  branch     = "main"
  file       = each.key
  content = try(each.value.use_templatefile, false) ? templatefile(each.value.source_file, {
    template_owner = "platform-team"
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
