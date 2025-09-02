###############################################
# Organization Custom Properties Management
# Managed via GitHub REST API using curl
# Requires a token with organization custom properties: write permissions
###############################################

locals {
  # Prepare custom properties payload for API calls
  custom_properties_payloads = {
    for name, config in var.organization_custom_properties : name => jsonencode({
      property_name  = name
      description    = config.description
      value_type     = config.property_type
      required       = config.required
      default_value  = try(config.default_value, null)
      allowed_values = try(config.allowed_values, null)
    })
  }
}

# Create organization-level custom properties
resource "null_resource" "org_custom_properties" {
  for_each = var.enable_custom_properties ? var.organization_custom_properties : {}

  # Re-run when org, property config changes
  triggers = {
    org      = var.github_organization
    payload  = local.custom_properties_payloads[each.key]
    property = each.key
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -eo pipefail

      # Log file for diagnostics
      LOG_FILE="$${LOG_FILE:-/tmp/custom-properties-${each.key}.log}"
      mkdir -p "$(dirname "$LOG_FILE")" || true

      echo "$(date -Is) START creating custom property ${each.key}" >> "$LOG_FILE"

      # GitHub App token minting (similar to codespaces.tf pattern)
      if [ -n "$APP_ID" ] && [ -n "$INSTALLATION_ID" ] && [ -n "$PEM_FILE" ]; then
        # Generate JWT
        NOW=$(date +%s)
        IAT=$((NOW - 60))
        EXP=$((NOW + 600))
        
        HEADER='{"alg":"RS256","typ":"JWT"}'
        PAYLOAD='{"iat":'$IAT',"exp":'$EXP',"iss":"'$APP_ID'"}'
        
        HEADER_B64=$(echo -n "$HEADER" | base64 -w0 | tr -d '=' | tr '/+' '_-')
        PAYLOAD_B64=$(echo -n "$PAYLOAD" | base64 -w0 | tr -d '=' | tr '/+' '_-')
        
        SIGNATURE=$(echo -n "$HEADER_B64.$PAYLOAD_B64" | openssl dgst -sha256 -sign "$PEM_FILE" | base64 -w0 | tr -d '=' | tr '/+' '_-')
        JWT="$HEADER_B64.$PAYLOAD_B64.$SIGNATURE"
        
        # Get installation token
        TOKEN_RESP=$(curl -sS -X POST \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer $JWT" \
          -H "X-GitHub-Api-Version: 2022-11-28" \
          "https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens")
        
        GITHUB_TOKEN=$(echo "$TOKEN_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
        
        if [ -z "$GITHUB_TOKEN" ]; then
          echo "$(date -Is) ERROR: Failed to get GitHub token" >> "$LOG_FILE"
          echo "ERROR: Failed to authenticate with GitHub App" >&2
          exit 1
        fi
        
        echo "$(date -Is) STEP token-minted" >> "$LOG_FILE"
      fi

      ORG="$ORG_NAME"
      PROPERTY_NAME="${each.key}"
      PAYLOAD="$PROPERTY_PAYLOAD"

      # Check if property already exists
      echo "$(date -Is) STEP check-existing-property org=$ORG property=$PROPERTY_NAME" >> "$LOG_FILE"
      CHECK_RESP=$(curl -sS -w "\\n%%{http_code}" -X GET \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/orgs/$ORG/properties/schema/$PROPERTY_NAME" 2>/dev/null || echo -e "\\n404")

      CHECK_STATUS=$(printf '%s' "$CHECK_RESP" | tail -n1)
      
      if [ "$CHECK_STATUS" = "200" ]; then
        echo "$(date -Is) INFO: Property $PROPERTY_NAME already exists, updating..." >> "$LOG_FILE"
        METHOD="PATCH"
        API_URL="https://api.github.com/orgs/$ORG/properties/schema/$PROPERTY_NAME"
      else
        echo "$(date -Is) INFO: Property $PROPERTY_NAME does not exist, creating..." >> "$LOG_FILE"
        METHOD="POST"
        API_URL="https://api.github.com/orgs/$ORG/properties/schema"
      fi

      # Create or update the custom property
      echo "$(date -Is) STEP $METHOD-custom-property org=$ORG property=$PROPERTY_NAME" >> "$LOG_FILE"
      RESP_ALL=$(curl -sS -w "\\n%%{http_code}" -X $METHOD \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$API_URL" \
        -d "$PAYLOAD")

      STATUS=$(printf '%s' "$RESP_ALL" | tail -n1)
      BODY=$(printf '%s' "$RESP_ALL" | sed '$d')

      echo "$(date -Is) $METHOD $API_URL status=$STATUS property=$PROPERTY_NAME" >> "$LOG_FILE"

      if [ "$STATUS" != "201" ] && [ "$STATUS" != "200" ]; then
        echo "$(date -Is) ERROR body: $BODY" >> "$LOG_FILE"
        echo "ERROR: Failed to create/update custom property $PROPERTY_NAME. HTTP $STATUS. See $(basename "$LOG_FILE") for details." >&2
        exit 1
      fi

      echo "Custom property $PROPERTY_NAME configured for organization $ORG (HTTP $STATUS)"
    EOT

    environment = {
      ORG_NAME         = var.github_organization
      PROPERTY_PAYLOAD = local.custom_properties_payloads[each.key]
      # GitHub App token minting
      APP_ID          = var.github_app_id
      INSTALLATION_ID = var.github_app_installation_id
      PEM_FILE        = abspath(var.github_app_pem_file)
      LOG_FILE        = "/tmp/custom-properties-${each.key}.log"
    }
  }
}

# Apply custom properties to template repositories
resource "github_repository_custom_property" "template_properties" {
  for_each = var.enable_custom_properties ? {
    for repo_name in keys(var.template_repositories) :
    "${repo_name}-service-tier" => {
      repository     = repo_name
      property_name  = "service-tier"
      property_type  = "single_select"
      property_value = [var.template_repository_custom_properties[repo_name].service_tier]
    }
  } : {}

  repository     = github_repository.templates[each.value.repository].name
  property_name  = each.value.property_name
  property_type  = each.value.property_type
  property_value = each.value.property_value

  depends_on = [
    github_repository.templates,
    null_resource.org_custom_properties
  ]
}

resource "github_repository_custom_property" "template_team_owner" {
  for_each = var.enable_custom_properties ? {
    for repo_name in keys(var.template_repositories) :
    "${repo_name}-team-owner" => {
      repository     = repo_name
      property_name  = "team-owner"
      property_type  = "string"
      property_value = [var.template_repository_custom_properties[repo_name].team_owner]
    }
  } : {}

  repository     = github_repository.templates[each.value.repository].name
  property_name  = each.value.property_name
  property_type  = each.value.property_type
  property_value = each.value.property_value

  depends_on = [
    github_repository.templates,
    null_resource.org_custom_properties
  ]
}

# Apply custom properties to main repositories (Backstage and reusable-workflows)
resource "github_repository_custom_property" "backstage_service_tier" {
  count = var.enable_custom_properties ? 1 : 0

  repository     = github_repository.backstage.name
  property_name  = "service-tier"
  property_type  = "single_select"
  property_value = ["tier-1"]

  depends_on = [
    github_repository.backstage,
    null_resource.org_custom_properties
  ]
}

resource "github_repository_custom_property" "backstage_team_owner" {
  count = var.enable_custom_properties ? 1 : 0

  repository     = github_repository.backstage.name
  property_name  = "team-owner"
  property_type  = "string"
  property_value = ["platform-team"]

  depends_on = [
    github_repository.backstage,
    null_resource.org_custom_properties
  ]
}

resource "github_repository_custom_property" "reusable_workflows_service_tier" {
  count = var.enable_custom_properties ? 1 : 0

  repository     = github_repository.reusable_workflows.name
  property_name  = "service-tier"
  property_type  = "single_select"
  property_value = ["tier-1"]

  depends_on = [
    github_repository.reusable_workflows,
    null_resource.org_custom_properties
  ]
}

resource "github_repository_custom_property" "reusable_workflows_team_owner" {
  count = var.enable_custom_properties ? 1 : 0

  repository     = github_repository.reusable_workflows.name
  property_name  = "team-owner"
  property_type  = "string"
  property_value = ["platform-team"]

  depends_on = [
    github_repository.reusable_workflows,
    null_resource.org_custom_properties
  ]
}