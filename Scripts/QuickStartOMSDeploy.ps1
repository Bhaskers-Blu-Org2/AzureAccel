#Adding some commentsY

New-AzureRmResourceGroup -Name RG_QuikStartOMS -Location EastUS

New-AzureRmResourceGroupDeployment -Force -Verbose -Name RG_QuikStartOMS -ResourceGroupName RG_QuikStartOMS  `
  -TemplateUri https://raw.githubusercontent.com/lagimik/azure-quickstart-templates/master/oms-all-deploy/azuredeploy.json `
  -TemplateParameterFile "C:\Users\mamoris\Dev\azure-quickstart-templates\oms-all-deploy\azuredeploy.parameters.json"