#VM Scale Set to create some traffic
#Local test harness


New-AzureRmResourceGroup -Name RG_Web -Location EastUS

New-AzureRmResourceGroupDeployment -Force -Verbose -Name RG_Web -ResourceGroupName RG_Web  `
  -TemplateUri "C:\Users\mamoris\Dev\azure-quickstart-templates\201-vmss-windows-webapp-dsc-autoscale\azuredeploy.json" `
  -TemplateParameterFile "C:\Users\mamoris\Dev\azure-quickstart-templates\201-vmss-windows-webapp-dsc-autoscale\azuredeploy.parameters.json"
  
