=========================================================

cd /mnt/c/Users/mavic/OneDrive/Escritorio/Ar1_Pr1/Proyecto

docker build -t tea-riscv .

(correr y montar)
docker run -it --rm \
    -v $(pwd)/workspace:/home/rvqemu-dev/workspace \
    tea-riscv /bin/bash

cd workspace

rm -rf build

./build.sh
./run-qemu.sh 

=========================================================

# Proyecto Individual Arquitectura de Computadores 1

Se implementa el Tiny Encryption Algorithm (TEA) en un entorno bare-metal RISC-V RV32, permitiendo depuración con GDB.

---

## 1. Estructura del proyecto

.
├── Dockerfile
├── workspace/          
│   ├──build.sh  
│   ├──run-qemu.sh
│   ├──linker.ld
│   ├──main.c               # capa de alto nivel
│   ├──startup.asm          # punto de entrada a capa de bajo nivel
│   ├──tea_encrypt.asm      # cifrado TEA
│   └──tea_decrypt.asm      # decifrado TEA
└── README.md

## 2. Guía de inicio

Para construir el contenedor dentro del archivo

    • docker build -t tea-riscv .

Una vez construido el contenedor se debe correr y montar el espacio de trabajo 

    • docker run -it --rm \
        -v $(pwd)/workspace:/home/rvqemu-dev/workspace \
        tea-riscv /bin/bash

Para entrar a la carpeta de desarrollo

    • cd workspace

Dentro del espacio de trabajo se le debe dar permiso de ejecucion a los archivos build.sh y run-qemu.sh de ser necesario

    -> chmod +x build.sh 
    -> chmod +x run-qemu.sh

Con el permiso correcto se construye el archivo tea.elf

    • chmod +x build.sh 

Se ejecuta usando QEMU

    • chmod +x run-qemu.sh

## 3. Descripción de implementación

El inicio del desarrollo se planteó con el uso de un archivo .txt para obtener el texto a cifrar con la intención de ser fácil de probar y modificar. El inicio del proceso de desarrollo se dedicó a definir el correcto funcionamiento de la construcción del programa con el build.sh, el cual inicialmente restringió el uso de la librería <stdint.h> por lo que se optó por el uso de un archivo adicional llamado types.h para definir manualmente los tipos de datos a usar, sin embargo eventualmente se corrigió la restricción por lo que se abandonó el uso de types.h como se puede observar en el flujo de desarrollo mostrado por el control de versiones.
Una vez asegurado el entorno de desarrollo se presentaron errores dentro del archivo tea_encrypt.asm al probar stubs en el cual se definían ciertas operación como ilegales, luego de varias pruebas se encontró que las operaciones definidas como ilegales hacían uso de registros temporales t7 o mayores restringidos por RV32I por lo que se limito el uso de estos a t0-t6 y se logró la compilación del programa
Una vez que se inició con la implementación de la lógica completa se cometió el error de implementar una solución la cual sobrescribía el contenido de t0 el cual contiene el buffer con el mensaje a cifrar y t2 el cual contiene el largo del mismo, critico para definir la condición de terminación de las rondas de cifrado.
Finalmente, la compilación del programa encontró fallos al momento de entrar a la capa de bajo nivel por lo que no cifraba el mensaje y producía una cadena de 00s infinitamente, se tomó la decisión de cambiar el origen del texto a cifrar del archivo msg.txt a una variable dentro del código lo que resolvió el problema finalizando la funcionalidad completa de la especificación.  Se sugiere que el problema al usar al archivo msg.txt era debido a que el objeto generado del archivo (msg.o) generaba punteros no fiables produciendo errores en la definición del contenido de t0 en tea_encrypt.asm.

## 4. Diagrama de implementación

        Inicio
        │
        ▼
        [Compilación inicial con build.sh incorrecto]
        │
        ▼
        Errores de compilación (memset, div/mod)
        │
        ▼
        Corregir build.sh (-ffreestanding, -nostdlib)
        │
        ▼
        [Pruebas en ensamblador]
        │
        ▼
        Fallas por registros temporales > t6
        │
        ▼
        Limitar uso a t0–t6
        │
        ▼
        [Ejecutar TEA]
        │
        ▼
        Resultados incorrectos por sobreescritura de registros
        │
        ▼
        Reorganizar uso de t0, t2, etc. en loops
        │
        ▼
        Programa no entra a tea_encrypt.asm
        │
        ▼
        Mensaje desde archivo txt genera punteros inválidos
        │
        ▼
        Definir mensaje como variable en main.c
        │
        ▼
        Programa ejecuta correctamente y permite depuración
        │
        ▼
        Fin


## 5. Rendimiento

• Ciclos por bloque:

EL TEA realiza 32 rondas por cada bloque de 64 bits consistiendo en:

2 operaciones de desplazamiento (sll, srl)

6 sumas (add, addi)

2 XOR (xor)

Produce un total aproximado de >200 instrucciones por bloque considerando bucles y control de flujo. En RV32I con ejecución sin pipelines complejos, cada instrucción consume 1–2 ciclos por lo que se estima ~250–300 ciclos por bloque de 8 bytes.

• Dependencia al tamano del mensaje

El tiempo total de cifrado es directamente proporcional al número de bloques:

Ciclos totales ≈ numero de bloques × 250 ciclos

Para mensajes mas grandes al de prueba (HOLA1234), basandose en un caso tipico aproximando 256 bits se esperan ~8,000 ciclos.

• Uso de memoria

En memoria, todos los registros temporales usados (t0–t6) están dentro de ABI RV32I, evitando sobreescrituras y garantizando consistencia.

Los bloques están alineados a 4 bytes y el buffer se asegura de ser múltiplo de 8 al usar padding, evitando accesos desalineados.

Las operaciones de lectura y escritura (lw y sw) son secuenciales y alineadas, maximizando la eficiencia en memoria.

