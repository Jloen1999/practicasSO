# Procesos
## 1. ¿ Qué es un proceso?
Es cualquier programa en ejecución, independiente de otros procesos, y es gestionado por el sistema operativo.
Cada proceso tiene estructuras con información relevante como su identificador, características y recursos asignados. La jerarquía de procesos se genera tras el arranque del sistema, con términos como "padre" e "hijo" para describir sus relaciones. El proceso "init" es el primero que existe, con el identificador `PID 1`.

## 2. Vida de un proceso
La vida de un proceso incluye tres etapas principales:
- **Creación**: Se usa la llamada al sistema `fork` o `exec`. Esto implica asignar espacio en memoria, encontrar un bloque de control (BCP) libre, y cargar en memoria el código, datos y pila del proceso.
- **Ejecución**: No se ejecuta de una vez, sino que incluye interrupciones y activaciones. La información del proceso en ejecución se guarda y restaura según sea necesario.
- **Terminación**: un proceso puede finalizar porque ha completado su tarea o porque se decide que ya no es necesario. Los recursos deben ser liberados. La llamada `kill` permite enviar señales de finalización a un proceso.

## 3. Estados de un proceso
Los procesos pasan por varios estados: **nuevo**, **listo**, **ejecución**, **bloqueado** y **terminado**. Los planificadores (a largo, corto y medio plazo) gestionan el cambio de estados y el cambio de contexto.

## 4. Servicios de gestión de procesos
- **Identificación de procesos**: Cada proceso tiene un identificador(**PID**), y se pueden obtener con funciones como `getpid()`, `getppid()`, `getuid()`, `geteuid()`, `getgid()` y `getegid()`.
- **Entorno de procesos**: Definido por variables de entorno accesibles mediante la llamada `getenv`.
- **Creación de procesos**: Usando la llamada `fork`, que clona el proceso solicitante. Las diferencias entre el proceso padre e hijo incluyen distintos PID, el hijo no hereda ciertos estados y señales pendientes.
- **Familia de llamadas `exec`**: Reemplazan la imagen del proceso invocador por la del programa especificado.

## 5. Finalización de procesos
Un proceso puede terminar con `return`, `exit` o `_exit`. La función `exit` realiza varias tareas, como cerrar descriptores de ficheros y liberar recursos. Se puede usar `atexit` para ejecutar una función al llamar `exit`.

## 6. Esperar la finalización de un proceso
Las llamadas `wait` y `waitpid` permiten al proceso padre esperar a que un proceso hijo finalice y obtener información sobre el estado de finalización. Estas funciones pueden manejarse mediante varias macros para interpretar el estado de salida del proceso hijo.

## 7. Señales
Las señales permiten que un proceso ejecute código de manera asíncrona, manejando condiciones excepcionales como interrupciones desde el teclado, errores en un proceso o eventos asíncronos.

## 8. PIPE
Un **pipe** es un mecanismo de comunicación entre procesos que permite la transferencia de datos. Se crea con la llamada `pipe` y se cierran los descriptores de fichero no necesarios. Los procesos pueden escribir y leer en el pipe, y se pueden crear pipes anónimos o con nombre.

