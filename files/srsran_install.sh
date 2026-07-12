#!/bin/bash
sudo apt install -y cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev 

# sudo git clone https://github.com/srsRAN/srsRAN_project
# Cloner uniquement si le dépôt n'existe pas
[ ! -d srsRAN_Project ] && git clone https://github.com/srsran/srsRAN_Project.git

cd srsRAN_Project || exit 1

# La dernière version de srsRAN_Projet est seulement readme; pour compiler, toujours avec checkout
# Latest version : release_25_10
# sudo git checkout release_25_10
sudo git checkout 50fe9623c


# Créer build uniquement s'il n'existe pas
[ ! -d build ] && mkdir build

cd build || exit 1

sudo cmake ../

sudo make -j $(nproc --ignore 2)

sudo make test -j $(nproc --ignore 2)

sudo make install

# sudo ldconfig

gnb --version
