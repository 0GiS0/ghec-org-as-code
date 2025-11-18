#!/bin/bash

#################################################################
# Demo Repository Cleanup Script
# 
# This script identifies and optionally deletes repositories 
# that have the 'demo' custom property set to 'yes'
#################################################################

set -euo pipefail

# Configuration (prefer values from .env via scripts/load-env.sh)
ORG_NAME=""
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
DRY_RUN="${DRY_RUN:-true}"
CONFIRM_DELETE="${CONFIRM_DELETE:-false}"
ALL_REPOS="${ALL_REPOS:-false}"

# GitHub App configuration for token generation
APP_ID=""
INSTALLATION_ID=""
PEM_FILE=""

# Try to load environment from repo root .env using scripts/load-env.sh
load_env_if_available() {
    local script_dir repo_root loader
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    repo_root="$(cd "$script_dir/../.." && pwd)"
    loader="$repo_root/scripts/load-env.sh"
    if [[ -f "$repo_root/.env" && -f "$loader" ]]; then
        # shellcheck disable=SC2164
        pushd "$repo_root" >/dev/null
        # shellcheck disable=SC1090
        source "$loader" >/dev/null 2>&1 || true
        popd >/dev/null || true
        # After loading, prefer env vars if they are now present
        ORG_NAME="${ORG_NAME:-${GITHUB_ORGANIZATION:-$ORG_NAME}}"
        APP_ID="${GITHUB_APP_ID:-$APP_ID}"
        INSTALLATION_ID="${GITHUB_APP_INSTALLATION_ID:-$INSTALLATION_ID}"
        PEM_FILE="${GITHUB_APP_PEM_FILE:-$PEM_FILE}"
        # Resolve PEM_FILE to absolute if relative and exists under repo root
        if [[ -n "$PEM_FILE" && "${PEM_FILE#/}" == "$PEM_FILE" && -f "$repo_root/$PEM_FILE" ]]; then
            PEM_FILE="$repo_root/$PEM_FILE"
        fi
    fi
}

# Load env early
load_env_if_available

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

This script identifies and optionally deletes GitHub repositories that have 
the 'demo' custom property set to 'yes'.

OPTIONS:
    -o, --org         GitHub organization name (default: GofiGeeksOrg)
    -t, --token       GitHub token with repo:delete permissions (auto-generated from GitHub App)
    -d, --delete      Actually delete repositories (default: dry run)
    -c, --confirm     Skip interactive confirmation (dangerous!)
    -A, --all         Target ALL repositories in the org (ignores demo property)
    -h, --help        Show this help message

ENVIRONMENT VARIABLES:
    ORG_NAME / GITHUB_ORGANIZATION   GitHub organization name (default: GofiGeeksOrg)
    GITHUB_TOKEN      GitHub token (if not provided, will use GitHub App)
    DRY_RUN           Set to 'false' to enable deletion (default: true)
    CONFIRM_DELETE    Set to 'true' to skip confirmation prompts (default: false)
    ALL_REPOS         Set to 'true' to target ALL repositories (default: false)
    GITHUB_APP_ID                 GitHub App ID (default: 1094298)
    GITHUB_APP_INSTALLATION_ID    GitHub App Installation ID (default: 58299244)
    GITHUB_APP_PEM_FILE           Path to GitHub App private key (default: GofiGeeksOrg.pem)

EXAMPLES:
    # Dry run (list demo repos without deleting) - uses GitHub App automatically
    $0

    # Dry run for specific org
    $0 --org myorg

    # Delete demo repos with confirmation prompts
    $0 --delete

    # Delete demo repos without prompts (be careful!)
    $0 --delete --confirm

    # Using environment variables
    ORG_NAME=myorg DRY_RUN=false $0

    # Delete demo repos without prompts (be careful!)
    $0 --delete --confirm

    # Using environment variables
    ORG_NAME=myorg DRY_RUN=false $0

    # Delete ALL repos (dry run first)
    $0 --all

    # Actually delete ALL repos with confirmation
    $0 --all --delete

    # Non-interactive delete ALL repos (dangerous!)
    $0 --all --delete --confirm

