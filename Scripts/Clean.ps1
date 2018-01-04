# To remove items created in this lab
$ResourceGroups = @("azureaccel-sandbox-rg", 
    "azureaccel-web-dev-rg", 
    "azureaccel-app-dev-rg", 
    "azureaccel-data-dev-rg"  )

foreach ( $ResourceGroup in $ResourceGroups ){
    Write-output "Removing  $ResourceGroup"
    Remove-AzureRmResourceGroup $ResourceGroup -Force;
}
