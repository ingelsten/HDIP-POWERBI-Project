<#
Fieldview API 4 - Individual question answers
This API pulls individual answers,
loops through form id's and checks for question alias.
#>

$apiToken = Get-Content C:\Users\aingelsten\scripts\api_AF_id.txt

$FVForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

#Gets All ID's
$formIds = Get-Content "C:\Users\aingelsten\scripts\All_Formslist_ID.csv"
#$formIds = "F248159.193"

#Loops through every project id
foreach ($formId in $formIds)

{

Write-Output $formId

$questionAlias = "Completed By"

#Write-Output $formId

#Start-Sleep -Seconds 1

$formsQuestionAnswer = $FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias).FormAnswerInformation.childnodes

$formsQuestionAnswer | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

$formsQuestionAnswer | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Completed_By.csv -Append -NoTypeInformation

Write-Output $formsQuestionAnswer

$questionAlias1 = "Contract"

#Write-Output $formId

#Start-Sleep -Seconds 0.5

$formsQuestionAnswer1 = $FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias1).FormAnswerInformation.childnodes

$formsQuestionAnswer1 | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

$formsQuestionAnswer1 | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Contract.csv -Append -NoTypeInformation

Write-Output $formsQuestionAnswer1

$questionAlias2 = "Date"

#Write-Output $formId

#Start-Sleep -Seconds 0.5

$formsQuestionAnswer2 = $FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias2).FormAnswerInformation.childnodes

$formsQuestionAnswer2 | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

$formsQuestionAnswer2 | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Date.csv -Append -NoTypeInformation

Write-Output $formsQuestionAnswer2

$questionAlias3 = "Hour Calculation"

#Write-Output $formId

#Start-Sleep -Seconds 0.5

$formsQuestionAnswer3 = $FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias3).FormAnswerInformation.childnodes

$formsQuestionAnswer3 | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

$formsQuestionAnswer3 | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Hours.csv -Append -NoTypeInformation

Write-Output $formsQuestionAnswer3

}

$cleaned = Import-Csv C:\Users\aingelsten\scripts\Answer_Completed_By.csv| Sort-Object Form_ID –Unique

$cleaned1 = Import-Csv C:\Users\aingelsten\scripts\Answer_Contract.csv| Sort-Object Form_ID –Unique

$cleaned2 = Import-Csv C:\Users\aingelsten\scripts\Answer_Date.csv| Sort-Object Form_ID –Unique

$cleaned3 = Import-Csv C:\Users\aingelsten\scripts\Answer_Hours.csv| Sort-Object Form_ID –Unique

Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Completed_By.csv -NoTypeInformation

$cleaned1 | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Contract.csv -NoTypeInformation

$cleaned2 | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Date.csv -NoTypeInformation

$cleaned3 | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Hours.csv -NoTypeInformation

Write-Output "Exporting to SharePoint"

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\Users\aingelsten\scripts\Answer_Completed_By.csv"
$SourceFilePath1 ="c:\Users\aingelsten\scripts\Answer_Contract.csv"
$SourceFilePath2 ="c:\Users\aingelsten\scripts\Answer_Date.csv"
$SourceFilePath3 ="c:\Users\aingelsten\scripts\Answer_Hours.csv"
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
