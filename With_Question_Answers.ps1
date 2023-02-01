<#
Fieldview API 4 - Individual question answers
This API pulls individual answers,
loops through form id's and checks for question alias.
#>

$apiToken = Get-Content C:\Users\aingelsten\scripts\api_AF_id.txt

$FVForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

#Gets All ID's
$formIds = Get-Content C:\Users\aingelsten\scripts\formslist_ID.csv

#Loops through every project id
foreach ($formId in $formIds)

{

$questionAlias = "Location of Job"

Write-Output $formId

Start-Sleep -Seconds 0.5

$formsQuestionAnswer = $FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias).FormAnswerInformation.childnodes

$formsQuestionAnswer | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

$formsQuestionAnswer | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Formslist.csv -Append -NoTypeInformation

Write-Output $formsQuestionAnswer

}

$cleaned = Import-Csv C:\Users\aingelsten\scripts\Answer_Formslist.csv| Sort-Object Form_ID –Unique

Start-Sleep -Seconds 0.5

$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Formslist.csv -NoTypeInformation

Write-Output "Exporting to SharePoint"

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\Users\aingelsten\scripts\Answer_Formslist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = "51de05cf-9537-4408-ae22-49c55d98b064"
$ClientSecret ="TK5KpFk+UX1XI+F4zsEXv1rDFF045QTortyhXC/z17g="

#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process Answers Completed"
