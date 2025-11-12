#!/bin/bash
#==============================================================================
# Script de Instalación
# Descripción: Configura permisos de ejecución para todos los módulos
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Configurando permisos de ejecución para Data Center Administration Tool..."
echo ""

# Dar permisos al script principal
chmod +x "$SCRIPT_DIR/admin_tool.sh"
echo "✓ Permisos configurados: admin_tool.sh"

# Dar permisos a todos los módulos
if [ -f "$SCRIPT_DIR/users/users.sh" ]; then
    chmod +x "$SCRIPT_DIR/users/users.sh"
    echo "✓ Permisos configurados: users/users.sh"
fi

if [ -f "$SCRIPT_DIR/filesystems/filesystems.sh" ]; then
    chmod +x "$SCRIPT_DIR/filesystems/filesystems.sh"
    echo "✓ Permisos configurados: filesystems/filesystems.sh"
fi

if [ -f "$SCRIPT_DIR/largest_files/largest_files.sh" ]; then
    chmod +x "$SCRIPT_DIR/largest_files/largest_files.sh"
    echo "✓ Permisos configurados: largest_files/largest_files.sh"
fi

if [ -f "$SCRIPT_DIR/memory/memory.sh" ]; then
    chmod +x "$SCRIPT_DIR/memory/memory.sh"
    echo "✓ Permisos configurados: memory/memory.sh"
fi

if [ -f "$SCRIPT_DIR/backup/backup.sh" ]; then
    chmod +x "$SCRIPT_DIR/backup/backup.sh"
    echo "✓ Permisos configurados: backup/backup.sh"
fi

echo ""
echo "Instalación completada!"
echo "Ejecute el programa con: sudo ./admin_tool.sh"
