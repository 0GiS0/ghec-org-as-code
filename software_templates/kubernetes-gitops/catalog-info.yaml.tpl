---
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: kubernetes-gitops
  title: ☸️ Kubernetes GitOps Repository
  description: >-
    Create a repository to manage Kubernetes manifests following
    GitOps best practices
  tags:
    - kubernetes
    - gitops
    - infrastructure
    - kustomize
    - helm
spec:
  owner: ${template_owner}
  type: infrastructure
  parameters:
    - title: Project Information
      required:
        - name
        - description
        - owner
      properties:
        name:
          type: string
          title: 📦 Repository Name
          description: Unique name for the GitOps repository
          ui:field: ValidateKebabCase
        description:
          type: string
          title: 📝 Description
          description: >-
            Short description of the cluster or environment being managed
          ui:widget: textarea
        owner:
          type: string
          title: 👥 Team Owner
          description: Team responsible for this infrastructure
          ui:field: EntityPicker
          ui:options:
            catalogFilter:
              kind: Group

    - title: Cluster Configuration
      required:
        - clusterName
        - environment
      properties:
        clusterName:
          type: string
          title: 🌐 Cluster Name
          description: >-
            Name of the Kubernetes cluster
            (e.g., production-us-east)
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
        allowedHosts: ['github.com']
        description: $${{ parameters.description }}
        repoUrl: $${{ parameters.owner }}/$${{ parameters.name }}
        defaultBranch: main
        protectDefaultBranch: true
        repoVisibility: private

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
