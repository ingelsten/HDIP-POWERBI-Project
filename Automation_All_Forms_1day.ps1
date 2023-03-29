<#
Fieldview API 1 - List of all froms up to 1 day.
This API pulls all project id's and pull all forms up to 1 day old by modified data
When pull is completed the data is exported to Sharepoint Online
#>

#Configuration -  API token
$ApiToken = Get-Content C:\scripts\api_AF2_id.txt

Write-Output "Connecting to API"

$FVApiConfig = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_ConfigurationServices.asmx?WSDL"

$FVApiForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

Write-Output "Getting Project ID's"

#Delete ofcurrent list to be replaced
Remove-Item c:\scripts\formslist_current.csv

#Gets Project ID
$FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id

$id = $FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id

#Export of Project ID
$id | Sort-Object | Out-File c:\scripts\projectid.txt


Write-Output "Getting Dates"

$reportEnd = (Get-Date).AddHours(1) 

Write-Output $reportEnd

#Getting dates
$datefrom = Get-Date -Date $reportEnd.AddDays(-1) -Format "yyyy-MM-ddTHH:mm:ss"

$dateTo= $reportEnd

$projectids = Get-Content C:\scripts\projectid.txt

Write-Output "Starting loop"

Write-Output $datefrom
Write-Output $dateTo

#Looping through each project for forms
foreach ($projectid in $projectids)

{

Write-Output $projectid 

$FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes

$formsList = $FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes

#If statement for if data is null or not
if ($null -eq $formsList)

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
$formsList | Export-Csv -Path c:\scripts\formslist.csv -append -NoTypeInformation

#Exporting only last data, creating new and apending data

$formsList | Export-Csv -Path c:\scripts\formslist_current.csv -append  -NoTypeInformation

Write-Output  "Data written to file"
}
#Time delay to avoid API call quota
Start-Sleep -Seconds 6

}

Start-Sleep -Seconds 0.5

Write-Output "Removing duplicates"

#Removal of duplications by import and sort
$cleaned = Import-Csv C:\scripts\formslist.csv| Sort-Object FormID -Unique

Start-Sleep -Seconds 0.5

$cleaned | Sort-Object |  Export-Csv -Path C:\scripts\formslist.csv -NoTypeInformation

Write-Output "Exporting to SharePoint"

# gets SITE URL from config file
Get-Content "C:\scripts\config.conf" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

#Configuration of Sharepoint Variables
$SiteURL = $h.Get_Item("SiteURL")
$SourceFilePath ="c:\scripts\formslist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = Get-Content "C:\scripts\ClientID.txt"
$ClientSecret = Get-Content "C:\scripts\ClientSecret.txt"




#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process AF 2 Completed"