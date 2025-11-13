#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  BACKUP DE DIRECTORIO A USB${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

validate_directory() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo -e "${RED}Error: El directorio '$dir' no existe.${NC}"
        return 1
    fi
    if [ ! -r "$dir" ]; then
        echo -e "${RED}Error: No tiene permisos de lectura en '$dir'.${NC}"
        return 1
    fi
    return 0
}

create_catalog() {
    local source_dir=$1
    local catalog_file=$2
    
    echo "# CATÁLOGO DE BACKUP" > "$catalog_file"
    echo "# Generado: $(date '+%Y-%m-%d %H:%M:%S')" >> "$catalog_file"
    echo "# Directorio origen: $source_dir" >> "$catalog_file"
    echo "#" >> "$catalog_file"
    echo "# Formato: TAMAÑO (bytes) | FECHA_MODIFICACIÓN | NOMBRE_ARCHIVO" >> "$catalog_file"
    echo "======================================================================" >> "$catalog_file"
    echo "" >> "$catalog_file"
    
    find "$source_dir" -type f -printf "%s|%TY-%Tm-%Td %TH:%TM:%TS|%p\n" 2>/dev/null | \
        sort -t'|' -k3 | \
        while IFS='|' read -r size datetime filepath; do
            printf "%-15s | %-20s | %s\n" "$size" "$datetime" "$filepath" >> "$catalog_file"
        done
    
    echo "" >> "$catalog_file"
    echo "======================================================================" >> "$catalog_file"
    echo "# Total de archivos: $(find "$source_dir" -type f 2>/dev/null | wc -l)" >> "$catalog_file"
    echo "# Tamaño total: $(du -sb "$source_dir" 2>/dev/null | awk '{print $1}') bytes" >> "$catalog_file"
}

echo -e "${YELLOW}Dispositivos de almacenamiento disponibles:${NC}"
echo ""
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,LABEL | grep -E "disk|part"
echo ""

read -p "Ingrese la ruta del directorio a respaldar: " source_dir

if ! validate_directory "$source_dir"; then
    exit 1
fi

echo ""
echo -e "${YELLOW}Opciones:${NC}"
echo "  1. Especificar punto de montaje USB (ej: /media/usb, /mnt/usb)"
echo "  2. Especificar ruta completa de destino"
echo ""
read -p "Ingrese la ruta de destino para el backup: " dest_dir

if [ ! -d "$dest_dir" ]; then
    echo -e "${YELLOW}El directorio de destino no existe.${NC}"
    read -p "¿Desea crearlo? (s/n): " create_dest
    if [ "$create_dest" = "s" ] || [ "$create_dest" = "S" ]; then
        mkdir -p "$dest_dir" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error: No se pudo crear el directorio de destino.${NC}"
            echo -e "${YELLOW}Intente con sudo o verifique permisos.${NC}"
            exit 1
        fi
        echo -e "${GREEN}Directorio creado exitosamente.${NC}"
    else
        echo -e "${RED}Operación cancelada.${NC}"
        exit 1
    fi
fi

# Verificar que el destino es escribible
if [ ! -w "$dest_dir" ]; then
    echo -e "${RED}Error: No tiene permisos de escritura en '$dest_dir'.${NC}"
    exit 1
fi

# Crear nombre único para el backup
backup_name="backup_$(basename "$source_dir")_$(date '+%Y%m%d_%H%M%S')"
backup_path="$dest_dir/$backup_name"

mkdir -p "$backup_path"

echo ""
echo -e "${YELLOW}Iniciando backup...${NC}"
echo -e "${CYAN}Origen:${NC} $source_dir"
echo -e "${CYAN}Destino:${NC} $backup_path"
echo ""

source_size=$(du -sb "$source_dir" 2>/dev/null | awk '{print $1}')
echo -e "${YELLOW}Tamaño a respaldar:${NC} $source_size bytes ($(du -sh "$source_dir" 2>/dev/null | awk '{print $1}'))"
echo ""

if command -v rsync &> /dev/null; then
    echo -e "${GREEN}Usando rsync para copia eficiente...${NC}"
    rsync -av --progress "$source_dir/" "$backup_path/" 2>&1 | \
        grep -E "sent|received|total size" | tail -3
    copy_result=${PIPESTATUS[0]}
else
    echo -e "${GREEN}Copiando archivos con cp...${NC}"
    cp -r "$source_dir"/* "$backup_path/" 2>&1
    copy_result=$?
fi

if [ $copy_result -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Copia de archivos completada exitosamente.${NC}"
    
    catalog_file="$backup_path/CATALOG.txt"
    echo ""
    echo -e "${YELLOW}Generando catálogo de archivos...${NC}"
    create_catalog "$source_dir" "$catalog_file"
    
    if [ -f "$catalog_file" ]; then
        echo -e "${GREEN}✓ Catálogo creado: $catalog_file${NC}"
        
        echo ""
        echo -e "${CYAN}Resumen del catálogo:${NC}"
        total_files=$(find "$source_dir" -type f 2>/dev/null | wc -l)
        total_size=$(du -sb "$source_dir" 2>/dev/null | awk '{print $1}')
        echo "  - Total de archivos respaldados: $total_files"
        echo "  - Tamaño total: $total_size bytes ($(du -sh "$source_dir" 2>/dev/null | awk '{print $1}'))"
        
        echo ""
        echo -e "${YELLOW}Generando checksums para verificación de integridad...${NC}"
        find "$backup_path" -type f ! -name "CATALOG.txt" ! -name "CHECKSUMS.md5" -exec md5sum {} \; > "$backup_path/CHECKSUMS.md5" 2>/dev/null
        if [ -f "$backup_path/CHECKSUMS.md5" ]; then
            echo -e "${GREEN}✓ Checksums creados: $backup_path/CHECKSUMS.md5${NC}"
        fi
    else
        echo -e "${RED}✗ Error al crear el catálogo.${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${GREEN}  BACKUP COMPLETADO EXITOSAMENTE${NC}"
    echo -e "${BLUE}============================================================${NC}"
    echo ""
    echo -e "${CYAN}Ubicación del backup:${NC}"
    echo "  $backup_path"
    echo ""
    echo -e "${CYAN}Archivos generados:${NC}"
    echo "  1. Directorio con todos los archivos respaldados"
    echo "  2. CATALOG.txt - Catálogo con nombres y fechas"
    echo "  3. CHECKSUMS.md5 - Checksums para verificación"
    echo ""
    echo -e "${YELLOW}Para verificar la integridad del backup más tarde:${NC}"
    echo "  cd $backup_path"
    echo "  md5sum -c CHECKSUMS.md5"
    echo ""
    
    echo -e "${CYAN}Vista previa del catálogo (primeras 10 líneas):${NC}"
    head -20 "$catalog_file"
    echo "  ..."
    
else
    echo ""
    echo -e "${RED}✗ Error durante la copia de archivos.${NC}"
    echo -e "${YELLOW}Verifique permisos y espacio disponible.${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}============================================================${NC}"
