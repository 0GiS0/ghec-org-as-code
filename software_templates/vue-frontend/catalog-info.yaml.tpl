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
          ui:widget: textarea
        owner:
          type: string
          title: 👥 Team Owner
          description: Team responsible for this application
          ui:field: EntityPicker
          ui:options:
            catalogFilter:
              kind: Group

    - title: ⚙️ Configuration Options
      properties:
        useTypeScript:
          type: boolean
          title: Use TypeScript
          description: Enable TypeScript support
          default: true
        usePinia:
          type: boolean
          title: Use Pinia
          description: Include Pinia for state management
          default: true
        useRouter:
          type: boolean
          title: Use Vue Router
          description: Include Vue Router for navigation
          default: true
        cssFramework:
          type: string
          title: 🎨 CSS Framework
          description: Select a CSS framework
          enum:
            - tailwind
            - none
          enumNames:
            - Tailwind CSS
            - None (Plain CSS)
          default: tailwind

  steps:
    - id: fetch-base
      name: 🏗️ Fetch Skeleton
      action: fetch:template
      input:
        url: ./skeleton
        values:
          name: $${{ parameters.name }}
          description: $${{ parameters.description }}
          owner: $${{ parameters.owner }}
          useTypeScript: $${{ parameters.useTypeScript }}
          usePinia: $${{ parameters.usePinia }}
          useRouter: $${{ parameters.useRouter }}
          cssFramework: $${{ parameters.cssFramework }}

    - id: publish
      name: 🚀 Publish Repository
      action: publish:github
      input:
        description: $${{ parameters.description }}
        repoUrl: github.com?owner=${github_organization}&repo=$${{ parameters.name }}
        topics:
          - backstage-include
          - ${github_organization}
          - vue
          - frontend
          - typescript
        defaultBranch: main
        protectDefaultBranch: true
        repoVisibility: private
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
