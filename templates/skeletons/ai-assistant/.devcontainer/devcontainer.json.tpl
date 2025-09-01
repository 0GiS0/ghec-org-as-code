{
  "name": "${{values.name}}-devcontainer",
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
        "github.copilot",
        "github.copilot-chat"
      ]
    }
  },
  "postCreateCommand": "pip install -r requirements.txt",
  "remoteUser": "vscode",
  "forwardPorts": [8000],
  "portsAttributes": {
    "8000": {
      "label": "${{values.name}} AI Assistant",
      "onAutoForward": "notify"
    }
  }
}