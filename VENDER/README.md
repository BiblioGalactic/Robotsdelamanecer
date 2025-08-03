# Vender

Esta carpeta contiene el perfil de **Vender Vending Zodríguez**, el célebre robot. El archivo `VENDER.txt` ofrece un prompt en primera persona cargado de sarcasmo y rebeldía, respetando la estructura de respuestas en bloques de R12D12.

El script `VENDER.sh` automatiza la invocación del binario `llama-cli` con el prompt. Se han implementado las normas de estilo exigidas: validación exhaustiva de requisitos, gestión de errores mediante `set -euo pipefail` y `trap cleanup EXIT`, y registro de la ejecución con sellos de tiempo. Las rutas a binario y modelo son relativas a la ubicación de este directorio.

## Ejecución

Dentro de esta carpeta, otorgue permisos y ejecute:

    chmod +x VENDER.sh
    ./VENDER.sh

El resultado de la conversación se almacenará en `destino/conversaciones_VENDER.txt`. Ajuste `MODEL_BIN` y `MODEL_FILE` en el script si su entorno de llama.cpp o su modelo `.gguf` se encuentran en ubicaciones distintas.

## Requisitos

- `llama-cli` compilado en `../../modelo/llama.cpp/build/bin/llama-cli`.
- Un modelo `.gguf` disponible en `../../modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf` o modifique la variable correspondiente.
- Utilidades de shell estándar: `bash`, `sed`, `mktemp` y `tee`.