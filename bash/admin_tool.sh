#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_menu() {
    clear
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${GREEN}    DATA CENTER ADMINISTRATION TOOL${NC}"
    echo -e "${BLUE}============================================================${NC}"
    echo ""
    echo "  1. Usuarios del sistema y último ingreso"
    echo "  2. Filesystems y discos conectados"
    echo "  3. Diez archivos más grandes en un disco"
    echo "  4. Memoria libre y espacio swap"
    echo "  5. Backup de directorio a USB"
    echo "  6. Salir"
    echo ""
    echo -e "${BLUE}============================================================${NC}"
}

pause() {
    echo ""
    read -p "Presione ENTER para continuar..."
}

main() {
    while true; do
        show_menu
        read -p "Seleccione una opción [1-6]: " option
        
        case $option in
            1)
                echo -e "\n${YELLOW}Ejecutando: Usuarios del sistema...${NC}\n"
                bash "$SCRIPT_DIR/users.sh"
                pause
                ;;
            2)
                echo -e "\n${YELLOW}Ejecutando: Filesystems y discos...${NC}\n"
                bash "$SCRIPT_DIR/filesystems.sh"
                pause
                ;;
            3)
                echo -e "\n${YELLOW}Ejecutando: Archivos más grandes...${NC}\n"
                bash "$SCRIPT_DIR/largest_files.sh"
                pause
                ;;
            4)
                echo -e "\n${YELLOW}Ejecutando: Memoria y swap...${NC}\n"
                bash "$SCRIPT_DIR/memory.sh"
                pause
                ;;
            5)
                echo -e "\n${YELLOW}Ejecutando: Backup a USB...${NC}\n"
                bash "$SCRIPT_DIR/backup.sh"
                pause
                ;;
            6)
                echo -e "\n${GREEN}Saliendo del programa...${NC}\n"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Opción inválida. Por favor seleccione una opción del 1 al 6.${NC}"
                sleep 2
                ;;
        esac
    done
}

main
