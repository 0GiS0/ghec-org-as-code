# 🏢 GitHub Enterprise Cloud as Code

<div align="center">

**Automatiza la configuración completa de una organización GitHub Enterprise Cloud con Terraform**

[![GitHub followers](https://img.shields.io/github/followers/0GiS0?style=for-the-badge&logo=github&logoColor=white)](https://github.com/0GiS0)
[![LinkedIn Follow](https://img.shields.io/badge/LinkedIn-Sígueme-blue?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/giselatorresbuitrago/)
[![X Follow](https://img.shields.io/badge/X-Sígueme-black?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/0GiS0)

</div>

---

¡Hola developer 👋🏻! En este repositorio encontrarás **todo el código necesario para montar y gestionar una organización GitHub Enterprise Cloud (GHEC)** de forma automatizada usando Terraform. 

Aquí se implementa una arquitectura completa de **Platform Engineering** que hace desarrolladores más felices y productivos mediante:
- ✅ Configuración automática de equipos y permisos
- ✅ Repositorios plantilla listos para usar
- ✅ Políticas de seguridad y rulesets organizacionales
- ✅ Metadatos de repositorios con Custom Properties
- ✅ Acceso gestionado a Codespaces
- ✅ Plantillas Backstage para crear nuevos proyectos

---

## 📑 Tabla de Contenidos
- [Características](#características)
- [Componentes](#componentes-del-proyecto)
- [Tecnologías](#tecnologías-utilizadas)
- [Requisitos Previos](#requisitos-previos)
- [Configuración de la GitHub App](#configuración-de-la-github-app)
- [Instalación](#instalación)
- [Uso](#uso)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Contribuir](#contribuir)

---

## ✨ Características

- **🏢 Gestión de Organización**: Configuración centralizada de tu GHEC
- **👥 Equipos Jerarquizados**: Estructura de equipos con permisos granulares
- **📦 Repositorios Plantilla**: Templates pre-configurados para múltiples stacks tecnológicos
- **🛡️ Seguridad Multinivel**: Rulesets, protecciones de rama y políticas de seguridad
- **🏷️ Custom Properties**: Metadatos organizacionales para categorizar y gestionar repositorios
- **💻 Codespaces**: Control de acceso a entornos de desarrollo en la nube
- **🧪 Backstage Integration**: Plantillas de software para generación automática de proyectos
- **🔧 Integraciones Avanzadas**: Scripts personalizados para funcionalidades no soportadas por Terraform

## 🛠️ Tecnologías Utilizadas

- **Terraform** ≥1.6 - Infrastructure as Code
- **GitHub Provider** ≥6.0 - Gestión de recursos GitHub
- **GitHub App** - Autenticación segura sin PAT
- **Bash** - Scripts de integración y utilidades
- **Docker** - Contenerización (opcional, para Codespaces)

## 📁 Estructura del Proyecto

```
ghec-org-as-code/
├── main.tf                          # Configuración principal
├── variables.tf                     # Variables reutilizables
├── outputs.tf                       # Salidas de Terraform
├── terraform.tf                     # Backend remoto y providers
├── teams.tf                         # Definición de equipos
├── repositories.tf                  # Configuración de repos
├── repository-template-*.tf         # Templates especializados
├── custom_properties.tf             # Propiedades personalizadas
├── codespaces.tf                    # Acceso a Codespaces
├── github-security-config.tf        # Configuración de seguridad
├── org-rulesets.tf                  # Rulesets organizacionales
├── scripts/
│   ├── load-env.sh                  # Cargador de variables de entorno
│   ├── setup.sh                     # Setup inicial
│   ├── terraform-integration/       # Scripts para GitHub API
│   │   ├── github_app_token.sh
│   │   ├── custom_property.sh
│   │   └── codespaces_access.sh
│   └── repo-tools/                  # Herramientas de validación
│       ├── check-python-format.sh
│       └── format-python.sh
├── software_templates/              # Plantillas Backstage
│   ├── ai-assistant/
│   ├── fastapi-service/
│   ├── node-service/
│   └── ... (más templates)
└── README.md                        # Este archivo
```

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener:

- ✅ **GitHub Enterprise Cloud** - Organización preexistente
- ✅ **Usuarios de la organización** - Los usuarios deben estar ya añadidos a la org (no es necesario crear teams previamente)
- ✅ **GitHub App** - Creada e instalada en tu organización
- ✅ **PEM File** - Clave privada descargada de tu GitHub App
- ✅ **Terraform ≥1.6** - Instalado localmente o en CI/CD
- ✅ **Terraform Cloud** (recomendado) - Para almacenar el estado remoto de forma segura
- ✅ **GitHub CLI** - Para validaciones y testing
- ✅ **Bash** - Para ejecutar scripts de integración

> **💡 Consejo**: Este proyecto **NO utiliza Personal Access Tokens (PAT)**. Todo se gestiona de forma segura mediante GitHub App.

---

## 🔐 Configuración de la GitHub App

### Creación de la GitHub App

1. Ve a **Settings → Developer settings → GitHub Apps**
2. Haz clic en **New GitHub App**
3. Rellena los datos básicos (el nombre es importante para identificarla)
4. En **Webhook**, desactiva la opción (no es necesaria)

### Permisos Requeridos (CRÍTICOS)

> ⚠️ Estos permisos son **imprescindibles** para que Terraform pueda gestionar tu organización

#### 📦 Permisos de Repositorio
- ✅ **Actions**: Read and write (gestión de workflows de CI)
- ✅ **Administration**: Read and write (configuración de repositorios)
- ✅ **Contents**: Read and write (lectura/escritura de archivos)
- ✅ **Custom properties**: Read and write (metadatos de repos)
- ✅ **Metadata**: Read (información general)
- ✅ **Workflows**: Read and write (gestión de templates de CI)

#### 🏢 Permisos de Organización
- ✅ **Administration**: Read and write (configuración org)
- ✅ **Custom properties**: Read and write (metadatos personalizados)
- ✅ **Members**: Read and write (gestión de miembros y teams)
- ✅ **Org Codespaces**: Read and write (acceso a dev environments)
- ✅ **Codespaces secrets**: Read and write (secretos de Codespaces)

#### 🔄 Permisos Opcionales Sugeridos
- 📋 **Pull requests**: Read
- ✓ **Checks**: Read

### Instalación en tu Organización

1. En la página de la GitHub App, haz clic en **Install App**
2. Selecciona tu organización
3. Selecciona **All repositories** (acceso a todos los repos)
4. Confirma la instalación
5. **Copia el Installation ID** (visible en la URL: `https://github.com/apps/your-app/installations/XXXXX`)
6. **Descarga la Private Key** como archivo `.pem` y guárdalo de forma segura

---

## 🚀 Instalación
### Paso 1: Clonar el repositorio

```bash
git clone https://github.com/0GiS0/ghec-org-as-code.git
cd ghec-org-as-code
```

### Paso 2: Preparar variables de entorno

```bash
# Copiar el archivo de ejemplo
cp .env.sample .env

# Editar con tus credenciales reales
code .env
```

**Variables necesarias en `.env`:**
```bash
GITHUB_ORGANIZATION=tu-organizacion          # Nombre de tu org GitHub
GITHUB_APP_ID=123456                         # ID de la GitHub App
GITHUB_APP_INSTALLATION_ID=98765432          # Installation ID
GITHUB_APP_PEM_FILE=/ruta/a/archivo.pem      # Ruta al archivo PEM
TERRAFORM_CLOUD_TOKEN=xxxxxxxxxxxx           # Token de Terraform Cloud (si usas cloud)
```

### Paso 3: Inicializar Terraform

```bash
# Cargar variables de entorno
source scripts/load-env.sh

# Inicializar Terraform (descarga providers)
terraform init
```

### Paso 4: Validar configuración

```bash
# Verificar que la sintaxis es correcta
terraform validate

# Formatear código (importante para commits)
terraform fmt
```

### Paso 5: Planificar cambios

```bash
# Ver qué cambios se van a realizar
terraform plan

# Opcional: Guardar el plan en un archivo
terraform plan -out=tfplan
```

### Paso 6: Aplicar cambios

```bash
# Aplicar la configuración (requiere confirmación)
terraform apply

# O aplicar sin confirmación (si tienes un plan guardado)
terraform apply tfplan

# O con auto-approve (solo en desarrollo/testing)
terraform apply -auto-approve
```

---

## 💻 Uso

### Gestionar Equipos

Edita `teams.tf` para crear o modificar equipos:

```hcl
resource "github_team" "developers" {
  name        = "developers"
  description = "Equipo de desarrollo"
  privacy     = "closed"
}
```

Luego:
```bash
terraform plan    # Revisa los cambios
terraform apply   # Aplica
```

### Crear Repositorios Plantilla

Cada tipo de proyecto tiene su archivo dedicado. Por ejemplo, para agregar un repositorio FastAPI:

```hcl
# En repository-template-fastapi-service.tf
module "fastapi_example" {
  source = "./modules/repository-template"
  
  name                   = "fastapi-example"
  description            = "API REST con FastAPI"
  template_repository    = "fastapi-service"
  team_permissions       = {
    "developers" = "maintain"
  }
}
```

### Configurar Custom Properties

Define metadatos de repositorios en `custom_properties.tf`:

```hcl
variable "organization_custom_properties" {
  default = {
    "service-tier" = {
      value_type = "single_select"
      allowed_values = ["tier-1", "tier-2", "tier-3"]
    }
  }
}
```

### Validar Código Python

Si trabajas con plantillas Python, asegúrate de que el formato es correcto:

```bash
# Verificar formato de archivos .py.tpl
./scripts/repo-tools/check-python-format.sh

# Aplicar formato automáticamente si es necesario
./scripts/repo-tools/format-python.sh
```

---

## 📚 Documentación Adicional

Para más detalles sobre el proyecto, consulta:

- **[AGENTS.md](./AGENTS.md)** - Instrucciones detalladas para agentes de IA
- **[scripts/terraform-integration/README.md](./scripts/terraform-integration/README.md)** - Documentación de scripts
- **[scripts/repo-tools/README.md](./scripts/repo-tools/README.md)** - Herramientas de validación

---

## 🔐 Seguridad
### ⚠️ Archivos Sensibles

Estos archivos **NUNCA deben ser commiteados**:

```
.env                    # Variables de entorno con credenciales
*.pem                   # Clave privada de GitHub App
terraform.tfvars        # Variables de Terraform con datos reales
terraform.tfstate       # Estado local (usa backend remoto)
terraform.tfstate.backup
```

### 🛡️ Mejores Prácticas

- ✅ Usa **GitHub App** en lugar de PAT (Personal Access Tokens)
- ✅ Almacena el estado en **Terraform Cloud** o similar
- ✅ Guarda archivos `.pem` con permisos restrictivos (`chmod 600`)
- ✅ Utiliza variables sensibles marcadas con `sensitive = true`
- ✅ Revisa siempre `terraform plan` antes de aplicar cambios
- ✅ Implementa todos los cambios vía Pull Requests

---

## 🚨 Solución de Problemas

### Error: "Resource not accessible by integration"
**Causa**: La GitHub App no tiene permisos suficientes
**Solución**: Verifica los permisos en Settings → Developer settings → GitHub Apps

### Error: "File not found: *.pem"
**Causa**: Ruta incorrecta del archivo PEM
**Solución**: Usa rutas absolutas y verifica con `ls -la /ruta/al/archivo.pem`

### Error de Codespaces: "400 Bad Request"
**Causa**: Problema en la configuración de acceso
**Solución**: Revisa `/tmp/codespaces-org-access.log`

### Error 422 EMU
**Causa**: Usuario no es miembro de la organización
**Solución**: Añade el usuario a la org antes de asignarlo a un team

---

## 🎯 Próximos Pasos

Una vez que tengas la organización de GitHub configurada:

1. **Configura Backstage**: Usa las plantillas para generar nuevos proyectos automáticamente
2. **Implementa CI/CD**: Los repositorios incluyen workflows listos para personalizar
3. **Automatiza onboarding**: Los nuevos desarrolladores pueden crear proyectos desde plantillas
4. **Monitorea la organización**: Usa el API de GitHub para auditoría y reporting

Consulta el [repositorio de Backstage](https://github.com/0GiS0/backstage-updated) para una integración completa.

---

## 👥 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Crea una rama para tu feature: `git checkout -b feature/nueva-plantilla`
2. Ejecuta `terraform fmt` y `terraform validate`
3. Si modificas archivos Python: `./scripts/repo-tools/check-python-format.sh`
4. Realiza un commit descriptivo: `git commit -am 'Añade nueva plantilla FastAPI'`
5. Abre un Pull Request con descripción detallada

---

## 🌐 Sígueme en Mis Redes Sociales

Si este proyecto te ha sido útil, no olvides seguirme para más contenido sobre Platform Engineering y GitHub:

<div align="center">

[![GitHub followers](https://img.shields.io/github/followers/0GiS0?style=for-the-badge&logo=github&logoColor=white)](https://github.com/0GiS0)
[![LinkedIn Follow](https://img.shields.io/badge/LinkedIn-Sígueme-blue?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/giselatorresbuitrago/)
[![X Follow](https://img.shields.io/badge/X-Sígueme-black?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/0GiS0)

</div>

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](./LICENSE) para más detalles.
