param(
  [Parameter(Mandatory = $false)]
  [string]$Environment = "sandbox"
)

$envPath = Join-Path $PSScriptRoot "../environments/$Environment"

Push-Location $envPath
terraform validate
terraform destroy -auto-approve -var-file="terraform.tfvars"
Pop-Location
