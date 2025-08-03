# Robotsdelamanecer


# Colección de perfiles de personajes IA

Este paquete contiene perfiles de cuatro personajes icónicos de ciencia ficción: **HAL_10**, **Da1ta1**, **CC‑33PPOO** y **Vender**. Cada carpeta incluye:

- Un archivo `.txt` con una narración en primera persona de cada personaje, siguiendo el formato del ejemplo `R12D12.txt` que acompaña a esta entrega.
- Un script `.sh` listo para utilizar el binario `llama-cli` de *llama.cpp* con el prompt del personaje. Los scripts utilizan rutas relativas y realizan comprobaciones de existencia y permisos antes de ejecutarse. Todos siguen las normas de estilo definidas por el usuario para cabeceras, validaciones, gestión de errores y limpieza.
- Un `README.md` específico del personaje con información sobre el mismo y cómo ejecutar el script.

## Requisitos

- **Entorno de llama.cpp**: Debe tener compilado el proyecto y disponer del binario `llama-cli`. El script espera encontrarlo en `../../modelo/llama.cpp/build/bin/llama-cli` relativo a cada carpeta de personaje. Modifique esa ruta en los scripts si su instalación difiere.
- **Modelo `.gguf`**: Necesitará un modelo de lenguaje en formato `.gguf`. Por defecto, los scripts apuntan a `../../modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf`. Descargue o coloque su modelo en esa ruta o edite la variable `MODEL_FILE` en cada script para especificarlo.
- **Herramientas de línea de comandos**: `bash`, `sed`, `mktemp` y `tee` deben estar disponibles. Los scripts validan su presencia antes de ejecutarse.

## Uso

Para utilizar un perfil, entre en la carpeta del personaje, asegúrese de que el script tenga permisos de ejecución y ejecútelo. Por ejemplo, para HAL 9000:

```bash
cd HAL_9000
chmod +x HAL_10.sh
./HAL_10.sh
```

El script limpiará el prompt, validará los recursos y luego lanzará la inferencia. El resultado de la conversación se guardará en un archivo `conversaciones_<personaje>.txt` dentro de una subcarpeta `destino`. Los mensajes informativos y de error se registran con marcas de tiempo en un archivo de log creado en el momento de la ejecución.

Repita el mismo procedimiento en las carpetas `Da1ta1`, `CC-33PPOO` y `VENDER` para los demás personajes.

## Nota sobre las rutas relativas

Los scripts usan rutas relativas para facilitar su portabilidad. Si la estructura propuesta no coincide con la de su entorno, edite las variables `MODEL_BIN` y `MODEL_FILE` en cada script para apuntar a las rutas correctas. El resto de componentes (prompt, destino y logs) permanecerán dentro de la carpeta del personaje, por lo que el paquete puede moverse sin romper el funcionamiento.

## Descarga del modelo

Si aún no posee un modelo en formato `.gguf`, puede descargar uno apropiado (por ejemplo, *Mistral 7B Instruct*). Consulte la documentación oficial de llama.cpp o repositorios de modelos para obtener el archivo. Una vez descargado, colóquelo en la ruta indicada o modifique la variable `MODEL_FILE` en los scripts de los personajes para que apunte a la ubicación de su modelo.

Esperamos que estos perfiles le sirvan para explorar diferentes personalidades de IA y para probar inferencias locales con *llama.cpp*.