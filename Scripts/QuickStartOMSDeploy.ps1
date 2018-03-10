New-AzureRmResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName ExampleResourceGroup `
  -TemplateUri https://raw.githubusercontent.com/lagimik/azure-quickstart-templates/master/oms-all-deploy/azuredeploy.json `
  -storageAccountType Standard_GRS