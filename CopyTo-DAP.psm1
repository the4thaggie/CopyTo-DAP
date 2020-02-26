<#
    .SYNOPSIS
    Copy a file or folder to a MTP DAP

    .PARAMETER MTPName
    The name your DAP shows as in My Computer

    .PARAMETER StorageRoot
    The name of the storage card/SD/Internal as shown after double clicking DAP

    .PARAMETER TargetFolder
    Folder one level down from StorageRoot to drop files in (optional)

    .PARAMETER PathToCopy
    The file or folder you wish to copy into your DAP

    .NOTES
    This was made for Fiio M11 DAP but could be adapted

    .EXAMPLE
    CopyTo-DAP -MTPName 'Fiio M11' -StorageRoot 'M11 Micro SD2' -TargetFolder Lol -PathToCopy 'M:\Indie\AFolderOfMusic\' 

#>
Function CopyTo-DAP
{
    [cmdletbinding()]
    PARAM(
        [parameter(Mandatory=$False)]
        [string]$MTPName,
        [parameter(Mandatory=$False)]
        [ValidateSet('M11 Micro SD1','M11 Micro SD2','internal shared storage')]
        [string]$StorageRoot,
        [parameter()]
        [string]$TargetFolder,
        [parameter()]
        [String]$PathToCopy
    )

if(!($MTPName))
{
    $MTPName="Fiio M11"
}

$Shell = New-Object -ComObject Shell.Application
$NS=$Shell.NameSpace(17).Self
$Device=($nS.GetFolder.Items()|?{$_.name -eq $MTPName}) 

if(!($StorageRoot))
{
    $Device.GetFolder.Items() | Select-object -property Name
    $StorageRoot=Read-Host "Enter full name of storage:  "
}
try
{
 $Storage=($Device.GetFolder.Items() |?{$_.name -eq $StorageRoot})
}
catch{
    $Device.GetFolder.Items() | Select-object -property Name
    $StorageRoot=Read-Host "Enter full name of storage:  "
     $Storage=($Device.GetFolder.Items() |?{$_.name -eq $StorageRoot})
}

if(!($TargetFolder))
{
    $DestFolder=$Storage
}
else
{
    $DestFolder=($Storage.GetFolder.Items()|?{$_.name -eq $TargetFolder})
}

$DestFolder.GetFolder.CopyHere($PathToCopy)
}


