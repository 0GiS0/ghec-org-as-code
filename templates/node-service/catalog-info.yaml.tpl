---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: node-service
  title: 🟢 Node.js Service
  description: Create a new Node.js microservice with TypeScript, Express, and best practices
  annotations:
    backstage.io/techdocs-ref: dir:.
  tags:
    - nodejs
    - typescript
    - express
    - microservice
    - recommended
spec:
  owner: platform-team
  type: service
  parameters:
    - title: 🟢 Complete the form to create a new Node.js Service
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
              placeholder: "Enter a clear, concise description of this Node.js service..."
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

    - id: Replace entity name in package.json
      name: 🔄 Replace BACKSTAGE_ENTITY_NAME in package.json
      action: roadiehq:utils:fs:replace
      input:
        files:
          - file: "./package.json"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name | replace("-", "_") }}

    - id: Replace entity name in package-lock.json
      name: 🔄 Replace BACKSTAGE_ENTITY_NAME in package-lock.json
      action: roadiehq:utils:fs:replace
      input:
        files:
          - file: "./package-lock.json"
            find: "BACKSTAGE_ENTITY_NAME"
            replaceWith: $${{ parameters.name | replace("-", "_") }}


    - id: Replace description in package.json
      name: 🔄 Replace BACKSTAGE_ENTITY_DESCRIPTION in package.json
      action: roadiehq:utils:fs:replace
      input:
        files:
          - file: "./package.json"
            find: "BACKSTAGE_ENTITY_DESCRIPTION"
            replaceWith: $${{ parameters.description }}

    - id: Replace BACKSTAGE_AUTHOR in package.json
      name: 🔄 Replace author in package.json
      action: roadiehq:utils:fs:replace
      input:
        files:
          - file: "./package.json"
            find: "BACKSTAGE_AUTHOR"
            replaceWith: $${{ parameters.owner }}

    - id: Replace BACKSTAGE_REPO_URL in package.json
      name: 🔄 Replace URL in package.json
      action: roadiehq:utils:fs:replace
      input:
        files:
          - file: "./package.json"
            find: "BACKSTAGE_REPO_URL"
            replaceWith: $${{ parameters.repoUrl }}

    - id: Replace_indexjs
      name: 🔄 Replace BACKSTAGE_ENTITY_NAME in index.js
      action: roadiehq:utils:fs:replace
      input:
        files:
          - file: "./src/index.js"
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
            "nodejs",
            "typescript",
          ]
        defaultBranch: main
        gitCommitMessage: Create Node.js service from template
        customProperties:
          service-tier: $${{ parameters.serviceTier }}
          team-owner: $${{ parameters.teamOwner }}
          demo: $${{ parameters.demo }}

    - id: register
      name: 📋 Register
      action: catalog:register
      input:
        repoContentsUrl: $${{ steps["publish"].output.repoContentsUrl }}
        catalogInfoPath: "/catalog-info.yaml"

  output:
    links:
      - title: Repository
        url: $${{ steps["publish"].output.remoteUrl }}
      - title: Open in catalog
        icon: catalog
        entityRef: $${{ steps["register"].output.entityRef }}
