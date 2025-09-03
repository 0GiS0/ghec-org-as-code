# AGENTS.md

## Project Description

${{values.description}}

This project is a base Helm Chart that provides standard templates and configurations for Kubernetes deployments, including production best practices.

## Setup Commands

- Validate chart: `helm lint .`
- Install chart: `helm install my-release .`
- Upgrade release: `helm upgrade my-release .`
- View templates: `helm template my-release .`
- Package chart: `helm package .`
- Uninstall: `helm uninstall my-release`

## Project Structure

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default values
- `templates/` - Kubernetes templates
- `templates/deployment.yaml` - Deployment template
- `templates/service.yaml` - Service template
- `templates/ingress.yaml` - Ingress template
- `templates/_helpers.tpl` - Helper templates
- `README.md` - Chart documentation

## Code Style

- Use valid YAML with 2-space indentation
- Follow Kubernetes naming conventions
- Use template helpers for reusable logic
- Document all values in comments
- Keep templates simple and readable
- Use conditional logic appropriately

## Script Integrations

### Available Helm Commands

- `helm template .` - Render templates locally
- `helm lint .` - Validate syntax and best practices
- `helm dependency update` - Update dependencies
- `helm test my-release` - Execute chart tests

### Kubernetes Integrations

This chart can integrate with:
- Ingress controllers (nginx, traefik)
- Service mesh (Istio, Linkerd)
- Monitoring (Prometheus, Grafana)
- Secrets management (External Secrets Operator)

## Testing Instructions

### Template Testing
```bash
# Validate chart syntax
helm lint .

# Render templates for review
helm template test-release . --debug

# Test with different values
helm template test-release . -f values-prod.yaml
```

### Deployment Testing
```bash
# Dry run install
helm install test-release . --dry-run --debug

# Install in test namespace
kubectl create namespace test
helm install test-release . -n test

# Verify created resources
kubectl get all -n test
```

### Configuration Testing
```bash
# Test with different configurations
helm template test . --set image.tag=v2.0.0
helm template test . --set replicaCount=3
helm template test . --set ingress.enabled=true
```

## Development Configuration

1. Install Helm 3.x
2. Have access to Kubernetes cluster
3. Clone the repository
4. Modify `values.yaml` as needed
5. Validate with `helm lint .`
6. Test with `helm template .`

### Values.yaml Structure

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

## Security Considerations

- Use appropriate security contexts
- Implement resource limits and requests
- Use specific service accounts
- Configure network policies if necessary
- Use secrets for sensitive data
- Enable pod security standards

## Troubleshooting

### Common Issues

**YAML syntax error:**
- Use `helm lint .` to validate
- Check indentation (2 spaces)
- Verify quotes in string values

**Template rendering errors:**
- Review template logic with `helm template --debug`
- Verify required values are defined
- Check Go template syntax

**Deployment failures:**
- Verify resource limits and requests
- Check image pull secrets
- Review network policies

## PR Instructions

- Run `helm lint .` before committing
- Test templates with different configurations
- Document changes in values.yaml
- Include tests for new templates
- Verify backward compatibility

## State Management

### Helm Releases
- Use semantic versioning in Chart.yaml
- Maintain changelog of changes
- Backup important releases

### Environment Configuration
```yaml
# values-dev.yaml
environment: development
replicaCount: 1

# values-prod.yaml
environment: production
replicaCount: 3
```

## Templates and Workflows

### CI/CD Workflows

The project includes workflows for:

- Chart validation with helm lint
- Template rendering tests
- Packaging and publishing to chart repository
- Automatic deployment to staging

### Template Helpers

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

### Conditional Templates

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

### Best Practices

- Use include instead of template
- Implement proper labeling
- Use consistent naming conventions
- Document custom values
- Implement proper resource management