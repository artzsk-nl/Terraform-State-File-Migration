param(
  [Parameter(Mandatory = $false)]
  [string]$Environment = "sandbox"
)

$envPath = Join-Path $PSScriptRoot "../environments/$Environment"

Push-Location $envPath
terraform fmt -recursive
terraform validate
terraform plan -var-file="terraform.tfvars" -out="plan.tfplan"
Pop-Location
