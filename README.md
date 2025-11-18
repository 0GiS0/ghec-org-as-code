# Organización de GitHub de ejemplo para explicar Plaform Engineering

¡Hola developer 👋🏻! En este repo encontrarás el código que utilicé para montar la organización de GitHub, dentro de un GitHub Enterprise Cloud (EMU) con la configuración y el contenido necesario para mis, donde hable de cómo hacer desarrolladores más felices y más productivos gracias a Platform Engineering.

<p align="center">
  <img width="720" height="405" alt="Desarrolladores más felices y productivos con Platform Engineering" src="https://github.com/user-attachments/assets/0c40e173-164b-4833-8ccd-7a3fe1bc2b03" />
</p>

## 📋 Componentes del Proyecto

| 🎯 Componente | 📝 Propósito | 📁 Archivos Clave |
|---------------|--------------|-------------------|
| 🏢 **Organización** | Configuración GHEC y seguridad | `main.tf`, `github-security-config.tf` |
| 👥 **Equipos** | Gestión de teams y permisos | `teams.tf` |
| 📦 **Repositorios** | Template repositories | `repository-template-*.tf` |
| 🛡️ **Seguridad** | Rulesets y protecciones | `org-rulesets.tf` |
| 🏷️ **Custom Properties** | Metadatos de repositorios | `custom_properties.tf` |
| 💻 **Codespaces** | Acceso a dev environments | `codespaces.tf` |
| 🧪 **Plantillas Backstage** | Esqueletos de proyectos | `software_templates/` |
| 🛠️ **Scripts** | Integraciones personalizadas | `scripts/terraform-integration/` |



## 📋 Requisitos

Para poder usar este código necesitas:

- Una GitHub Enterprise Cloud
- Una organización dentro de GHEC precreada
- Los usuarios con los que quieras interactuar dentro de la misma añadidos a la org (no hace falta crear los teams)
- Una GitHub App, que permita a Terraform poder interactuar con tu organización
- Una cuenta de Terraform Cloud para poder almacenar el Terraform State

### 🔐 Permisos de la GitHub App (imprescindibles)

Para autenticación, este repo usa exclusivamente la GitHub App (sin PAT ni GITHUB_TOKEN). Asegúrate de otorgar como mínimo:

- Repositorio:
   - Actions: Read and write (si gestionas workflows/templates de CI)
   - Administration: Read and write
   - Contents: Read and write
   - Custom properties: Read and write (para gestionar propiedades personalizadas de repositorios)
   - Metadata: Read
   - Workflows: Read and write (para poder añadir workflows/templates de CI)

- Organización:
   - Administration: Read and write
   - Custom properties: Read and write (para gestionar propiedades personalizadas de repositorios)
   - Members: Read and write
   - Org Codespaces: Read and write (necesario para gestionar el acceso de Codespaces de la organización)
   - Codespaces secrets: Read and write (recomendado si más adelante se gestionan secretos de Codespaces)


Cuando se instala hay que dar `Acceso a repositorios: All repositories`.

Sugeridos (opcionales): Pull requests: Read, Checks: Read.

Nota: La App debe estar instalada en la organización objetivo y el `installation_id` debe corresponder a esa instalación.

### 📝 Terraform.tfvars

También necesitas configurar las variables de entorno para Terraform, ajustadas a tu organización.

## 🚀 Lanzar Terraform

Para poder crear todos los recursos necesarios dentro de tu organización de GitHub necesitas seguir los siguientes pasos:

```bash
# 1. Configurar variables de entorno
cp .env.sample .env
code .env  # Editar con tus credenciales

# 2. Cargar variables e inicializar (con Terraform Cloud)
source scripts/load-env.sh
terraform init

# 3. Planificar y aplicar
terraform plan
terraform apply
```


### 🔐 Seguridad de Archivos Sensibles

**Archivos que NO deben ser commiteados**:
- `.env` - Variables de entorno con credenciales reales
- `*.pem` - Claves privadas de GitHub App
- `terraform.tfvars` - Variables de Terraform con datos reales


## 🎉 Listo

Una vez que tengas la organización de GitHub lista, ya puedes ir [al otro repo para configurar 🎸Backstage](https://github.com/0GiS0/backstage-updated)
