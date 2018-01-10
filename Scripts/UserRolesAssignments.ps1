### Sample script to create cloud users, AzureAD Groups and assign them an Azure RBAC role

### Mandatory Parameters to ask for at script execution
Param(
    [Parameter(Mandatory=$true)][string]$InputFile
      ) 



### Prompting user for tenant name = used for UPN generation
$tenantname = Read-Host -Prompt "Please Enter your AD Tenant Name, i.e tenant.onmicrosoft.com "
if ( $tenantname -notmatch "onmicrosoft.com" ) {
    Write-Host "Please enter full tenant name, i.e <tenant>.onmicrosoft.com"
    Write-Host "Run the script again with proper input"
    exit 0
    }

if ( $userlist -in [array] ) {
    Write-Host "Input File Format Incorrect"
    Write-Host "Run the Script Again with a CSV file like the UserList.CSV sample"
    exit 0
}
## Confirming our subscription object and that it is enabled
$sub = Get-AzureRmSubscription -TenantId $tenantname
$ObjectType = $sub.GetType()
if ($ObjectType.Name -ne "PSAzureSubscription" -and $sub.State -ne "Enabled")
 {
Write-Host "Check your subscription with Select-AzureRMSubscription"
Exit 0
}

# Setting up environment for random pw generation
$PasswordLength = 12
$NonAlphCh = 4 
Add-Type -AssemblyName System.Web
## This section can be used if you want to securely store initial passwords in a key vault in your subscription
#$KeyVaultName = "keyvault"
#Get-AzureRmKeyVault -VaultName $KeyVaultName
#Importing CSV file and starting iteration through accounts
$userlist = Import-Csv $InputFile


$userlist |ForEach-Object{
$postalcode = "K1P5B4"
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = ([System.Web.Security.Membership]::GeneratePassword($PasswordLength,$NonAlphCh))
$mailnnickname = $_.givenname + $_.surname
$displayname = $_.givenname + " " + $_.surname
$upn = $_.givenname + "." + $_.surname + "@"+ $tenantname
$newuser = New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $true -DisplayName $displayname -Department $_.department -GivenName $_.givenname -Surname $_surname -UserPrincipalName $upn -MailNickName $mailnnickname -PostalCode $postalcode -Verbose
$_.ObjectID = $newuser.ObjectID
Write-Host "User" $_.givenname $_.surname "has been created"
## Determining the user group and adding them to the right group
# To be added later
##############################
# This section below will safely store the user password in a key vault in a subscription.
# For this to work, you will need to specify the name of a key vault in your sub that you can access at script launch
# If you do not have a key vault or do not wish to use it, you can safely delete the three lines below.
########################
##$secretname = $mailnnickname + "PW"
#$secretvalue = ConvertTo-SecureString $PasswordProfile.Password -AsPlainText -Force
#$secret = Set-AzureKeyVaultSecret -VaultName $keyvault.VaultName -Name $secretname  -SecretValue $secretvalue -ContentType "Initial Password"
}

$listroles = Get-AzureRmRoleDefinition

#Creating the Groups First then confirming they are there before continuing
$BillingAdminGroupDisplayName = "Billing Readers"
$BillingAdmingGroupDesc = "Users can read roles and role assignments,billing information and manage support tickets "
$BillingGroup = New-AzureADGroup -Description $BillingAdmingGroupDesc -DisplayName $BillingAdminGroupDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Billing-Admins"


$SecurityAdminGroupDisplayName = "Security Admins"
$SecurityAdminGroupDesc = "Users can manage security components, security policies and virtual machines "
$SecurityGroup = New-AzureADGroup -Description $SecurityAdminGroupDesc -DisplayName $SecurityAdminGroupDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Security-Admins"

$readerGroupDisplayName = "Readers"
$readerGroupDesc = "Users can view everything but not make any changes "
$readerGroup = New-AzureADGroup -Description $readerGroupDesc -DisplayName $readerGroupDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Readers"

$ContributorsDisplayName = "Contributors"
$ContributorsGroupDesc = "Users manage everything except access to resources "
$ContributorGroup = New-AzureADGroup -Description $ContributorsGroupDesc -DisplayName $ContributorsDisplayName -MailEnabled $false -SecurityEnabled $true -Verbose -MailNickName "Contributors"

Write-Host $ContributorGroup.DisplayName $readerGroup.DisplayName $securitygroup.DisplayName and $billingGroup.DisplayName have been created

### We are waiting a few seconds as groups sometimes take a while to be available for assigment
Write-Host "Waiting 15 secs for group initialization"
Start-Sleep 15
### RBAC ASSIGNMENT FOR THE Billing Role in the input file


$billingusers = $userlist | Where-Object {$_.role -like "Billing"}

$billingRole = $listroles |Where-Object {$_.Name -like "Billing Reader"}
$newbillingroleAssignment = New-AzureRmRoleAssignment -ObjectId $BillingGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $BillingRole.Id -Verbose
$billingusers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $BillingGroup.ObjectId -RefObjectId $_.ObjectId
                        }
## RBAC Assignment for the Security Admins in the input file

$securityusers = $userlist | Where-Object {$_.role -like "Security Admin"}

$SecurityRole = $listroles |Where-Object {$_.Name -like "Security Manager"}
$newsecurityroleAssignment = New-AzureRmRoleAssignment -ObjectId $SecurityGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $SecurityRole.Id -Verbose
$securityusers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $SecurityGroup.ObjectId -RefObjectId $_.ObjectId
                        }

##### RBAC Assignment for the Readers in the input file                        

$readerusers = $userlist | Where-Object {$_.role -like "Reader"}
$readerRole = $listroles |Where-Object {$_.Name -like "Reader"}
$newReaderRoleAssignment = New-AzureRmRoleAssignment -ObjectId $ReaderGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $ReaderRole.Id -Verbose
$ReaderUsers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $ReaderGroup.ObjectId -RefObjectId $_.ObjectId
                        }

##### RBAC Assignment for the Contributors in the input file                        

$ContributorUsers = $userlist | Where-Object {$_.role -like "Contributor"}
$ContributorRole = $listroles |Where-Object {$_.Name -like "Contributor"}
$newContributorRoleAssignment = New-AzureRmRoleAssignment -ObjectId $ContributorGroup.ObjectId -Scope ("/subscriptions/" + $sub.id) -RoleDefinitionId $ContributorRole.Id -Verbose
$ContributorUsers | ForEach-Object{
Add-AzureADGroupMember -ObjectId $ContributorGroup.ObjectId -RefObjectId $_.ObjectId
                        }

Write-Host "The Following Role Assignments are in effect on the subscription"
Get-AzureRmRoleAssignment |Format-Table DisplayName,ObjectType

