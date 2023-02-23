﻿<#
Fieldview API 4 - Individual question answers for the Fieldview Timesheet
This API pulls individual answers,
loops through form id's and checks for question alias.
#>

$apiToken = Get-Content C:\Users\aingelsten\scripts\api_AF_id.txt

$FVForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

$answer = "FVTimeSheet_Completed_By.csv"
$answer1 = "FVTimeSheet_Contract.csv"
$answer2 = "FVTimeSheet_Date.csv"
$answer3 = "FVTimeSheet_Hours.csv"
$questionAlias = "TS_Completed_By"
$questionAlias1 = "TS_Contract"
$questionAlias2 = "TS_Date_Timesheet"
$questionAlias3 = "TS_Hour_Calculation"

#Gets All ID's
$formIds = Get-Content "C:\Users\aingelsten\scripts\All_Coins_Timesheet_ID.csv"
#$formIds = Get-Content "C:\Users\aingelsten\scripts\All_Formslist_ID.csv"
#$formIds = "F248159.193"

#Loops through every project id
foreach ($FormID in $formIds)

{

Write-Output $FormID

#Write-Output $formId

#Start-Sleep -Seconds 1

$formsQuestionAnswer = $FVForms.GetQuestionAnswer($apiToken, $FormID, $questionAlias).FormAnswerInformation.childnodes

$formsQuestionAnswer | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $FormID

$formsQuestionAnswer | Export-Csv -Path C:\Users\aingelsten\scripts\$answer -Append -NoTypeInformation

Write-Output $formsQuestionAnswer

#Write-Output $formId

#Start-Sleep -Seconds 0.5

$formsQuestionAnswer1 = $FVForms.GetQuestionAnswer($apiToken, $FormID, $questionAlias1).FormAnswerInformation.childnodes

$formsQuestionAnswer1 | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $FormID

$formsQuestionAnswer1 | Export-Csv -Path C:\Users\aingelsten\scripts\$answer1 -Append -NoTypeInformation

Write-Output $formsQuestionAnswer1


#Write-Output $formId

#Start-Sleep -Seconds 0.5

$formsQuestionAnswer2 = $FVForms.GetQuestionAnswer($apiToken, $FormID, $questionAlias2).FormAnswerInformation.childnodes

$formsQuestionAnswer2 | Add-Member -MemberType NoteProperty -Name "Formid" -Value $FormID

$formsQuestionAnswer2 | Export-Csv -Path C:\Users\aingelsten\scripts\$answer2 -Append -NoTypeInformation

Write-Output $formsQuestionAnswer2

#Write-Output $formId

#Start-Sleep -Seconds 0.5

$formsQuestionAnswer3 = $FVForms.GetQuestionAnswer($apiToken, $FormID, $questionAlias3).FormAnswerInformation.childnodes

$formsQuestionAnswer3 | Add-Member -MemberType NoteProperty -Name "FormID" -Value $FormID

$formsQuestionAnswer3 | Export-Csv -Path C:\Users\aingelsten\scripts\$answer3 -Append -NoTypeInformation

Write-Output $formsQuestionAnswer3

}

$cleaned = Import-Csv C:\Users\aingelsten\scripts\$answer| Sort-Object FormID –Unique

$cleaned1 = Import-Csv C:\Users\aingelsten\scripts\$answer1 | Sort-Object FormID –Unique

$cleaned2 = Import-Csv C:\Users\aingelsten\scripts\$answer2 | Sort-Object FormID –Unique

$cleaned3 = Import-Csv C:\Users\aingelsten\scripts\$answer3 | Sort-Object FormID –Unique

Start-Sleep -Seconds 0.5

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