#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/R_Giskard_Reventlov.txt"
MODEL_NAME="${MODEL_NAME:-modelo-generico-instruct}"
OUTPUT_DIR="$SCRIPT_DIR/destino"
OUTPUT_FILE="$OUTPUT_DIR/ejecucion_$(basename "$PROMPT_FILE" .txt).txt"

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "[ERROR] No se encontró el prompt: $PROMPT_FILE" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

{
  echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Modelo sugerido/activo: $MODEL_NAME"
  echo "Prompt: $PROMPT_FILE"
  echo "--- PROMPT START ---"
  cat "$PROMPT_FILE"
  echo "--- PROMPT END ---"
  echo
  echo "[INFO] Ejemplo de lanzamiento rápido (ajusta a tu runtime):"
  echo "llama-cli -m /ruta/a/tu_modelo.gguf --prompt-file '$PROMPT_FILE'"
} | tee "$OUTPUT_FILE"

echo "[OK] Salida guardada en: $OUTPUT_FILE"
