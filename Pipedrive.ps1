
#Content of getDetailsOfDeal
 
#Pipedrive API token
#$api_token = '1b0a5852601c4b14bacd5800721f3fd97e884d35';
 
Import-Module PipedriveCmdlets;
$conn = Connect-Pipedrive -APIToken "1b0a5852601c4b14bacd5800721f3fd97e884d35" -AuthScheme "Basic" -CompanyDomain "mainlinegroup" 

#$results = Select-Pipedrive -Connection $conn -Table "Deals" -Columns @("Id, gwatson@mainline.ie") -Where "UserName='Bob'"

#Select-Pipedrive -Connection $conn -Table Deals -Where "UserName = 'Bob'" | Select -Property * -ExcludeProperty Connection,Table,Columns | Export-Csv -Path c:\myDealsData.csv -NoTypeInformation
