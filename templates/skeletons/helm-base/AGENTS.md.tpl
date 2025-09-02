# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es un Helm Chart base que proporciona templates y configuraciones estándar para deployments de Kubernetes, incluyendo best practices para production.

## Comandos de configuración

- Validar chart: `helm lint .`
- Instalar chart: `helm install my-release .`
- Actualizar release: `helm upgrade my-release .`
- Ver templates: `helm template my-release .`
- Empaquetar chart: `helm package .`
- Desinstalar: `helm uninstall my-release`

## Estructura del proyecto

- `Chart.yaml` - Metadata del chart
- `values.yaml` - Valores por defecto
- `templates/` - Templates de Kubernetes
- `templates/deployment.yaml` - Template de Deployment
- `templates/service.yaml` - Template de Service
- `templates/ingress.yaml` - Template de Ingress
- `templates/_helpers.tpl` - Helper templates
- `README.md` - Documentación del chart

## Estilo de código

- Usar YAML válido con indentación de 2 espacios
- Seguir convenciones de naming de Kubernetes
- Usar templates helpers para lógica reutilizable
- Documentar todos los values en comments
- Mantener templates simples y legibles
- Usar conditional logic apropiadamente

## Integraciones mediante Scripts

### Comandos Helm disponibles

- `helm template .` - Renderizar templates localmente
- `helm lint .` - Validar sintaxis y best practices
- `helm dependency update` - Actualizar dependencias
- `helm test my-release` - Ejecutar tests del chart

### Integraciones con Kubernetes

Este chart puede integrarse con:
- Ingress controllers (nginx, traefik)
- Service mesh (Istio, Linkerd)
- Monitoring (Prometheus, Grafana)
- Secrets management (External Secrets Operator)

## Instrucciones de testing

### Testing de templates
```bash
# Validar sintaxis del chart
helm lint .

# Renderizar templates para revisión
helm template test-release . --debug

# Test con diferentes valores
helm template test-release . -f values-prod.yaml
```

### Testing de deployment
```bash
# Dry run install
helm install test-release . --dry-run --debug

# Install en namespace de test
kubectl create namespace test
helm install test-release . -n test

# Verificar recursos creados
kubectl get all -n test
```

### Testing de configuración
```bash
# Test con diferentes configurations
helm template test . --set image.tag=v2.0.0
helm template test . --set replicaCount=3
helm template test . --set ingress.enabled=true
```

## Configuración de desarrollo

1. Instalar Helm 3.x
2. Tener acceso a cluster de Kubernetes
3. Clonar el repositorio
4. Modificar `values.yaml` según necesidades
5. Validar con `helm lint .`
6. Probar con `helm template .`

### Estructura de values.yaml

```yaml
# Default values for the chart
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "latest"

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts: []
  tls: []

resources: {}
nodeSelector: {}
tolerations: []
affinity: {}
```

## Consideraciones de seguridad

- Usar security contexts apropiados
- Implementar resource limits y requests
- Usar service accounts específicos
- Configurar network policies si es necesario
- Usar secrets para datos sensibles
- Habilitar pod security standards

## Solución de problemas

### Problemas comunes

**Error de sintaxis YAML:**
- Usar `helm lint .` para validar
- Verificar indentación (2 espacios)
- Comprobar quotes en valores de string

**Template rendering errors:**
- Revisar logic de templates con `helm template --debug`
- Verificar que required values estén definidos
- Comprobar sintaxis de Go templates

**Deployment failures:**
- Verificar resources limits y requests
- Comprobar image pull secrets
- Revisar network policies

## Instrucciones de PR

- Ejecutar `helm lint .` antes de commit
- Probar templates con diferentes configuraciones
- Documentar cambios en values.yaml
- Incluir tests para nuevos templates
- Verificar backward compatibility

## Gestión de estado

### Releases de Helm
- Usar semantic versioning en Chart.yaml
- Mantener changelog de cambios
- Backup de releases importantes

### Configuración por entorno
```yaml
# values-dev.yaml
environment: development
replicaCount: 1

# values-prod.yaml
environment: production
replicaCount: 3
```

## Plantillas y workflows

### Workflows de CI/CD

El proyecto incluye workflows para:

- Validación de chart con helm lint
- Tests de rendering de templates
- Packaging y publishing a chart repository
- Deployment automático a staging

### Template helpers

```yaml
{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
```

### Conditional templates

```yaml
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "chart.fullname" . }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{ .Values.ingress.className }}
  {{- end }}
  # ... rest of ingress spec
{{- end }}
```

### Best practices

- Usar include en lugar de template
- Implementar proper labeling
- Usar consistent naming conventions
- Documentar custom values
- Implementar proper resource management