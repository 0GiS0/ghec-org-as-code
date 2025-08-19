---
apiVersion: backstage.io/v1alpha1
%{ if template_type == "system" ~}
kind: System
%{ else ~}
%{ if template_type == "domain" ~}
kind: Domain
%{ else ~}
kind: Component
%{ endif ~}
%{ endif ~}
metadata:
  name: $${{ values.name }}
  title: $${{ values.name | title }}
  description: $${{ values.description }}
  annotations:
    backstage.io/techdocs-ref: dir:.
    github.com/project-slug: $${{ values.destination.owner }}/$${{ values.name }}
%{ if template_type != "system" && template_type != "domain" ~}
  tags:
    - $${{ values.system }}
%{ endif ~}
spec:
%{ if template_type == "system" ~}
  owner: $${{ values.owner }}
  domain: $${{ values.domain }}
%{ else ~}
%{ if template_type == "domain" ~}
  owner: $${{ values.owner }}
%{ else ~}
  type: ${template_type}
  lifecycle: experimental
  owner: $${{ values.owner }}
  system: $${{ values.system }}
%{ endif ~}
%{ endif ~}
