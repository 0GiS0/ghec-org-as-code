# .github Repository Configuration
# This file manages the organization-wide .github repository
# Includes shared agents, workflows, and configuration

# Commit configuration for .github repository
locals {
  github_config_commit = {
    commit_author = "Terraform"
    commit_email  = "terraform@${var.github_organization}.com"
  }

  # Dynamically discover all agent files in the .github/agents directory
  agent_files = {
    for agent_file in fileset("${path.module}/.github/agents", "*.agent.md") :
    trimsuffix(agent_file, ".agent.md") => {
      file_name = agent_file
      path      = "agents/${agent_file}"
      message   = "Add ${trimsuffix(agent_file, ".agent.md")} specialized agent"
    }
  }
}

# Agent files for the .github repository
# Automatically syncs all .agent.md files from the .github/agents directory
resource "github_repository_file" "github_agents" {
  for_each = local.agent_files

  repository          = github_repository.github_config.name
  branch              = "main"
  file                = each.value.path
  content             = file("${path.module}/.github/agents/${each.value.file_name}")
  commit_message      = each.value.message
  commit_author       = local.github_config_commit.commit_author
  commit_email        = local.github_config_commit.commit_email
  overwrite_on_create = true

  depends_on = [github_repository.github_config]
}
