## This will create 3 resource group in your subscription: Web, App, Database
## Please modify the variables then execute the script
## Resrouce Group naming standard: <service short name>-<environment>-rg
## Tags: billTo, managedBy,  project-name, project-version, environment, tier, dataProfile

# Each resource group in the same region
$Location = "eastus"

#Define Web Tier
$WebRGName = "azureaccel-web-dev-rg"
$WebTags = @{ billTo = "IT"; 
    mabagedBy = "IT"; 
    projectName = "AzureAccel"; 
    projectVersion = "1.0"; 
    Environment= "dev"; 
    tier = "Web"; 
    dataProfile = "public"
    }
$CreateWebRG = New-AzureRMResourceGroup -Name $WebRGName -Location $Location -Tag $Tags -Force

#Define AppTier
$AppRGName = "azureaccel-app-dev-rg"

$AppTags = @{ billTo = "IT"; 
    mabagedBy = "IT"; 
    projectName = "AzureAccel"; 
    projectVersion = "1.0"; 
    Environment= "dev"; 
    tier = "App"; 
    dataProfile = "public"
    }
$CreateAppRG = New-AzureRMResourceGroup -Name $AppRGName -Location $Location -Tag $AppTags -Force

#Define Data DataTier
$DataRGName = "azureaccel-data-dev-rg"

$DataTags = @{ billTo = "IT"; 
    mabagedBy = "IT"; 
    projectName = "AzureAccel"; 
    projectVersion = "1.0"; 
    Environment= "dev"; 
    tier = "Data"; 
    dataProfile = "public"
    }
$CreateDataRG = New-AzureRMResourceGroup -Name $DataRGName -Location $Location -Tag $DataTags -Force


#Creat the Agile IT Resoure Groups
$CreateWebRG

$CreateAppRG

$CreateDataRG