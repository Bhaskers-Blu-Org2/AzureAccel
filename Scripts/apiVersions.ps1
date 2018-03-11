#Get API Versions
 (Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Insights).ResourceTypes | Where {$_.ResourceTypeName -eq 'components'} | Select -ExpandProperty ApiVersions
 