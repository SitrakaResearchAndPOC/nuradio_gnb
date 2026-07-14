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

# INSTALLING ALL DEPENDENCIES FOR OPEN5GS
sudo apt install -y   git build-essential cmake meson ninja-build   libglib2.0-dev libmongoc-dev libbson-dev   libsctp-dev lksctp-tools libssl-dev   libidn11-dev libyaml-dev   flex bison   pkg-config libtalloc-dev libmicrohttpd-dev libgcrypt20-dev libnghttp2-dev libcurl4-openssl-dev 
sudo apt install -y python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git cmake libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson
( if apt-cache show libidn-dev > /dev/null 2>&1; then     sudo apt-get install -y --no-install-recommends libidn-dev; else     sudo apt-get install -y --no-install-recommends libidn11-dev; fi; )
sudo apt install  -y   build-essential     meson     ninja-build     cmake     git     pkg-config     flex     bison     libsctp-dev     libgnutls28-dev     libgcrypt20-dev     libidn11-dev     libmongoc-dev     libbson-dev     libyaml-dev     libmicrohttpd-dev     libcurl4-openssl-dev     libnghttp2-dev     libssl-dev     cppcheck     clang-tidy


[ ! -d open5gs ] && git clone https://github.com/open5gs/open5gs
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
sudo rm -rf /etc/open5gs/*
sudo cp -rf build/configs/open5gs/* /etc/open5gs/
sudo chown -R open5gs:open5gs /etc/open5gs/

# CREATE DIRECTORY FOR LOGFILE 
sudo mkdir -p  /var/log/open5gs
sudo chown -R open5gs:open5gs /var/log/open5gs

# CHANGE THE ADDRESS OF NRF TO PATCH THE CONFIGURATION OF NRF
sudo sed -i 's/address: 127.0.0.10/address: 127.0.0.200/' /etc/open5gs/nrf.yaml

# CHANGE THE ADDRESS  PATCH THE CONFIGURATION OF SCP
sudo sed -i 's/127\.0\.0\.200/127.0.1.10/' /etc/open5gs/scp.yaml
sudo sed -i 's|http://127\.0\.0\.10:7777|http://127.0.0.200:7777|' /etc/open5gs/scp.yaml

# COPY ALL SYSTEMD FILES
sudo cp build/configs/systemd/*.service /etc/systemd/system/
cd ..



sudo systemctl daemon-reload

systemctl list-unit-files | grep open5gs
sudo systemctl enable $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
sudo systemctl stop $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
