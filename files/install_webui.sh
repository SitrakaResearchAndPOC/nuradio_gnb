#!/bin/bash
# DEFAULT SYSTEMD OF OPEN5GS IS ONLY AUTORIZE WITH open5gs ;  need to change on docker ALL SERVICES  FILE AT : /home/nr/open5gs/build/configs/systemd/*.service COPY AT  :  /etc/systemd/system/
# sudo useradd --system --no-create-home --shell /usr/sbin/nologin open5gs
# sudo groupadd open5gs
# sudo usermod -a -G open5gs open5gs
if ! getent group open5gs >/dev/null 2>&1; then
    sudo groupadd open5gs
fi

if ! id open5gs >/dev/null 2>&1; then
    sudo useradd --system --no-create-home --shell /usr/sbin/nologin -g open5gs open5gs
fi

if id open5gs >/dev/null 2>&1; then
    if ! id -nG open5gs | grep -qw open5gs; then
        sudo usermod -a -G open5gs open5gs
    fi
fi

[ ! -d open5gs-webui ] && git clone https://github.com/open5gs/open5gs open5gs-webui
cd open5gs-webui/
git checkout v2.7.0

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
# rm -rf node_modules package-lock.json .next
# npm ci
# NO NEED TO RUN IT , JUST TEST BEFORE LAUNCHING THE SYSTEMD OF OPEN5GS-WEBUI
# npm run dev

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

cd ../..


sudo systemctl daemon-reload
sudo systemctl enable open5gs-webui
sudo systemctl restart  open5gs-webui
