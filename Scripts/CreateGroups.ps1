#Param(
#    [Parameter(Mandatory=$true)][string]$InputFile
#    ) 
##
### This script reads the user csv file for the userid
### It creates groups in Azure AD for those roles
### 

$sub = Get-AzureRmSubscription

$listroles = Get-AzureRmRoleDefinition

### CREATING THE Group and RBAC ASSIGNMENT FOR THE Billing Role in the input file
$BillingAdminGroupDisplayName = "Billing Readers"
$BillingAdmingGroupDesc = "Users can read roles and role assignments,billing information and manage support tickets "

$billingusers = $userlist | Where-Object {$_.role -like "Billing"}
$BillingGroup = New-AzureADGroup -Description $BillingAdmingGroupDesc -DisplayName $BillingAdminGroupDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Billing-Admins"
$billingRole = $listroles |Where-Object {$_.Name -like "Billing Reader"}
$newbillingroleAssignment = New-AzureRmRoleAssignment -ObjectId $BillingGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $BillingRole.Id -Verbose
$billingusers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $BillingGroup.ObjectId -RefObjectId $_.ObjectId
                        }
##### CREATING THE GROUP AND RBAC Assignment for the Security Admins in the input file
$SecurityAdminGroupDisplayName = "Security Admins"
$SecurityAdminGroupDesc = "Users can manage security components, security policies and virtual machines "


$securityusers = $userlist | Where-Object {$_.role -like "Security Admin"}
$SecurityGroup = New-AzureADGroup -Description $SecurityAdminGroupDesc -DisplayName $SecurityAdminGroupDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Security-Admins"
$SecurityRole = $listroles |Where-Object {$_.Name -like "Security Manager"}
$newsecurityroleAssignment = New-AzureRmRoleAssignment -ObjectId $SecurityGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $SecurityRole.Id -Verbose
$securityusers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $SecurityGroup.ObjectId -RefObjectId $_.ObjectId
                        }

##### CREATING THE GROUP AND RBAC Assignment for the Readers in the input file                        
$readerGroupDisplayName = "Readers"
$readerGroupDesc = "Users can view everything but not make any changes "


$readerusers = $userlist | Where-Object {$_.role -like "Reader"}
$readerGroup = New-AzureADGroup -Description $readerGroupDesc -DisplayName $readerGroupDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Readers"
$readerRole = $listroles |Where-Object {$_.Name -like "Reader"}
$newReaderRoleAssignment = New-AzureRmRoleAssignment -ObjectId $ReaderGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $ReaderRole.Id -Verbose
$ReaderUsers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $ReaderGroup.ObjectId -RefObjectId $_.ObjectId
                        }

##### CREATING THE GROUP AND RBAC Assignment for the Contributors in the input file                        
$ContributorsDisplayName = "Contributors"
$ContributorsGroupDesc = "Users manage everything except access to resources "


$ContributorUsers = $userlist | Where-Object {$_.role -like "Contributor"}
$ContributorGroup = New-AzureADGroup -Description $ContributorsGroupDesc -DisplayName $ContributorsDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Contributors"
$ContributorRole = $listroles |Where-Object {$_.Name -like "Contributor"}
$newContributorRoleAssignment = New-AzureRmRoleAssignment -ObjectId $ContributorGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $ContributorRole.Id -Verbose
$ContributorUsers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $ContributorGroup.ObjectId -RefObjectId $_.ObjectId
                        }