EOF
}

# Function to get GitHub token using GitHub App
get_github_token() {
    if [[ -n "$GITHUB_TOKEN" ]]; then
        echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 🔑 Using provided GitHub token"
        return 0
    fi
    
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 🔄 Generating GitHub token using GitHub App..."
    
    # Check if required files and variables exist
    if [[ ! -f "$PEM_FILE" ]]; then
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} 🔴 PEM file not found: $PEM_FILE" >&2
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} Please ensure the GitHub App private key is available" >&2
        exit 1
    fi
    
    # Get the directory of this script to find github_app_token.sh
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # Token script lives in scripts/terraform-integration/github_app_token.sh relative to repo root
    local token_script="$script_dir/../terraform-integration/github_app_token.sh"
    
    if [[ ! -f "$token_script" ]]; then
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} 🔴 GitHub App token script not found: $token_script" >&2
        exit 1
    fi
    
    # Generate token using the GitHub App script
    local token
    if ! token=$(APP_ID="$APP_ID" INSTALLATION_ID="$INSTALLATION_ID" PEM_FILE="$PEM_FILE" "$token_script"); then
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} 🔴 Failed to generate GitHub token using GitHub App" >&2
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} Debug: APP_ID='$APP_ID' INSTALLATION_ID='$INSTALLATION_ID' PEM_FILE='$PEM_FILE' helper='$token_script'" >&2
        exit 1
    fi
    
    if [[ -z "$token" ]]; then
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} 🔴 Empty token returned from GitHub App" >&2
        exit 1
    fi
    
    GITHUB_TOKEN="$token"
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} ✅ Successfully generated GitHub token using GitHub App"
}

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} $1"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--org)
            ORG_NAME="$2"
            shift 2
            ;;
        -t|--token)
            GITHUB_TOKEN="$2"
            shift 2
            ;;
        -d|--delete)
            DRY_RUN="false"
            shift
            ;;
        -c|--confirm)
            CONFIRM_DELETE="true"
            shift
            ;;
        -A|--all)
            ALL_REPOS="true"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate required parameters
if [[ -z "$ORG_NAME" ]]; then
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} 🔴 Organization name is required. Use -o/--org or set ORG_NAME environment variable." >&2
    exit 1
fi

# Get GitHub token (either provided or generated from GitHub App)
get_github_token

# Function to make GitHub API calls
github_api() {
    local endpoint="$1"
    local method="${2:-GET}"
    
    curl -s \
        -X "$method" \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com$endpoint"
}

# Function to get repositories with demo=yes
get_demo_repos() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 🔍 Fetching repositories in organization '$ORG_NAME'..." >&2
    
    local page=1
    local per_page=100
    local demo_repos=()
    
    while true; do
        local repos
        repos=$(github_api "/orgs/$ORG_NAME/repos?page=$page&per_page=$per_page&sort=updated&direction=desc")
        
        if [[ $(echo "$repos" | jq length) -eq 0 ]]; then
            break
        fi
        
        # If ALL_REPOS is true, collect all repo names without checking custom properties
        if [[ "$ALL_REPOS" == "true" ]]; then
            while read -r repo_name; do
                if [[ -n "$repo_name" && "$repo_name" != "null" ]]; then
                    demo_repos+=("$repo_name")
                    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} 🎯 Queued repository: $repo_name" >&2
                fi
            done < <(echo "$repos" | jq -r '.[].name')
            ((page++))
            continue
        fi

        # Otherwise, check each repository for demo custom property
        while read -r repo_name; do
            if [[ -n "$repo_name" && "$repo_name" != "null" ]]; then
                echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 🔍 Checking custom properties for repository: $repo_name" >&2
                
                local properties
                properties=$(github_api "/repos/$ORG_NAME/$repo_name/properties/values" 2>/dev/null || echo "[]")
                
                # Check if demo property exists and equals "yes"
                local demo_value
                demo_value=$(echo "$properties" | jq -r '.[] | select(.property_name == "demo") | .value // empty')
                
                if [[ "$demo_value" == "yes" ]]; then
                    demo_repos+=("$repo_name")
                    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} 🎯 Found demo repository: $repo_name" >&2
                elif [[ -n "$demo_value" ]]; then
                    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} ❌ Repository $repo_name has demo=$demo_value (not 'yes')" >&2
                else
                    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} ⚪ Repository $repo_name has no demo property" >&2
                fi
            fi
        done < <(echo "$repos" | jq -r '.[].name')
        
        ((page++))
    done
    
    # Output only the repo names to stdout
    printf '%s\n' "${demo_repos[@]}"
}

