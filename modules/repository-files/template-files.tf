# Repository Files Module - Template Files
# This module manages template.yaml files for all template repositories

resource "github_repository_file" "template_yaml" {
  for_each = var.template_repositories

  repository = var.repository_names[each.key]
  branch     = "main"
  file       = "template.yaml"
  content = templatefile("${path.root}/templates/template.yaml.tpl", {
    name        = local.template_name_mapping[each.key]
    title       = local.template_title_mapping[each.key]
    description = each.value.description
    type        = each.value.type
  })
  commit_message      = "Add Backstage template configuration"
  commit_author       = "Terraform"
  commit_email        = "terraform@${var.github_organization}.com"
  overwrite_on_create = true

  depends_on = [var.template_repositories_dependency]
}