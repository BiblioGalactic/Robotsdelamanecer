# HAL_10

Este perfil describe la personalidad y el comportamiento de **HAL_10**, el sistema de control central de naves. El archivo `HAL_10.txt` contiene un prompt en primera persona adaptado del estilo de R12D12. Puede utilizarse como entrada para modelos LLM para simular la voz y las reacciones de HAL.

El script `HAL_10.sh` ejecuta el binario `llama-cli` con este prompt. El script realiza validaciones de archivos, permisos y dependencias antes de lanzar la inferencia y registra el progreso con marcas de tiempo. Se basa exclusivamente en rutas relativas para que pueda mover la carpeta sin romper referencias.

## Cómo ejecutarlo

Conceda permisos de ejecución al script y láncelo desde la carpeta `HAL_9000`:

    chmod +x HAL_10.sh
    ./HAL_10.sh

El resultado de la conversación se guardará en `destino/conversaciones_HAL_10.txt`. Revise el propio script si desea modificar la ruta del binario de llama.cpp (`MODEL_BIN`) o la ubicación del modelo `.gguf` (`MODEL_FILE`).

## Dependencias

- **llama.cpp** compilado localmente y disponible en `../../modelo/llama.cpp/build/bin/llama-cli`.
- **Modelo `.gguf`** en `../../modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf` o modifique la variable correspondiente.
- Herramientas básicas de GNU: `bash`, `sed`, `mktemp` y `tee`.