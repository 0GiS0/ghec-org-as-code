---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: electron-desktop-app
  title: 🖥️ Electron Desktop App
  description: Create a modern cross-platform desktop application with Electron, React, and TypeScript
  annotations:
    backstage.io/techdocs-ref: dir:.
    github.com/project-slug: ${github_organization}/${github_repository}
  tags:
    - electron
    - desktop
    - typescript
    - react
    - cross-platform
    - recommended
spec:
  owner: platform-team
  type: component
  parameters:
    - title: 🖥️ Complete the form to create a new Electron Desktop App
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
          description: The name of the project
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
              placeholder: "Enter a clear, concise description of this desktop application..."
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
    - title: 🛠️ Electron Configuration
      required:
        - electronVersion
        - includeStore
        - includeE2E
      properties:
        electronVersion:
          title: ⚛️ Electron Version
          type: string
          description: Base Electron version for the project
          default: latest
          enum:
            - latest
            - "latest-30"
            - "latest-29"
            - "latest-28"
          enumNames:
            - "Latest (Recommended)"
            - "v30 (LTS)"
            - "v29 (LTS)"
            - "v28 (LTS)"
        includeStore:
          title: 🏪 Include State Management
          type: boolean
          description: Include Redux Toolkit for state management
          default: true
        includeE2E:
          title: 🧪 Include E2E Tests
          type: boolean
          description: Include Playwright for end-to-end testing
          default: true

  steps:
    - id: fetch-base
      name: Fetch base
      action: fetch:template
      input:
        url: ./skeleton
        values:
          name: $${{ parameters.name }}
          description: $${{ parameters.description }}
          owner: $${{ parameters.owner }}
          system: $${{ parameters.system }}
          serviceTier: $${{ parameters.serviceTier }}
          teamOwner: $${{ parameters.teamOwner }}
          electronVersion: $${{ parameters.electronVersion }}
          includeStore: $${{ parameters.includeStore }}
          includeE2E: $${{ parameters.includeE2E }}

    - id: replace-placeholders
      name: 🔄 Replace placeholders
      action: roadiehq:utils:fs:replace
      input:
        files:
          - file: "./README.md"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name }}

    - id: publish
      name: Publish
      action: publish:github
      input:
        allowedHosts: ['github.com']
        description: $${{ parameters.description }}
        repoUrl: $${{ parameters.repoUrl }}
        defaultBranch: main
        gitAuthorName: Backstage
        gitAuthorEmail: backstage@example.com
        access: public

    - id: register
      name: Register
      action: catalog:register
      input:
        repoContentsUrl: $${{ steps.publish.output.repoContentsUrl }}
        catalogInfoPath: '/catalog-info.yaml'
