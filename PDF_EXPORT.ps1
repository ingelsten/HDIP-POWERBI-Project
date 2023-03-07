

#gets API token from file
$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_AF_id.txt
$formid = "F1.1826236"
$bolean ="Y"
$size = "Large"

Write-Output "Connecting to API"

#calls the API
$FVApiForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

#Getting data by created date
$FVApiForms.GetFormPDF($apiToken, $formid, $bolean, $bolean, $bolean, $bolean, $bolean, $bolean, $size).ProjectFormsListResponse


$response = $FVApiForms.GetFormPDF($apiToken, $formid, $bolean, $bolean, $bolean, $bolean, $bolean, $bolean, $size).ProjectFormsListResponse

Write-Output $response

Write-Output "finished"
