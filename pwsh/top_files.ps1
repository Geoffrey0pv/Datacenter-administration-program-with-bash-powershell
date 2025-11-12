param(
    [string]$PathPrompt
)

if (-not $PathPrompt) {
    $PathPrompt = Read-Host "Ingrese la letra de unidad o ruta del filesystem (ej: C:\ o \\server\share\)"
}

if (-not (Test-Path -Path $PathPrompt)) {
    Write-Error "La ruta especificada no existe o no está accesible: $PathPrompt"
    return
}

Write-Host "Buscando archivos ..."

try {
    $files = Get-ChildItem -Path $PathPrompt -File -Recurse -ErrorAction SilentlyContinue |
             Sort-Object -Property Length -Descending |
             Select-Object -First 10 |
             Select-Object @{N='FullName';E={$_.FullName}}, @{N= 'SizeMB';E={"{0:N2}" -f [math]::Round(($_.Length / 1MB), 2)}}

    if (-not $files) {
        Write-Host "No se encontraron archivos o no hay permisos para leer algunos subdirectorios."
    } else {
        $files | Format-Table -AutoSize
    }
} catch {
    Write-Error "Error durante la búsqueda: $_"
}
