# Data Center Administration Tool

## Proyecto Final - Sistemas Operativos

Herramientas de administración para Data Center desarrolladas en **Bash** y **PowerShell**.

## Descripción

Este proyecto consiste en dos herramientas (una en Bash para Linux y otra en PowerShell para Windows) que facilitan las labores del administrador de un data center, proporcionando funcionalidades para:

1. **Gestión de usuarios**: Visualizar usuarios del sistema y su último ingreso
2. **Monitoreo de discos**: Información sobre filesystems y espacio disponible
3. **Análisis de archivos**: Identificar los archivos más grandes en el sistema
4. **Monitoreo de recursos**: Memoria libre y uso de swap
5. **Backup**: Copias de seguridad a dispositivos USB con catálogo

## Características

### Versión Bash (Linux)
- Arquitectura modular con scripts separados
- Interfaz de menú colorida e intuitiva
- Información detallada en bytes
- Compatible con sistemas Linux

### Versión PowerShell (Windows)
- Script principal con menú interactivo (`admin_tools.ps1`)
- Ejecución modular de cada funcionalidad en scripts dedicados
- Compatibilidad con PowerShell 5.1+ y Windows 10/11
- Soporte para unidades locales, de red y USB

## Estructura del Proyecto

```
PROJECTO/
├── bash/
│   ├── admin_tool.sh                    # Script principal con menú
│   ├── setup.sh                         # Script de instalación
│   ├── test.sh                          # Script de verificación
│   ├── DOCUMENTATION.md                 # Documentación técnica completa
│   ├── users/
│   │   └── users.sh                     # Módulo 1: Usuarios y último login
│   ├── filesystems/
│   │   └── filesystems.sh               # Módulo 2: Filesystems y discos
│   ├── largest_files/
│   │   └── largest_files.sh             # Módulo 3: Archivos más grandes
│   ├── memory/
│   │   └── memory.sh                    # Módulo 4: Memoria y swap
│   └── backup/
│       └── backup.sh                    # Módulo 5: Backup a USB
├── pwsh/
│   ├── admin_tools.ps1                # Menú principal en PowerShell
│   ├── all_disks.ps1                  # Módulo 2: Filesystems y discos
│   ├── top_files.ps1                  # Módulo 3: Archivos más grandes
│   ├── memory_swap.ps1                # Módulo 4: Memoria y swap
│   ├── back_up_to.ps1                 # Módulo 5: Backup a USB con catálogo
│   └── user_logon_registry.ps1        # Módulo 1: Usuarios y último login
└── README.md
```

## Instalación y Uso

### Bash (Linux)

1. **Clonar el repositorio:**
```bash
git clone https://github.com/Geoffrey0pv/Datacenter-administration-program-with-bash-powershell.git
cd Datacenter-administration-program-with-bash-powershell
```

2. **Verificar el sistema:**
```bash
cd bash
./test.sh
```

3. **Configurar permisos (automático):**
```bash
./setup.sh
```

O **manualmente:**
```bash
chmod +x admin_tool.sh setup.sh test.sh
chmod +x users/*.sh
chmod +x filesystems/*.sh
chmod +x largest_files/*.sh
chmod +x memory/*.sh
chmod +x backup/*.sh
```

4. **Ejecutar la herramienta:**
```bash
sudo ./admin_tool.sh
```

> **Nota:** Se requieren permisos de superusuario (sudo) para acceso completo a todas las funcionalidades.

### PowerShell (Windows)

1. **Abrir PowerShell con permisos adecuados:**
   - Se recomienda ejecutar como administrador para evitar restricciones de permisos.
2. **Clonar y ubicarse en la carpeta del proyecto (si no se ha hecho ya):**
   ```powershell
   git clone https://github.com/Geoffrey0pv/Datacenter-administration-program-with-bash-powershell.git
   Set-Location .\Datacenter-administration-program-with-bash-powershell\pwsh
   ```
3. **Permitir la ejecución temporal de scripts (solo durante la sesión actual):**
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
4. **Ejecutar el menú principal:**
   ```powershell
   .\admin_tools.ps1
   ```

> **Notas:**
> - También es posible ejecutar `admin_tools.ps1` directamente con `powershell -ExecutionPolicy Bypass -File .\admin_tools.ps1`.
> - Las opciones del menú invocan los módulos individuales ubicados en la misma carpeta.

### Descripción de los Scripts PowerShell

- `admin_tools.ps1`: menú interactivo que orquesta las cinco funcionalidades disponibles.
- `user_logon_registry.ps1`: lista usuarios locales habilitados y su último inicio de sesión, utilizando `Get-LocalUser` cuando está disponible.
- `all_disks.ps1`: muestra información detallada de los discos lógicos detectados (tipo de unidad, tamaño total, espacio libre y porcentaje).
- `top_files.ps1`: solicita una ruta y lista los 10 archivos más grandes encontrados, manejando errores de permisos o rutas inexistentes.
- `memory_swap.ps1`: genera un reporte del uso de memoria física y de la memoria virtual (swap/pagefile) en bytes y porcentaje.
- `back_up_to.ps1`: guía al usuario para seleccionar una unidad USB, crea un directorio de respaldo con sello de tiempo, genera un catálogo CSV y realiza la copia (preferiblemente con Robocopy).

## Funcionalidades Detalladas

### 1. Usuarios del Sistema
- Muestra todos los usuarios creados en el sistema
- Fecha y hora del último ingreso (login)
- Estado del usuario

### 2. Filesystems y Discos
- Lista todos los discos y particiones montados
- Tamaño total de cada disco (en bytes)
- Espacio libre disponible (en bytes)
- Porcentaje de uso

### 3. Archivos Más Grandes
- Solicita al usuario especificar un filesystem o directorio
- Busca y lista los 10 archivos más grandes
- Muestra la ruta completa de cada archivo
- Tamaño en bytes

### 4. Memoria y Swap
- Memoria RAM libre (bytes y porcentaje)
- Espacio swap total y en uso (bytes y porcentaje)
- Información detallada del sistema

### 5. Backup a USB
- Copia de seguridad de directorios a dispositivo USB
- Generación automática de catálogo con:
  - Nombre de archivos respaldados
  - Fecha de última modificación
  - Tamaño de cada archivo
- Verificación de integridad

## Equipo de Desarrollo

- Geoffrey (Geoffrey0pv)

## Información del Proyecto

- **Curso:** Sistemas Operativos
- **Fecha de entrega:** 13 de noviembre de 2025
- **Universidad:** (Agregar nombre de la universidad)

## Requisitos del Sistema

### Bash
- Sistema operativo: Linux (cualquier distribución)
- Bash 4.0 o superior
- Permisos de superusuario para algunas funciones

### PowerShell
- Sistema operativo: Windows 10/11 o Windows Server
- PowerShell 5.1 o superior

## Tecnologías Utilizadas

- **Bash Scripting**: Para la versión Linux
- **PowerShell**: Para la versión Windows
- **Git/GitHub**: Control de versiones y documentación

## Licencia

Este proyecto es de código abierto y está disponible para fines educativos.

## Contribuciones

Este es un proyecto académico. Para sugerencias o mejoras, por favor contactar al equipo de desarrollo.

---
**Fecha de creación:** Noviembre 2025
