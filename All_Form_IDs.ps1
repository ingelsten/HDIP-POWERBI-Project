<#
Fieldview API 1 - Lst of all froms up to 3months old.
This API pulls all project id's and pull all forms up to 3 months old by modified data
When pull is completed the data is exported to Sharepoint Online
#>


$ApiToken = Get-Content C:\Users\aingelsten\scripts\api_AF2_id.txt

Write-Output "Connecting to API"

$FVApiConfig = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_ConfigurationServices.asmx?WSDL"


$FVApiForms = New-WebServiceProxy -Uri "https://www.priority1.uk.net/FieldViewWebServices/WebServices/XML/API_FormsServices.asmx?WSDL"

Write-Output "Getting Project ID's"

$FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id


$id = $FVApiConfig.GetProjects($apiToken, $null, $null, 1, 0, 100).ProjectInformation.childnodes.id


$id | Out-File c:\Users\aingelsten\scripts\projectid.txt

Write-Output "Getting Dates"

$reportEnd = (Get-Date).AddHours(1)

Write-Output $reportEnd

$datefrom = Get-Date -Date $reportEnd.AddMonths(-2) -Format "yyyy-MM-ddTHH:mm:ss"

$dateTo= $reportEnd

$projectids = Get-Content C:\Users\aingelsten\scripts\projectid.txt

Write-Output "Starting loop"

foreach ($projectid in $projectids)

{

Write-Output $projectid 

$FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes

$formsListID = $FVApiForms.GetProjectFormsList($apiToken, $projectid, $null, 0, $datefrom, $dateTo, $null, $null, $null, $null, $null, $null).ProjectFormsListInformation.childnodes.FormID


if ($formsListID -eq $null)

{
Write-Output "*****NOTHING FOUND****"
}

else
{
#Write-Output  "Adding Projectid"
#
#$formsList | Add-Member -MemberType NoteProperty -Name "ProjectId" -Value $projectid

#Write-Output  "Writing to file"

Write-Output $formsListID

#Write-Output  "Data written to file"
}

Start-Sleep -Seconds 10

}
