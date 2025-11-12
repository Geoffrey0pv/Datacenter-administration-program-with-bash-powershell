#!/bin/bash
#==============================================================================
# Módulo: Filesystems y Discos
# Descripción: Despliega los filesystems o discos conectados a la máquina
#              Incluye para cada disco su tamaño y cantidad de espacio libre
#              (en bytes)
#==============================================================================

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  FILESYSTEMS Y DISCOS CONECTADOS${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# Encabezado de la tabla
printf "%-25s %-15s %-20s %-20s %-10s\n" "FILESYSTEM" "TIPO" "TAMAÑO (bytes)" "ESPACIO LIBRE (bytes)" "USO %"
echo "------------------------------------------------------------------------------------------------"

# Obtener información de filesystems usando df
# -B1 = mostrar en bytes
# -x tmpfs -x devtmpfs -x squashfs = excluir sistemas temporales
# -T = mostrar tipo de filesystem

df -B1 -T | grep -v "^tmpfs" | grep -v "^devtmpfs" | grep -v "^squashfs" | grep -v "^Filesystem" | while read filesystem type size used avail percent mountpoint; do
    # Limpiar el porcentaje de uso
    percent_clean=$(echo "$percent" | tr -d '%')
    
    # Formatear el tamaño y espacio libre para mejor legibilidad
    size_formatted="$size"
    avail_formatted="$avail"
    
    # Color según el porcentaje de uso
    if [ "$percent_clean" -ge 90 ]; then
        color=$RED
    elif [ "$percent_clean" -ge 70 ]; then
        color=$YELLOW
    else
        color=$GREEN
    fi
    
    printf "${CYAN}%-25s${NC} %-15s %-20s %-20s ${color}%-10s${NC}\n" \
        "$filesystem" "$type" "$size_formatted" "$avail_formatted" "$percent"
done

echo ""
echo -e "${YELLOW}Información adicional de discos físicos:${NC}"
echo "------------------------------------------------------------------------------------------------"

# Mostrar información de discos físicos con lsblk
echo ""
lsblk -b -o NAME,SIZE,TYPE,MOUNTPOINT 2>/dev/null | head -20

echo ""
echo -e "${BLUE}============================================================${NC}"
echo -e "${YELLOW}Leyenda:${NC}"
echo "  - Tamaño: Capacidad total del filesystem en bytes"
echo "  - Espacio libre: Bytes disponibles para uso"
echo "  - Uso %: Porcentaje del espacio utilizado"
echo -e "${BLUE}============================================================${NC}"
