#$adminSiteUrl = "https://typetecmg-admin.sharepoint.com"

#Connect-SPOService $adminSiteUrl

#Get all Site colections with SharePoint PowerShell
#Get-SPOSite


# Connect to SharePoint Online (substitute your ClientId and Thumbprint using the values from the steps in the URL above)
#Connect-PnPOnline -Tenant contoso.onmicrosoft.com -ClientId 68b3527b-cf40-4284-acb2-854cafcdbac4 -Thumbprint 34CFAA860E5FB8C44335A38A097C1E41EEA206AA -Url https://contoso.sharepoint.com/SiteName

# Upload the CSV file
#Add-PnPFile -Path "C:\Users\aingelsten\data_list_cleaned.csv"

<#Config Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="C:\Users\aingelsten\data_list_cleaned.csv"
$DestinationPath = "Shared Documents" #Site Relative Path of the Library
  
#Get Credentials to connect
#$Cred = Get-Credential
  
#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -UseWebLogin  
#Connect-PnPOnline -Url $SiteURL -Credentials $Cred
      
#powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath


#Read more: https://www.sharepointdiary.com/2016/06/upload-files-to-sharepoint-online-using-powershell.html#ixzz7qlYIjtZk
#>
Write-Output "Exporting to SharePoint"

#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath ="c:\Users\aingelsten\scripts\formslist.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
  
  
#Connect to PnP Online using Weblogin
#Connect-PnPOnline -Url $SiteURL -UseWebLogin  

#Powershell pnp to upload file to sharepoint online
#Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

#Write-Output "Process Completed"

$ClientId = "51de05cf-9537-4408-ae22-49c55d98b064"
$ClientSecret ="TK5KpFk+UX1XI+F4zsEXv1rDFF045QTortyhXC/z17g="

#connection example.

#Site collection URL
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline/"
 
#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath -Folder $DestinationPath

Write-Output "Process Completed"


$csv = Import-CSV -Path c:\Users\aingelsten\scripts\All_Formslist.csv 
$IDs = $csv.ID | Select-Object -Unique
foreach ($ID in $IDs) {
    $newfile,$csv = $csv.where({$_.ID -eq $ID},'Split')
    $newfile | Export-CSV "c:\Users\aingelsten\scripts\$ID.csv"
}

$a = Import-Csv C:\Users\aingelsten\scripts\All_Formslist.csv 
$b = $a[0] | Get-Member | Where-Object { $_.membertype -eq 'noteproperty'} | Select-Object name
$b | ForEach-Object { $a | Format-Table -Property $_.name | out-file "$($_.name).txt"  }
Write-Output "Process Completed"
