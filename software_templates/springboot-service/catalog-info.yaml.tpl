---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: springboot-service
  title: ☕ Spring Boot Service
  description: Create a new Spring Boot microservice with Java 21, Maven, and best practices
  links:
    - url: https://spring.io/projects/spring-boot
      title: Spring Boot Documentation
      icon: book
    - url: https://docs.spring.io/spring-boot/reference/
      title: Spring Boot Reference
      icon: docs
  annotations:
    backstage.io/techdocs-ref: dir:.
    github.com/project-slug: ${github_organization}/${github_repository}
  tags:
    - java
    - spring-boot
    - maven
    - microservice
    - recommended
spec:
  owner: platform-team
  type: service
  parameters:
    - title: ☕ Complete the form to create a new Spring Boot Service
      required:
        - name
        - description
        - system
        - serviceTier
        - teamOwner
      properties:
        name:
          type: string
          title: 📦 Project Name
          description: The name of the project (will be used as artifact name)
          ui:autofocus: true
          ui:field: ValidateKebabCase
        description:
          title: 📝 Description
          type: string
          description: A description for the component
          minLength: 1
          maxLength: 340
          pattern: "^.*\\S.*$"
          ui:help: "Required field. Max 340 characters (GitHub has a 350-byte limit, accented characters count as multiple bytes). Excess whitespace will be normalized automatically."
          ui:options:
            inputProps:
              maxLength: 340
              placeholder: "Enter a clear, concise description of this Spring Boot service..."
          ui:widget: textarea
        owner:
          title: 👥 Select in which group the component will be created
          type: string
          description: The group the component belongs to
          ui:field: MyGroupsPicker
        system:
          title: 🏗️ System
          type: string
          description: The system the component belongs to
          ui:field: EntityPicker
          ui:options:
            catalogFilter:
              kind: System
        serviceTier:
          title: 🏷️ Service Tier
          type: string
          description: Service tier classification for operational support
          default: tier-3
          enum:
            - tier-1
            - tier-2
            - tier-3
            - experimental
          enumNames:
            - "🔴 Tier 1 (Critical)"
            - "🟡 Tier 2 (Important)"
            - "🟢 Tier 3 (Standard)"
            - "🧪 Experimental"
        teamOwner:
          title: 👨‍💼 Team Owner
          type: string
          description: Team responsible for maintaining this repository
          default: platform-team
          ui:field: MyGroupsPicker
        javaVersion:
          title: ☕ Java Version
          type: string
          description: Java version for the project
          default: "21"
          enum:
            - "17"
            - "21"
          enumNames:
            - "Java 17 (LTS)"
            - "Java 21 (LTS - Recommended)"
        springBootVersion:
          title: 🍃 Spring Boot Version
          type: string
          description: Spring Boot version
          default: "3.4.0"
          enum:
            - "3.3.6"
            - "3.4.0"
          enumNames:
            - "3.3.6 (Stable)"
            - "3.4.0 (Latest)"
        demo:
          title: 🎪 Demo Repository
          type: string
          description: Mark this repository as a demonstration/test repository
          default: "yes"
          enum:
            - "yes"
            - "no"
          enumNames:
            - "🎪 Yes - Demo/Test"
            - "🏭 No - Production"
    - title: 🎯 Choose a destination
      required:
        - repoUrl
      properties:
        repoUrl:
          title: 🔗 Repository URL
          type: string
          description: The URL of the repository
          ui:field: RepoUrlPicker
          ui:options:
            allowedOwners:
              - ${github_organization}
            allowedHosts:
              - github.com
  steps:
    - id: fetch-base
      name: 📥 Fetch Template
      action: fetch:template
      input:
        url: ./skeleton
        copyWithoutTemplating:
          - .github/workflows/*
        values:
          name: $${{ parameters.name }}
          owner: $${{ parameters.owner }}
          description: $${{ parameters.description }}
          destination: $${{ parameters.repoUrl | parseRepoUrl }}
          repoUrl: $${{ parameters.repoUrl }}
          serviceTier: $${{ parameters.serviceTier }}
          teamOwner: $${{ parameters.teamOwner }}
          system: $${{ parameters.system }}
          javaVersion: $${{ parameters.javaVersion }}
          springBootVersion: $${{ parameters.springBootVersion }}

    - id: replace-placeholders
      name: 🔄 Replace placeholders
      action: roadiehq:utils:fs:replace
      input:
        files:
          # README.md
          - file: "./README.md"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}
          - file: "./README.md"
            find: "BACKSTAGE_ENTITY_DESCRIPTION"
            replaceWith: $${{ parameters.description }}
          # pom.xml
          - file: "./pom.xml"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}
          - file: "./pom.xml"
            find: "BACKSTAGE_ENTITY_DESCRIPTION"
            replaceWith: $${{ parameters.description }}
          - file: "./pom.xml"
            find: "BACKSTAGE_JAVA_VERSION"
            replaceWith: $${{ parameters.javaVersion }}
          - file: "./pom.xml"
            find: "BACKSTAGE_SPRING_VERSION"
            replaceWith: $${{ parameters.springBootVersion }}
          # Application.java
          - file: "./src/main/java/com/example/demo/Application.java"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name | replace("-", "") | capitalize }}
          # application.yml
          - file: "./src/main/resources/application.yml"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}
          # devcontainer.json
          - file: "./.devcontainer/devcontainer.json"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}
          # api.http
          - file: "./api.http"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}
          # Dockerfile
          - file: "./Dockerfile"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}

    - id: publish
      name: 🚀 Publish to GitHub
      action: publish:github
      input:
        repoUrl: $${{ parameters.repoUrl }}
        description: $${{ parameters.description }}
        topics:
          [
            "backstage-include",
            "${github_organization}",
            "java",
            "spring-boot",
            "microservice",
          ]
        defaultBranch: main
        gitCommitMessage: Create Spring Boot service from template
        customProperties:
          service-tier: $${{ parameters.serviceTier }}
          team-owner: $${{ parameters.teamOwner }}
          demo: $${{ parameters.demo }}

    - id: register
      name: 📋 Register
      action: catalog:register
      input:
        repoContentsUrl: $${{ steps['publish'].output.repoContentsUrl }}
        catalogInfoPath: '/catalog-info.yaml'

  output:
    links:
      - title: 🔗 Repository
        url: $${{ steps['publish'].output.remoteUrl }}
      - title: 📋 Open in catalog
        icon: catalog
        entityRef: $${{ steps['register'].output.entityRef }}
