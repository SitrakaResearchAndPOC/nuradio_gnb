#!/bin/bash

# DEFAULT SYSTEMD OF OPEN5GS IS ONLY AUTORIZE WITH open5gs ;  need to change on docker ALL SERVICES  FILE AT : /home/nr/open5gs/build/configs/systemd/*.service COPY AT  :  /etc/systemd/system/
sudo useradd --system --no-create-home --shell /usr/sbin/nologin open5gs
sudo groupadd open5gs
sudo usermod -a -G open5gs open5gs

# INSTALLING MONG DB
sudo apt install -y gnupg curl
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg --dearmor --yes  -o /usr/share/keyrings/mongodb-server-6.0.gpg
grep -qxF 'deb [signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse' /etc/apt/sources.list.d/mongodb-org-6.0.list 2>/dev/null || echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse' | sudo tee -a /etc/apt/sources.list.d/mongodb-org-6.0.list > /dev/null
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl restart mongod

# NEED FOR VERIFICATION
# sudo systemctl restart mongod
# sudo  systemctl status mongod


# INSTALLING ALL DEPENDENCIES FOR OPEN5GS
sudo apt install -y   git build-essential cmake meson ninja-build   libglib2.0-dev libmongoc-dev libbson-dev   libsctp-dev lksctp-tools libssl-dev   libidn11-dev libyaml-dev   flex bison   pkg-config libtalloc-dev libmicrohttpd-dev libgcrypt20-dev libnghttp2-dev libcurl4-openssl-dev 
sudo apt install -y python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git cmake libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson
( if apt-cache show libidn-dev > /dev/null 2>&1; then     sudo apt-get install -y --no-install-recommends libidn-dev; else     sudo apt-get install -y --no-install-recommends libidn11-dev; fi; )
sudo apt install  -y   build-essential     meson     ninja-build     cmake     git     pkg-config     flex     bison     libsctp-dev     libgnutls28-dev     libgcrypt20-dev     libidn11-dev     libmongoc-dev     libbson-dev     libyaml-dev     libmicrohttpd-dev     libcurl4-openssl-dev     libnghttp2-dev     libssl-dev     cppcheck     clang-tidy


git clone https://github.com/open5gs/open5gs
cd open5gs/
git checkout v2.7.0
sudo meson build --prefix=/usr
sudo apt install build-essential meson ninja-build cmake pkg-config git flex bison libsctp-dev libgnutls28-dev libgcrypt20-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev libmicrohttpd-dev libnghttp2-dev libssl-dev libcurl4-openssl-dev libtalloc-dev libtins-dev
sudo ninja -C build
sudo ninja -C build install
sudo ldconfig

# NEED FOR VERIFICATION
# ls /usr/bin/open5gs*
# which open5gs-amfd
# ldd $(which open5gs-amfd) | grep ogs


# COPY USEFULL CONFIGURATION
# DON'T USE THIS CONFIG : sudo cp -rf configs/open5gs/* /etc/open5gs/ USE INSTEAD  sudo cp -rf build/configs/open5gs/* /etc/open5gs/
rm -rf /etc/open5gs/*
sudo cp -rf build/configs/open5gs/* /etc/open5gs/
sudo chown -R open5gs:open5gs /etc/open5gs/

# CREATE DIRECTORY FOR LOGFILE 
mkdir -p  /var/log/open5gs
sudo chown -R open5gs:open5gs /var/log/open5gs

# CHANGE THE ADDRESS OF NRF TO PATCH THE CONFIGURATION
sudo sed -i 's/address: 127.0.0.10/address: 127.0.0.200/' /etc/open5gs/nrf.yaml


# COPY ALL SYSTEMD FILES
sudo cp /home/nr/open5gs/build/configs/systemd/*.service /etc/systemd/system/
sudo systemctl daemon-reload

systemctl list-unit-files | grep open5gs
sudo systemctl enable $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
sudo systemctl stop $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')




############################### INSTALLLATION WEBUI ###########################################################
sudo apt update
sudo apt update
sudo apt install -y ca-certificates curl gnupg
NODE_MAJOR=20
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo sudo apt install nodejs -y

cd webui
npm ci
# NO NEED TO RUN IT , JUST TEST BEFORE LAUNCHING THE SYSTEMD OF OPEN5GS-WEBUI
# npm run dev
rm -rf node_modules package-lock.json .next
npm install
npm run build 

# NEED FOR VERIFICATION
# VERIFY IF ALL FILS EXISTS
# ls .next 
# ls 
# THE DIRECTORY SHOULD EXIST server/
# THE DIRECTORY SHOULD EXIST static/ 

# npm install -g

 
WEBUI_PATH=$(pwd)

# CREATE ALSO SYSTEMD FOR WEBUI TO FACILITE THE INTERFACE OF OPEN5GS
sudo tee /etc/systemd/system/open5gs-webui.service > /dev/null <<EOF
[Unit]
Description=Open5GS WebUI
After=network.target

[Service]
Type=simple
WorkingDirectory=${WEBUI_PATH}
ExecStart=$(which node) ${WEBUI_PATH}/server/index.js
Restart=always
RestartSec=3
Environment=NODE_ENV=production
User=root

[Install]
WantedBy=multi-user.target
EOF



sudo systemctl daemon-reload
sudo systemctl enable open5gs-webui
sudo systemctl restart  open5gs-webui

# NEED FOR VERIFICATION
# sudo systemctl status open5gs-webui


# FOR WEBUI in browswer : 
# FOR WEBUI login : admin
# FOR WEBUI password : 1423

