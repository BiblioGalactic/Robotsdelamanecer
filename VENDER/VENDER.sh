#!/bin/bash
# 🤖 IA: "../../modelo/llama.cpp/build/bin/llama-cli"
# === Script de ejecución para el perfil Bender ===

set -euo pipefail

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Archivo de prompt correspondiente
PROMPT_FILE="${SCRIPT_DIR}/VENDER.txt"
# Rutas relativas al binario y al modelo
MODEL_BIN="${SCRIPT_DIR}/../../modelo/llama.cpp/build/bin/llama-cli"
MODEL_FILE="${SCRIPT_DIR}/../../modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf"
# Archivo de log con marca temporal
LOG_FILE="${SCRIPT_DIR}/run_VENDER_$(date +%Y%m%d_%H%M%S).log"
# Variable para temporales
TMPFILE=""

# Obtener timestamp para logs
timestamp() {
  date +"[%Y-%m-%d %H:%M:%S]"
}

# Función de limpieza ejecutada al salir
cleanup() {
  local status=$?
  if [[ -n "$TMPFILE" && -f "$TMPFILE" ]]; then
    rm -rf "$TMPFILE"
  fi
  exit $status
}
trap cleanup EXIT

# Validar existencia de archivos, permisos y comandos
validar() {
  echo "$(timestamp) [INFO] Validando entorno..." | tee -a "$LOG_FILE"
  # Prompt
  if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "$(timestamp) [ERROR] Archivo de prompt no encontrado: $PROMPT_FILE" | tee -a "$LOG_FILE" >&2
    exit 1
  fi
  if [[ ! -r "$PROMPT_FILE" ]]; then
    echo "$(timestamp) [ERROR] Sin permisos de lectura para: $PROMPT_FILE" | tee -a "$LOG_FILE" >&2
    exit 1
  fi
  # Binario
  if [[ ! -x "$MODEL_BIN" ]]; then
    echo "$(timestamp) [ERROR] Binario llama-cli no ejecutable o no encontrado: $MODEL_BIN" | tee -a "$LOG_FILE" >&2
    exit 1
  fi
  # Modelo
  if [[ ! -f "$MODEL_FILE" ]]; then
    echo "$(timestamp) [ERROR] Archivo de modelo no encontrado: $MODEL_FILE" | tee -a "$LOG_FILE" >&2
    exit 1
  fi
  # Comandos necesarios
  for cmd in sed mktemp tee "${MODEL_BIN}"; do
    if ! command -v ${cmd##*/} >/dev/null 2>&1; then
      echo "$(timestamp) [ERROR] Comando requerido no encontrado: ${cmd##*/}" | tee -a "$LOG_FILE" >&2
      exit 1
    fi
  done
  echo "$(timestamp) [INFO] Validaciones completadas." | tee -a "$LOG_FILE"
}

# Ejecutar la inferencia
ejecutar() {
  echo "$(timestamp) [INFO] Ejecutando inferencia con $PROMPT_FILE" | tee -a "$LOG_FILE"
  # Limpiar y normalizar el prompt
  TMPFILE="$(mktemp)"
  sed -e 's/\r//g' \
      -e 's/^[[:space:]]\+//g' \
      -e 's/[[:space:]]\+$//g' \
      -e '/^[[:space:]]*$/d' \
      "$PROMPT_FILE" > "$TMPFILE"
  mv "$TMPFILE" "$PROMPT_FILE"
  # Crear carpeta de salida
  mkdir -p "$SCRIPT_DIR/destino"
  local output_file="$SCRIPT_DIR/destino/conversaciones_VENDER.txt"
  # Ejecutar el modelo con flags literales
  "$MODEL_BIN" \
    -m "$MODEL_FILE" \
    --ctx-size 2048 \
    --prompt "$(cat "$PROMPT_FILE")" \
    --n-predict 256 \
    --color \
    --temp 1.2 \
    --threads 6 \
    --interactive \
    | tee "$output_file"
  echo "$(timestamp) [INFO] Conversación guardada en $output_file" | tee -a "$LOG_FILE"
}

validar
ejecutar