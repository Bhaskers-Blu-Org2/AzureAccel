#Param(
#    [Parameter(Mandatory=$true)][string]$InputFile
#    ) 
##
### This script reads the user csv file for the userid
### It creates groups in Azure AD for those roles
### 

$sub = Get-AzureRmSubscription

$BillingAdminGroupDisplayName = "Billing Readers"
$BillingAdmingGroupDesc = "Users can read roles and role assignments,billing information and manage support tickets "

$listroles = Get-AzureRmRoleDefinition


$billingusers = $userlist | where {$_.role -match "Billing"}
$BillingGroup = New-AzureADGroup -Description $BillingAdmingGroupDesc -DisplayName $BillingAdminGroupDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Billing-Admins"
$billingRole = $listroles |where {$_.Name -match "Billing Reader"}
$newbillingroleAssignment = New-AzureRmRoleAssignment -ObjectId $BillingGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $BillingRole.Id -Verbose
$billingusers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $BillingGroup.ObjectId -RefObjectId $_.ObjectId
                        }


