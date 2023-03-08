
<#
PipeDriveAPI- This API pulls all deals, persons, and activitites from Pipedrive
As the data is paginated and a page only holds 100 records
The loops starts on 0 and iterates by 100
When pull is completed the data is exported to Sharepoint Online
#>


#Configuration -  API token
$PipeDriveAPI= Get-Content "c:\scripts\PipeDriveAPI.txt"
$Pipedrive_domain= Get-Content "c:\scripts\Pipedrive_domain.txt"
$Pipedrive_BaseURL="https://$Pipedrive_domain.pipedrive.com/v1/"

Write-Output "***Getting All Deals***"

# Get All Deals
$num = 0
for ($num;; $num+=99)
{
        $Url_Deals=$Pipedrive_BaseURL+"deals?start=$num&api_token=$PipeDriveAPI"

        $Result_Deals=Invoke-RestMethod -uri $URL_Deals -Method GET 
    
        $Result_Deals.data
        Write-Output "Page number" $num 

        if ($null -ne $Result_Deals.data)
        {
            $Result_Deals.data | Export-Csv -Path C:\scripts\Deals_pipe.csv -NoTypeInformation -Append
            Write-Output "****EXPORT****"
            Start-Sleep -Seconds 0.5 
        }
        else {

        Write-Output "****LOOP ENDS***"
        Break

        }

    }

$cleaned_Deals = Import-Csv C:\scripts\Deals_pipe.csv| Sort-Object id -Unique

Start-Sleep -Seconds 0.5

$cleaned_Deals | Export-Csv -Path C:\scripts\Deals_pipe.csv -NoTypeInformation


Write-Output "***Getting All Activities***"
# Get All Activities
$numa = 0
    for ($numa;; $numa+=99)
    {
            $Url_Activities=$Pipedrive_BaseURL+"activities?start=$numa&api_token=$PipeDriveAPI"
    
            $Result_Activities=Invoke-RestMethod -uri $URL_Activities -Method GET 
        
            $Result_Activities.data
            Write-Output "Page number" $numa
    
            if ($null -ne $Result_Activities.data)
            {
                $Result_Activities.data | Export-Csv -Path C:\scripts\Activities_pipe.csv -NoTypeInformation -Append
                Write-Output "*****EXPORT****"
                Start-Sleep -Seconds 0.5 
            }
            else {
    
            Write-Output "****LOOP ENDS***"
            Break
    
            }
    
        }




$cleaned_Activities = Import-Csv C:\scripts\Activities_pipe.csv| Sort-Object id -Unique

Start-Sleep -Seconds 0.5

$cleaned_Activities | Export-Csv -Path C:\scripts\Activities_pipe.csv -NoTypeInformation

# Get All Deal Fields
#$Url=$Pipedrive_BaseURL+"dealFields?start=$num&api_token=$PipeDriveAPI"

Write-Output "***Getting All Persons***"
# Get All Persons
$nump = 0
    for ($nump;; $nump+=99)
    {
            $Url_Persons=$Pipedrive_BaseURL+"persons?start=$nump&api_token=$PipeDriveAPI"
               
            $Result_Persons=Invoke-RestMethod -uri $URL_Persons -Method GET 
        
            $Result_Persons.data
            Write-Output "Page number" $nump 
    
            if ($null -ne $Result_Persons.data)
            {
                $Result_Persons.data | Export-Csv -Path C:\scripts\Persons_pipe.csv -NoTypeInformation -Append
                Write-Output "*****EXPORT****"
                Start-Sleep -Seconds 0.5 
            }
            else {
    
            Write-Output "****LOOP ENDS***"
            Break
    
            }
    
        }

$cleaned_Persons = Import-Csv C:\scripts\Persons_pipe.csv| Sort-Object id -Unique

Start-Sleep -Seconds 0.5

$cleaned_Persons | Export-Csv -Path C:\scripts\Persons_pipe.csv -NoTypeInformation


#Configuration of Sharepoint Variables
$SiteURL = "https://typetecmg.sharepoint.com/sites/ITMainline"
$SourceFilePath_Deals ="c:\scripts\Deals_pipe.csv"
$SourceFilePath_Activities ="c:\scripts\Activities_pipe.csv"
$SourceFilePath_Persons ="c:\scripts\Persons_pipe.csv"
$DestinationPath = "Kpi_Data" #Site Relative Path of the Library
$ClientId = Get-Content "C:\scripts\ClientID.txt"
$ClientSecret = Get-Content "C:\scripts\ClientSecret.txt"

 
#Connect to SharePoint Online with ClientId and ClientSecret
Connect-PnPOnline -Url $SiteURL -ClientId $ClientId -ClientSecret $ClientSecret

#Powershell pnp to upload file to sharepoint online
Add-PnPFile -Path $SourceFilePath_Deals -Folder $DestinationPath
Add-PnPFile -Path $SourceFilePath_Activities -Folder $DestinationPath
Add-PnPFile -Path $SourceFilePath_Persons -Folder $DestinationPath

Write-Output "Process Deals,Activities and Persons Pipeline completed"


