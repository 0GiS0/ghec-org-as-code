# GHEC Org as Code – Copilot Agent Instructions

This repo manages GitHub Enterprise Cloud (GHEC) org teams, template repos, branch protections, and Codespaces access via Terraform. AI agents should use these instructions for all automation and coding tasks.

## Architecture & Key Patterns
- **Terraform-centric:** All org, team, repo, and security config is managed via HCL in root `.tf` files (see `main.tf`, `teams.tf`, `repositories.tf`, etc.).
- **Backstage templates:** Under `software_templates/`, repo skeletons and template files use Backstage and Terraform placeholders. See AGENTS.md for placeholder conventions.
- **Custom integrations:** For unsupported GitHub features (e.g., org custom properties), use Bash scripts in `scripts/terraform-integration/` triggered by `null_resource` blocks in Terraform. See `custom_properties.tf` and AGENTS.md for examples.
- **Python formatting:** All `.py.tpl` files in `software_templates/` must be formatted with Black. Use `scripts/repo-tools/check-python-format.sh` and `format-python.sh` before any commit.

## Critical Workflows
- **Terraform lifecycle:**
  - Always run: `terraform fmt`, `terraform validate`, `terraform plan` before PRs.
  - Never cancel `terraform init`, `plan`, or `apply` (timeouts ≥60min).
  - Use remote state (see `terraform.tf`). Never edit state manually.
- **Validation:**
  - After changes, verify in GHEC UI: teams, repos, branch protections, CODEOWNERS, security settings.
  - For Backstage templates, use `.local-validate/render.sh` to test rendering locally.
- **PR process:**
  - All changes via PR. Run local validation before push. Platform team reviews required for infra changes.

## Project-Specific Conventions
- **Team hierarchy:** Parent team is `canary-trips`; see `teams.tf` for structure.
- **Repo settings:** All template repos are private, auto-init, main branch protected, required checks: `ci-template`, `lint`, `docs-build`, `codeql`. CODEOWNERS required for `skeleton/` and `template.yaml`.
- **Backstage placeholders:**
  - In files processed by Terraform: `${variable}` for Terraform, `$${{parameters.var}}` for Backstage.
  - In skeleton files: `${{values.var}}` for Backstage only.
- **Custom properties:** Managed via Bash scripts and `null_resource` (see `custom_properties.tf`, `scripts/terraform-integration/custom_property.sh`).
- **Python templates:** Format with Black before commit. Use repo-tools scripts for check/fix.

## Integration Points
- **GitHub provider:** Use version ≥6.0. Credentials via GitHub App (see AGENTS.md for env vars).
- **Codespaces access:** Managed in `codespaces.tf` and `scripts/terraform-integration/codespaces_access.sh`.
- **Security config:** See `github-security-config.tf` and `org-rulesets.tf` for org-wide rulesets and security policies.

## Examples
- Add a team: Edit `teams.tf`, run `terraform plan`, validate in GHEC UI.
- Add a template repo: Edit `repositories.tf`, set team permissions, run `terraform plan`, validate repo settings and branch protection.
- Add org custom property: Update `custom_properties.tf`, provide property payload, run plan/apply, verify via GitHub API and logs.
- Format Python templates: `./scripts/repo-tools/check-python-format.sh` and `./scripts/repo-tools/format-python.sh`.

## Troubleshooting
- If Terraform fails on custom properties, check logs in `/tmp/custom-properties-*.log` and validate with GitHub API.
- For Codespaces errors, review `/tmp/codespaces-org-access.log`.
- For provider errors, confirm GitHub App permissions and PEM file access.

---
**Feedback:** If any section is unclear or missing, please specify what needs improvement or what additional context is required.