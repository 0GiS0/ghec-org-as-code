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
        "alexcvzz.vscode-sqlite",
        "ms-vscode.vscode-docker"
      ],
      "settings": {
        "editor.formatOnSave": true,
        "files.associations": {
          "*.sql": "sql"
        }
      }
    }
  },
  "postCreateCommand": "mkdir -p /workspace/db && sqlite3 /workspace/db/$${parameters.name}.db < scripts/init.sql",
  "remoteUser": "vscode",
  "containerEnv": {
    "DATABASE_URL": "sqlite:///workspace/db/$${parameters.name}.db"
  }
}