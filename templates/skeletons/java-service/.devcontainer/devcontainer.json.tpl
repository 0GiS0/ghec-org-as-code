{
  "name": "$${parameters.name}-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/java:17-jdk",
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
        "vscjava.vscode-java-pack",
        "vmware.vscode-spring-boot",
        "pivotal.vscode-boot-dev-pack",
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml",
        "ms-vscode.remote-containers",
        "github.copilot",
        "github.copilot-chat",
        "hashicorp.terraform",
        "ms-azuretools.vscode-azureterraform",
        "oracle.oracle-java",
        "ms-vscode.vscode-docker"
      ],
      "settings": {
        "java.configuration.runtimes": [
          {
            "name": "JavaSE-17",
            "path": "/usr/local/sdkman/candidates/java/current"
          }
        ],
        "java.compile.nullAnalysis.mode": "automatic",
        "java.format.settings.url": "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": true
        }
      }
    }
  },
  "postCreateCommand": "./mvnw dependency:resolve",
  "remoteUser": "vscode",
  "forwardPorts": [8080, 1521],
  "portsAttributes": {
    "8080": {
      "label": "$${parameters.name} API",
      "onAutoForward": "notify"
    },
    "1521": {
      "label": "Oracle Database",
      "onAutoForward": "silent"
    }
  },
  "containerEnv": {
    "ORACLE_URL": "jdbc:oracle:thin:@localhost:1521:XE",
    "ORACLE_USERNAME": "system",
    "ORACLE_PASSWORD": "oracle",
    "SPRING_PROFILES_ACTIVE": "development"
  }
}