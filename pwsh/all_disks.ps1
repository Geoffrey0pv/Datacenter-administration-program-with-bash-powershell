
function Show-LogicalDisks {
    
    $disks = Get-CimInstance -ClassName Win32_LogicalDisk -ErrorAction Stop | Where-Object { $_.Size -ne $null }
    
    $disks | Select-Object @{N='DeviceID';E={$_.DeviceID}}, 
    @{N='Description';E={$_.Description}}, 
    @{N='DriveType';E={$_.DriveType}}, 
    @{N='SizeBytes';E={'{0:N2}' -f [int64]$_.Size}}, 
    @{N='FreeBytes';E={'{0:N2}' -f [int64]$_.FreeSpace}},
    @{N='FreePercent %';E={[math]::Round(($_.FreeSpace / $_.Size) * 100, 2)}} | Format-Table -AutoSize

    Write-Host "`nResumen (DriveType: 2 = Removable, 3 = Local, 4 = Network, 5 = CDROM)"
}

Show-LogicalDisks
