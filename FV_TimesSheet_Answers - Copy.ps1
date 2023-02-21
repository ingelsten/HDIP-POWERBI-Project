<#
Fieldview API 4 - Individual question answers for the Fieldview Timesheet
This API pulls individual answers,
loops through form id's and checks for question alias.
#>

$answer = "FVTimeSheet_Completed_By.csv"
$answer1 = "FVTimeSheet_Contract.csv"
$answer2 = "FVTimeSheet_Date.csv"
$answer3 = "FVTimeSheet_Hours.csv"





$cleaned = Import-Csv C:\Users\aingelsten\scripts\$answer| Sort-Object FormID -Unique

$cleaned1 = Import-Csv C:\Users\aingelsten\scripts\$answer1 | Sort-Object FormID -Unique

$cleaned2 = Import-Csv C:\Users\aingelsten\scripts\$answer2 | Sort-Object FormID -Unique

$cleaned3 = Import-Csv C:\Users\aingelsten\scripts\$answer3 | Sort-Object FormID -Unique

#Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\$answer -NoTypeInformation

$cleaned1 | Export-Csv -Path C:\Users\aingelsten\scripts\$answer1 -NoTypeInformation

$cleaned2 | Export-Csv -Path C:\Users\aingelsten\scripts\$answer2 -NoTypeInformation

$cleaned3 | Export-Csv -Path C:\Users\aingelsten\scripts\$answer3 -NoTypeInformation

Write-Output "Exporting to SharePoint"

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\Users\aingelsten\scripts\$answer"
$SourceFilePath1 ="c:\Users\aingelsten\scripts\$answer1"
$SourceFilePath2 ="c:\Users\aingelsten\scripts\$answer2"
$SourceFilePath3 ="c:\Users\aingelsten\scripts\$answer3"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = "51de05cf-9537-4408-ae22-49c55d98b064"
$ClientSecret ="TK5KpFk+UX1XI+F4zsEXv1rDFF045QTortyhXC/z17g="

#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath
Add-PnPFile -Path $SourceFilePath1 -Folder $DestinationPath
Add-PnPFile -Path $SourceFilePath2 -Folder $DestinationPath
Add-PnPFile -Path $SourceFilePath3 -Folder $DestinationPath

Write-Output "Process Answers Completed"
