---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: system
  title: 🔧 System Entity
  description: Create a new System entity for organizing components and resources
  annotations:
    backstage.io/techdocs-ref: dir:.
  tags:
    - system
    - catalog
    - organization
    - architecture
    - recommended
spec:
  owner: platform-team
  type: system
  parameters:
    - title: 🔧 Complete the form to create a new System
      required:
        - name
        - description
        - owner
      properties:
        name:
          type: string
          title: 🔧 System Name
          description: The name of the system (will be used as entity name)
          ui:autofocus: true
          ui:field: ValidateKebabCase
        description:
          title: 📝 Description
          type: string
          description: A description for the system
          minLength: 1
          maxLength: 340
          pattern: "^.*\\S.*$"
          ui:help: "Required field. Max 340 characters. Describe what this system does and its main purpose."
          ui:options:
            inputProps:
              maxLength: 340
              placeholder: "Enter a clear, concise description of this system..."
          ui:widget: textarea
        owner:
          title: 👥 Select the team that owns this system
          type: string
          description: The team that owns and maintains this system
          ui:field: MyGroupsPicker
        domain:
          title: 🏗️ Domain
          type: string
          description: The domain this system belongs to
          ui:field: EntityPicker
          ui:options:
            catalogFilter:
              kind: Domain
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
        values:
          name: $${{ parameters.name }}
          owner: $${{ parameters.owner }}
          description: $${{ parameters.description }}
          domain: $${{ parameters.domain | parseEntityRef | pick('name') }}
          destination: $${{ parameters.repoUrl | parseRepoUrl }}
          repoUrl: $${{ parameters.repoUrl }}

    - id: publish
      name: 🚀 Publish to GitHub
      action: publish:github
      input:
        repoUrl: $${{ parameters.repoUrl }}
        description: $${{ parameters.description }}
        topics:
          ["backstage-include", "${github_organization}", "system", "catalog"]
        defaultBranch: main
        gitCommitMessage: Create System entity from template
        customProperties:
          service-tier: "tier-2"
          team-owner: $${{ parameters.owner }}
          demo: "no"

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
