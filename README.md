# Robotsdelamanecer

Empece este repo con cuatro voces clasicas y acabo creciendo hasta 10 paquetes. No los fusione en un solo prompt gigante porque cuando lo probe perdia justo lo que me interesaba: la friccion entre personalidades.

## Que hay aqui

Cada carpeta suele mantener tres piezas:

- un `.txt` con la voz o manifiesto,
- un `.sh` para lanzarlo con `llama.cpp`,
- un `README.md` propio.

## Por que esta separado por personajes

Queria que cada voz tuviera su propio espacio de contexto, logs y salida. Compartir demasiado entre personajes hacia el mantenimiento mas limpio, pero volvia las respuestas demasiado parecidas.

## Lo que asumo del entorno

Los lanzadores esperan una instalacion local de `llama.cpp` y un modelo GGUF accesible por ruta relativa. Esa decision me dio portabilidad dentro de mi propio workspace, pero obliga a tocar rutas si tu arbol no se parece al mio.

## Deuda honesta

- hay duplicacion entre algunos lanzadores,
- varios prompts crecieron mas por uso que por diseno elegante,
- este repo sirve mejor para explorar tonos y encuadres que para construir una arquitectura de agentes compleja.

## Si vienes nuevo

No leas esto como una libreria de personajes "terminados". Leelo como una coleccion de voces que fui afinando porque cada una me dejaba ver fallos distintos del modelo.
