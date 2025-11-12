#!/bin/bash
#==============================================================================
# Módulo: Usuarios del Sistema
# Descripción: Despliega todos los usuarios creados en el sistema y 
#              la fecha y hora de su último ingreso (login)
#==============================================================================

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  USUARIOS DEL SISTEMA Y ÚLTIMO INGRESO${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

# Encabezado de la tabla
printf "%-20s %-30s %-20s\n" "USUARIO" "ÚLTIMO INGRESO" "ESTADO"
echo "--------------------------------------------------------------------"

# Obtener lista de usuarios del sistema (usuarios con UID >= 1000 y root)
# y mostrar su último ingreso

# Primero mostramos root
username="root"
# Obtener el último login usando lastlog
last_login=$(lastlog -u "$username" 2>/dev/null | tail -1 | awk '{
    if ($2 == "Never") {
        print "Nunca ha ingresado"
    } else {
        # Extraer la fecha del último login
        for(i=4; i<=NF; i++) printf "%s ", $i
        print ""
    }
}')

# Si lastlog no funciona, usar last como alternativa
if [ -z "$last_login" ] || [ "$last_login" = "**Never logged in**" ]; then
    last_login=$(last -1 "$username" 2>/dev/null | head -1 | awk '{
        if ($1 == "") {
            print "Nunca ha ingresado"
        } else {
            for(i=4; i<=7; i++) printf "%s ", $i
            print ""
        }
    }')
    if [ -z "$last_login" ]; then
        last_login="Nunca ha ingresado"
    fi
fi

printf "${CYAN}%-20s${NC} %-30s %-20s\n" "$username" "$last_login" "Activo"

# Obtener usuarios regulares (UID >= 1000)
while IFS=: read -r username _ uid _ _ homedir shell; do
    # Filtrar usuarios del sistema (UID < 1000) excepto root
    if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ]; then
        # Verificar si el usuario tiene un shell válido (no nologin)
        if [[ "$shell" != *"nologin"* ]] && [[ "$shell" != *"false"* ]]; then
            # Obtener el último login usando lastlog
            last_login=$(lastlog -u "$username" 2>/dev/null | tail -1 | awk '{
                if ($2 == "Never") {
                    print "Nunca ha ingresado"
                } else {
                    # Extraer la fecha del último login
                    for(i=4; i<=NF; i++) printf "%s ", $i
                    print ""
                }
            }')
            
            # Si lastlog no funciona, usar last como alternativa
            if [ -z "$last_login" ] || [ "$last_login" = "**Never logged in**" ]; then
                last_login=$(last -1 "$username" 2>/dev/null | head -1 | awk '{
                    if ($1 == "") {
                        print "Nunca ha ingresado"
                    } else {
                        for(i=4; i<=7; i++) printf "%s ", $i
                        print ""
                    }
                }')
                if [ -z "$last_login" ]; then
                    last_login="Nunca ha ingresado"
                fi
            fi
            
            # Determinar estado del usuario
            status="Activo"
            
            printf "${CYAN}%-20s${NC} %-30s %-20s\n" "$username" "$last_login" "$status"
        fi
    fi
done < /etc/passwd

echo ""
echo -e "${YELLOW}Total de usuarios mostrados: $(grep -c "^[^:]*:[^:]*:[1-9][0-9][0-9][0-9]:" /etc/passwd)${NC}"
echo ""
echo -e "${BLUE}============================================================${NC}"
