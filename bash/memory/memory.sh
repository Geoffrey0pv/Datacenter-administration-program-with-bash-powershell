#!/bin/bash
#==============================================================================
# Módulo: Memoria y Swap
# Descripción: Muestra la cantidad de memoria libre y cantidad del espacio 
#              de swap en uso (en bytes y porcentaje)
#==============================================================================

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  INFORMACIÓN DE MEMORIA Y SWAP${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# Obtener información de memoria usando /proc/meminfo (valores en KB)
# Convertir a bytes multiplicando por 1024

# Memoria Total
mem_total_kb=$(grep "^MemTotal:" /proc/meminfo | awk '{print $2}')
mem_total_bytes=$((mem_total_kb * 1024))

# Memoria Libre (MemFree + Buffers + Cached para una medida más precisa)
mem_free_kb=$(grep "^MemFree:" /proc/meminfo | awk '{print $2}')
mem_available_kb=$(grep "^MemAvailable:" /proc/meminfo | awk '{print $2}')
mem_free_bytes=$((mem_available_kb * 1024))

# Memoria en uso
mem_used_bytes=$((mem_total_bytes - mem_free_bytes))

# Calcular porcentaje de memoria libre
if [ $mem_total_bytes -gt 0 ]; then
    mem_free_percent=$(awk "BEGIN {printf \"%.2f\", ($mem_free_bytes / $mem_total_bytes) * 100}")
    mem_used_percent=$(awk "BEGIN {printf \"%.2f\", ($mem_used_bytes / $mem_total_bytes) * 100}")
else
    mem_free_percent="0.00"
    mem_used_percent="0.00"
fi

# Swap Total
swap_total_kb=$(grep "^SwapTotal:" /proc/meminfo | awk '{print $2}')
swap_total_bytes=$((swap_total_kb * 1024))

# Swap Libre
swap_free_kb=$(grep "^SwapFree:" /proc/meminfo | awk '{print $2}')
swap_free_bytes=$((swap_free_kb * 1024))

# Swap en uso
swap_used_bytes=$((swap_total_bytes - swap_free_bytes))

# Calcular porcentaje de swap en uso
if [ $swap_total_bytes -gt 0 ]; then
    swap_used_percent=$(awk "BEGIN {printf \"%.2f\", ($swap_used_bytes / $swap_total_bytes) * 100}")
    swap_free_percent=$(awk "BEGIN {printf \"%.2f\", ($swap_free_bytes / $swap_total_bytes) * 100}")
else
    swap_used_percent="0.00"
    swap_free_percent="0.00"
fi

# Función para convertir bytes a formato legible (opcional para referencia)
bytes_to_human() {
    local bytes=$1
    if [ $bytes -ge 1073741824 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $bytes / 1073741824}") GB"
    elif [ $bytes -ge 1048576 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $bytes / 1048576}") MB"
    elif [ $bytes -ge 1024 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $bytes / 1024}") KB"
    else
        echo "$bytes bytes"
    fi
}

# Mostrar información de MEMORIA RAM
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  MEMORIA RAM${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo ""
printf "%-30s : ${GREEN}%'20d${NC} bytes    (%s)\n" "Memoria Total" "$mem_total_bytes" "$(bytes_to_human $mem_total_bytes)"
printf "%-30s : ${CYAN}%'20d${NC} bytes    (%s)\n" "Memoria Libre" "$mem_free_bytes" "$(bytes_to_human $mem_free_bytes)"
printf "%-30s : ${RED}%'20d${NC} bytes    (%s)\n" "Memoria en Uso" "$mem_used_bytes" "$(bytes_to_human $mem_used_bytes)"
echo ""
printf "%-30s : ${GREEN}%s%%${NC}\n" "Porcentaje Libre" "$mem_free_percent"
printf "%-30s : ${RED}%s%%${NC}\n" "Porcentaje en Uso" "$mem_used_percent"

# Barra de progreso visual para memoria
echo ""
echo -n "Estado: ["
mem_used_bars=$(awk "BEGIN {printf \"%.0f\", $mem_used_percent / 2}")
mem_free_bars=$((50 - mem_used_bars))

# Color de la barra según el uso
if (( $(echo "$mem_used_percent > 90" | bc -l) )); then
    bar_color=$RED
elif (( $(echo "$mem_used_percent > 70" | bc -l) )); then
    bar_color=$YELLOW
else
    bar_color=$GREEN
fi

echo -ne "${bar_color}"
for ((i=0; i<mem_used_bars; i++)); do echo -n "█"; done
echo -ne "${NC}"
for ((i=0; i<mem_free_bars; i++)); do echo -n "░"; done
echo "] $mem_used_percent% usado"

echo ""
echo ""

# Mostrar información de SWAP
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  ESPACIO SWAP${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo ""

if [ $swap_total_bytes -eq 0 ]; then
    echo -e "${YELLOW}  ⚠ No hay espacio SWAP configurado en el sistema${NC}"
else
    printf "%-30s : ${GREEN}%'20d${NC} bytes    (%s)\n" "Swap Total" "$swap_total_bytes" "$(bytes_to_human $swap_total_bytes)"
    printf "%-30s : ${RED}%'20d${NC} bytes    (%s)\n" "Swap en Uso" "$swap_used_bytes" "$(bytes_to_human $swap_used_bytes)"
    printf "%-30s : ${CYAN}%'20d${NC} bytes    (%s)\n" "Swap Libre" "$swap_free_bytes" "$(bytes_to_human $swap_free_bytes)"
    echo ""
    printf "%-30s : ${RED}%s%%${NC}\n" "Porcentaje en Uso" "$swap_used_percent"
    printf "%-30s : ${GREEN}%s%%${NC}\n" "Porcentaje Libre" "$swap_free_percent"
    
    # Barra de progreso visual para swap
    echo ""
    echo -n "Estado: ["
    swap_used_bars=$(awk "BEGIN {printf \"%.0f\", $swap_used_percent / 2}")
    swap_free_bars=$((50 - swap_used_bars))
    
    # Color de la barra según el uso
    if (( $(echo "$swap_used_percent > 90" | bc -l) )); then
        bar_color=$RED
    elif (( $(echo "$swap_used_percent > 50" | bc -l) )); then
        bar_color=$YELLOW
    else
        bar_color=$GREEN
    fi
    
    echo -ne "${bar_color}"
    for ((i=0; i<swap_used_bars; i++)); do echo -n "█"; done
    echo -ne "${NC}"
    for ((i=0; i<swap_free_bars; i++)); do echo -n "░"; done
    echo "] $swap_used_percent% usado"
fi

echo ""
echo ""
echo -e "${BLUE}============================================================${NC}"
echo -e "${YELLOW}Información adicional del sistema:${NC}"
echo ""
free -h
echo ""
echo -e "${BLUE}============================================================${NC}"
