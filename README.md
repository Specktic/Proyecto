Guia
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

==========================================================

(entrar)
docker exec -it tea-riscv-cont /bin/bash

chmod +x build.sh 
chmod +x run-qemu.sh