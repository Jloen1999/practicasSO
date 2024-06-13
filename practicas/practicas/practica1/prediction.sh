#!/bin/bash

echo -e "\n${AZUL}---------------------------| Análisis TF-IDF | ---------------------------${RESET}"

crearTfidf=0
existTfidf=0

read -p "¿Acaba de realizar el análisis (s/n)? " -r answer
if ! [[ $answer =~ ^[Ss]$ ]]; then
    read -p "Introduce el nombre del archivo de frecuencias: " -r freq_file
    if [ ! -f "$freq_file" ]; then
        echo -e "${ROJO}El archivo de frecuencias no existe.${RESET}"
        source practica1.sh
    else
        crearTfidf=1

      # Comprobar si existe el fichero tfidf
      tfidf_file="${freq_file%.freq}.tfidf"
      if [ -f "$tfidf_file" ]; then
          read -p "El archivo $tfidf_file ya existe. ¿Desea cargar sus datos? (s/n): " -r load
          if [[ $load =~ ^[Ss]$ ]]; then
              # Leer los encabezados del archivo .tfidf
              IFS=',' read -r -a headers < "$tfidf_file"
              IFS=' ' read -r -a words <<< "${headers[@]:2}"  # Dividir los encabezados en palabras individuales
              # Cargar los datos de TF-IDF en la matriz, omitiendo la primera línea
              declare -A tfidf_matrix  # Cambiado de freq_matrix a tfidf_matrix
              i=0
              while IFS=',' read -r -a line; do
                  for j in "${!line[@]}"; do
                      tfidf_matrix[$i,$j]=${line[$j]}  # Cambiado de freq_matrix a tfidf_matrix
                  done
                  ((i++))
              done < <(tail -n +2 "$tfidf_file")

              # Obtener el número total de correos electrónicos
              num_emails=$i

              echo -e "${VERDE}Datos cargados desde $tfidf_file.${RESET}"
          fi

          existTfidf=1

      fi

    fi

else
    crearTfidf=1
fi

if [[ -z $analisys_done ]] && [ $existTfidf -eq 0 ]; then
    echo -e "${ROJO}No se ha realizado el análisis de frecuencias.${RESET}"
    source practica1.sh
fi

# Leer los encabezados del archivo de frecuencias
IFS=',' read -r -a headers < "$freq_file"
IFS=' ' read -r -a words <<< "${headers[@]:2}"  # Dividir los encabezados en palabras individuales
# Cargar los datos de frecuencia en la matriz, omitiendo la primera línea
declare -A freq_matrix
i=0
while IFS=',' read -r -a line; do
    for j in "${!line[@]}"; do
        freq_matrix[$i,$j]=${line[$j]}
    done
    ((i++))
done < <(tail -n +2 "$freq_file")

# Obtener el número total de correos electrónicos
num_emails=$i

# Crear una matriz para almacenar el TF y el IDF
declare -A tf_matrix
declare -A idf_matrix

# Calcular TF y IDF
for ((j=0; j<${#words[@]}; j++)); do
    # Calcular el número de correos electrónicos que contienen la palabra
    num_emails_with_word=0
    for ((i=0; i<num_emails; i++)); do
        if [ "${freq_matrix[$i,$((j+2))]}" -gt 0 ]; then
            ((num_emails_with_word++))
        fi
    done

    # Comprobar que el número de correos electrónicos con la palabra es mayor que 0
    if [ $num_emails_with_word -gt 0 ]; then
        idf=$(echo "scale=4; l($num_emails/($num_emails_with_word))/l(10)" | bc -l)
    else
        # Establecer el IDF en 0 si la palabra no aparece en ningún correo electrónico
        idf=0
    fi

    idf_matrix[$j]=$idf

    # Calcular el TF para cada correo electrónico
    for ((i=0; i<num_emails; i++)); do
        email_id=$(echo "${freq_matrix[$i,0]}" | cut -d':' -f1)
        total_words=$(echo "${freq_matrix[$i,0]}" | cut -d':' -f2)

        # Comprobar que el número total de palabras es mayor que 0
        if [ $total_words -eq 0 ]; then
          tf=0
        else
          tf=$(echo "scale=4; ${freq_matrix[$i,$((j+2))]} / $total_words" | bc -l)
        fi

        tf_matrix[$i,$j]=$tf
    done

done

# Calcular la métrica TF-IDF y almacenarla en la matriz tfidf_matrix, y calcular la media de los valores de TF-IDF para cada correo electrónico
declare -A tfidf_matrix
declare -A tfidf_avg
for ((i=0; i<num_emails; i++)); do
    sum=0
    for ((j=0; j<${#words[@]}; j++)); do
        tfidf_matrix[$i,$j]=$(echo "scale=4; ${tf_matrix[$i,$j]} * ${idf_matrix[$j]}" | bc -l)
        sum=$(echo "$sum + ${tfidf_matrix[$i,$j]}" | bc -l)
    done
    tfidf_avg[$i]=$(echo "scale=4; $sum / ${#words[@]}" | bc -l)
done

# Modificar los valores de la segunda columna (spam/ham) de la matriz freq_matrix
for ((i=0; i<num_emails; i++)); do
    if (( $(echo "${tfidf_avg[$i]} < 0.3" | bc -l) )); then
        freq_matrix[$i,1]=ham  # ham
    else
        freq_matrix[$i,1]=spam  # spam
    fi
done

# Guardar los resultados en un archivo .tfidf, incluyendo la media de los valores de TF-IDF para cada correo electrónico
tfidf_file="${freq_file%.freq}.tfidf"
{
    echo -n "ID,spam/ham,"
    printf "%s," "${words[@]}"
    echo "Media TF-IDF"
} > "$tfidf_file"

for ((i=0; i<num_emails; i++)); do
    {
        echo -n "${freq_matrix[$i,0]},${freq_matrix[$i,1]},"
        for ((j=0; j<${#words[@]}; j++)); do
            echo -n "${tfidf_matrix[$i,$j]}"
            if (( j < ${#words[@]} )); then
                echo -n ","
            fi
        done
        echo "${tfidf_avg[$i]}"
    } >> "$tfidf_file"
done

if [ $crearTfidf -eq 1 ]; then
    echo -e "${VERDE}Análisis TF-IDF completado. Los resultados se han guardado en $tfidf_file.${RESET}"
fi


