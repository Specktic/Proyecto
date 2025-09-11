Guia
=========================================================

cd /mnt/c/Users/mavic/OneDrive/Escritorio/Ar1_Pr1/Proyecto

docker build -t tea-riscv .

docker exec -it tea-riscv-cont /bin/bash

cd workspace
cd workspace

rm -rf build

./build.sh
./run-qemu.sh 

chmod +x build.sh 
chmod +x run-qemu.sh

==========================================================
