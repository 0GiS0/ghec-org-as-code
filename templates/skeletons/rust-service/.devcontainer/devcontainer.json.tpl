{
  "name": "$${parameters.name}-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/rust:1.75",
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
        "rust-lang.rust-analyzer",
        "serayuzgur.crates",
        "vadimcn.vscode-lldb",
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml",
        "ms-vscode.remote-containers",
        "github.copilot",
        "github.copilot-chat",
        "hashicorp.terraform",
        "ms-azuretools.vscode-azureterraform",
        "ms-vscode.vscode-docker",
        "alexcvzz.vscode-sqlite"
      ],
      "settings": {
        "rust-analyzer.checkOnSave.command": "cargo clippy",
        "rust-analyzer.cargo.features": "all",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": true
        }
      }
    }
  },
  "postCreateCommand": "cargo build",
  "remoteUser": "vscode",
  "forwardPorts": [8080],
  "portsAttributes": {
    "8080": {
      "label": "$${parameters.name} API",
      "onAutoForward": "notify"
    }
  },
  "containerEnv": {
    "DATABASE_URL": "sqlite:///workspace/db/$${parameters.name}.db",
    "RUST_LOG": "debug"
  }
}