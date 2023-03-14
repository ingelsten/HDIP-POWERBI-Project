<#
Fieldview API 2 - List of all Forms. Update
This API loops through all dates pulls all project id's and pull all forms
When pull is completed the data is exported to Sharepoint Online
#>


<#
This API only pulls data 3months back in time, 
start time of the first projects was in the Summer of 2021
#>
$StartDate = Get-Date '2021-06-01 00:00'

$EndDate = Get-Date

Write-Output $EndDate

#calculate time difference in months
$monthdiff = $EndDate.month - $StartDate.month + (($EndDate.Year - $StartDate.year) * 12)

Write-Output $monthdiff

#gets API token from file
$ApiToken = Get-Content C:\scripts\api_AF_id.txt

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

$projectids = Get-Content C:\scripts\projectid.txt

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
$formsList | Export-Csv -Path c:\scripts\All_Formslist.csv -append –NoTypeInformation

Write-Output  "Data written to file"
}

#Time delay to avoid API call quota
Start-Sleep -Seconds 2
}

Start-Sleep -Seconds 2

Write-Output "Removing duplicates"

#Removal of duplications by import and sort
$cleaned = Import-Csv C:\scripts\All_Formslist.csv| Sort-Object FormID –Unique

Start-Sleep -Seconds 2

$cleaned | Export-Csv -Path C:\scripts\All_Formslist.csv –NoTypeInformation
}

Write-Output "Export seperate file of Form ID's only"


#import, split and export only coins timesheet and it's Id's sorted by ID.
$path = "C:\scripts"

Import-Csv -Path $path\All_Formslist.csv | Where-Object {$_.FormName -eq "Coins TimeSheet" -and $_.Complete -eq "TRUE" } | Sort-Object LastModifiedOnServer -Descending | Export-Csv C:\scripts\All_Coins_Timesheet.csv –NoTypeInformation

Import-Csv C:\scripts\All_Coins_Timesheet.csv  | Select-Object FormID | Export-Csv -Path C:\scripts\All_Coins_Timesheet_ID.csv –NoTypeInformation

Get-Content C:\scripts\All_Coins_Timesheet_ID.csv -Encoding UTF8 | ForEach-Object {$_ -replace '"',''} | Out-File C:\scripts\All_Coins_Timesheet_ID.txt -Encoding UTF8

#import, split and export.
$AllFormlist = "C:\scripts\All_Formslist.csv"
Get-Content $AllFormlist | ForEach-Object{$_.Split(",")[1]} | set-content "C:\scripts\All_Formslist_ID.csv"
Write-Output "Process Completed"

Write-Output "Exporting to SharePoint"

#Export to Sharepoint
#Gets SITE URL from config file
Get-Content "C:\scripts\config.conf" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }


#Configuration of Sharepoint Variables
$SourceFilePath ="c:\scripts\All_Formslist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = Get-Content "C:\scripts\ClientID.txt"
$ClientSecret = Get-Content "C:\scripts\ClientSecret.txt"

#Site collection URL
$SiteURL = $h.Get_Item("SiteURL")
 
#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process Completed"