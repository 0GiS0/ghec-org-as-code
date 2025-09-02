## 🚀 Quickstart: GHEC Org as Code

Configura tu organización de GitHub Enterprise Cloud con Terraform en minutos. Este repo crea equipos, repositorios plantilla y protecciones de rama.

---

## ✅ Requisitos

- Terraform CLI ≥ 1.6
- Una GitHub App instalada en tu organización (con la clave privada .pem)

### 🔐 Permisos de la GitHub App (imprescindibles)

Para autenticación, este repo usa exclusivamente la GitHub App (sin PAT ni GITHUB_TOKEN). Asegúrate de otorgar como mínimo:

- Organización:
   - Administration: Read and write
   - Members: Read
   - Codespaces: Read and write (necesario para gestionar el acceso de Codespaces de la organización)
   - Codespaces secrets: Read and write (recomendado si más adelante se gestionan secretos de Codespaces)
   - Custom properties: Read and write (para gestionar propiedades personalizadas de repositorios)
- Repositorio:
   - Administration: Read and write
   - Contents: Read and write
   - Metadata: Read
- Actions: Read and write (si gestionas workflows/templates de CI)
- Workflows: Read and write (para poder añadir workflows/templates de CI)
- Acceso a repositorios: All repositories

Sugeridos (opcionales): Pull requests: Read, Checks: Read.

Nota: La App debe estar instalada en la organización objetivo y el `installation_id` debe corresponder a esa instalación.

---

## ⚙️ Configuración

1) Copia el archivo de variables y edítalo:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2) Rellena `terraform.tfvars` con tu organización y la App:

```hcl
github_organization        = "GofiGeeksOrg"
github_app_id              = "<APP_ID>"
github_app_installation_id = "<INSTALLATION_ID>"
github_app_pem_file        = "/workspaces/ghec-org-as-code/GofiGeeksOrg.pem" # usa ruta absoluta

# Email de facturación de la organización (requerido)
github_organization_billing_email = "billing@gofigeeks.org"

# Equipos (opcional)
platform_team_maintainers = ["platform-lead", "infra-admin"]
platform_team_members     = ["engineer1", "engineer2"]
```

### 🔒 Configuración de Seguridad Avanzada

Por defecto, este repositorio habilita **GitHub Advanced Security** para todos los nuevos repositorios en la organización, incluyendo:

- ✅ **Advanced Security** - Análisis de código y vulnerabilidades
- ✅ **Dependabot Alerts** - Alertas de dependencias vulnerables
- ✅ **Dependabot Security Updates** - Actualizaciones automáticas de seguridad
- ✅ **Dependency Graph** - Gráfico de dependencias
- ✅ **Secret Scanning** - Detección de secretos
- ✅ **Secret Scanning Push Protection** - Prevención de push con secretos

Estas configuraciones se aplican automáticamente a todos los repositorios creados después de ejecutar `terraform apply`. Los repositorios existentes mantendrán su configuración actual.

Para personalizar estas configuraciones, puedes modificar las variables en `terraform.tfvars`:

```hcl
# Deshabilitar alguna característica específica si es necesario
# secret_scanning_push_protection_enabled_for_new_repositories = false
```

3) Asegúrate de que el PEM exista y sea legible:

```bash
ls -l /workspaces/ghec-org-as-code/GofiGeeksOrg.pem
chmod 600 /workspaces/ghec-org-as-code/GofiGeeksOrg.pem
```

### 👥 Importante: miembros de la organización

- Antes de listar usuarios en `platform_team_members`, `template_approvers_members`, `security_team_members` o `read_only_team_members`, asegúrate de que esos usuarios YA aparecen en la sección People de la organización.
- No es necesario asignarlos manualmente a ningún team, solo que sean miembros de la org.
- En organizaciones EMU (Enterprise Managed Users), la pertenencia a la org se gestiona vía IdP/SCIM y Terraform/ la GitHub App NO pueden invitarlos. Si el usuario no está en People, el `apply` fallará con un 422 (EMU must be part of the organization).

---

## ▶️ Ejecución

Ejecuta desde la raíz del repo y no canceles los comandos:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

Durante el `apply`, se realiza una llamada a la API de GitHub para configurar el acceso a Codespaces de la organización usando un token de instalación de la App. Los logs de diagnóstico se escriben en `/tmp/codespaces-org-access.log`.

> Consejo: si usas backend remoto (Azure, S3, etc.), configura el bloque `backend` en `terraform.tf` antes de `init`.

---

## 🏷️ Propiedades Personalizadas

Esta implementación incluye soporte para **custom properties** de GitHub, que proporcionan metadatos estructurados a los repositorios:

### Propiedades Definidas

- **service-tier**: Clasificación del nivel de servicio (tier-1, tier-2, tier-3, experimental)
- **team-owner**: Equipo responsable del mantenimiento del repositorio

### Configuración

Las propiedades personalizadas están habilitadas por defecto. Para deshabilitarlas:

```hcl
enable_custom_properties = false
```

### Integración con Backstage

Las plantillas de Backstage incluyen formularios para configurar estas propiedades automáticamente al crear nuevos repositorios.

📖 **Documentación completa**: [docs/CUSTOM_PROPERTIES.md](docs/CUSTOM_PROPERTIES.md)

---

## 🧩 Solución de problemas

- Resource not accessible by integration:
   - Verifica que la App esté instalada en la org correcta y con “All repositories”.
   - Habilita en Organización → Members: Read (requerido), Administration: Read and write y Codespaces: Read and write.
   - Confirma que `github_app_installation_id` corresponde a esa instalación.

- Error al configurar Codespaces (HTTP 4xx/5xx):
   - Revisa `/tmp/codespaces-org-access.log`.
   - Confirma que la App tiene el permiso Organization → Codespaces: Read and write.

- Error al configurar Custom Properties (HTTP 4xx/5xx):
   - Revisa `/tmp/custom-properties-*.log`.
   - Confirma que la App tiene el permiso Organization → Custom properties: Read and write.
   - Verifica que no existe conflicto con propiedades existentes.

- No se encuentra el PEM:
   - Usa ruta absoluta en `terraform.tfvars` y que el archivo exista con permisos 600.

---

## 🎉 Listo

Al aplicar, se crearán equipos bajo el parent `canary-trips`, repositorios plantilla y protecciones de rama con checks requeridos.
