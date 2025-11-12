# Documentación Técnica - Bash Version

## Proyecto: Data Center Administration Tool

### Autor: Geoffrey
### Fecha: Noviembre 2025

---

## Estructura del Proyecto

```
bash/
├── admin_tool.sh              # Script principal con menú interactivo
├── setup.sh                   # Script de instalación y configuración
├── users/
│   └── users.sh              # Módulo 1: Gestión de usuarios
├── filesystems/
│   └── filesystems.sh        # Módulo 2: Información de discos
├── largest_files/
│   └── largest_files.sh      # Módulo 3: Búsqueda de archivos grandes
├── memory/
│   └── memory.sh             # Módulo 4: Monitoreo de memoria y swap
└── backup/
    └── backup.sh             # Módulo 5: Sistema de backup
```

---

## Descripción de Módulos

### 1. Script Principal (admin_tool.sh)

**Función:** Menú interactivo que coordina todos los módulos del sistema.

**Características:**
- Interfaz colorida y amigable
- Navegación mediante números (1-6)
- Validación de entrada del usuario
- Sistema de pausa entre módulos

**Variables principales:**
- `SCRIPT_DIR`: Directorio base del script
- Códigos de color para interfaz visual

### 2. Módulo de Usuarios (users/users.sh)

**Requerimiento:** Desplegar usuarios del sistema y fecha de último ingreso.

**Comandos utilizados:**
- `lastlog`: Obtiene el último login de usuarios
- `last`: Comando alternativo para información de login
- `grep` en `/etc/passwd`: Lista usuarios del sistema

**Funcionamiento:**
1. Lee el archivo `/etc/passwd` para obtener usuarios
2. Filtra usuarios con UID >= 1000 (usuarios reales)
3. Excluye cuentas del sistema y sin shell válido
4. Usa `lastlog` para obtener fecha de último acceso
5. Formatea la salida en tabla con colores

**Salida:**
- Nombre de usuario
- Fecha y hora de último ingreso
- Estado del usuario

### 3. Módulo de Filesystems (filesystems/filesystems.sh)

**Requerimiento:** Mostrar filesystems con tamaño y espacio libre en bytes.

**Comandos utilizados:**
- `df -B1 -T`: Información de discos en bytes
- `lsblk -b`: Lista de dispositivos de bloque

**Funcionamiento:**
1. Ejecuta `df -B1 -T` para obtener información en bytes
2. Filtra sistemas temporales (tmpfs, devtmpfs, squashfs)
3. Calcula porcentaje de uso
4. Aplica colores según nivel de uso:
   - Rojo: >90% usado
   - Amarillo: >70% usado
   - Verde: <70% usado
5. Muestra información adicional con `lsblk`

**Salida:**
- Nombre del filesystem
- Tipo (ext4, xfs, etc.)
- Tamaño total en bytes
- Espacio libre en bytes
- Porcentaje de uso

### 4. Módulo de Archivos Grandes (largest_files/largest_files.sh)

**Requerimiento:** Mostrar 10 archivos más grandes con ruta completa.

**Comandos utilizados:**
- `find`: Búsqueda recursiva de archivos
- `sort -rn`: Ordenamiento numérico descendente
- `head -10`: Primeros 10 resultados

**Funcionamiento:**
1. Lista filesystems disponibles
2. Solicita al usuario especificar directorio
3. Valida existencia del directorio
4. Ejecuta: `find <dir> -type f -printf "%s %p\n"`
5. Ordena por tamaño descendente
6. Muestra los 10 más grandes

**Salida:**
- Tamaño en bytes
- Ruta completa del archivo

### 5. Módulo de Memoria (memory/memory.sh)

**Requerimiento:** Memoria libre y swap en uso (bytes y porcentaje).

**Comandos utilizados:**
- Lectura de `/proc/meminfo`: Información de memoria del kernel
- `free -h`: Visualización adicional
- `awk` y `bc`: Cálculos matemáticos

**Funcionamiento:**

#### Memoria RAM:
1. Lee `MemTotal` de `/proc/meminfo` (en KB)
2. Lee `MemAvailable` para memoria disponible real
3. Convierte KB a bytes (multiplicando por 1024)
4. Calcula porcentajes: `(libre/total) * 100`
5. Muestra barra de progreso visual

#### Swap:
1. Lee `SwapTotal` y `SwapFree` de `/proc/meminfo`
2. Calcula swap en uso: `total - libre`
3. Calcula porcentajes
4. Muestra barra de progreso visual
5. Maneja caso de sistema sin swap

**Salida:**
- Memoria total, libre y en uso (bytes)
- Porcentajes de uso
- Barras de progreso visuales
- Salida de `free -h` para referencia

### 6. Módulo de Backup (backup/backup.sh)

**Requerimiento:** Backup a USB con catálogo de archivos y fechas.

**Comandos utilizados:**
- `rsync`: Copia eficiente (si está disponible)
- `cp -r`: Alternativa para copia recursiva
- `find`: Generación de catálogo
- `md5sum`: Checksums para integridad
- `lsblk`: Lista dispositivos de almacenamiento

