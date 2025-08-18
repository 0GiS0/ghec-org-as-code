{
  "name": "$${parameters.name}-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/php:8.2",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {},
    "ghcr.io/devcontainers/features/terraform:1": {
      "version": "1.7.5"
    },
    "ghcr.io/devcontainers/features/node:1": {
      "version": "18"
    }
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "bmewburn.vscode-intelephense-client",
        "xdebug.php-debug",
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml",
        "ms-vscode.remote-containers",
        "github.copilot",
        "github.copilot-chat",
        "hashicorp.terraform",
        "ms-azuretools.vscode-azureterraform",
        "ms-vscode.vscode-docker",
        "cweijan.vscode-mysql-client2",
        "bradlc.vscode-tailwindcss"
      ],
      "settings": {
        "php.suggest.basic": false,
        "php.validate.enable": true,
        "php.validate.run": "onType",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": true
        }
      }
    }
  },
  "postCreateCommand": "composer install && php artisan key:generate",
  "remoteUser": "vscode",
  "forwardPorts": [8000, 3306],
  "portsAttributes": {
    "8000": {
      "label": "$${parameters.name} Laravel App",
      "onAutoForward": "notify"
    },
    "3306": {
      "label": "MariaDB",
      "onAutoForward": "silent"
    }
  },
  "containerEnv": {
    "DB_CONNECTION": "mysql",
    "DB_HOST": "localhost",
    "DB_PORT": "3306",
    "DB_DATABASE": "$${parameters.name}",
    "DB_USERNAME": "root",
    "DB_PASSWORD": "password"
  }
}