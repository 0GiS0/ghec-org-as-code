{
  "name": "$${parameters.name}-database-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {},
    "ghcr.io/devcontainers/features/terraform:1": {
      "version": "1.7.5"
    }
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml",
        "ms-vscode.remote-containers",
        "github.copilot",
        "github.copilot-chat",
        "hashicorp.terraform",
        "ms-azuretools.vscode-azureterraform",
        "ms-ossdata.vscode-postgresql",
        "ms-vscode.vscode-docker",
        "ms-vscode-remote.remote-containers",
        "bradlc.vscode-tailwindcss"
      ],
      "settings": {
        "editor.formatOnSave": true,
        "files.associations": {
          "*.sql": "sql"
        }
      }
    }
  },
  "postCreateCommand": "docker-compose up -d && sleep 10 && psql postgresql://postgres:password@localhost:5432/$${parameters.name} < scripts/init.sql",
  "remoteUser": "vscode",
  "forwardPorts": [5432],
  "portsAttributes": {
    "5432": {
      "label": "PostgreSQL Database",
      "onAutoForward": "silent"
    }
  },
  "containerEnv": {
    "POSTGRES_DB": "$${parameters.name}",
    "POSTGRES_USER": "postgres",
    "POSTGRES_PASSWORD": "password",
    "DATABASE_URL": "postgresql://postgres:password@localhost:5432/$${parameters.name}"
  }
}