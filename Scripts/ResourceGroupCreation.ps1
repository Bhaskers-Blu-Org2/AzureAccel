Param(
    [Parameter(Mandatory=$true)][string]$ProjectCode,
    [Parameter(Mandatory=$true)][string]$ResourceGroupName,
    [Parameter(Mandatory=$true)][string]$AzureRegion,
    [Parameter(Mandatory=$true)][string]$EnvironmentName
     ) 
# The tag key below will be created everytime, as we will be enforcing a policy for its presence later
$mandatoryTag = "Project"
$rgcreate = New-AzureRMResourceGroup -Name $ResourceGroupName -Location $AzureRegion -Tag @{ $mandatoryTag = $ProjectCode; Environment= $EnvironmentName }
$rgcreate

