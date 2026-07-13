# STEP 0 : PREPARING SYSTEM
## Install Ubuntu 22.04
* Download and install ubuntu 22.04
* Use RAM >= 4Gio

## Creation repository
```
[ -d "nuradio" ] && sudo rm -rf nuradio; mkdir nuradio && cd nuradio
```
## Verify that the directory is at nuradio 
```
pwd | grep nuradio
```
## Installation utility
```
sudo apt update && sudo apt install -y wget curl neofetch
```

## Verification of installation of utility
```
wget --version
```
```
neofetch
```
## Installation CPU optimization
```
sudo apt install -y linux-lowlatency linux-headers-lowlatency linux-tools-lowlatency linux-cloud-tools-lowlatency
```
```
sudo apt install  -y cpuset stress-ng
```
### To add menu mode
```
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
```
### Verify mode menu
```
cat /etc/default/grub | grep GRUB_TIMEOUT_STYLE | grep menu
```

### To have timeout in second
```
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
```
## Verify timeout
```
cat /etc/default/grub | grep GRUB_TIMEOUT | grep 5
```
## Change low latency as default Grub
```
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux '"$(ls /boot/vmlinuz* | grep lowlatency | sed 's|^/boot/vmlinuz-||')"'"/' /etc/default/grub
```
```
cat /etc/default/grub | grep GRUB_DEFAULT | grep lowlatency
```
### To upgrade GRUB 
```
sudo update-grub
```
### Reboot
Check : 
```
uname -r
```

# STEP 1 : OPEN-SOURCE 5G NETWORK INSTALL
## Install UHD
### Install by source 
The installation is by source due to the GPSDO which need to be patched 
```
cd nuradio
```
```
[ -f "install_uhd_v4.1.0.5.sh" ] && sudo rm -rf install_uhd_v4.1.0.5.sh; \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_uhd_v4.1.0.5.sh
```
```
chmod +x install_uhd_v4.1.0.5.sh && bash install_uhd_v4.1.0.5.sh
```
### Verify UHD
```
uhd_config_info --version
```
```
uhd_config_info --print-all
```
```
ls /usr/local/lib/uhd/utils/
```

```
which uhd_find_devices
```
```
which uhd_usrp_probe
```
```
which uhd_images_downloader
```

### Install FW images
```
sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py
```
or directly : 
```
sudo uhd_images_downloader
```
### Verify FW is download completly
```
ls /usr/local/share/uhd/images
```
### Verify with pluging USRP
```
uhd_find_devices
```
```
uhd_usrp_probe
```
```
sudo query_gpsdo_sensors 
```

## Install srsRAN
### Install srsRAN by source
Open new terminal and make commad
```
cd nuradio
```
```
[ -f "srsran_50fe9623c_install.sh" ] && sudo rm -rf srsran_50fe9623c_install.sh; wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/srsran_50fe9623c_install.sh
```
```
chmod +x srsran_50fe9623c_install.sh && bash srsran_50fe9623c_install.sh
```
### Verify srsRAN
Verify 
```
[ -d "srsRAN_Project" ]  && cd srsRAN_Project &&  sudo make test -j $(nproc --ignore 1)
```
```
gnb --version
```
## Install Open5gs
### Install Mongodb
```
[ ! -f install_mongodb_6.0.sh ] && wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/main/files/install_mongodb_6.0.sh
```
```
chmod +x install_mongodb_6.0.sh && bash install_mongodb_6.0.sh
```

### Verify MongoDB
```
mongodb --version
```
```
sudo systemctl restart mongod
```
```
sudo systemctl status mongod
```

### Install Open5gs
```
[ ! -f install_open5gs_2.7.sh ] && \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_open5gs_2.7.sh
```
```
chmod +x install_open5gs_2.7.sh && bash install_open5gs_2.7.sh
```
### Verificaiton of Open5gs
```
ls /usr/bin/open5gs*
```
```
systemctl list-unit-files | grep open5gs
```
```
sudo systemctl enable $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
```
sudo systemctl restart $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
```
sudo systemctl status $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
```
sudo systemctl stop $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
```
which open5gs-amfd
```
```
ldd $(which open5gs-amfd) | grep ogs
```

### Install NodeJS (WEBUI)
```
[ ! -f install_webui.sh ] && \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_webui.sh
```
```
chmod +x install_webui.sh && bash install_webui.sh
```

### Verification NodeJS (WEBUI)
```
node -v
```
```
npm -v
```
```
ls open5gs/webui/*
```
```
ls open5gs/webui/.next/*
```
THE DIRECTORY SHOULD EXIST server/  </br>
THE DIRECTORY SHOULD EXIST static/  </br>

### Lauching Mongodb & WEBUI

```
sudo systemctl restart mongod
```
```
sudo systemctl status mongod
```
```
sudo systemctl restart open5gs-webui
```
```
sudo systemctl enable open5gs-webui
```

Tape on broswer :
```
http://localhost:9999
```
Login is : 
```
admin
```
Password is : 
```
1423
```

# STEP 3 : OPEN-SOURCE 5G NETWORK ADMIN
## Kill process on Open5Gs

## Create and Start script on Open5Gs

# STEP 4 : OPEN-SOURCE 5G NETWORK CONFIGURATION OPEN5GS
## Configuration OGSTUN
### scenario 1
### scenario 2
### scenario 3
## Configuration PLMN amf.conf

# STEP 5 : OPEN-SOURCE 5G NETWORK  CONFIGURATION WEBUI

# STEP 6 : OPEN-SOURCE 5G NETWORK  CONFIGURATION SRSRAN_GNB



