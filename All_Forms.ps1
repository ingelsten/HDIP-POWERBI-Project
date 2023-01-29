<#
Fieldview API 1 - Lst of all froms up to 3months old.
This API pulls all project id's and pull all forms up to 3 months old by modified data
When pull is completed the data is exported to Sharepoint Online
#>

$StartDate =Get-Date "2021-06-01 00:00:00"

$EndDate = Get-Date

Write-Output $EndDate

$monthdiff = $EndDate.month - $StartDate.month + (($EndDate.Year - $StartDate.year) * 12)

Write-Output $monthdiff

$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_AF_id.txt

Write-Output "Connecting to API"


$FVApiForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"


Write-Output "Getting Dates"

for ($num = 0 ; $num -le $monthdiff ; $num++){

Write-Output = *****DATE LOOP****

Write-Output $num

Write-Output = *****REPORT END DATE****

$reportEnd = (Get-Date).AddMonths(-$num)

Write-Output $reportEnd

$datefrom = Get-Date -Date $reportEnd.AddMonths(-1-$num) -Format "yyyy-MM-ddTHH:mm:ss"

Write-Output = *****REPORT START DATE****

Write-Output $datefrom

$dateTo= $reportEnd

$projectids = Get-Content C:\Users\aingelsten\scripts\projectid.txt

Write-Output "Starting loop"

foreach ($projectid in $projectids)

{

Write-Output $projectid 

$FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes

$formsList = $FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes


if ($formsList -eq $null)

{
Write-Output "*****NOTHING FOUND****"
}

else
{
Write-Output  "Adding Projectid"

$formsList | Add-Member -MemberType NoteProperty -Name "ProjectId" -Value $projectid

Write-Output  "Writing to file"

$formsList | Export-Csv -Path c:\Users\aingelsten\scripts\All_Formslist.csv -append -NoTypeInformation

Write-Output  "Data written to file"
}

Start-Sleep -Seconds 6
}

Start-Sleep -Seconds 0.5

Write-Output "Removing duplicates"

$cleaned = Import-Csv C:\Users\aingelsten\scripts\All_Formslist.csv| sort FormID –Unique

Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\All_Formslist.csv -NoTypeInformation
}

Write-Output "Exporting to SharePoint"

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\Users\aingelsten\scripts\All_Formslist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
  
  
#Connect to PnP Online using Weblogin
Connect-PnPOnline -Url $SiteURL -UseWebLogin  

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process Completed"