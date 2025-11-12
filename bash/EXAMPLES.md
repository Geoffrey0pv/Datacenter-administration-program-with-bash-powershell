# Ejemplos de Uso - Data Center Administration Tool

## Guía Rápida de Uso

### Inicio del Programa

```bash
cd bash
sudo ./admin_tool.sh
```

Verás el menú principal:
```
============================================================
    DATA CENTER ADMINISTRATION TOOL
============================================================

  1. Usuarios del sistema y último ingreso
  2. Filesystems y discos conectados
  3. Diez archivos más grandes en un disco
  4. Memoria libre y espacio swap
  5. Backup de directorio a USB
  6. Salir

============================================================
Seleccione una opción [1-6]: 
```

---

## Ejemplos por Módulo

### Módulo 1: Usuarios del Sistema

**Uso:** Simplemente seleccione la opción 1

**Salida ejemplo:**
```
============================================================
  USUARIOS DEL SISTEMA Y ÚLTIMO INGRESO
============================================================

USUARIO              ÚLTIMO INGRESO                 ESTADO              
--------------------------------------------------------------------
root                 Mon Nov 11 10:30:45 2025       Activo              
geoffrey             Mon Nov 11 14:25:00 2025       Activo              
admin                Nunca ha ingresado             Activo              

Total de usuarios mostrados: 3

============================================================
```

---

### Módulo 2: Filesystems y Discos

**Uso:** Seleccione la opción 2

**Salida ejemplo:**
```
============================================================
  FILESYSTEMS Y DISCOS CONECTADOS
============================================================

FILESYSTEM                TIPO            TAMAÑO (bytes)       ESPACIO LIBRE (bytes) USO %     
------------------------------------------------------------------------------------------------
/dev/sda1                 ext4            536870912000         214748364800          60%       
/dev/sdb1                 ext4            1073741824000        644245094400          40%       
/dev/sdc1                 ntfs            2147483648000        1288490188800         40%       

Información adicional de discos físicos:
------------------------------------------------------------------------------------------------

NAME         SIZE TYPE MOUNTPOINT
sda  536870912000 disk 
└─sda1 536870912000 part /
sdb 1073741824000 disk 
└─sdb1 1073741824000 part /home
```

---

### Módulo 3: Archivos Más Grandes

**Uso:** Seleccione la opción 3, luego ingrese la ruta

**Ejemplo de interacción:**
```
============================================================
  DIEZ ARCHIVOS MÁS GRANDES
============================================================

Filesystems disponibles:

  /
  /home
  /mnt/data

Ingrese el filesystem o directorio a analizar (ejemplo: / o /home): /home

Buscando los 10 archivos más grandes en: /home
Por favor espere, esto puede tomar unos momentos...

TAMAÑO (bytes)  RUTA COMPLETA DEL ARCHIVO                                                      
------------------------------------------------------------------------------------------------
5368709120      /home/user/Videos/movie.mp4                                                     
2147483648      /home/user/Documents/database.sql                                               
1073741824      /home/user/Downloads/ubuntu.iso                                                 
536870912       /home/user/Pictures/photo_collection.zip                                        
268435456       /home/user/Documents/presentation.pptx                                          
134217728       /home/user/Music/album.flac                                                     
67108864        /home/user/Documents/report.pdf                                                 
33554432        /home/user/Documents/spreadsheet.xlsx                                           
16777216        /home/user/Pictures/image.raw                                                   
8388608         /home/user/Documents/document.docx                                              
```

---

### Módulo 4: Memoria y Swap

**Uso:** Seleccione la opción 4

**Salida ejemplo:**
```
============================================================
  INFORMACIÓN DE MEMORIA Y SWAP
============================================================

═══════════════════════════════════════════════════════════
  MEMORIA RAM
═══════════════════════════════════════════════════════════

Memoria Total                  :   16,911,101,952 bytes    (15.75 GB)
Memoria Libre                  :   10,146,661,376 bytes    (9.45 GB)
Memoria en Uso                 :    6,764,440,576 bytes    (6.30 GB)

Porcentaje Libre               : 60.00%
Porcentaje en Uso              : 40.00%

Estado: [████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 40.00% usado


═══════════════════════════════════════════════════════════
  ESPACIO SWAP
═══════════════════════════════════════════════════════════

Swap Total                     :    8,589,934,592 bytes    (8.00 GB)
Swap en Uso                    :      214,748,364 bytes    (0.20 GB)
Swap Libre                     :    8,375,186,228 bytes    (7.80 GB)

Porcentaje en Uso              : 2.50%
Porcentaje Libre               : 97.50%

Estado: [█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 2.50% usado


============================================================
Información adicional del sistema:

              total        used        free      shared  buff/cache   available
Mem:           15Gi       6.3Gi       9.5Gi       150Mi       2.1Gi       9.4Gi
Swap:          8.0Gi       204Mi       7.8Gi

============================================================
```

---

### Módulo 5: Backup a USB

**Uso:** Seleccione la opción 5, luego siga las instrucciones

