#!/bin/bash
#==============================================================================
# Módulo: Archivos Más Grandes
# Descripción: Despliega el nombre y tamaño de los diez archivos más grandes
#              almacenados en un disco o filesystem especificado por el usuario.
#              Los archivos aparecen con su trayectoria completa.
#==============================================================================

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  DIEZ ARCHIVOS MÁS GRANDES${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# Mostrar filesystems disponibles
echo -e "${YELLOW}Filesystems disponibles:${NC}"
echo ""
df -h | grep -v "^tmpfs" | grep -v "^devtmpfs" | grep -v "^squashfs" | awk '{print "  " $NF}' | grep -v "Mounted"
echo ""

# Solicitar al usuario el filesystem o directorio
read -p "Ingrese el filesystem o directorio a analizar (ejemplo: / o /home): " target_path

# Validar que el directorio existe
if [ ! -d "$target_path" ]; then
    echo -e "${RED}Error: El directorio '$target_path' no existe.${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Buscando los 10 archivos más grandes en: ${CYAN}$target_path${NC}"
echo -e "${YELLOW}Por favor espere, esto puede tomar unos momentos...${NC}"
echo ""

# Encabezado de la tabla
printf "%-15s %-80s\n" "TAMAÑO (bytes)" "RUTA COMPLETA DEL ARCHIVO"
echo "------------------------------------------------------------------------------------------------"

# Buscar los 10 archivos más grandes
# -type f: solo archivos (no directorios)
# -printf: formato personalizado para obtener tamaño y ruta
# sort -rn: ordenar numéricamente en orden descendente
# head -10: tomar los primeros 10

find "$target_path" -type f -printf "%s %p\n" 2>/dev/null | \
    sort -rn | \
    head -10 | \
    while read size filepath; do
        # Formatear la salida
        printf "${CYAN}%-15s${NC} %-80s\n" "$size" "$filepath"
    done

# Si no se encontraron archivos
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo -e "${RED}No se pudieron encontrar archivos en el directorio especificado.${NC}"
fi

echo ""
echo -e "${BLUE}============================================================${NC}"
echo -e "${YELLOW}Nota:${NC}"
echo "  - Los tamaños están expresados en bytes"
echo "  - Se muestran las rutas completas de los archivos"
echo "  - Se excluyen directorios, solo se analizan archivos regulares"
echo -e "${BLUE}============================================================${NC}"
