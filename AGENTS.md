# AGENTS.md

## Descripción del proyecto

Este repositorio gestiona la configuración de una organización de GitHub Enterprise Cloud (GHEC) como código usando Terraform. Crea equipos, repositorios plantilla, protecciones de rama y configura el acceso a Codespaces de la organización.

## Comandos de configuración

- Inicializar Terraform: `terraform init`
- Formatear código: `terraform fmt`
- Validar configuración: `terraform validate`
- Planificar cambios: `terraform plan`
- Aplicar cambios: `terraform apply`
- Destruir recursos: `terraform destroy`

## Estructura del proyecto

- `main.tf` - Configuración principal de Terraform
- `variables.tf` - Definición de variables
- `outputs.tf` - Valores de salida
- `terraform.tf` - Configuración de providers y backend
- `repositories.tf` - Gestión de repositorios
- `teams.tf` - Gestión de equipos
- `codespaces.tf` - Configuración de Codespaces
- `templates/` - Plantillas para repositorios y workflows
- `terraform.tfvars.example` - Archivo de ejemplo para variables

## Estilo de código

- Usar Terraform >= 1.6
- Provider de GitHub >= 6.0
- Usar indentación de 2 espacios
- Comentarios en español para documentación
- Variables sensibles marcadas con `sensitive = true`
- Validaciones en variables cuando sea apropiado

## Instrucciones de testing

- Ejecutar `terraform fmt -check` para verificar formato
- Ejecutar `terraform validate` para validar sintaxis
- Ejecutar `terraform plan` antes de aplicar cambios
- Verificar que el archivo PEM de la GitHub App existe y es legible
- Confirmar que los usuarios listados en las variables son miembros de la organización

## Configuración de desarrollo

1. Copiar `terraform.tfvars.example` a `terraform.tfvars`
2. Configurar las variables requeridas:
   - `github_organization`
   - `github_app_id`
   - `github_app_installation_id`
   - `github_app_pem_file`
3. Asegurar que el archivo PEM tenga permisos 600
4. Verificar que la GitHub App tenga los permisos necesarios

## Consideraciones de seguridad

- El archivo PEM debe tener permisos restrictivos (600)
- Usar rutas absolutas para el archivo PEM
- Las variables sensibles están marcadas como `sensitive = true`
- La GitHub App debe tener permisos mínimos necesarios
- No commitear archivos `terraform.tfvars` con datos reales

## Solución de problemas

- Error "Resource not accessible by integration": Verificar permisos de la GitHub App
- Error de Codespaces: Revisar `/tmp/codespaces-org-access.log`
- Error de archivo PEM: Verificar que existe y es legible
- Error 422 EMU: Los usuarios deben ser miembros de la organización antes de ser asignados a equipos

## Instrucciones de PR

- Título: `[GHEC] <Descripción del cambio>`
- Siempre ejecutar `terraform fmt` y `terraform validate` antes de commitear
- Incluir descripción detallada de los cambios en el PR
- Verificar que no se incluyan archivos sensibles en el commit
- Actualizar documentación si se añaden nuevas variables o funcionalidades

## Gestión de estado

- Configurar backend remoto en `terraform.tf` para entornos de producción
- Usar workspaces de Terraform para diferentes entornos si es necesario
- Hacer backup del estado antes de cambios importantes
- No modificar manualmente el archivo de estado

## Plantillas y workflows

- Las plantillas están en `templates/` y se usan para crear repositorios
- Los workflows de CI/CD se generan automáticamente
- Modificar plantillas requiere actualizar la configuración de repositorios
- Verificar que `manage_workflow_files` esté configurado correctamente

### Plantillas para Backstage

Las plantillas en el directorio `templates/` están diseñadas para ser utilizadas por **Backstage** como templates de software. Backstage es una plataforma de desarrollador que permite crear nuevos proyectos desde plantillas predefinidas.

#### Manejo de placeholders mixtos (Terraform + Backstage)

Cuando un archivo necesita placeholders tanto para Terraform como para Backstage, se debe usar la siguiente estrategia:

##### Archivos procesados por Terraform (`templatefile()`)

Para archivos como `catalog-info.yaml.tpl` que son procesados por Terraform:

- **Placeholders de Terraform**: `${variable_name}` (una sola $)
- **Placeholders de Backstage**: `$${{parameters.nombreVariable}}` (doble $)
  - Terraform convierte `$$` en `$` literal
  - El resultado final será `${{parameters.nombreVariable}}` que Backstage puede procesar

```yaml
# En catalog-info.yaml.tpl (procesado por Terraform)
metadata:
  name: ${template_name}                    # Terraform placeholder
  title: ${template_title}                  # Terraform placeholder
  description: ${template_description}      # Terraform placeholder
  values:
    name: $${{parameters.name}}             # Backstage placeholder (doble $)
    owner: $${{parameters.owner}}           # Backstage placeholder (doble $)
```

##### Archivos copiados directamente (`file()`)

Para archivos en `skeletons/` que se copian tal cual:

- **Placeholders de Backstage**: `${{values.nombreVariable}}` (una sola $)
- **No hay placeholders de Terraform** en estos archivos

```json
// En package.json.tpl (copiado con file())
{
  "name": "backstage-node-service-template", // Nombre fijo válido para Dependabot
  "description": "${{values.description}}"    // Backstage placeholder (una $)
}
```

**Nota**: Para campos críticos como `name` en `package.json`, se usa un valor fijo válido en lugar de placeholders para garantizar que herramientas como Dependabot puedan parsear el archivo correctamente en el repositorio template.

#### Formato correcto de placeholders

- **Terraform**: `${variable_name}`
- **Backstage en archivos procesados por Terraform**: `$${{parameters.nombreVariable}}`
- **Backstage en archivos copiados directamente**: `${{values.nombreVariable}}`

#### Ejemplo de uso en Backstage

```yaml
# En el template.yaml de Backstage
parameters:
  - name: projectName
    type: string
    description: Nombre del proyecto
  - name: description
    type: string
    description: Descripción del proyecto
```

```markdown
<!-- En un archivo README.md de la plantilla (skeleton) -->
# ${{values.projectName}}

${{values.description}}

Este proyecto fue creado desde la plantilla de Backstage.
```
