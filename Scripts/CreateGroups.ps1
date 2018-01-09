#Param(
#    [Parameter(Mandatory=$true)][string]$InputFile
#    ) 
##TEMP BELOW
$InputFile = "C:\Users\malaniel\GitRepos\AzureAccel\Scripts\UserList.csv"

$users = Import-Csv $InputFile

$filter = @("role", "role2", "role3")
    $users |where-object $_.role -contains "Contributor"

