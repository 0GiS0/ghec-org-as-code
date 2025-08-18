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
        "ms-mssql.mssql",
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
  "postCreateCommand": "docker-compose up -d && sleep 30 && sqlcmd -S localhost,1433 -U sa -P 'YourStrong@Passw0rd' -d $${parameters.name} -i scripts/init.sql",
  "remoteUser": "vscode",
  "forwardPorts": [1433],
  "portsAttributes": {
    "1433": {
      "label": "SQL Server Database",
      "onAutoForward": "silent"
    }
  },
  "containerEnv": {
    "MSSQL_SA_PASSWORD": "YourStrong@Passw0rd",
    "ACCEPT_EULA": "Y",
    "MSSQL_PID": "Express",
    "DATABASE_URL": "Server=localhost,1433;Database=$${parameters.name};User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=true;"
  }
}