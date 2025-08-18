terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-$${parameters.name}-$${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "$${parameters.name}"
    ManagedBy   = "Terraform"
    Database    = "PostgreSQL"
  }
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "psql-$${parameters.name}-$${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  version                      = "15"
  administrator_login          = var.db_admin_username
  administrator_password       = var.db_admin_password
  sku_name                     = var.sku_name
  storage_mb                   = var.storage_mb
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled          = true
  }

  tags = azurerm_resource_group.main.tags
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "$${parameters.name}"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Firewall rule to allow Azure services
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Firewall rule for development (optional, controlled by variable)
resource "azurerm_postgresql_flexible_server_firewall_rule" "dev_access" {
  count            = var.allow_dev_access ? 1 : 0
  name             = "AllowDeveloperAccess"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = var.dev_ip_range_start
  end_ip_address   = var.dev_ip_range_end
}

# PostgreSQL Configuration for optimal performance
resource "azurerm_postgresql_flexible_server_configuration" "shared_preload_libraries" {
  name      = "shared_preload_libraries"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "pg_stat_statements"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_statement" {
  name      = "log_statement"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "all"
}

# Diagnostic settings (optional)
resource "azurerm_monitor_diagnostic_setting" "postgresql" {
  count                      = var.enable_monitoring ? 1 : 0
  name                       = "postgresql-diagnostics"
  target_resource_id         = azurerm_postgresql_flexible_server.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "PostgreSQLLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}