**Ejemplo de interacción:**
```
============================================================
  BACKUP DE DIRECTORIO A USB
============================================================

Dispositivos de almacenamiento disponibles:

NAME   SIZE TYPE MOUNTPOINT LABEL
sda    500G disk           
└─sda1 500G part /
sdb    32G  disk           
└─sdb1 32G  part /media/usb USB_BACKUP

Ingrese la ruta del directorio a respaldar: /home/user/documents

Opciones:
  1. Especificar punto de montaje USB (ej: /media/usb, /mnt/usb)
  2. Especificar ruta completa de destino

Ingrese la ruta de destino para el backup: /media/usb

Iniciando backup...
Origen: /home/user/documents
Destino: /media/usb/backup_documents_20251111_143000

Tamaño a respaldar: 1073741824 bytes (1.0 GB)

Usando rsync para copia eficiente...
sent 1,073,741,824 bytes  received 128 bytes  71,582,796.80 bytes/sec
total size is 1,073,741,824  speedup is 1.00

✓ Copia de archivos completada exitosamente.

Generando catálogo de archivos...
✓ Catálogo creado: /media/usb/backup_documents_20251111_143000/CATALOG.txt

Resumen del catálogo:
  - Total de archivos respaldados: 150
  - Tamaño total: 1073741824 bytes (1.0 GB)

Generando checksums para verificación de integridad...
✓ Checksums creados: /media/usb/backup_documents_20251111_143000/CHECKSUMS.md5

============================================================
  BACKUP COMPLETADO EXITOSAMENTE
============================================================

Ubicación del backup:
  /media/usb/backup_documents_20251111_143000

Archivos generados:
  1. Directorio con todos los archivos respaldados
  2. CATALOG.txt - Catálogo con nombres y fechas
  3. CHECKSUMS.md5 - Checksums para verificación

Para verificar la integridad del backup más tarde:
  cd /media/usb/backup_documents_20251111_143000
  md5sum -c CHECKSUMS.md5

Vista previa del catálogo (primeras 10 líneas):
# CATÁLOGO DE BACKUP
# Generado: 2025-11-11 14:30:00
# Directorio origen: /home/user/documents
#
# Formato: TAMAÑO (bytes) | FECHA_MODIFICACIÓN | NOMBRE_ARCHIVO
======================================================================

1024            | 2025-11-10 14:22:30 | /home/user/documents/file1.txt
2048            | 2025-11-11 10:15:00 | /home/user/documents/file2.pdf
4096            | 2025-11-09 08:30:45 | /home/user/documents/file3.docx
  ...

============================================================
```

---

## Casos de Uso Comunes

### Caso 1: Auditoría de usuarios activos
```bash
# Ejecutar el programa
sudo ./admin_tool.sh

# Seleccionar opción 1
# Revisar lista de usuarios y sus últimos accesos
# Identificar usuarios inactivos o accesos sospechosos
```

### Caso 2: Monitoreo de espacio en disco
```bash
# Ejecutar el programa
sudo ./admin_tool.sh

# Seleccionar opción 2 para ver estado general
# Si algún disco está >90% lleno, usar opción 3
# Buscar archivos grandes en ese disco para limpiar
```

### Caso 3: Optimización de memoria
```bash
# Ejecutar el programa
sudo ./admin_tool.sh

# Seleccionar opción 4
# Revisar uso de memoria y swap
# Si memoria libre es <10%, investigar procesos
# Si swap está >50% usado, considerar agregar RAM
```

### Caso 4: Backup regular de datos críticos
```bash
# Conectar USB al servidor
# Ejecutar el programa
sudo ./admin_tool.sh

# Seleccionar opción 5
# Especificar directorio crítico (/var/www, /home, etc.)
# Especificar destino USB
# Guardar catálogo para referencia futura
```

---

## Verificación de Integridad del Backup

Después de crear un backup, puedes verificar su integridad:

```bash
# Ir al directorio del backup
cd /media/usb/backup_documents_20251111_143000

# Verificar checksums
md5sum -c CHECKSUMS.md5

# Salida esperada:
# file1.txt: OK
# file2.pdf: OK
# file3.docx: OK
# ...
```

---

## Solución de Problemas

### Error: "Permiso denegado"
**Solución:** Ejecutar con sudo
```bash
sudo ./admin_tool.sh
```

### Error: "Comando no encontrado"
**Solución:** Verificar instalación de comandos
```bash
./test.sh  # Verifica comandos disponibles
```

### Error: "No hay espacio en dispositivo"
**Solución:** Verificar espacio antes de backup
```bash
df -h /media/usb  # Verificar espacio disponible
```

### Módulo de usuarios no muestra información
**Solución:** Verificar permisos y comandos
```bash
sudo lastlog      # Verificar comando funciona
sudo last         # Verificar comando funciona
```

---

## Tips y Mejores Prácticas

1. **Siempre ejecutar con sudo** para acceso completo
2. **Verificar espacio disponible** antes de backups grandes
3. **Revisar el catálogo** después de cada backup
4. **Programar backups regulares** usando cron
5. **Mantener múltiples copias** de backups críticos
6. **Verificar integridad** con checksums periódicamente
7. **Documentar cambios** en usuarios y accesos

---

## Automatización con Cron

Para programar ejecuciones automáticas:

```bash
# Editar crontab
sudo crontab -e

# Ejemplo: Backup diario a las 2 AM
0 2 * * * /ruta/bash/backup/backup.sh /home/data /media/usb
```

---

Para más información técnica, consulte: `bash/DOCUMENTATION.md`
