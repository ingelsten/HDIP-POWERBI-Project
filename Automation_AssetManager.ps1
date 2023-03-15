<#
AssetManager copy script - to be run to location for PowerBI to access.
Change
#>

# This is the file to be copied
$source = "C:\KZSoftware\ASSETMANAGER.ADB"
 
# Destination for file
$dest = "C:\inetpub"

# Copy of file
Copy-Item $source -Destination $dest -Recurse -force