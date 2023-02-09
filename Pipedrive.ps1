
#Content of getDetailsOfDeal
 
#Pipedrive API token
#$api_token = '1b0a5852601c4b14bacd5800721f3fd97e884d35';
#Install-Module PipedriveCmdlets

#Import-Module PipedriveCmdlets;

#$conn = Connect-Pipedrive -APIToken "1b0a5852601c4b14bacd5800721f3fd97e884d35" -AuthScheme "Basic" -CompanyDomain "mainlinegroup" 

#$conn = Connect-Pipedrive -AuthScheme "Basic" -CompanyDomain "mainlinegroup" -APIToken "1b0a5852601c4b14bacd5800721f3fd97e884d35"

#$results = Select-Pipedrive -Connection $conn -Table "Deals" -Columns @("Id, gwatson@mainline.ie") -Where "UserName='Bob'"

#Select-Pipedrive -Connection $conn -Table Deals -Where "UserName = 'Bob'" | Select -Property * -ExcludeProperty Connection,Table,Columns | Export-Csv -Path c:\myDealsData.csv -NoTypeInformation

$PipeDriveAPI="1b0a5852601c4b14bacd5800721f3fd97e884d35"
$Pipedrive_domain="mainlinegroup"

#$Pipedrive_BaseURL="https://$Pipedrive_domain.pipedrive.com/v1/"

#$Url=$Pipedrive_BaseURL+"activities?start=0&api_token=$PipeDriveAPI"

Write-Output $Url

# related Blog Post https://www.techguy.at/control-pipedrive-crm-with-powershell-start-and-connect/

#$PipeDrive_APIKey="3e3c33c3a3d3333dcd333ab3c333333c33b33fc"
#$Pipedrive_domain="company"

$Pipedrive_BaseURL="https://$Pipedrive_domain.pipedrive.com/v1/"

$num = 0

# Get All Persons
#https://developers.pipedrive.com/docs/api/v1/#!/Persons/getPersons
#https://company.pipedrive.com/v1/persons?start=0&api_token=3e3c33c3a3d3333dcd333ab3c333333c33b33fc

# Get All Persons
#$Url=$Pipedrive_BaseURL+"persons?start=$num&api_token=$PipeDriveAPI"

# Get All Activities
#$Url=$Pipedrive_BaseURL+"activities?start=$num&api_token=$PipeDriveAPI"

# Get All Deals
$Url=$Pipedrive_BaseURL+"deals?start=$num&api_token=$PipeDriveAPI"

# Get All Deal Fields
#$Url=$Pipedrive_BaseURL+"dealFields?start=$num&api_token=$PipeDriveAPI"


$Result=Invoke-RestMethod -uri $URL -Method GET 

$Result.data

$Result.data | Export-Csv -Path C:\Users\aingelsten\scripts\deals_deal.csv -NoTypeInformation -Append

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\Users\aingelsten\scripts\deals_activities.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = "51de05cf-9537-4408-ae22-49c55d98b064"
$ClientSecret ="TK5KpFk+UX1XI+F4zsEXv1rDFF045QTortyhXC/z17g="

 
#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process Deals Pipeline completed"