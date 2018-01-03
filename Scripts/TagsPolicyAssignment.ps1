# To create a custom Tags Policy Definition then Assign it to the subscription
# Please modify the variables based on your environment
# This policy definition uses built-in policy json files as the base.

$policydefname = "Mandatory Tags"
$policydisplayname = "Mandatory Tags Policy"
$description = "This policy enforces mandatory tags on the resources"
$policyURI = 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/enforce-resourceGroup-tags/azurepolicy.rules.json'
$PolicyParamsURI = 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/enforce-resourceGroup-tags/azurepolicy.parameters.json'
$definition
$assignmentname = "Tags Policy Assignment"
# Enter the Regions you want to allow below
$tagName = "Environment"
$tagValue = "Development"
# Enter the Sandbox resource group name you want to exclude from the policy assignment
$ExclusionRG = "Sandbox-RG"
# This will apply the policy to the first subscription retrieved by the cmdlet
$AzureSub = Get-AzureRmSubscription
$subscope = "/subscriptions/" + $AzureSub[0].SubscriptionId
$notscope = $subscope + "/" + $ExclusionRG

$definition = New-AzureRmPolicyDefinition -Name $policydefname -DisplayName $policydisplayname -description $description -Policy $policyURI  -Parameter $PolicyParamsURI -Mode All
$definition
$skutable = @{"Name" = "A1"; "Tier" = "Standard"}
$assignment = New-AzureRMPolicyAssignment -Name $assignmentname -Scope $subscope -tagName $tagName -tagValue $tagValue -PolicyDefinition $definition -Sku $skutable -NotScope $notscope
$assignment