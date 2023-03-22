# POWERBI REPORT AUTOMATION

Utilising PowerShell to automate reporting in PowerBI

This is a work-based project

Name: Anders Ingelsten - 20095402

## General Overview.

This project automates the generation and visualization of a company’s KPI reports.  

Data is pulled from local hosted as well as remote cloud-based systems, for example Fieldview and PipeDrive, via their APIs and the data is stored into SharePoint Online as CSV Data. PowerBI in conjunction with the formula language DAX is utilised as the visualisation tool, to display the stored data, as up to date organisational interactive KPI reporting diagrams on the company’s intranet. 

PowerShell is used as the scripting language to facilitate the data pull and. The data pull and PowerBI refresh is scheduled several times per day, so employees have access to near live data.


Lecturer: Colm Dunphy
Project Supervisor: Anita Kealy

Module: Project

## Pre-requisites

The scripts in this GitHub is applicable to company and organisations using Fieldview and/or Pipedrive

Any development will reuire the creation of API keys.

## Script Languages

Powershell

## Git Approach

I approached Git the following way: When I thought i had an acceptable starting point I created and committed to the initial
repository. From there I committed everytime I made any small change. 

## Script Screenshots

Pipedrive API

![][view2]

Fieldview API

![][view1]

## Resources

* https://www.smartsheet.com
* https://www.viewpoint.com/en-gb/products/viewpoint-field-view
* https://www.microsoft.com/en-ie/microsoft-365/sharepoint/collaboration
* https://powerbi.microsoft.com/en-gb
* https://www.altexsoft.com/blog/engineering/what-is-soap-formats-protocols-message-structure-and-how-soap-is-different-from-rest
* https://learn.microsoft.com/en-us/powershell
* https://powerautomate.microsoft.com/en-gb
* https://learn.microsoft.com/en-us/power-automate/desktop-flows/actions-reference/scripting
* https://learn.microsoft.com/en-us/dax/
* https://www.microsoft.com/en-ie/microsoft-365/business/task-management-software
* https://help.viewpoint.com/en/viewpoint-field-view/field-view/api-documentation/apis
* https://www.spanishpoint.ie
* https://www.sharepointdiary.com/2018/03/connect-to-sharepoint-online-using-pnp-powershell.html
* https://www.youtube.com/watch?v=IJ1I2737JWU
* https://www.pipedrive.com
* https://www.kzsoftware.com/products/asset-management-software
* https://firebirdsql.org>Firebird
* https://docs.devart.com/odbc/firebird/powerbi.htm


### HDIP in Computer Science 2023 - Dep of Computing & Mathematics, SETU

[view1]: https://github.com/ingelsten/HDIP-POWERBI-Project/blob/master/Background%20Data/Fieldview.PNG
[view2]: https://github.com/ingelsten/HDIP-POWERBI-Project/blob/master/Background%20Data/PipeDrive.PNG
