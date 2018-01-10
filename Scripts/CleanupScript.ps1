$resgrps = Get-AzureRmResourceGroup | Where-Object {$_.ResourceGroupName -like "Sandbox*"}
ForEach ($grp in $resgrps)
{Remove-AzureRmResourceGroup -Name $grp.ResourceGroupName -Force
}



Get-AzureADGroup |Where-Object {$_.DisplayName -like "Billing Readers"} |Remove-AzureADGroup
Get-AzureADGroup |Where-Object {$_.DisplayName -like "Security Admins"} |Remove-AzureADGroup
Get-AzureADGroup |Where-Object {$_.DisplayName -like "Billing Administrators"} |Remove-AzureADGroup
Get-AzureADGroup |Where-Object {$_.DisplayName -like "Readers"} |Remove-AzureADGroup
Get-AzureADGroup |Where-Object {$_.DisplayName -like "Contributors"} |Remove-AzureADGroup
$userlist | Remove-AzureADUser





