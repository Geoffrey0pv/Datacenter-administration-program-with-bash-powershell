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
- (En desarrollo)

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
├── powershell/
│   └── (En desarrollo)
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
