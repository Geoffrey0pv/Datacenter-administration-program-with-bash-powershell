$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$flag = $true


function Show-Menu {
    Clear-Host
    Write-Host "===== Herramientas de administracion ====="
    Write-Host "1) Usuarios creados y ultimo login"
    Write-Host "2) Filesystems / discos (tamano y libre)"
    Write-Host "3) Top 10 archivos más grandes en un disco/filesystem"
    Write-Host "4) Memoria libre y espacio de swap (bytes y %)"
    Write-Host "5) Backup de directorio a memoria USB (incluye catalogo)"
    Write-Host "0) Salir"
    Write-Host "=========================================="
}

while ($flag) {
    Show-Menu
    $choice = Read-Host "Elija una opcion (0-5)"
    switch ($choice) {
        '1' { powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir 'user_logon_registry.ps1') }
        '2' { powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir 'all_disks.ps1') }
        '3' { powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir 'top_files.ps1') }
        '4' { powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir 'memory_swap.ps1') }
        '5' { powershell -ExecutionPolicy Bypass -File (Join-Path $scriptDir 'back_up_to.ps1') }
        '0' { $flag = $false }
        default { Write-Warning "Opcion no valida. Intente de nuevo."; Start-Sleep -Seconds 1 }
    }
    Write-Host "`nPresione ENTER para volver al menu o salir definitivamente..."
    Read-Host | Out-Null
}
Write-Host "Saliendo..."
