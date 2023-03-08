<#
Fieldview API 4 - Individual question answers for the Fieldview Timesheet
This API pulls individual answers,
loops through form id's and checks for question alias.
#>
<#gets API token from config file
Get-Content "C:\OneDrive - Mainline Group\HDIP POWERBI Project\config.conf" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

$apiToken1 = $h.Get_Item("Answer1")
$apiToken2 = $h.Get_Item("Answer2")
$apiToken3 = $h.Get_Item("Answer3")
$apiToken4 = $h.Get_Item("Answer4")
#>

$apiToken1 = Get-Content C:\scripts\api_answer1.txt
$apiToken2 = Get-Content C:\scripts\api_answer2.txt
$apiToken3 = Get-Content C:\scripts\api_answer3.txt
$apiToken4 = Get-Content C:\scripts\api_answer4.txt

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

$formIds = Get-Content "C:\scripts\All_Coins_Timesheet_ID.txt"
#$formIds = Get-Content - "C:\scripts\All_Coins_Timesheet_ID.csv"
#$formIds = Get-Content "C:\scripts\All_Formslist_ID.csv"
#$formIds = "F207743.169"
#$formIds.$FormID
#Write-Output $FormID

#Loops through every project id
foreach ($FormID in $formIds)

{

Write-Output $FormID

#Write-Output $formId

#Start-Sleep -Seconds 1

$formsQuestionAnswer = $FVForms.GetQuestionAnswer($apiToken1, $FormID, $questionAlias).FormAnswerInformation.childnodes

$formsQuestionAnswer | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $FormID

$formsQuestionAnswer | Export-Csv -Path C:\scripts\$answer -Append -NoTypeInformation

Write-Output $formsQuestionAnswer

#Write-Output $formId

#Start-Sleep -Seconds 1

$formsQuestionAnswer1 = $FVForms.GetQuestionAnswer($apiToken2, $FormID, $questionAlias1).FormAnswerInformation.childnodes

$formsQuestionAnswer1 | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $FormID

$formsQuestionAnswer1 | Export-Csv -Path C:\scripts\$answer1 -Append -NoTypeInformation

Write-Output $formsQuestionAnswer1


#Write-Output $formId

#Start-Sleep -Seconds 1

$formsQuestionAnswer2 = $FVForms.GetQuestionAnswer($apiToken3, $FormID, $questionAlias2).FormAnswerInformation.childnodes

$formsQuestionAnswer2 | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $FormID

$formsQuestionAnswer2 | Export-Csv -Path C:\scripts\$answer2 -Append -NoTypeInformation

Write-Output $formsQuestionAnswer2

#Write-Output $formId

#Start-Sleep -Seconds 1

$formsQuestionAnswer3 = $FVForms.GetQuestionAnswer($apiToken4, $FormID, $questionAlias3).FormAnswerInformation.childnodes

$formsQuestionAnswer3 | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $FormID

$formsQuestionAnswer3 | Export-Csv -Path C:\scripts\$answer3 -Append -NoTypeInformation

Write-Output $formsQuestionAnswer3

}

$answer = "FVTimeSheet_Completed_By.csv"
$answer1 = "FVTimeSheet_Contract.csv"
$answer2 = "FVTimeSheet_Date.csv"
$answer3 = "FVTimeSheet_Hours.csv"

$cleaned = Import-Csv C:\scripts\$answer| Sort-Object Form_Id -Unique

$cleaned1 = Import-Csv C:\scripts\$answer1 | Sort-Object Form_Id -Unique

$cleaned2 = Import-Csv C:\scripts\$answer2 | Sort-Object Form_Id -Unique

$cleaned3 = Import-Csv C:\scripts\$answer3 | Sort-Object Form_Id -Unique

#Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\scripts\$answer -NoTypeInformation

$cleaned1 | Export-Csv -Path C:\scripts\$answer1 -NoTypeInformation

$cleaned2 | Export-Csv -Path C:\scripts\$answer2 -NoTypeInformation

$cleaned3 | Export-Csv -Path C:\scripts\$answer3 -NoTypeInformation

Write-Output "Exporting to SharePoint"

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\scripts\$answer"
$SourceFilePath1 ="c:\scripts\$answer1"
$SourceFilePath2 ="c:\scripts\$answer2"
$SourceFilePath3 ="c:\scripts\$answer3"
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
