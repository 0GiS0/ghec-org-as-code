---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: ai-assistant
  title: 🤖 AI Assistant Service
  description: Create a new AI Assistant service with Python, FastAPI, and AI capabilities
  annotations:
    backstage.io/techdocs-ref: dir:.
  tags:
    - python
    - ai
    - assistant
    - fastapi
    - microservice
    - recommended
spec:
  owner: platform-team
  type: service
  parameters:
    - title: 🤖 Complete the form to create a new AI Assistant Service
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
              placeholder: "Enter a clear, concise description of this AI Assistant service..."
          ui:widget: textarea
        owner:
          title: 👥 Component Owner Group
          type: string
          description: The group that will own this component in the Backstage catalog
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
    - title: 🎯 Repository Location
      required:
        - repoUrl
      properties:
        repoUrl:
          title: 🔗 GitHub Repository URL
          type: string
          description: Select the organization and repository name that will be created
          ui:field: RepoUrlPicker
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
            "python",
            "fastapi",
          ]
        defaultBranch: main
        gitCommitMessage: Create AI Assistant service from template
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
