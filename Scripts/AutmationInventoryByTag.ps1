# Get information required for the automation account from parameter values when the runbook is started.
Param
(
    [Parameter(Mandatory = $True)]
    [string]$resourceGroupName,
   
    [Parameter(Mandatory = $True)]
    [string]$tagName,
   
    [Parameter(Mandatory = $True)]
    [string]$tagValue
)

# Authenticate to the Automation account using the Azure connection created when the Automation account was created.
# Code copied from the runbook AzureAutomationTutorial.
$connectionName = "AzureRunAsConnection"
$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         
Add-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $servicePrincipalConnection.TenantId `
    -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

# Set the $VerbosePreference variable so that we get verbose output in test environment.
$VerbosePreference = "Continue"

# Get information required for Log Analytics workspace from Automation variables.
$customerId = Get-AutomationVariable -Name 'OMSWorkspaceId'
$sharedKey = Get-AutomationVariable -Name 'OMSWorkspacekey'

# Set the name of the record type.
$logType = "AutomationJob"

#Get a list of resources in the sunscription that match the tag
#$resources = Get-AzureRmAutomationJob -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -StartTime (Get-Date).AddHours(-1)

$resources = Get-AzureRmVmssVM -ResourceGroupName $resourceGroupName -VMScaleSetName "webvmssqh" 


if ($resources -ne $null) {
    # Convert the job data to json
    $body = $resources | ConvertTo-Json

    # Write the body to verbose output so we can inspect it if verbose logging is on for the runbook.
    Write-Verbose $body

    # Send the data to Log Analytics.
    Send-OMSAPIIngestionFile -customerId $customerId -sharedKey $sharedKey -body $body -logType $logType -TimeStampField CreationTime
}