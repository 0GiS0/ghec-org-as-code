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
  }
}

# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                = "cae-$${parameters.name}-$${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = azurerm_resource_group.main.tags
}

# MongoDB Cosmos DB Account
resource "azurerm_cosmosdb_account" "main" {
  name                = "cosmos-$${parameters.name}-$${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableMongo"
  }

  tags = azurerm_resource_group.main.tags
}

# MongoDB Database
resource "azurerm_cosmosdb_mongo_database" "main" {
  name                = "$${parameters.name}"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  throughput          = 400
}

# Container App
resource "azurerm_container_app" "main" {
  name                         = "ca-$${parameters.name}-$${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "$${parameters.name}"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest" # Replace with your image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "MONGODB_URI"
        value = azurerm_cosmosdb_account.main.connection_strings[0]
      }

      env {
        name  = "PORT"
        value = "8080"
      }
    }

    min_replicas = 1
    max_replicas = 3
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = azurerm_resource_group.main.tags
}