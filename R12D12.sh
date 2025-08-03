#!/opt/homebrew/bin/bash

DESTINO="$HOME/proyecto/txtapoyo/critica"

PROMPT_FILE="$HOME/proyecto/txtapoyo/perfilesdeia/cerrado/R12D12.txt"
TMPFILE="$(mktemp)"

# Limpiar líneas vacías y espacios innecesarios sin eliminar acentos ni UTF-8
sed -e 's/\r//g' \
    -e 's/^[[:space:]]\+//g' \
    -e 's/[[:space:]]\+$//g' \
    -e '/^[[:space:]]*$/d' \
    "$PROMPT_FILE" > "$TMPFILE" && mv "$TMPFILE" "$PROMPT_FILE"

~/modelo/llama.cpp/build/bin/llama-cli \
  -m ~/modelo/modelos_grandes/M6/mistral-7b-instruct-v0.1.Q6_K.gguf \
  --ctx-size 2048 \
  --prompt "$(cat $HOME/proyecto/txtapoyo/perfilesdeia/cerrado/R12D12.txt)" \
  --n-predict 256 \
  --color \
  --temp 1.2 \
  --threads 6 \
  --interactive \
  | tee "$DESTINO/conversaciones_R12D12.txt"
