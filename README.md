# STEP 0 : PREPARING SYSTEM
## Install Ubuntu 22.04
Download and install ubuntu 22.04
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
sudo apt update && apt install -y wget curl neofetch
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
sudo apt install linux-lowlatency linux-headers-lowlatency linux-tools-lowlatency linux-cloud-tools-lowlatency
```
```
apt install cset stress-ng
```
### To add menu mode
```
sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
```
### To have timeout in second
```
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=15/' /etc/default/grub
```
### To upgrade GRUB 
```
sudo update-grub
```
### On Reboot
Choose : 
```
Advanced options for Ubuntu
Then, Ubuntu, with Linux Low latency
```
## Configure CPU Optimization
# STEP 1 : OPEN-SOURCE 5G NETWORK INSTALL
## Install UHD
### Install by source 
The installation is by source due to the GPSDO which need to be patched 
```
cd nuradio
```
```
[ -f "uhd_v4.1.0.5_install.sh" ] && sudo rm -rf uhd_v4.1.0.5_install.sh; wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/uhd_v4.1.0.5_install.sh
```
```
chmod +x uhd_v4.1.0.5_install.sh && bash uhd_v4.1.0.5_install.sh
```
### Install FW images
```
cd /usr/lib/uhd/utils && \
ls && \
sudo ./uhd_images_downloader.py
```
or directly : 
```
sudo uhd_images_downloader
```
### Verify FW is download completly
```
cd /usr/share/uhd/images && \
ls
```
Close the terminal
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
[ -d "srsRAN_Project" ]  && cd cd srsRAN_Project &&  sudo make test -j $(nproc --ignore 1)
```
```
gnb --version
```
## Install Open5gs
### Install Mongodb
### Install Open5gs
### Install NodeJS (WEBUI)



