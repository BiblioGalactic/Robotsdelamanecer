#!/usr/bin/env bash

DESTINO="$HOME/proyecto/txtapoyo/critica"

PROMPT_FILE="$HOME/proyecto/txtapoyo/perfilesdeia/cerrado/R12D12.txt"
TMPFILE="$(mktemp)"

# === MEMORIA CONVERSACIONAL ===
HISTORIAL_DIR="$HOME/proyecto/txtapoyo/perfilesdeia/cerrado/historial"
MEMORIA_FILE="${HISTORIAL_DIR}/memoria.txt"
mkdir -p "$HISTORIAL_DIR"
touch "$MEMORIA_FILE"

# Cargar últimas 50 líneas de memoria
cargar_memoria() {
    if [[ -s "$MEMORIA_FILE" ]]; then
        echo "--- Contexto previo ---"
        tail -50 "$MEMORIA_FILE"
        echo "--- Fin contexto ---"
    fi
}

# Guardar intercambio en memoria
guardar_memoria() {
    local entrada="$1"
    local respuesta="$2"
    {
        echo "[$(date +'%Y-%m-%d %H:%M')] Entrada: $entrada"
        echo "[$(date +'%Y-%m-%d %H:%M')] Respuesta: $respuesta"
        echo "---"
    } >> "$MEMORIA_FILE"
    # Mantener solo últimas 200 líneas para no crecer indefinidamente
    if [[ $(wc -l < "$MEMORIA_FILE") -gt 200 ]]; then
        tail -200 "$MEMORIA_FILE" > "${MEMORIA_FILE}.tmp"
        mv "${MEMORIA_FILE}.tmp" "$MEMORIA_FILE"
    fi
}

# Limpiar líneas vacías y espacios innecesarios sin eliminar acentos ni UTF-8
sed -e 's/\r//g' \
    -e 's/^[[:space:]]\+//g' \
    -e 's/[[:space:]]\+$//g' \
    -e '/^[[:space:]]*$/d' \
    "$PROMPT_FILE" > "$TMPFILE" && mv "$TMPFILE" "$PROMPT_FILE"

# Construir prompt con contexto de memoria
PROMPT_BASE="$(cat $HOME/proyecto/txtapoyo/perfilesdeia/cerrado/R12D12.txt)"
PROMPT_CON_MEMORIA="$(cargar_memoria)
$PROMPT_BASE"

# Ejecutar el modelo y capturar respuesta
RESPUESTA=$(~/modelo/llama.cpp/build/bin/llama-cli \
  -m ~/modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf \
  --ctx-size 2048 \
  --prompt "$PROMPT_CON_MEMORIA" \
  --n-predict 256 \
  --color \
  --temp 1.2 \
  --threads 6 \
  --interactive 2>&1)

echo "$RESPUESTA" | tee "$DESTINO/conversaciones_R12D12.txt"

# Guardar el intercambio en memoria
ENTRADA="[Ejecución interactiva]"
guardar_memoria "$ENTRADA" "$(echo "$RESPUESTA" | head -20)..."
