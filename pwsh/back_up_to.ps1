function Select-RemovableDrive {
    $removables = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=2" -ErrorAction SilentlyContinue

    if (-not $removables) {
        Write-Warning "No se detectaron unidades removibles (memorias USB). Conecte una y reintente."
        return $null
    }

    $removables | Select-Object DeviceID, VolumeName, @{N='FreeBytes';E={[int64]$_.FreeSpace}}, @{N='SizeBytes';E={[int64]$_.Size}} | Format-Table -AutoSize
   
    $drive = Read-Host "Ingrese la letra de unidad destino (ej: E:)"

    if (-not $drive) { return $null }
    if ($drive -notmatch "^[A-Za-z]:$") { $drive = $drive.TrimEnd('\') }
    if (-not (Test-Path $drive)) { Write-Error "Unidad no válida: $drive"; return $null }
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
$destRoot = Join-Path $destDrive "backup_$timestamp"
New-Item -Path $destRoot -ItemType Directory -Force | Out-Null

$catalogFile = Join-Path $destRoot "backup_catalog.csv"
Write-Host "Generando catálogo de archivos..."

try {
    Get-ChildItem -Path $source -File -Recurse -ErrorAction SilentlyContinue |
        Select-Object @{N='FullName';E={$_.FullName}}, @{N='LastWriteTime'} |
        Export-Csv -Path $catalogFile -NoTypeInformation -Encoding UTF8
} catch {
    Write-Warning "No se pudo crear catálogo completo: $_"
}

$robocopy = Join-Path $env:SystemRoot "System32\robocopy.exe"

if (Test-Path $robocopy) {
    Write-Host "Iniciando copia con Robocopy..."

    $rcArgs = @(
        "`"$source`"", "`"$destRoot`"",
        "/E", "/COPY:DAT", "/R:2", "/W:2", "/NFL", "/NDL", "/NP"
    )

    $proc = Start-Process -FilePath $robocopy -ArgumentList $rcArgs -NoNewWindow -Wait -PassThru

    if ($proc.ExitCode -ge 8) {
        Write-Warning "Robocopy finalizó con código $($proc.ExitCode). Revise logs o permisos."
    } else {
        Write-Host "Copia completada (Robocopy exit $($proc.ExitCode))."
    }
} else {
    Write-Host "Robocopy no disponible, usando Copy-Item (más lento)."
    try {
        Copy-Item -Path (Join-Path $source '*') -Destination $destRoot -Recurse -Force -ErrorAction Stop
        Write-Host "Copia completada."
    } catch {
        Write-Error "Error copiando archivos: $_"
    }
}

Write-Host "Catálogo guardado en: $catalogFile"
