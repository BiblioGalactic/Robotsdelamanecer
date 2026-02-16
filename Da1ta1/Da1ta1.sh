#!/usr/bin/env bash
# 🤖 IA: "../../modelo/llama.cpp/build/bin/llama-cli"
# === Script de ejecución para el perfil Da1ta1 ===

set -euo pipefail

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cargar librería común si existe (Expuesto/ es el repo de infraestructura)
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPUESTO_ROOT="${WORKSPACE_ROOT}/Expuesto"
[[ -f "$EXPUESTO_ROOT/lib/bash-common.sh" ]] && source "$EXPUESTO_ROOT/lib/bash-common.sh"

show_help() {
    cat <<'HELP'
Uso: ./Da1ta1.sh [--help]

Descripción:
  Ejecuta inferencia con llama-cli usando el perfil Da1ta1.
  Limpia el prompt, ejecuta el modelo y guarda la conversación.

Variables de entorno:
  LLAMA_CLI       Ruta al binario llama-cli (default: ../../modelo/llama.cpp/build/bin/llama-cli)
  MODELO          Ruta al modelo GGUF (default: mistral-7b-instruct-v0.1.Q6_K.gguf)
  LOG_ROTATE_COUNT  Máximo de logs a mantener (default: 5)

Archivos:
  Da1ta1.txt      Prompt de personalidad (requerido)
  destino/        Directorio de salida para conversaciones

Retorno:
  0  Éxito
  1  Error de validación o ejecución
HELP
    exit 0
}
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && show_help

# Archivo de prompt correspondiente
PROMPT_FILE="${SCRIPT_DIR}/Da1ta1.txt"
# Rutas relativas al binario y al modelo
MODEL_BIN="${LLAMA_CLI:-${SCRIPT_DIR}/../../modelo/llama.cpp/build/bin/llama-cli}"
MODEL_FILE="${MODELO:-${SCRIPT_DIR}/../../modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf}"
# Archivo de log con marca temporal
LOG_FILE="${SCRIPT_DIR}/run_Da1ta1_$(date +%Y%m%d_%H%M%S).log"
# Variable para temporales
TMPFILE=""

# Obtener timestamp para logs
timestamp() {
  date +"[%Y-%m-%d %H:%M:%S]"
}

# Rotación de logs: mantener solo los últimos N archivos
rotate_old_logs() {
  local max_logs="${LOG_ROTATE_COUNT:-5}"
  local log_count
  log_count=$(find "$SCRIPT_DIR" -maxdepth 1 -name "run_Da1ta1_*.log" -type f 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$log_count" -gt "$max_logs" ]]; then
    find "$SCRIPT_DIR" -maxdepth 1 -name "run_Da1ta1_*.log" -type f -print0 \
      | xargs -0 ls -t \
      | tail -n "+$((max_logs + 1))" \
      | xargs rm -f 2>/dev/null || true
    echo "$(timestamp) [INFO] Logs antiguos eliminados (max: $max_logs)"
  fi
}
rotate_old_logs


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

# === MEMORIA CONVERSACIONAL ===
HISTORIAL_DIR="${SCRIPT_DIR}/historial"
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
  local output_file="$SCRIPT_DIR/destino/conversaciones_Da1ta1.txt"
  # Construir prompt con contexto de memoria
  local prompt_base="$(cat "$PROMPT_FILE")"
  local prompt_con_memoria="$(cargar_memoria)
$prompt_base"
  # Capturar entrada y respuesta para guardar en memoria
  local entrada=""
  local respuesta=""
  # Ejecutar el modelo con flags literales
  respuesta=$("$MODEL_BIN" \
    -m "$MODEL_FILE" \
    --ctx-size 2048 \
    --prompt "$prompt_con_memoria" \
    --n-predict 256 \
    --color \
    --temp 1.2 \
    --threads 6 \
    --interactive 2>&1)
  echo "$respuesta" | tee "$output_file"
  # Guardar el intercambio en memoria (respuesta capturada)
  entrada="[Ejecución interactiva]"
  guardar_memoria "$entrada" "$(echo "$respuesta" | head -20)..."
  echo "$(timestamp) [INFO] Conversación guardada en $output_file" | tee -a "$LOG_FILE"
}

validar
ejecutar