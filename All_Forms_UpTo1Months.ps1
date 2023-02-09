<#
Fieldview API 1 - Lst of all froms up to 3months old.
This API pulls all project id's and pull all forms up to 3 months old by modified data
When pull is completed the data is exported to Sharepoint Online
#>

#Configuration -  API token
$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_AF2_id.txt

Write-Output "Connecting to API"

$FVApiConfig = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_ConfigurationServices.asmx?WSDL"

$FVApiForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

Write-Output "Getting Project ID's"

#Gets Project ID
$FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id


$id = $FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id

#Export of Project ID
$id | Out-File c:\Users\aingelsten\scripts\projectid.txt

Write-Output "Getting Dates"

$reportEnd = (Get-Date).AddHours(1)

Write-Output $reportEnd

#Getting dates
$datefrom = Get-Date -Date $reportEnd.AddDays(-30) -Format "yyyy-MM-ddTHH:mm:ss"

$dateTo= $reportEnd

$projectids = Get-Content C:\Users\aingelsten\scripts\projectid.txt

Write-Output "Starting loop"

#Looping through each project for forms
foreach ($projectid in $projectids)

{

Write-Output $projectid 

$FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes

$formsList = $FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes

#If statement for if data is null or not
if ($formsList -eq $null)

{
Write-Output "*****NOTHING FOUND****"
}

else
{
Write-Output  "Adding Projectid"

#Adds Projet id to list
$formsList | Add-Member -MemberType NoteProperty -Name "ProjectId" -Value $projectid

Write-Output  "Writing to file"

#Export to file
$formsList | Export-Csv -Path c:\Users\aingelsten\scripts\formslist.csv -append -NoTypeInformation

Write-Output  "Data written to file"
}
#Time delay to avoid API call quota
Start-Sleep -Seconds 6

}

Start-Sleep -Seconds 0.5

Write-Output "Removing duplicates"

#Removal of duplications by import and sort
$cleaned = Import-Csv C:\Users\aingelsten\scripts\formslist.csv| Sort-Object FormID -Unique

Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\formslist.csv -NoTypeInformation

Write-Output "Exporting to SharePoint"

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\Users\aingelsten\scripts\formslist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = "51de05cf-9537-4408-ae22-49c55d98b064"
$ClientSecret ="TK5KpFk+UX1XI+F4zsEXv1rDFF045QTortyhXC/z17g="

 
#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process AF 2 Completed"