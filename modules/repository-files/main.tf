# Repository Files Module - Main Configuration
# This module manages all file content for template repositories

# Local values for template processing
locals {
  template_name_mapping = {
    for key, value in var.template_repositories :
    key => replace(key, "backstage-template-", "")
  }

  template_title_mapping = {
    "backstage-template-system"          = "🧩 System"
    "backstage-template-domain"          = "🏷️ Domain"
    "backstage-template-node-service"    = "🟢 Node.js Service"
    "backstage-template-fastapi-service" = "⚡ FastAPI Service"
    "backstage-template-dotnet-service"  = "🟣 .NET Service"
    "backstage-template-gateway"         = "🚦 API Gateway"
    "backstage-template-ai-assistant"    = "🤖 AI Assistant Service"
    "backstage-template-astro-frontend"  = "☄️ Astro Frontend"
    "backstage-template-helm-base"       = "⚓ Helm Chart"
    "backstage-template-env-live"        = "🌍 Environment Configuration"
  }
}