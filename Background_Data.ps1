<#
Fieldview API 0 - Lists of all organisational data.
When pull is completed the data is exported to Sharepoint Online
#>

#gets API token from config file
Get-Content "C:\Users\aingelsten\OneDrive - Mainline Group\HDIP POWERBI Project\config.conf" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

$apiToken = $h.Get_Item("APIKEY")
$SiteURL = $h.Get_Item("SiteURL")

#$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_id.txt

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
$ClientId = Get-Content "C:\Users\aingelsten\scripts\ClientID.txt"
$ClientSecret = Get-Content "C:\Users\aingelsten\scripts\ClientSecret.txt"


#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process BD Completed"