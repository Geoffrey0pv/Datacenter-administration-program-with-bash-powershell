function Select-RemovableDrive {
    $removables = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=2" -ErrorAction SilentlyContinue
    if (-not $removables) {
        Write-Warning "No se detectaron unidades removibles (memorias USB). Conecte una y reintente."
        return $null
    }

    $removables |
        Select-Object DeviceID, VolumeName,
            @{N='FreeMB';E={[math]::Round($_.FreeSpace/1MB,2)}},
            @{N='SizeMB';E={[math]::Round($_.Size/1MB,2)}} |
        Format-Table -AutoSize | Out-Host

    $drive = Read-Host "Ingrese la letra de unidad destino (ej: E:)"
    if (-not $drive) { return $null }
    if ($drive -notmatch "^[A-Za-z]:$") { $drive = $drive.TrimEnd('\') }
    if (-not (Test-Path $drive)) { Write-Error "Unidad no valida: $drive"; return $null }
    return $drive
}

$source = Read-Host "Directorio a respaldar (ruta completa)"
if (-not (Test-Path -Path $source -PathType Container)) {
    Write-Error "Directorio fuente no existe: $source"
    return
}

$destDrive = Select-RemovableDrive
if (-not $destDrive) { return }

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$destRoot = Join-Path $destDrive ("backup_" + $timestamp)
New-Item -Path $destRoot -ItemType Directory -Force | Out-Null

$catalogFile = Join-Path $destRoot "backup_catalog.csv"
Write-Host "Generando catalogo de archivos..."
try {
    Get-ChildItem -Path $source -File -Recurse -ErrorAction SilentlyContinue |
        Select-Object FullName, LastWriteTime |
        Export-Csv -Path $catalogFile -NoTypeInformation -Encoding UTF8 -Force
} catch {
    Write-Warning "No se pudo crear catalogo completo: $_"
}

$robocopy = Join-Path $env:SystemRoot "System32\robocopy.exe"
if (Test-Path $robocopy) {
    Write-Host "Iniciando copia con Robocopy..."
    $rcArgs = @("`"$source`"", "`"$destRoot`"", "/E", "/COPY:DAT", "/R:2", "/W:2", "/NFL", "/NDL", "/NP")
    $proc = Start-Process -FilePath $robocopy -ArgumentList $rcArgs -NoNewWindow -Wait -PassThru
    if ($proc.ExitCode -ge 8) {
        Write-Warning "Robocopy finalizo con codigo $($proc.ExitCode). Revise logs o permisos."
    } else {
        Write-Host "Copia completada (Robocopy exit $($proc.ExitCode))."
    }
} else {
    Write-Host "Robocopy no disponible, usando Copy-Item (mas lento)."
    try {
        Copy-Item -Path (Join-Path $source '*') -Destination $destRoot -Recurse -Force -ErrorAction Stop
        Write-Host "Copia completada."
    } catch {
        Write-Error "Error copiando archivos: $_"
    }
}

Write-Host "Catalogo guardado en: $catalogFile"
