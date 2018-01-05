### Sample script to create cloud users and assign them a role

### Mandatory Parameters to ask for at script execution
Param(
    [Parameter(Mandatory=$true)][string]$InputFile,
    [Parameter(Mandatory=$true)][string]$KeyVaultName
     ) 

# Setting up environment for random pw generation
$PasswordLength = 12
$NonAlphCh = 4 
Add-Type -AssemblyName System.Web
Get-AzureRmKeyVault -VaultName $KeyVaultName
#Importing CSV file and starting iteration through accounts
Import-Csv $InputFile |ForEach-Object{


$postalcode = "K1P5B4"
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = ([System.Web.Security.Membership]::GeneratePassword($PasswordLength,$NonAlphCh))
$mailnnickname = $_.givenname + $_.surname
$displayname = $_.givenname + " " + $_.surname
$upn = $_.givenname + "." + $_.surname + "@mlaniel11outlook.onmicrosoft.com"
$usertype = "Member"
$newuser = New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $true -DisplayName $displayname -Department $_.department -GivenName $_.givenname -Surname $_surname -UserPrincipalName $upn -MailNickName $mailnnickname -PostalCode $postalcode -Verbose
## Determining the user group and adding them to the right group
# To be added later
##############################
# This section below will safely store the user password in a key vault in a subscription.
# For this to work, you will need to specify the name of a key vault in your sub that you can access at script launch
# If you do not have a key vault or do not wish to use it, you can safely delete the three lines below.
########################
$secretname = $mailnnickname + "PW"
$secretvalue = ConvertTo-SecureString $PasswordProfile.Password -AsPlainText -Force
$secret = Set-AzureKeyVaultSecret -VaultName $keyvault.VaultName -Name $secretname  -SecretValue $secretvalue -ContentType "Initial Password"


}

