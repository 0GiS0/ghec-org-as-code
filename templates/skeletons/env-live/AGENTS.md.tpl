# AGENTS.md

## Project Description

${{values.description}}

This project is a template for managing live environment configuration using infrastructure as code, including configurations for development, staging, and production.

## Setup Commands

- Validate configuration: `python validate_config.py`
- Apply dev configuration: `./scripts/deploy-dev.sh`
- Apply staging configuration: `./scripts/deploy-staging.sh`
- Apply prod configuration: `./scripts/deploy-prod.sh`
- Check differences: `./scripts/diff-envs.sh`

## Project Structure

- `environments/` - Configuration per environment
- `environments/dev/` - Development configuration
- `environments/staging/` - Staging configuration  
- `environments/prod/` - Production configuration
- `validate_config.py` - Validation script
- `scripts/` - Deployment and utility scripts
- `.devcontainer/` - Development container configuration

## Code Style

- Use YAML for configurations
- Maintain consistency between environments
- Document environment-specific differences
- Use environment variables for sensitive values
- Follow infrastructure as code principles
- Version all configuration changes

## Script Integrations

### Available Deployment Scripts

- `./scripts/deploy-dev.sh` - Deploy to development
- `./scripts/deploy-staging.sh` - Deploy to staging
- `./scripts/deploy-prod.sh` - Deploy to production
- `./scripts/rollback.sh` - Rollback to previous version
- `./scripts/diff-envs.sh` - Compare configurations

### Tool Integrations

This project can integrate with:
- Terraform for infrastructure
- Ansible for configuration
- Kubernetes for orchestration
- GitOps tools (ArgoCD, Flux)

## Testing Instructions

### Configuration Testing
```bash
# Validate YAML syntax
python validate_config.py

# Test differences between environments
./scripts/diff-envs.sh dev staging

# Dry run deployment
./scripts/deploy-dev.sh --dry-run
```

### Deployment Testing
```bash
# Test in development environment
./scripts/deploy-dev.sh

# Verify deployment
./scripts/health-check.sh dev

# Test rollback
./scripts/rollback.sh dev previous-version
```

### Environment-specific Configuration Testing
```bash
# Validate specific configuration
python validate_config.py --env dev
python validate_config.py --env staging  
python validate_config.py --env prod
```

## Development Configuration

1. Clone the repository
2. Install Python 3.11+ and dependencies
3. Configure necessary environment variables
4. Validate configuration: `python validate_config.py`
5. Test deployment in dev: `./scripts/deploy-dev.sh`

### Environment Variables per Environment

```bash
# Development
export ENV=dev
export API_URL=https://api-dev.example.com
export DATABASE_URL=postgresql://dev-db

# Staging  
export ENV=staging
export API_URL=https://api-staging.example.com
export DATABASE_URL=postgresql://staging-db

# Production
export ENV=prod
export API_URL=https://api.example.com
export DATABASE_URL=postgresql://prod-db
```

## Security Considerations

- Use secrets management for credentials
- Implement least privilege access
- Audit configuration changes
- Use encryption for sensitive data
- Maintain deployment logs
- Implement approval workflows for prod

## Troubleshooting

### Common Issues

**YAML validation error:**
- Verify syntax with `python validate_config.py`
- Check indentation and structure
- Validate variable references

**Deployment failure:**
- Review logs in `./logs/deploy-{env}.log`
- Verify service connectivity
- Check permissions and credentials

**Configuration differences:**
- Use `./scripts/diff-envs.sh` to compare
- Review change documentation
- Verify changes are intentional

## PR Instructions

- Validate configuration with `python validate_config.py`
- Document changes per environment
- Test in development before staging/prod
- Include rollback plan for critical changes
- Review impact on all environments

## State Management

### Configuration Versioning
- Use git tags for releases
- Maintain changelog of changes
- Document breaking changes

### Backup and Rollback
```bash
# Backup before deployment
./scripts/backup-config.sh prod

# Rollback if necessary
./scripts/rollback.sh prod backup-20231201
```

## Templates and Workflows

### CI/CD Workflows

The project includes workflows for:

- Automatic configuration validation
- Automatic deployment to dev on merge
- Approval gates for staging and prod
- Automatic rollback on failure

### Configuration Structure

```yaml
# environments/dev/config.yaml
environment: development
replicas: 1
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

# environments/prod/config.yaml
environment: production
replicas: 3
resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

### Validation Script

```python
# validate_config.py
import yaml
import sys
import os

def validate_environment(env_path):
    """Validate configuration for a specific environment"""
    config_file = os.path.join(env_path, 'config.yaml')
    
    if not os.path.exists(config_file):
        print(f"Error: {config_file} not found")
        return False
    
    try:
        with open(config_file, 'r') as f:
            config = yaml.safe_load(f)
        
        # Add your validation logic here
        required_fields = ['environment', 'replicas', 'resources']
        for field in required_fields:
            if field not in config:
                print(f"Error: Missing required field '{field}' in {config_file}")
                return False
        
        print(f"✓ {config_file} is valid")
        return True
        
    except yaml.YAMLError as e:
        print(f"Error parsing {config_file}: {e}")
        return False

if __name__ == "__main__":
    environments = ['dev', 'staging', 'prod']
    all_valid = True
    
    for env in environments:
        env_path = f"environments/{env}"
        if not validate_environment(env_path):
            all_valid = False
    
    sys.exit(0 if all_valid else 1)
```