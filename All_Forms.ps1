<#
Fieldview API 2 - List of all Forms
This API loops through all dates pulls all project id's and pull all forms
When pull is completed the data is exported to Sharepoint Online
#>


<#
This API only pulls data 3months back in time, 
start time of the first projects was in the Summer of 2021
#>
$StartDate =Get-Date "2021-06-01 00:00:00"

$EndDate = Get-Date

Write-Output $EndDate

#calculate time difference in months
$monthdiff = $EndDate.month - $StartDate.month + (($EndDate.Year - $StartDate.year) * 12)

Write-Output $monthdiff

#gets API token from file
$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_AF_id.txt

Write-Output "Connecting to API"

#calls the API
$FVApiForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"


Write-Output "Getting Dates"

#Loops through dates
for ($num = 0 ; $num -le $monthdiff ; $num++){

Write-Output = *****DATE LOOP****

Write-Output $num

Write-Output = *****REPORT END DATE****

$reportEnd = (Get-Date).AddMonths(-$num)

Write-Output $reportEnd

#Applies dates to loop
$datefrom = Get-Date -Date $reportEnd.AddMonths(-1-$num) -Format "yyyy-MM-ddTHH:mm:ss"

Write-Output = *****REPORT START DATE****

Write-Output $datefrom

$dateTo= $reportEnd

$projectids = Get-Content C:\Users\aingelsten\scripts\projectid.txt

Write-Output "Starting loop"

#Loops through every project id
foreach ($projectid in $projectids)

{

Write-Output $projectid 

#Getting data by created date
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

#Adds the project id to Form as an identifier
$formsList | Add-Member -MemberType NoteProperty -Name "ProjectId" -Value $projectid

Write-Output  "Writing to file"

#Write result to file
$formsList | Export-Csv -Path c:\Users\aingelsten\scripts\All_Formslist.csv -append -NoTypeInformation

Write-Output  "Data written to file"
}

#Time delay to avoid API call quota
Start-Sleep -Seconds 6
}

Start-Sleep -Seconds 0.5

Write-Output "Removing duplicates"

#Removal of duplications by import and sort
$cleaned = Import-Csv C:\Users\aingelsten\scripts\All_Formslist.csv| Sort-Object FormID –Unique

Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\All_Formslist.csv -NoTypeInformation
}

Write-Output "Export seperate file of Form ID's only"


#import, split and export only coins timesheet and it's Id's sorted by ID.
Import-Csv -Path C:\Users\aingelsten\scripts\All_Formslist.csv | Where-Object {$_.FormName -eq "Coins TimeSheet" -and $_.Complete -eq "TRUE" } | Sort-Object LastModifiedOnServer -Descending | Export-Csv C:\Users\aingelsten\scripts\All_Coins_Timesheet.csv -notypeinfo

Import-Csv C:\Users\aingelsten\scripts\All_Coins_Timesheet.csv | Select-Object FormID | Export-Csv -Path C:\Users\aingelsten\scripts\All_Coins_Timesheet_ID.txt –NoTypeInformation


#import, split and export.
$AllFormlist = "C:\Users\aingelsten\scripts\All_Formslist.csv"
Get-Content $AllFormlist | ForEach-Object{$_.Split(",")[1]} | set-content "C:\Users\aingelsten\scripts\All_Formslist_ID.csv"
Write-Output "Process Completed"

Write-Output "Exporting to SharePoint"

#EXport to Sharepoint
#Configuration of Sharepoint Variables
$SourceFilePath ="c:\Users\aingelsten\scripts\All_Formslist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = "51de05cf-9537-4408-ae22-49c55d98b064"
$ClientSecret ="TK5KpFk+UX1XI+F4zsEXv1rDFF045QTortyhXC/z17g="

#Site collection URL
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline/"
 
#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process Completed"
