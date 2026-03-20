# Terraform Landing Zone Lab

This project is a safe sandbox to test Terraform deployments and iterative updates for an Azure landing zone.

## What this includes
- Single-subscription, simple environment in `environments/sandbox`
- One VNet with two subnets
- One small Windows VM
- One Azure Storage Account
- PowerShell scripts in `scripts` for repeatable workflows

## Prerequisites
- Terraform >= 1.6
- Azure CLI (`az login` completed)
- Contributor access to the target subscription

If Terraform is not installed on Windows:

```powershell
winget install Hashicorp.Terraform
```

## Quick start
1. Copy the example values:
   - `environments/sandbox/terraform.tfvars.example` -> `environments/sandbox/terraform.tfvars`
   - `environments/sandbox/backend.hcl.example` -> `environments/sandbox/backend.hcl`
2. Update values for your subscription, state storage account, and admin credentials.
3. Run:

```powershell
./scripts/init.ps1 -Environment sandbox
./scripts/plan.ps1 -Environment sandbox
./scripts/apply.ps1 -Environment sandbox
```

## Update workflow
1. Make a Terraform change in the module or environment.
2. Run `./scripts/plan.ps1 -Environment sandbox`.
3. Review the diff.
4. Run `./scripts/apply.ps1 -Environment sandbox`.

## Destroy sandbox resources

```powershell
./scripts/destroy.ps1 -Environment sandbox
```

## Suggested next steps
- Add additional environment folders such as `environments/dev` and `environments/test`.
- Add policy and role assignments as separate modules.
- Add CI validation for `terraform fmt -check`, `terraform validate`, and `terraform plan`.
