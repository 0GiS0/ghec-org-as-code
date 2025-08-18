# Main configuration file for GHEC Organization as Code
# This file serves as the entry point and includes data sources and locals

# Data source to get current organization information
data "github_organization" "current" {
  name = var.github_organization
}

# Local values for reusable configurations
locals {
  # Common tags for all resources
  common_topics = ["ghec", "terraform", "iac"]

  # Team names
  team_names = {
    parent             = var.parent_team_name
    platform           = "platform-team"
    template_approvers = "template-approvers"
    security           = "security"
    read_only          = "read-only"
    developers         = "cosmic-devs"
  }

  # Repository permissions for teams
  repository_permissions = {
    platform_team      = "admin"
    template_approvers = "maintain"
    security           = "pull"
    read_only          = "pull"
  }

  # Template type mapping for catalog-info.yaml
  template_type_mapping = {
    "backstage-template-system"             = "system"
    "backstage-template-domain"             = "domain"
    "backstage-template-node-service"       = "service"
    "backstage-template-fastapi-service"    = "service"
    "backstage-template-dotnet-service"     = "service"
    "backstage-template-gateway"            = "service"
    "backstage-template-ai-assistant"       = "service"
    "backstage-template-astro-frontend"     = "website"
    "backstage-template-helm-base"          = "library"
    "backstage-template-env-live"           = "resource"
    "backstage-template-go-service"         = "service"
    "backstage-template-java-service"       = "service"
    "backstage-template-rust-service"       = "service"
    "backstage-template-php-service"        = "service"
    "backstage-template-postgres-database"  = "resource"
    "backstage-template-mysql-database"     = "resource"
    "backstage-template-sqlserver-database" = "resource"
    "backstage-template-mongodb-database"   = "resource"
    "backstage-template-oracle-database"    = "resource"
    "backstage-template-sqlite-database"    = "resource"
    "backstage-template-mariadb-database"   = "resource"
  }

  # Helper function to convert repository name to template name
  template_name_mapping = {
    for key, value in var.template_repositories :
    key => replace(key, "backstage-template-", "")
  }

  # Helper function to create template titles
  template_title_mapping = {
    "backstage-template-system"             = "🧩 System"
    "backstage-template-domain"             = "🏷️ Domain"
    "backstage-template-node-service"       = "🟢 Node.js Service"
    "backstage-template-fastapi-service"    = "⚡ FastAPI Service"
    "backstage-template-dotnet-service"     = "🟣 .NET Service"
    "backstage-template-gateway"            = "🚦 API Gateway"
    "backstage-template-ai-assistant"       = "🤖 AI Assistant Service"
    "backstage-template-astro-frontend"     = "☄️ Astro Frontend"
    "backstage-template-helm-base"          = "⚓ Helm Chart"
    "backstage-template-env-live"           = "🌍 Environment Configuration"
    "backstage-template-go-service"         = "🔵 Go Service"
    "backstage-template-java-service"       = "☕ Java Spring Boot Service"
    "backstage-template-rust-service"       = "🦀 Rust Service"
    "backstage-template-php-service"        = "🐘 PHP Laravel Service"
    "backstage-template-postgres-database"  = "🐘 PostgreSQL Database"
    "backstage-template-mysql-database"     = "🐬 MySQL Database"
    "backstage-template-sqlserver-database" = "🗃️ SQL Server Database"
    "backstage-template-mongodb-database"   = "🍃 MongoDB Database"
    "backstage-template-oracle-database"    = "🔶 Oracle Database"
    "backstage-template-sqlite-database"    = "📦 SQLite Database"
    "backstage-template-mariadb-database"   = "🗄️ MariaDB Database"
  }
}
