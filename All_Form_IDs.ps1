<#
Fieldview API 3 - List of all Form IDs
This API loops through all dates pulls all project id's and pull all forms id's
When pull is completed the data is exported to Sharepoint Online
#>


<#
This API only pulls data 3months back in time, 
start time of the first projects was in the Summer of 2021
#>


$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_AF2_id.txt

Write-Output "Connecting to API"

$FVApiConfig = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_ConfigurationServices.asmx?WSDL"


$FVApiForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

Write-Output "Getting Project ID's"

$id | Out-File c:\Users\aingelsten\scripts\projectid.txt

Write-Output "Getting Dates"

$reportEnd = (Get-Date).AddHours(1)

Write-Output $reportEnd

$datefrom = Get-Date -Date $reportEnd.AddMonths(-2) -Format "yyyy-MM-ddTHH:mm:ss"

Write-Output "Date From"
Write-Output $datefrom

$dateTo= $reportEnd

Write-Output "Date To"
Write-Output $dateTo

$projectids = "21206"


Write-Output "Starting loop"

foreach ($projectid in $projectids)

{

Write-Output $projectid 

$FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes.FormID

$formsListID = $FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes.FormID


if ($null -eq $formsListID)

{
Write-Output "*****NOTHING FOUND****"
}

else
{
#Write-Output  "Adding Projectid"
#
#$formsList | Add-Member -MemberType NoteProperty -Name "ProjectId" -Value $projectid

Write-Output  "Writing to file"

Write-Output $formsListID

$str_list = @($formsListID)
$obj_list = $str_list | Select-Object @{Name='Form_ID';Expression={$_}}
$obj_list | Export-Csv -Path c:\Users\aingelsten\scripts\formslist_ID.txt -append -NoType

#fix https://stackoverflow.com/questions/19450616/export-csv-exports-length-but-not-name

Write-Output  "Data written to file"

}

Start-Sleep -Seconds 6

}

Start-Sleep -Seconds 0.5

Write-Output "Removing duplicates"

$cleaned = Import-Csv C:\Users\aingelsten\scripts\formslist_ID.csv| Sort-Object Form_ID –Unique

Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\formslist_ID.csv -NoTypeInformation

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

Write-Output "Process Answer Completed"
