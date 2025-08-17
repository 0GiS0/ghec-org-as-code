{
  "name": "${parameters.name}-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.pylint",
        "ms-python.black-formatter",
        "ms-python.isort",
        "ms-python.flake8",
        "charliermarsh.ruff",
        "github.copilot",
        "github.copilot-chat"
      ],
      "settings": {
        "python.defaultInterpreterPath": "/usr/local/bin/python",
        "python.formatting.provider": "black",
        "python.linting.enabled": true,
        "python.linting.pylintEnabled": false,
        "python.linting.flake8Enabled": true,
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": true
        }
      }
    }
  },
  "postCreateCommand": "pip install -r requirements.txt -r requirements-dev.txt",
  "remoteUser": "vscode",
  "forwardPorts": [8000],
  "portsAttributes": {
    "8000": {
      "label": "${parameters.name} API",
      "onAutoForward": "notify"
    }
  }
}