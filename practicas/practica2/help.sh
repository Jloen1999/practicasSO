#!/bin/bash

echo -e "\n${ROJO}---------------------------| Ayuda | ---------------------------${RESET}"
echo -e "${VERDE}Bienvenido a la ayuda de la aplicación.${RESET}"
echo -e "La aplicación tiene las siguientes opciones:"

echo -e "\n${AZUL}1. Análisis de datos:${RESET}"
echo -e "Esta opción le permite analizar los datos. Se le pedirá que introduzca el nombre del archivo de palabras, nombre del archivo de correos electrónicos y el nombre del archivo de salida. Luego, el script analizará los datos y guardará los resultados en el archivo de salida con extensión .freq."
echo -e "${ROJO}Nota:${RESET} Los archivos de palabras y correos electrónicos deben existir y el archivo de salida no debe existir previamente. Si el archivo de salida no tiene la extensión .freq, se le añadirá automáticamente."

echo -e "\n${AZUL}2. Predicción:${RESET}"
echo -e "Esta opción le permite hacer predicciones basadas en los datos analizados. Se le preguntará si acaba de realizar el análisis o si desea cargar el análisis de frecuencias desde un archivo. Luego, el script calculará las métricas TF-IDF y guardará los resultados en un archivo .tfidf."

echo -e "\n${AZUL}3. Informes de resultados:${RESET}"
echo -e "Esta opción le permite generar informes basados en los resultados del análisis y las predicciones. Puede elegir entre tres tipos de informes: informe de términos por correo electrónico, informe de correos electrónicos por término e informe de términos por identificador de correo electrónico."

echo -e "\n${AZUL}4. Ayuda:${RESET}"
echo -e "Esta opción muestra este mensaje de ayuda."

echo -e "\n${AZUL}5. Salir:${RESET}"
echo -e "Esta opción cierra la aplicación."

echo -e "\n${AZUL}6. Mostrar contenido del archivo .freq:${RESET}"
echo -e "Esta opción muestra el contenido del archivo .freq generado por el análisis de datos. Si no ha realizado un análisis de datos durante la sesión actual, se le pedirá que introduzca el nombre del archivo .freq."

echo -e "\n${AZUL}7. Mostrar contenido del archivo .tfidf:${RESET}"
echo -e "Esta opción muestra el contenido del archivo .tfidf generado por la predicción. Si no ha realizado una predicción durante la sesión actual, se le pedirá que introduzca el nombre del archivo .tfidf."