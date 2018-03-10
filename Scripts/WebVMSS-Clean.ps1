#remove resrouce group
$resgrps = Get-AzureRmResourceGroup | Where-Object {$_.ResourceGroupName -like "RG_Web*"}
ForEach ($grp in $resgrps)
{
    Remove-AzureRmResourceGroup -Name $grp.ResourceGroupName -Force
}


