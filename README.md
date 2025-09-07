GUÍA DE USO 
=====================================================

REQUISITOS
----------
1. WSL2 con Ubuntu
   - Verifica con:
     wsl --list --verbose

2. Docker Desktop instalado en Windows
   - Con integración habilitada para WSL2 (Ubuntu).


PASOS PARA EJECUTAR EL PROYECTO
--------------------------------

1. Abrir una terminal WSL (Ubuntu).

2. Ir a la carpeta del proyecto:
   cd ~/ruta/al/proyecto

3. Construir la imagen de Docker:
   docker build -t rvqemu .

4. Crear y entrar al contenedor:
   docker run -it --name rvqemu -v $(pwd):/home/rvqemu-dev/workspace rvqemu /bin/bash

5. Dentro del contenedor, compilar el proyecto:
   cd /home/rvqemu-dev/workspace
   chmod +x build.sh
   ./build.sh

   -> Si la compilación es correcta, se genera:
      build/tea.elf

6. Ejecutar el programa en QEMU:
   chmod +x run-qemu.sh
   ./run-qemu.sh


DEPURACIÓN CON GDB
------------------

1. Iniciar QEMU en modo debug:
   ./run-qemu.sh -d

2. Abrir otra terminal (WSL) y conectarse al contenedor:
   docker exec -it rvqemu /bin/bash

3. Dentro de la segunda terminal, ejecutar:
   gdb-multiarch build/tea.elf

4. En GDB, conectar a QEMU:
   (gdb) target remote :1234

5. (Opcional) Depurar con breakpoints:
   (gdb) break main
   (gdb) continue


ESTRUCTURA DEL PROYECTO
-----------------------
Proyecto/
├── C/                  -> Código en C
├── RISCV/              -> Código ensamblador RISC-V
├── build.sh            -> Script de compilación
├── run-qemu.sh         -> Script de ejecución/depuración
├── linker.ld           -> Script de linkeo
├── msg.txt             -> Mensaje de entrada
└── Dockerfile          -> Entorno reproducible
