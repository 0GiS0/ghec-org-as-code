{
  "name": "$${parameters.name}-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/go:1.21",
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
        "golang.go",
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml",
        "ms-vscode.remote-containers",
        "github.copilot",
        "github.copilot-chat",
        "hashicorp.terraform",
        "ms-azuretools.vscode-azureterraform",
        "mongodb.mongodb-vscode",
        "ms-vscode.vscode-docker",
        "ms-vscode.makefile-tools"
      ],
      "settings": {
        "go.formatTool": "goimports",
        "go.lintTool": "golangci-lint",
        "go.useLanguageServer": true,
        "go.enableCodeLens": {
          "references": true,
          "runtest": true
        },
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": true
        }
      }
    }
  },
  "postCreateCommand": "go mod download",
  "remoteUser": "vscode",
  "forwardPorts": [8080, 27017],
  "portsAttributes": {
    "8080": {
      "label": "$${parameters.name} API",
      "onAutoForward": "notify"
    },
    "27017": {
      "label": "MongoDB",
      "onAutoForward": "silent"
    }
  },
  "containerEnv": {
    "MONGODB_URI": "mongodb://localhost:27017/$${parameters.name}",
    "GO_ENV": "development"
  }
}