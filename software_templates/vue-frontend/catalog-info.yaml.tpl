---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: vue-frontend
  title: 🟢 Vue.js Frontend
  description: >
    Create a modern Vue.js frontend application with TypeScript,
    Vite, and best practices
  annotations:
    backstage.io/techdocs-ref: dir:.
  tags:
    - vue
    - frontend
    - typescript
    - vite
    - javascript
spec:
  owner: ${template_owner}
  type: website
  parameters:
    - title: 🟢 Create a Vue.js Frontend Application
      required:
        - name
        - description
        - owner
        - system
      properties:
        name:
          type: string
          title: 📦 Project Name
          description: Unique name for the Vue.js application (kebab-case)
          ui:autofocus: true
          ui:field: ValidateKebabCase
        description:
          type: string
          title: 📝 Description
          description: Short description of the application
          minLength: 1
          maxLength: 340
          pattern: "^.*\\S.*$"
          ui:widget: textarea
        owner:
          type: string
          title: 👥 Team Owner
          description: Team responsible for this application
          ui:field: MyGroupsPicker
        system:
          type: string
          title: 🏗️ System
          description: The system this application belongs to
          ui:field: EntityPicker
          ui:options:
            catalogFilter:
              kind: System
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
      name: 🏗️ Fetch Skeleton
      action: fetch:template
      input:
        url: ./skeleton
        copyWithoutTemplating:
          - .github/workflows/*
          - node_modules/**
        values:
          name: $${{ parameters.name }}
          description: $${{ parameters.description }}
          owner: $${{ parameters.owner }}
          system: $${{ parameters.system }}
          destination: $${{ parameters.repoUrl | parseRepoUrl }}

    - id: replace-placeholders
      name: 🔄 Replace placeholders
      action: roadiehq:utils:fs:replace
      input:
        files:
          # package.json
          - file: "./package.json"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}
          # package-lock.json
          - file: "./package-lock.json"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}

    - id: publish
      name: 🚀 Publish Repository
      action: publish:github
      input:
        repoUrl: $${{ parameters.repoUrl }}
        description: $${{ parameters.description }}
        topics:
          - backstage-include
          - ${github_organization}
          - vue
          - frontend
          - typescript
        defaultBranch: main
        gitCommitMessage: Create Vue.js frontend from template

    - id: register
      name: 📝 Register in Catalog
      action: catalog:register
      input:
        repoContentsUrl: $${{ steps.publish.output.repoContentsUrl }}
        catalogInfoPath: '/catalog-info.yaml'

  output:
    links:
      - title: 📂 Repository
        url: $${{ steps.publish.output.remoteUrl }}
      - title: 📖 Open in Catalog
        icon: catalog
        entityRef: $${{ steps.register.output.entityRef }}