**Funcionamiento:**

1. **Preparación:**
   - Muestra dispositivos disponibles con `lsblk`
   - Solicita directorio origen
   - Valida existencia y permisos
   - Solicita destino USB
   - Crea destino si no existe

2. **Copia de archivos:**
   - Intenta usar `rsync -av` para copia eficiente
   - Si no está disponible, usa `cp -r`
   - Muestra progreso de la operación

3. **Generación de catálogo (CATALOG.txt):**
   - Usa `find` con formato personalizado
   - Incluye: tamaño, fecha de modificación, ruta
   - Formato: `find -printf "%s|%TY-%Tm-%Td %TH:%TM:%TS|%p"`
   - Ordena alfabéticamente por ruta

4. **Verificación de integridad:**
   - Genera checksums MD5 de todos los archivos
   - Guarda en `CHECKSUMS.md5`
   - Permite verificación posterior con `md5sum -c`

5. **Estructura del backup:**
   ```
   backup_<nombre>_<fecha>/
   ├── [archivos copiados]
   ├── CATALOG.txt       # Catálogo detallado
   └── CHECKSUMS.md5     # Checksums para verificación
   ```

**Salida:**
- Confirmación de copia exitosa
- Ubicación del backup
- Resumen de archivos respaldados
- Vista previa del catálogo
- Instrucciones para verificación

**Formato del catálogo:**
```
# CATÁLOGO DE BACKUP
# Generado: 2025-11-11 15:30:45
# Directorio origen: /home/user/documents
#
# Formato: TAMAÑO (bytes) | FECHA_MODIFICACIÓN | NOMBRE_ARCHIVO
======================================================================

1024            | 2025-11-10 14:22:30 | /home/user/documents/file1.txt
2048            | 2025-11-11 10:15:00 | /home/user/documents/file2.pdf
...

======================================================================
# Total de archivos: 150
# Tamaño total: 1048576 bytes
```

---

## Instalación

### Método 1: Script automático
```bash
cd bash
./setup.sh
```

### Método 2: Manual
```bash
chmod +x bash/admin_tool.sh
chmod +x bash/users/users.sh
chmod +x bash/filesystems/filesystems.sh
chmod +x bash/largest_files/largest_files.sh
chmod +x bash/memory/memory.sh
chmod +x bash/backup/backup.sh
```

---

## Uso

### Ejecución normal
```bash
cd bash
./admin_tool.sh
```

### Ejecución con privilegios (recomendado)
```bash
cd bash
sudo ./admin_tool.sh
```

**Nota:** Se requieren permisos de superusuario para:
- Acceso completo a información de usuarios
- Lectura de todos los archivos del sistema
- Escritura en dispositivos USB montados

---

## Requisitos del Sistema

### Software necesario:
- Bash 4.0 o superior
- Comandos estándar de Linux: df, du, find, grep, awk, sort
- Opcional: rsync (para backup más eficiente)

### Permisos:
- Lectura de `/proc/meminfo`
- Lectura de `/etc/passwd`
- Acceso a `lastlog` y `last`
- Escritura en dispositivo de backup

---

## Manejo de Errores

Cada módulo incluye:
1. Validación de entradas del usuario
2. Verificación de permisos
3. Mensajes de error descriptivos
4. Códigos de salida apropiados
5. Manejo de casos especiales (ej: sistema sin swap)

---

## Características Técnicas

### Colores y Formato:
- Rojo: Errores y alertas
- Verde: Éxito y valores normales
- Amarillo: Advertencias
- Cyan: Información destacada
- Azul: Encabezados y separadores

### Optimizaciones:
- Uso de `/proc/meminfo` en lugar de comandos pesados
- Filtrado temprano de datos irrelevantes
- Pipeline de comandos eficiente
- Supresión de errores con `2>/dev/null` donde apropiado

---

## Notas de Implementación

1. **Portabilidad:** Scripts probados en distribuciones Linux principales
2. **Modularidad:** Cada función es independiente y reutilizable
3. **Mantenibilidad:** Código comentado y estructurado
4. **Escalabilidad:** Fácil agregar nuevos módulos

---

## Limitaciones Conocidas

1. Específico para sistemas Linux (no funciona en Windows)
2. Requiere filesystem compatible con permisos Unix
3. Algunos comandos pueden variar entre distribuciones
4. El módulo de backup requiere espacio suficiente en destino

---

## Mejoras Futuras

- [ ] Soporte para backup incremental
- [ ] Compresión de archivos en backup
- [ ] Notificaciones por email
- [ ] Log de operaciones
- [ ] Interfaz web opcional
- [ ] Programación de backups automáticos

---

## Contacto y Soporte

**Repositorio:** https://github.com/Geoffrey0pv/Datacenter-administration-program-with-bash-powershell

**Autor:** Geoffrey (Geoffrey0pv)

**Curso:** Sistemas Operativos

**Fecha de entrega:** 13 de noviembre de 2025