# Function to delete a repository
delete_repo() {
    local repo_name="$1"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} 🧪 DRY RUN: Would delete repository '$repo_name'"
        return 0
    fi
    
    if [[ "$CONFIRM_DELETE" != "true" ]]; then
        echo -n "❓ Are you sure you want to delete repository '$repo_name'? [y/N]: "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} ⏭️  Skipping deletion of '$repo_name'"
            return 0
        fi
    fi
    
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 🗑️  Deleting repository: $repo_name"
    local result
    result=$(github_api "/repos/$ORG_NAME/$repo_name" "DELETE")
    
    if [[ -z "$result" ]]; then
        echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} ✅ Successfully deleted repository: $repo_name"
    else
        echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} ❌ Failed to delete repository '$repo_name': $result" >&2
        return 1
    fi
}

# Main execution
main() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 🚀 Starting demo repository cleanup for organization: $ORG_NAME"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} 🧪 Running in DRY RUN mode. No repositories will be deleted."
        echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} Use --delete flag to actually delete repositories."
    else
        echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} ⚠️  DELETION MODE ENABLED. Repositories will be permanently deleted!"
    fi
    
    if [[ "$ALL_REPOS" == "true" ]]; then
        warn "ALL REPOS MODE: The script will target EVERY repository in '$ORG_NAME' (ignoring the 'demo' custom property)."
    else
        log "Filtering by custom property: demo=yes"
    fi

    # Get demo repositories
    local demo_repos
    readarray -t demo_repos < <(get_demo_repos)
    
    if [[ ${#demo_repos[@]} -eq 0 ]]; then
        echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 🤷 No repositories found with demo property set to 'yes'"
        exit 0
    fi
    
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 📋 Found ${#demo_repos[@]} demo repositories:"
    for repo in "${demo_repos[@]}"; do
        echo "  🎯 $repo"
    done
    
    if [[ "$DRY_RUN" != "true" && "$CONFIRM_DELETE" != "true" ]]; then
        echo -n "❓ Do you want to proceed with deleting these ${#demo_repos[@]} repositories? [y/N]: "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} ❌ Operation cancelled by user"
            exit 0
        fi
    fi
    
    # Process each repository
    local success_count=0
    local failure_count=0
    
    for repo in "${demo_repos[@]}"; do
        if delete_repo "$repo"; then
            success_count=$((success_count + 1))
        else
            failure_count=$((failure_count + 1))
        fi
    done
    
    # Summary
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} 📊 Cleanup completed:"
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC}   📈 Found: ${#demo_repos[@]} demo repositories"
        echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC}   🧪 Would delete: ${#demo_repos[@]} repositories"
    else
        echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC}   📈 Processed: ${#demo_repos[@]} repositories"
        echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS:${NC}   ✅ Successfully deleted: $success_count"
        if [[ $failure_count -gt 0 ]]; then
            echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC}   ❌ Failed: $failure_count"
        fi
        
        # Exit with error code if there were failures
        if [[ $failure_count -gt 0 ]]; then
            exit 1
        fi
    fi
    
    exit 0
}

# Run main function
main "$@"