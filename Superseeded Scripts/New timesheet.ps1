
#import, split and export only coins timesheet and it's Id's sorted by ID.
#$path = "C:\scripts"

#Import-Csv -Path $path\All_Formslist.csv | Where-Object {$_.FormName -eq "Coins TimeSheet" -and $_.Complete -eq "TRUE" } | Sort-Object LastModifiedOnServer -Descending | Export-Csv C:\scripts\All_Coins_Timesheet.csv –NoTypeInformation

#Import-Csv C:\scripts\All_Coins_Timesheet.csv  | Select-Object FormID | Export-Csv -Path C:\scripts\All_Coins_Timesheet_ID.csv –NoTypeInformation

#Get-Content C:\scripts\All_Coins_Timesheet_ID.csv -Encoding UTF8 | ForEach-Object {$_ -replace '"',''} | Out-File C:\scripts\All_Coins_Timesheet_ID.txt -Encoding UTF8



#import, split and export only coins timesheet and it's Id's sorted by ID.

$path = "C:\Users\aingelsten\scripts"

Import-Csv C:\Users\aingelsten\scripts\formslist_current.csv | Where-Object {$_.FormName -eq "Coins TimeSheet" -and $_.Complete -eq "TRUE"} | Sort-Object LastModifiedOnServer -Descending | Export-Csv C:\Users\aingelsten\scripts\All_Coins_Timesheet2.csv –NoTypeInformation

Import-Csv C:\Users\aingelsten\scripts\Current_Coins_Timesheet.csv  | Select-Object FormID | Export-Csv -Path C:\Users\aingelsten\scripts\Current_Coins_Timesheet_ID.csv –NoTypeInformation

Get-Content C:\Users\aingelsten\scripts\Current_Coins_Timesheet_ID.csv -Encoding UTF8 | ForEach-Object {$_ -replace '"',''} | Out-File C:\Users\aingelsten\scripts\Current_Coins_Timesheet_ID.txt -Encoding UTF8
