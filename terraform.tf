terraform {
  required_version = ">= 1.6"

  # cloud {}

  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }

  }

}

# Configure the GitHub Provider with GitHub App authentication
provider "github" {
  # GitHub App configuration
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = var.github_app_private_key
  }

  # Organization to manage
  owner = var.github_organization
}
