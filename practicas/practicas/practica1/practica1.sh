#!/bin/bash

# Definir colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AZUL='\033[0;34m'
RESET='\033[0m' # No Color

export ROJO VERDE AZUL RESET

freq_file=""
tfidf_file=""
# Definir el archivo de emails por defecto
mapfile -t emails < "Emails.txt"

username=$(whoami)
echo -e "\n${AZUL}---------------------------| Bienvenido $username | ---------------------------${RESET}"
while true
do
    echo -e "\n\t\t${AZUL}1${RESET}. Análisis de datos"
    echo -e "\t\t${AZUL}2${RESET}. Predicción"
    echo -e "\t\t${AZUL}3${RESET}. Informes de resultados"
    echo -e "\t\t${AZUL}4${RESET}. Ayuda"
    echo -e "\t\t${ROJO}5. Salir${RESET}"
    read -p "Introduce una opción: " -r opcion

    case $opcion in
        1)
            source analysis.sh
            ;;
        2)
            source prediction.sh
            ;;
        3)
            source reports.sh
            ;;
        4)
            source help.sh
            ;;
        5)
            echo -e "\n\t\t\t${AZUL}¡Hasta luego!${RESET}"
            break
            ;;
        *)
            echo "Opción no válida"
            ;;
    esac
done
