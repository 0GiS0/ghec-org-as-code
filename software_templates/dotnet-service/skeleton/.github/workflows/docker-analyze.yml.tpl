name: 🔎 Docker Image Analysis

on:
  pull_request:
    branches: [main, develop]
    paths:
      - "Dockerfile"
      - ".github/workflows/docker-analyze.yml"
      - "src/**"
  push:
    branches: [main]
    paths:
      - "Dockerfile"
      - ".github/workflows/docker-analyze.yml"

permissions:
  contents: read
  security-events: write

jobs:
  analyze-insecure-image:
    name: 🐳 Scan insecure Dockerfile
    # Reference reusable workflow hosted centrally
    uses: ${github_organization}/${reusable_workflows_repository}/.github/workflows/analyze_docker_images.yml@main
    with:
      dockerfile: Dockerfile
      context: .
      image_name: insecure-dotnet-service
      severity: CRITICAL,HIGH,MEDIUM
      vuln_types: os,library
      ignore_unfixed: true
      exit_on_findings: false # Learning mode: show findings without failing
      generate_sbom: true
