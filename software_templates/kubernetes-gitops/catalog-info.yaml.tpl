---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: kubernetes-gitops
  title: ☸️ Kubernetes GitOps Repository
  description: >
    Create a repository to manage Kubernetes manifests following
    GitOps best practices
  annotations:
    backstage.io/techdocs-ref: dir:.
  tags:
    - kubernetes
    - gitops
    - infrastructure
    - kustomize
    - helm
    - argocd
spec:
  owner: ${template_owner}
  type: infrastructure
  parameters:
    - title: ☸️ Complete the form to create a Kubernetes GitOps Repository
      required:
        - name
        - description
        - owner
        - clusterName
        - environment
      properties:
        name:
          type: string
          title: 📦 Repository Name
          description: Unique name for the GitOps repository (kebab-case)
          ui:autofocus: true
          ui:field: ValidateKebabCase
        description:
          type: string
          title: 📝 Description
          description: Short description of the cluster or environment being managed
          ui:widget: textarea
        owner:
          type: string
          title: 👥 Team Owner
          description: Team responsible for this infrastructure
          ui:field: EntityPicker
          ui:options:
            catalogFilter:
              kind: Group
        clusterName:
          type: string
          title: 🌐 Cluster Name
          description: Name of the Kubernetes cluster (e.g., production-us-east)
          ui:field: ValidateKebabCase
        environment:
          type: string
          title: 🌍 Environment
          description: Target environment
          enum:
            - development
            - staging
            - production
          default: development

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
          clusterName: $${{ parameters.clusterName }}
          environment: $${{ parameters.environment }}

    - id: publish
      name: 🚀 Publish Repository
      action: publish:github
      input:
        description: $${{ parameters.description }}
        repoUrl: github.com?owner=${github_organization}&repo=$${{ parameters.name }}
        topics:
          - backstage-include
          - ${github_organization}
          - kubernetes
          - gitops
          - $${{ parameters.environment }}
        defaultBranch: main
        protectDefaultBranch: true
        repoVisibility: private
        gitCommitMessage: Create Kubernetes GitOps repository from template

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
