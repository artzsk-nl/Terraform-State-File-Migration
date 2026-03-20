# Landing Zone Migration Runbook

## Purpose
This document captures the full implementation history, current architecture, drift/state management approach, and a repeatable workflow to evolve this into an agent-driven landing zone migration process.

## Scope
Subscription: d3ee0257-dea0-49db-8e34-03cdcf1d0ab5  
Subscription Name: ME-MngEnvMCAP241332-susanartz-4  
Region: swedencentral

## Final Working Architecture
The sandbox deployment currently manages the following resources in resource group rg-lzlab-sandbox:
- Virtual network: vnet-lzlab-sandbox
- Subnets:
  - snet-vm (for VM)
  - snet-app (for private endpoint)
- NSG: nsg-lzlab-sandbox-vm (RDP rule)
- Public IP: pip-lzlab-sandbox-vm
- NIC: nic-lzlab-sandbox-vm
- Windows VM: vm-lzlab-sandbox
- Storage account: stlzlabsandboxhkvmsw
- Key Vault: kv-newresourceportal (portal-created, now imported/managed)
- Private DNS zone: privatelink.blob.core.windows.net (portal-created, now imported/managed)
- Private DNS VNet link: rdm5jg65rcq3o (portal-created, now imported/managed)
- Private endpoint: pe-stlzlabsandboxhkvmsw (portal-created, now imported/managed)

## Source of Truth Files
- Main infra: environments/sandbox/main.tf
- Provider: environments/sandbox/providers.tf
- Variables: environments/sandbox/variables.tf
- Outputs: environments/sandbox/outputs.tf
- Active values: environments/sandbox/terraform.tfvars

## Chronological Implementation Summary
1. Project scaffold created under terraform-landingzone-lab with environment and scripts.
2. Initial module-based seed deployment (resource group + log analytics) created.
3. Simplified to direct resources for single-subscription sandbox:
   - VNet + 2 subnets
   - Small Windows VM
   - Azure SQL Server + SQL DB + private endpoint (initial target)
4. Subscription and region updated to target values:
   - subscription_id = d3ee0257-dea0-49db-8e34-03cdcf1d0ab5
   - location = swedencentral
5. Apply blocked by Azure policy on SQL Server creation (RequestDisallowedByPolicy).
6. SQL resources replaced with Storage Account per request.
7. Apply then hit Storage policy for key-based auth restrictions; provider/storage settings aligned:
   - storage_use_azuread = true in provider
   - shared_access_key_enabled = false in storage account
8. Deployment succeeded for core stack.
9. Drift detected from portal-side changes using refresh-only plan.
10. aztfexport run performed in separate folder to capture portal-created resources.
11. Portal-created resources selectively merged into main sandbox config.
12. Resources imported into main sandbox state.
13. Final plan reached no changes, confirming config and infrastructure alignment.

## Current Terraform Behavior
The configuration is aligned and stable.
- validate: success
- plan: no changes

The storage account is explicitly configured for restricted network posture and keyless access compatibility:
- public_network_access_enabled = false
- network_rules default_action = Deny with AzureServices bypass
- shared_access_key_enabled = false

## Drift and State Update Workflow
Use this workflow whenever portal or policy changes happen.

### A) Detect and record drift for existing managed resources
1. terraform plan -refresh-only
2. Review drift output.
3. If drift is expected and should be recorded without changing resources:
   - terraform apply -refresh-only
4. If drift should become codified behavior:
   - Update .tf config to match desired state
   - terraform plan
   - terraform apply

### B) Bring portal-created resources under Terraform
1. Add matching resource blocks to config.
2. Import each resource into state:
   - terraform import <address> <resource-id>
3. Run terraform plan and iterate until no unintended changes.

## aztfexport Usage Notes (From This Implementation)
aztfexport was used successfully through query mode in a separate export folder, not inside the main workspace, to avoid polluting the primary IaC.

Working pattern:
- Export scope with query mode including resource group resources
- Review generated mapping and HCL
- Selectively merge useful resources only
- Import into primary state using existing naming conventions

Important caveat observed:
- Storage account import/export can fail in environments that disallow key-based auth unless provider/runtime is aligned to Azure AD storage auth semantics.

## Why Separate Export Folder Was Correct
Benefits:
- Prevents accidental overwrite of curated Terraform files
- Avoids random resource names from generator output becoming production standards
- Enables controlled merge into existing naming and module conventions

## Security and State Considerations
Current sandbox state is local. Local state can include secrets/sensitive values.
Recommended next step:
- Move to remote backend in Azure Storage with encryption and RBAC-controlled access.
- Add state locking and role-segregated access for team workflows.

## Repeatable Agent Blueprint (Future)
Goal: one-command runbook for each landing zone migration.

### Recommended agent responsibilities
1. Precheck stage
- Validate subscription, tenant, region, Terraform version, Azure CLI context.

2. Drift stage
- Run refresh-only plan.
- Produce drift summary grouped by:
  - managed resource attribute changes
  - unmanaged resources found in resource group

3. Export stage
- Optionally run aztfexport in timestamped temp folder.
- Parse mapping file.
- Propose merge candidates (new resources only).

4. Merge stage
- Generate deterministic patches against main.tf/variables.tf/outputs.tf.
- Avoid replacing existing naming conventions.

5. Import stage
- Run terraform import for selected resources.
- Retry/import fallbacks for policy-constrained resources.

6. Verification stage
- terraform fmt
- terraform validate
- terraform plan
- Emit clear pass/fail report and next steps.

### Suggested implementation options in this repo
Option 1: Script-first approach (quickest)
- Add scripts/drift-check.ps1
- Add scripts/export-and-merge.ps1
- Add scripts/import-portal-resources.ps1
- Add scripts/verify-iac.ps1

Option 2: VS Code skill/agent customization (best long-term UX)
- Add a workspace customization file under .github/skills/landing-zone-migration/SKILL.md
- Include:
  - trigger phrases for landing zone drift/import/update
  - mandatory execution order
  - policy-aware fallbacks
  - output report template

## Operational Command Set
Use these as the base run sequence in sandbox.

1. terraform -chdir=terraform-landingzone-lab/environments/sandbox fmt
2. terraform -chdir=terraform-landingzone-lab/environments/sandbox validate
3. terraform -chdir=terraform-landingzone-lab/environments/sandbox plan -refresh-only
4. terraform -chdir=terraform-landingzone-lab/environments/sandbox apply -refresh-only
5. terraform -chdir=terraform-landingzone-lab/environments/sandbox plan
6. terraform -chdir=terraform-landingzone-lab/environments/sandbox apply

## Done Criteria for Each Future Migration
A migration/update is complete when all are true:
- All intended resources exist in Azure.
- All intended resources are represented in Terraform config.
- All intended resources are imported in state.
- terraform validate passes.
- terraform plan returns no unexpected changes.
- Runbook/report archived with date, subscription, region, and import list.

## Change Log Anchor
Last known aligned state: March 2026  
Environment: sandbox  
Status: Terraform configuration and Azure resources are aligned (no-change plan).
