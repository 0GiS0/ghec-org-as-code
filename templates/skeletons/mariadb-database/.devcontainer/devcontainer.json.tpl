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
        "cweijan.vscode-mysql-client2",
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
  "postCreateCommand": "docker-compose up -d && sleep 10 && mysql -h localhost -u root -ppassword $${parameters.name} < scripts/init.sql",
  "remoteUser": "vscode",
  "forwardPorts": [3306],
  "portsAttributes": {
    "3306": {
      "label": "MariaDB Database",
      "onAutoForward": "silent"
    }
  },
  "containerEnv": {
    "MARIADB_DATABASE": "$${parameters.name}",
    "MARIADB_USER": "app_user",
    "MARIADB_PASSWORD": "app_password",
    "MARIADB_ROOT_PASSWORD": "password",
    "DATABASE_URL": "mysql://app_user:app_password@localhost:3306/$${parameters.name}"
  }
}