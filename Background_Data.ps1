<#
Fieldview API 0 - Lists of all organisational data.
When pull is completed the data is exported to Sharepoint Online
#>


$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_id.txt

Write-Output "Connecting to API"

$FVApiConfig = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_ConfigurationServices.asmx?WSDL"


Write-Output "Getting Organisation ID's"

$FVApiConfig.GetOrganisations($apiToken, $null, $null, $null, $null, 0, 100).OrganisationInformation.childnodes


$organisations = $FVApiConfig.GetOrganisations($apiToken, $null, $null, $null, 1, 0, 100).OrganisationInformation.childnodes

$organisations | Export-Csv -Path C:\Users\aingelsten\scripts\projectlist.csv -NoTypeInformation



Write-Output "Getting Project ID's"

$FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes


$projects = $FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes


$projects | Export-Csv -Path C:\Users\aingelsten\scripts\projectlist.csv -NoTypeInformation

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="C:\Users\aingelsten\scripts\projectlist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
  
  
#Connect to PnP Online using Weblogin
Connect-PnPOnline -Url $SiteURL -UseWebLogin  

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process Completed"