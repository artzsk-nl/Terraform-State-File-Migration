param(
  [Parameter(Mandatory = $false)]
  [string]$Environment = "sandbox"
)

$envPath = Join-Path $PSScriptRoot "../environments/$Environment"

Push-Location $envPath
terraform validate
terraform apply -auto-approve "plan.tfplan"
Pop-Location
