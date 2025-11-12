#!/bin/bash
#==============================================================================
# Script de Prueba - Data Center Administration Tool
# Descripción: Verifica que todos los módulos están correctamente instalados
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}  VERIFICACIÓN DEL SISTEMA${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# Contador de errores
errors=0

# Función para verificar archivo
check_file() {
    local file=$1
    local name=$2
    
    if [ -f "$file" ]; then
        if [ -x "$file" ]; then
            echo -e "${GREEN}✓${NC} $name - OK (ejecutable)"
        else
            echo -e "${YELLOW}⚠${NC} $name - Existe pero no es ejecutable"
            ((errors++))
        fi
    else
        echo -e "${RED}✗${NC} $name - NO ENCONTRADO"
        ((errors++))
    fi
}

echo -e "${YELLOW}Verificando archivos del proyecto...${NC}"
echo ""

# Verificar script principal
check_file "$SCRIPT_DIR/admin_tool.sh" "Script principal"

# Verificar módulos
check_file "$SCRIPT_DIR/users/users.sh" "Módulo de usuarios"
check_file "$SCRIPT_DIR/filesystems/filesystems.sh" "Módulo de filesystems"
check_file "$SCRIPT_DIR/largest_files/largest_files.sh" "Módulo de archivos grandes"
check_file "$SCRIPT_DIR/memory/memory.sh" "Módulo de memoria"
check_file "$SCRIPT_DIR/backup/backup.sh" "Módulo de backup"

echo ""
echo -e "${YELLOW}Verificando comandos del sistema...${NC}"
echo ""

# Verificar comandos necesarios
commands=("df" "du" "find" "grep" "awk" "sort" "last" "lastlog" "lsblk" "free")

for cmd in "${commands[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} Comando '$cmd' disponible"
    else
        echo -e "${RED}✗${NC} Comando '$cmd' NO ENCONTRADO"
        ((errors++))
    fi
done

# Verificar comando opcional
echo ""
if command -v rsync &> /dev/null; then
    echo -e "${GREEN}✓${NC} rsync disponible (recomendado para backups)"
else
    echo -e "${YELLOW}⚠${NC} rsync no disponible (se usará cp como alternativa)"
fi

echo ""
echo -e "${YELLOW}Verificando permisos de lectura...${NC}"
echo ""

# Verificar acceso a archivos del sistema
if [ -r "/proc/meminfo" ]; then
    echo -e "${GREEN}✓${NC} Acceso a /proc/meminfo"
else
    echo -e "${RED}✗${NC} Sin acceso a /proc/meminfo"
    ((errors++))
fi

if [ -r "/etc/passwd" ]; then
    echo -e "${GREEN}✓${NC} Acceso a /etc/passwd"
else
    echo -e "${RED}✗${NC} Sin acceso a /etc/passwd"
    ((errors++))
fi

echo ""
echo -e "${BLUE}============================================================${NC}"

if [ $errors -eq 0 ]; then
    echo -e "${GREEN}  ✓ VERIFICACIÓN COMPLETA - TODO OK${NC}"
    echo -e "${BLUE}============================================================${NC}"
    echo ""
    echo -e "El sistema está listo para usarse."
    echo -e "Ejecute: ${YELLOW}sudo ./admin_tool.sh${NC}"
    exit 0
else
    echo -e "${RED}  ✗ VERIFICACIÓN FALLIDA - $errors ERROR(ES)${NC}"
    echo -e "${BLUE}============================================================${NC}"
    echo ""
    echo -e "Por favor corrija los errores antes de ejecutar el programa."
    echo -e "Ejecute: ${YELLOW}./setup.sh${NC} para configurar permisos."
    exit 1
fi
