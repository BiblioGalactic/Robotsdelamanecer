# Da1ta1

Esta carpeta contiene el perfil del Teniente Comandante **Da1ta1**, oficial científico. El archivo `Da1ta1.txt` representa al androide hablando en primera persona y en español, siguiendo el estilo modular que se encuentra en `R12D12.txt`.

El script `Da1ta1.sh` se encarga de invocar el binario `llama-cli` con este prompt. Incluye verificaciones exhaustivas de existencia de archivos y comandos, registro de eventos con marcas de tiempo y limpieza automática de temporales mediante la función `cleanup`. Todo se basa en rutas relativas para favorecer la portabilidad.

## Uso

Desde esta carpeta, otorgue permisos y ejecute el script:

    chmod +x Da1ta1.sh
    ./Da1ta1.sh

Al finalizar, la conversación se almacenará en `destino/conversaciones_Da1ta1.txt`. Puede editar las variables `MODEL_BIN` y `MODEL_FILE` en el script si su instalación de llama.cpp o del modelo se encuentra en otra ubicación.

## Requisitos

- Binario `llama-cli` compilado en `../../modelo/llama.cpp/build/bin/llama-cli`.
- Modelo `.gguf` adecuado en `../../modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf` o ajuste la variable para señalar su modelo.
- Herramientas estándar de línea de comandos (`bash`, `sed`, `mktemp`, `tee`).