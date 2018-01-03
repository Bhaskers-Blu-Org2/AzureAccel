# To create a custom Policy Definition then Assign it to the subscription
# Please modify the variables based on your environment
# This policy definition uses built-in policy json files as the base.

$policydefname = "Canada Regions"
$policydisplayname = "Canada Regions Policy"
$description = "This policy restricts the deployment of resources to the regions specified, minus the exceptions"
$policyURI = 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.rules.json'
$PolicyParamsURI = 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.parameters.json'
$assignmentname = "Canada Regions Assignment"
# Enter the Regions you want to allow below
$locations = "canadacentral","canadaeast"
# Enter the Sandbox resource group name you want to exclude from the policy assignment
$ExclusionRG = "Sandbox-RG"
# This will apply the policy to the first subscription retrieved by the cmdlet
$AzureSub = Get-AzureRmSubscription
$subscope = "/subscriptions/" + $AzureSub[0].SubscriptionId
$notscope = $subscope + "/" + $ExclusionRG

$definition = New-AzureRmPolicyDefinition -Name $policydefname -DisplayName $policydisplayname -description $description -Policy $policyURI  -Parameter $PolicyParamsURI -Mode All
$definition
$skutable = @{"Name" = "A1"; "Tier" = "Standard"}
$assignment = New-AzureRMPolicyAssignment -Name $assignmentname -Scope $subscope -listOfAllowedLocations $locations -PolicyDefinition $definition -Sku $skutable -NotScope $notscope
$assignment