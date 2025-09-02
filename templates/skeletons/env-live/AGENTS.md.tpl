# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es un template para gestión de configuración de entornos live usando infraestructura como código, incluyendo configuraciones para desarrollo, staging y producción.

## Comandos de configuración

- Validar configuración: `python validate_config.py`
- Aplicar configuración dev: `./scripts/deploy-dev.sh`
- Aplicar configuración staging: `./scripts/deploy-staging.sh`
- Aplicar configuración prod: `./scripts/deploy-prod.sh`
- Verificar diferencias: `./scripts/diff-envs.sh`

## Estructura del proyecto

- `environments/` - Configuraciones por entorno
- `environments/dev/` - Configuración de desarrollo
- `environments/staging/` - Configuración de staging  
- `environments/prod/` - Configuración de producción
- `validate_config.py` - Script de validación
- `scripts/` - Scripts de deployment y utilidades
- `.devcontainer/` - Configuración de contenedor de desarrollo

## Estilo de código

- Usar YAML para configuraciones
- Mantener consistencia entre entornos
- Documentar diferencias específicas por entorno
- Usar variables de entorno para valores sensibles
- Seguir principios de infrastructure as code
- Versionar todos los cambios de configuración

## Integraciones mediante Scripts

### Scripts de deployment disponibles

- `./scripts/deploy-dev.sh` - Deploy a desarrollo
- `./scripts/deploy-staging.sh` - Deploy a staging
- `./scripts/deploy-prod.sh` - Deploy a producción
- `./scripts/rollback.sh` - Rollback a versión anterior
- `./scripts/diff-envs.sh` - Comparar configuraciones

### Integraciones con herramientas

Este proyecto puede integrarse con:
- Terraform para infraestructura
- Ansible para configuración
- Kubernetes para orchestración
- GitOps tools (ArgoCD, Flux)

## Instrucciones de testing

### Testing de configuración
```bash
# Validar sintaxis YAML
python validate_config.py

# Test de diferencias entre entornos
./scripts/diff-envs.sh dev staging

# Dry run de deployment
./scripts/deploy-dev.sh --dry-run
```

### Testing de deployment
```bash
# Test en entorno de desarrollo
./scripts/deploy-dev.sh

# Verificar deployment
./scripts/health-check.sh dev

# Test de rollback
./scripts/rollback.sh dev previous-version
```

### Testing de configuración por entorno
```bash
# Validar configuración específica
python validate_config.py --env dev
python validate_config.py --env staging  
python validate_config.py --env prod
```

## Configuración de desarrollo

1. Clonar el repositorio
2. Instalar Python 3.11+ y dependencias
3. Configurar variables de entorno necesarias
4. Validar configuración: `python validate_config.py`
5. Probar deployment en dev: `./scripts/deploy-dev.sh`

### Variables de entorno por ambiente

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

## Consideraciones de seguridad

- Usar secrets management para credenciales
- Implementar least privilege access
- Auditar cambios de configuración
- Usar encryption para datos sensibles
- Mantener logs de deployments
- Implementar approval workflows para prod

## Solución de problemas

### Problemas comunes

**Error de validación YAML:**
- Verificar sintaxis con `python validate_config.py`
- Comprobar indentación y estructura
- Validar referencias a variables

**Deployment failure:**
- Revisar logs en `./logs/deploy-{env}.log`
- Verificar conectividad a servicios
- Comprobar permisos y credenciales

**Diferencias de configuración:**
- Usar `./scripts/diff-envs.sh` para comparar
- Revisar documentación de cambios
- Verificar que cambios sean intencionales

## Instrucciones de PR

- Validar configuración con `python validate_config.py`
- Documentar cambios por entorno
- Probar en desarrollo antes de staging/prod
- Incluir rollback plan para cambios críticos
- Revisar impacto en todos los entornos

## Gestión de estado

### Versionado de configuración
- Usar git tags para releases
- Mantener changelog de cambios
- Documentar breaking changes

### Backup y rollback
```bash
# Backup antes de deployment
./scripts/backup-config.sh prod

# Rollback si es necesario
./scripts/rollback.sh prod backup-20231201
```

## Plantillas y workflows

### Workflows de CI/CD

El proyecto incluye workflows para:

- Validación automática de configuración
- Deployment automático a dev en merge
- Approval gates para staging y prod
- Rollback automático en caso de fallo

### Estructura de configuración

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

### Validation script

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