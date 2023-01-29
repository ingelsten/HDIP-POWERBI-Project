#$adminSiteUrl = "https://typetecmg-admin.sharepoint.com"

#Connect-SPOService $adminSiteUrl

#Get all Site colections with SharePoint PowerShell
#Get-SPOSite


# Connect to SharePoint Online (substitute your ClientId and Thumbprint using the values from the steps in the URL above)
#Connect-PnPOnline -Tenant contoso.onmicrosoft.com -ClientId 68b3527b-cf40-4284-acb2-854cafcdbac4 -Thumbprint 34CFAA860E5FB8C44335A38A097C1E41EEA206AA -Url https://contoso.sharepoint.com/SiteName

# Upload the CSV file
#Add-PnPFile -Path "C:\Users\aingelsten\data_list_cleaned.csv"

#Config Variables
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