# CC-33PPOO

Aquí encontrará el perfil del droide de protocolo **CC-33PPOO**. El archivo `CC-33PPOO.txt` contiene una descripción en primera persona adaptada al estilo de R12D12, resaltando su cautela, formalidad y capacidad de traducción.

El script `CC-33PPOO.sh` automatiza la ejecución del modelo con este prompt. Incluye validaciones de archivos y dependencias, captura de eventos con marcas de tiempo y una función de limpieza que elimina ficheros temporales al finalizar. Todas las rutas empleadas son relativas a esta carpeta.

## Instrucciones

Para poner en marcha la simulación de C‑3PO, ejecute los siguientes pasos dentro de esta carpeta:

    chmod +x CC-33PPOO.sh
    ./CC-33PPOO.sh

El diálogo generado se guardará en `destino/conversaciones_CC-33PPOO.txt`. Si necesita ajustar la ubicación del binario de llama.cpp o del modelo, edite las variables `MODEL_BIN` y `MODEL_FILE` dentro del script.

## Requisitos

- Compilación local de `llama.cpp` accesible en `../../modelo/llama.cpp/build/bin/llama-cli`.
- Un modelo `.gguf` apropiado disponible en `../../modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf`.
- Utilidades de línea de comandos como `bash`, `sed`, `mktemp` y `tee`.