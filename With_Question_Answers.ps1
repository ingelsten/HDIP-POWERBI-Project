#Add text

$apiToken = Get-Content C:\Users\aingelsten\api_id.txt


$FVConfig = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_ConfigurationServices.asmx?WSDL"


$FVForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"


$FVConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes

$FVConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id


$id = $FVConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id


$id | Out-File c:\Users\aingelsten\projectid.txt



$FVConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.name


$projectId = 20698


$reportEnd = Get-Date

$datefrom = Get-Date -Date $reportEnd.AddMonths(-3) -Format "yyyy-MM-ddTHH:mm:ss"

$dateTo= Get-Date -Date $reportEnd -Format "yyyy-MM-ddTHH:mm:ss"


$formId = "F215921.41"
 
$questionAlias ="Hour Calculation"


$FVForms.GetForm($apiToken, $formId).FormInformation.childnodes.id


$formsList = $FVForms.GetProjectFormsList($apiToken, $projectId, $null, 0, $null, $null, $null, $null, $datefrom, $dateTo, $null, $null).ProjectFormsListInformation.childnodes


$formsDetails = $FVForms.GetForm($apiToken, $formId).FormInformation.childnodes


$formsQuestionAnswer = $FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias).FormAnswerInformation.childnodes


$formsTemplates = $FVForms.GetProjectFormTemplates($apiToken, $projectId, 1, 1).FormAnswerInformation.childnodes



$formsList | Add-Member -MemberType NoteProperty -Name "ProjectID" -Value $projectId


$formsList | Export-Csv -Path ./data_list_example.csv -NoTypeInformation


$formsDetails | Export-Csv -Path ./data_form_example.csv -NoTypeInformation


$formsQuestionAnswer | Export-Csv -Path ./data_question_example.csv -NoTypeInformation


$FVForms.GetQuestionAnswer($apiToken, $formId, $questionAlias).FormAnswerInformation.childnodes

$FVForms.GetProjectFormTemplates($apiToken, $projectId, 1, 1).ProjectFormTemplateInformation.childnodes



$projectids = Get-Content C:\Users\aingelsten\projectid.txt


foreach ($projectId2 in $projectids)
{

$formsList2 = $FVForms.GetProjectFormsList($apiToken, $projectId2, $null, 0, $null, $null, $null, $null, $datefrom, $dateTo, $null, $null).ProjectFormsListInformation.childnodes


$formsList2 | Export-Csv -Path C:\Users\aingelsten\data_list_temp.csv -Append -NoTypeInformation

}


$cleaned = Import-Csv C:\Users\aingelsten\data_list_temp.csv| sort FormID –Unique

$cleaned | Export-Csv -Path C:\Users\aingelsten\data_list_cleaned.csv -NoTypeInformation



$FVForms.GetForm($apiToken, $formId).FormInformation.childnodes

$answer = $FVForms.GetForm($apiToken, $formId).FormInformation.childnodes

$answer | Format-Xml | Out-File C:\Users\aingelsten\test.xml
 
 


