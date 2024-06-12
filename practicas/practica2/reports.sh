#!/bin/bash

echo -e "\n${AZUL}---------------------------| Informe de resultados | ---------------------------${RESET}"
while true; do
    # Preguntar al usuario qué informe desea generar
    echo -e "\n\t\t${AZUL}1.${RESET} Informe de términos por correo electrónico"
    echo -e "\t\t${AZUL}2.${RESET} Informe de correos electrónicos por término"
    echo -e "\t\t${AZUL}3.${RESET} Informe de términos por identificador de correo electrónico"
    echo -e "\t\t${ROJO}4. Salir${RESET}"
    read -p "Elija una opción: " -r opcion

    IFS=' ' read -r -a words <<< "${headers[@]:2}"  # Dividir los encabezados en palabras individuales
    case $opcion in
        1)
           # Informe de términos por correo electrónico
               for ((j=0; j<${#words[@]}; j++)); do
                   count=0
                   for ((i=0; i<num_emails; i++)); do
                       if [ "${freq_matrix[$i,$((j+2))]}" -gt 0 ]; then
                           ((count++))
                       fi
                   done
                   echo -e "El término ${VERDE}${words[$j]}${RESET} aparece en $count correos electrónicos"
               done
               ;;
        2)
            # Informe de correos electrónicos por término
                    read -p "Introduce un término: " -r term
                    index=$(printf "%s\n" "${words[@]}" | grep -n -x "$term" | cut -d':' -f1)
                    if [ -z "$index" ]; then
                        echo -e "${ROJO}El término $term no existe.${RESET}"
                    else
                         count=0
                        for ((i=0; i<num_emails; i++)); do
                            if [ "${freq_matrix[$i,$((index+1))]}" -gt 0 ]; then
                                email_id=$(echo "${freq_matrix[$i,0]}" | cut -d':' -f1)
                                echo "ID: $email_id"
                                email_content=$(echo "${emails[$((email_id-1))]}" | cut -d'|' -f2)
                                # Mostrar el ID del correo electrónico y solo los 50 primeros caracteres del contenido del correo electrónico
                                echo "ID: $email_id, Contenido: ${email_content:0:50}..."
                                ((count++))
                            fi
                        done
                        echo -e "El término ${VERDE}$term ${RESET}aparece en $count correos electrónicos"
                    fi
                    ;;
        3)
             # Informe de términos por identificador de correo electrónico
             read -p "Introduce un identificador de correo electrónico: " -r id
             # Declarar array para almacenar los términos analizados
              declare -a analyzed_terms
             if [ "$id" -ge 1 ] && [ "$id" -le "$num_emails" ]; then
                 count=0
                 for ((j=0; j<${#words[@]}; j++)); do
                      if [ "${freq_matrix[$((id-1)),$((j+2))]}" -gt 0 ]; then
                        # Almacenar los términos de forma que no se repitan
                        term="${words[$j]}"
                        if [[ ! " ${analyzed_terms[@]} " =~ " $term " ]]; then
                            analyzed_terms+=("$term")
                        fi
                          ((count++))
                      fi
                 done

                echo "El correo electrónico $id contiene $count términos analizados que son: "
                for term in "${analyzed_terms[@]}"; do
                    echo -e "\t${VERDE}$term${RESET}"
                done

             else
                 echo "El identificador de correo electrónico no es válido."
             fi

            ;;
        4)
            echo "Saliendo..."
            break
            ;;
        *)
            echo "Opción no válida"
            ;;
    esac
done