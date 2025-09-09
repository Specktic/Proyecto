Guia
=========================================================

cd /mnt/c/Users/mavic/OneDrive/Escritorio/Ar1_Pr1/Proyecto

docker run -it --name prcrv-tea-cont -v $(pwd):/home/rvqemu-dev/workspace prcrv-tea /bin/bash

cd /home/rvqemu-dev/workspace

chmod +x build.sh 
chmod +x run-qemu.sh
    
./build.sh
./run-qemu.sh 

==========================================================


docker ps -a

docker container prune

