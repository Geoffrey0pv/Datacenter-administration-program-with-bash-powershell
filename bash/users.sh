#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}  USUARIOS DEL SISTEMA Y ÚLTIMO INGRESO${NC}"
echo -e "${BLUE}============================================================${NC}"
echo ""

printf "%-20s %-30s %-20s\n" "USUARIO" "ÚLTIMO INGRESO" "ESTADO"
echo "--------------------------------------------------------------------"

username="root"
last_login=$(lastlog -u "$username" 2>/dev/null | tail -1 | awk '{
    if ($2 == "Never") {
        print "Nunca ha ingresado"
    } else {
        for(i=4; i<=NF; i++) printf "%s ", $i
        print ""
    }
}')

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

while IFS=: read -r username _ uid _ _ homedir shell; do
    if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ]; then
        if [[ "$shell" != *"nologin"* ]] && [[ "$shell" != *"false"* ]]; then
            last_login=$(lastlog -u "$username" 2>/dev/null | tail -1 | awk '{
                if ($2 == "Never") {
                    print "Nunca ha ingresado"
                } else {
                    for(i=4; i<=NF; i++) printf "%s ", $i
                    print ""
                }
            }')
            
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
            
            status="Activo"
            
            printf "${CYAN}%-20s${NC} %-30s %-20s\n" "$username" "$last_login" "$status"
        fi
    fi
done < /etc/passwd

echo ""
echo -e "${YELLOW}Total de usuarios mostrados: $(grep -c "^[^:]*:[^:]*:[1-9][0-9][0-9][0-9]:" /etc/passwd)${NC}"
echo ""
echo -e "${BLUE}============================================================${NC}"
