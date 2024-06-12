#!/bin/bash

echo -e "\n${AZUL}---------------------------| Análisis de datos | ---------------------------${RESET}"

# Solicitar al usuario los nombres de los archivos
read -p "Introduce el nombre del archivo de palabras: " -r words_file
while [ ! -f "$words_file" ] ; do
    echo -e "${ROJO}El archivo de palabras no existe.${RESET}"
    read -p "Introduce el nombre del archivo de palabras: " -r words_file
done

read -p "Introduce el nombre del archivo de correos electrónicos: " -r emails_file
while [ ! -f "$emails_file" ] ; do
    echo -e "${ROJO}El archivo de correos electrónicos no existe.${RESET}"
    read -p "Introduce el nombre del archivo de correos electrónicos: " -r emails_file
done

read -p "Introduce el nombre del archivo de salida: " -r output_file
while [ -f "$output_file" ] ; do
    echo -e "${ROJO}El archivo de salida ya existe.${RESET}"
    read -p "¿Desea sobrescribirlo? (s/n): " -r overwrite
    if [[ $overwrite =~ ^[Ss]$ ]]; then
        rm "$output_file"
    else
        read -p "Introduce un nuevo nombre para el archivo de salida: " -r output_file
    fi
done

# Comprueba si el fichero de salida tiene la extensión freq, en caso de que no lo tenga se la añade
if [[ ! "$output_file" == *.freq ]]; then
    output_file="$output_file.freq"
fi

# Leer el archivo de palabras y almacenar las palabras en una matriz
mapfile -t words < "$words_file"

# Leer el archivo de correos electrónicos y almacenar los correos electrónicos en una matriz
mapfile -t emails < "$emails_file"

# Crear una matriz vacía para almacenar los resultados
declare -A matrix

# Para cada correo electrónico en la matriz de correos electrónicos
for i in "${!emails[@]}"; do
    # Extraer el ID y el contenido del correo electrónico
    id=$(echo "${emails[$i]}" | cut -d'|' -f1)
    content=$(echo "${emails[$i]}" | cut -d'|' -f2)
    label=$(echo "${emails[$i]}" | cut -d'|' -f3)

    # Convertir el contenido a minúsculas y eliminar signos de puntuación
    content=$(echo "$content" | tr -d '[:punct:]' | tr '[:upper:]' '[:lower:]')

    # Calcular el total de palabras en el contenido del correo electrónico
    total_words=$(echo "$content" | wc -w)

    # Agregar el ID y el total de palabras a la matriz
    matrix[$i,0]="$id:$total_words"
    matrix[$i,1]=$label

    # Para cada palabra en la matriz de palabras
    for j in "${!words[@]}"; do
        # Calcular la frecuencia de la palabra en el contenido del correo electrónico
        freq=$(grep -o -i -w "${words[$j]}" <<< "$content" | wc -l)

        # Agregar la frecuencia a la matriz
        matrix[$i,$((j+2))]=$freq
    done
done

# Header del archivo de salida
{
    echo -n "ID,spam/ham,"
    printf "%s," "${words[@]}"
    echo ""
} > "$output_file"

# Escribir los resultados en el archivo de salida
for i in "${!emails[@]}"; do
    {
        echo -n "${matrix[$i,0]},${matrix[$i,1]},"
        for j in "${!words[@]}"; do
            echo -n "${matrix[$i,$((j+2))]}"
            if (( j < ${#words[@]}-1 )); then
                echo -n ","
            fi
        done
        echo ""
    } >> "$output_file"
done

# Informar al usuario que el análisis ha finalizado
echo -e "${VERDE}Análisis completado. Los resultados se han guardado en $output_file.${RESET}"

analisys_done=1

# Almacenar el archivo de salida en un archivo global para que pueda ser mostrado en la opción 6 del menú
freq_file=$output_file
