<#
Fieldview API 0 - Lists of all organisational data.
When pull is completed the data is exported to Sharepoint Online
#>

#gets API token from file
$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_id.txt

Write-Output "Connecting to API"

#calls the API
$FVApiConfig = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_ConfigurationServices.asmx?WSDL"


Write-Output "Getting Organisation ID's"

#Calls gets Organisations
$FVApiConfig.GetOrganisations($apiToken, $null, $null, $null, $null, 0, 100).OrganisationInformation.childnodes


$organisations = $FVApiConfig.GetOrganisations($apiToken, $null, $null, $null, 1, 0, 100).OrganisationInformation.childnodes

#Exports
$organisations | Export-Csv -Path C:\Users\aingelsten\scripts\projectlist.csv -NoTypeInformation



Write-Output "Getting Project ID's"
#Calls gets Projects
$FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes


$projects = $FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes

#Exports projects
$projects | Export-Csv -Path C:\Users\aingelsten\scripts\projectlist.csv -NoTypeInformation

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="C:\Users\aingelsten\scripts\projectlist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = "51de05cf-9537-4408-ae22-49c55d98b064"
$ClientSecret ="TK5KpFk+UX1XI+F4zsEXv1rDFF045QTortyhXC/z17g="


#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process BD Completed"