<#
Fieldview API 6 - GET FORMS INFO
#>

$apiToken = Get-Content C:\Users\aingelsten\scripts\api_AF_id.txt

$FVForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

#Gets All ID's
$formId = F248159.193

#Loops through every project id
#foreach ($formId in $formIds)

#{

Write-Output $formId

Start-Sleep -Seconds 0.5

$form = $FVForms.GetForm($apiToken, $formId).FormInformation.childnodes

Write-Output $form

$form | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

$form | Export-Csv -Path C:\Users\aingelsten\scripts\Individual_form_raw.csv -NoTypeInformation

Import-Csv C:\Users\aingelsten\scripts\Individual_form_raw.csv | Select-Object Form_Id,Question,Answer | Export-Csv -Path C:\Users\aingelsten\scripts\Individual_form_col.csv  -NoTypeInformation



<#

}

$formTemplateLinkId = 

#Loops through every project id
foreach ($formId in $formIds)

{

Write-Output $formId

Start-Sleep -Seconds 0.5

Write-Output "Got here first"

$table = $FVForms.GetTableGroup($apiToken, $formId, $formTemplateLinkId).FormTableGroupResponse.childnodes

Write-Output $table

Write-Output "Got here"
#>

#$table | Add-Member -MemberType NoteProperty -Name "Form_Id" -Value $formId

#$table | Export-Csv -Path C:\Users\aingelsten\scripts\Table_Sample.csv -Append -NoTypeInformation





#$cleaned = Import-Csv C:\Users\aingelsten\scripts\Forms.csv| Sort-Object Form_ID –Unique

#Start-Sleep -Seconds 0.5

#$cleaned | Export-Csv -Path C:\Users\aingelsten\scripts\Forms.csv -NoTypeInformation


