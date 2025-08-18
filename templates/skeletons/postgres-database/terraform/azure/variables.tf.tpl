variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "db_admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
  default     = "psqladmin"
}

variable "db_admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU name for PostgreSQL Flexible Server"
  type        = string
  default     = "B_Standard_B1ms" # Burstable, 1 vCore, 2 GB RAM
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
  default     = 32768 # 32 GB
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backups"
  type        = bool
  default     = false
}

variable "allow_dev_access" {
  description = "Allow developer access from specific IP range"
  type        = bool
  default     = false
}

variable "dev_ip_range_start" {
  description = "Start IP address for developer access"
  type        = string
  default     = "0.0.0.0"
}

variable "dev_ip_range_end" {
  description = "End IP address for developer access"
  type        = string
  default     = "0.0.0.0"
}

variable "enable_monitoring" {
  description = "Enable monitoring and diagnostic settings"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for monitoring"
  type        = string
  default     = null
}