param(
  [Parameter(Mandatory = $false)]
  [string]$Environment = "sandbox"
)

$envPath = Join-Path $PSScriptRoot "../environments/$Environment"

Push-Location $envPath
terraform init -backend-config="backend.hcl"
Pop-Location
