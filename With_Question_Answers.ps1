#Add text

$apiToken = Get-Content C:\Users\aingelsten\scripts\api_id.txt

$FVForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

$formIds = Get-Content C:\Users\aingelsten\scripts\formid.csv

foreach ($formId in $formIds)

{

$questionAlias = "Job Comment"

Write-Output $formId

Start-Sleep -Seconds 1

$formsQuestionAnswer = $FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias).FormAnswerInformation.childnodes

$formsQuestionAnswer | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

$formsQuestionAnswer | Export-Csv -Path C:\Users\aingelsten\scripts\Answer_Formslist.csv -Append -NoTypeInformation

Write-Output $formsQuestionAnswer

}
