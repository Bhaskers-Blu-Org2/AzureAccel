## This will create a resource group in your subscription
## Please modify the variables then execute the script
$RGName = "Sandbox-RG"
$Location = "eastus"
$Tags = @{ Department = "IT"; Environment= "Sandbox" }

$CreateRG = New-AzureRMResourceGroup -Name $RGName -Location $Location -Tag $Tags -Force
$CreateRG
