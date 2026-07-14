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
sudo apt update && sudo apt install -y wget curl neofetch zsh net-tools
```

## Checking of installation of utility
```
wget --version
```
```
neofetch
```
```
ifconfig
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
```
[ -f "srsran_50fe9623c_install.sh" ] && sudo rm -rf srsran_50fe9623c_install.sh; wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/srsran_50fe9623c_install.sh
```
```
chmod +x srsran_50fe9623c_install.sh && bash srsran_50fe9623c_install.sh
```
### Verify srsRAN
Verify 
```
[ -d "srsRAN_Project/build" ] && sudo make -C srsRAN_Project/build test -j "$(nproc --ignore=1)"
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
mongod --version
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
### Checking of Open5gs
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

### Checking NodeJS (WEBUI)
```
node -v
```
20.20.2
```
npm -v
```
10.8.2
### Checking file of WEBUI
```
ls open5gs/webui/.next/
```
THIS DIRECTORY SHOULD EXIST : BUILD_ID
```
ls open5gs/webui/
```
THIS DIRECTORY SHOULD EXIST : server/  </br>
THIS DIRECTORY SHOULD EXIST  : static/  </br>

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
sudo systemctl status open5gs-webui
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
### Killing one by one
```
ps aux | grep open5gs
```
```
sudo systemctl stop open5gs-pcrfd
```
```
sudo systemctl stop open5gs-mmed
```
```
sudo systemctl stop open5gs-hssd
```
```
sudo systemctl stop open5gs-sgwud
```
```
sudo systemctl stop open5gs-sgwcd
```
```
ps aux | grep open5gs
```
### Killing all directly
```
sudo systemctl stop $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
```
sudo systemctl status $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
```
ps aux | grep open5gs
```

## Create and Start script on Open5Gs
```
ps aux | grep open5gs
```
### Creating script stop_5gc
```
sudo tee stop_5gc > /dev/null <<'EOF'
#!/usr/bin/zsh

########################################
# Clear Open5GS logs
########################################
sudo rm -f /var/log/open5gs/*

########################################
# Stop Open5GS 4G EPC
########################################
sudo systemctl stop open5gs-mmed
sudo systemctl stop open5gs-sgwcd
sudo systemctl stop open5gs-sgwud
sudo systemctl stop open5gs-hssd
sudo systemctl stop open5gs-pcrfd

########################################
# Stop Open5GS 5G Core
########################################
sudo systemctl stop open5gs-smfd
sudo systemctl stop open5gs-amfd
sudo systemctl stop open5gs-upfd
sudo systemctl stop open5gs-nrfd
sudo systemctl stop open5gs-scpd
sudo systemctl stop open5gs-ausfd
sudo systemctl stop open5gs-udmd
sudo systemctl stop open5gs-pcfd
sudo systemctl stop open5gs-nssfd
sudo systemctl stop open5gs-bsfd
sudo systemctl stop open5gs-udrd

########################################
# Stop Open5GS WebUI
########################################
sudo systemctl stop open5gs-webui
EOF
```

```
sudo chmod +x stop_5gc
```
```
sudo cp -rf stop_5gc /usr/bin/stop_5gc
```
### Creating script start_5gc
```
sudo tee start_5gc > /dev/null <<'EOF'
#!/usr/bin/zsh

########################################
# Restart Open5GS 5GC Database
########################################
sudo systemctl restart open5gs-udrd
sudo systemctl restart open5gs-udmd
sudo systemctl restart open5gs-ausfd

########################################
# Restart Open5GS 5GC Service Discovery
########################################
sudo systemctl restart open5gs-nrfd
sudo systemctl restart open5gs-scpd

########################################
# Restart Open5GS 5GC Policy Functions
########################################
sudo systemctl restart open5gs-nssfd
sudo systemctl restart open5gs-bsfd
sudo systemctl restart open5gs-pcfd

########################################
# Restart Open5GS 5GC AMF/SMF/UPF
########################################
sudo systemctl restart open5gs-amfd
sudo systemctl restart open5gs-smfd
sudo systemctl restart open5gs-upfd

########################################
# Restart Open5GS WebUI
########################################
sudo systemctl restart open5gs-webui
EOF
```

```
sudo chmod +x start_5gc
```
```
sudo cp -rf start_5gc /usr/bin/start_5gc
```
### Creating script 5gc as restart_5gc
```
sudo tee 5gc > /dev/null <<'EOF'
#!/usr/bin/zsh

sudo stop_5gc
sudo start_5gc
EOF
```

```
sudo chmod +x 5gc
```
```
sudo cp -rf 5gc /usr/bin/5gc
```

```
sudo tee restart_5gc > /dev/null <<'EOF'
#!/usr/bin/zsh

stop_5gc
start_5gc
EOF
```

```
sudo chmod +x restart_5gc
```
```
sudo cp -rf restart_5gc /usr/bin/restart_5gc 
```

```
ps aux | grep open5gs
```

# STEP 4 : OPEN-SOURCE 5G NETWORK CONFIGURATION OPEN5GS
## Configuration OGSTUN
### Explainning the 3 scenarios : 
The goal is to have schenario 3,
* Scenario 1 : OGSTUN Interface is not configured
1. ifconfig </br>
2. observe no interface named 'ogstun' </br>
3. sudo ip tuntap add name ogstun mode tun </br>
4. sudo ip addr add 10.45.0.1/16 dev ogstun </br>
5. sudo ip link set ogstun up </br>

* Scenario 2 : OGSTUN Interface is not with no IP Address
1. ifconfig  </br>

<div align="center">

<table border="1" align="center">
<tr>
<th align="center">Scenario 2</th>
</tr>
<tr>
<td>

<pre>
<font color="green"><b>ogstun</b></font>: flags=430&lt;UP,POINTOPOINT,RUNNING,NOARP,MULTICAST&gt; mtu 1400
        inet6 fe80::0c02:ce67:6831 prefixlen 64 scopeid 0x20&lt;link&gt;
        <font color="green"><b>inet</b></font> 2001:db8:ca0e::1 prefixlen 48 scopeid 0x0&lt;global&gt;
        unspec 00-00-00-00-00-00-00-00-00-00-00 00-00-00-00-00-00-00-00-00-
        RX packets 772 bytes 50678 (49.4 KiB)
        RX errors 0 dropped 0 overruns 0 frame 0
        TX packets 213 bytes 10776 (10.5 KiB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0
</pre>

</td>
</tr>
</table>

</div>


2. sudo ip addr add 10.45.0.1/16 dev ogstun

* Scenario 3 :  OGSTUN Interface is configured with IP Address </br>
1. ifconfig

<div align="center">

<table border="1" align="center">
<tr>
<th align="center">Scenario 3</th>
</tr>
<tr>
<td>

<pre>
<font color="green"><b>ogstun</b></font>: flags=430&lt;UP,POINTOPOINT,RUNNING,NOARP,MULTICAST&gt; mtu 1400
        <font color="green"><b>inet</b></font> 10.45.0.1 <font color="green"><b>netmask</b></font> 255.255.0.0 <font color="green"><b>destination</b></font> 10.45.0.1
        inet6 fe80::0c02:ce67:6831 prefixlen 64 scopeid 0x20&lt;link&gt;
        <font color="green"><b>inet</b></font> 2001:db8:ca0e::1 prefixlen 48 scopeid 0x0&lt;global&gt;
        unspec 00-00-00-00-00-00-00-00-00-00-00 00-00-00-00-00-00-00-00-00-
        RX packets 772 bytes 50678 (49.4 KiB)
        RX errors 0 dropped 0 overruns 0 frame 0
        TX packets 213 bytes 10776 (10.5 KiB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0
</pre>

</td>
</tr>
</table>

</div>

### Optionnal : If you want to del interface ogstun
```
ifconfig
```
```
sudo ip link delete  ogstun
```
Checking by using : 
```
ifconfig
```

### Choosing and processing all scenarios

```
sudo tee configure_ogstun.sh > /dev/null <<'EOF'
#!/bin/bash

if ifconfig ogstun >/dev/null 2>&1; then
    if ifconfig ogstun | grep -q "inet.*netmask.*destination"; then
        scenario="scenario3"
        echo "$scenario"
        echo "The configuration is good, no modification."
    else
        scenario="scenario2"
        echo "$scenario"

        sudo ip tuntap add name ogstun mode tun
        sudo ip addr add 10.45.0.1/16 dev ogstun
        sudo ip link set ogstun up
    fi
else
    scenario="scenario1"
    echo "$scenario"

    sudo ip addr add 10.45.0.1/16 dev ogstun
fi

# Vérification après les modifications
if ifconfig ogstun >/dev/null 2>&1; then
    if ifconfig ogstun | grep -q "inet.*netmask.*destination"; then
        scenario="scenario3"
    else
        scenario="scenario2"
    fi
else
    scenario="scenario1"
fi

echo "Scenario should be scenario3 after process: $scenario"
EOF
```
```
sudo chmod +x configure_ogstun.sh
```
```
cp -rf configure_ogstun.sh /usr/local/bin/configure_ogstun.sh
```
```
bash configure_ogstun.sh
```
Scenario 3 should appears

### Checking ogstun

```
sudo tee check_ogstun.sh > /dev/null <<'EOF'
#!/bin/bash

# Vérification après les modifications
if ifconfig ogstun >/dev/null 2>&1; then
    if ifconfig ogstun | grep -q "inet.*netmask.*destination"; then
        scenario="scenario3"
    else
        scenario="scenario2"
    fi
else
    scenario="scenario1"
fi

echo "Scenario should be scenario3 after Checking: $scenario"
EOF
```
```
sudo chmod +x check_ogstun.sh
```
```
cp -rf check_ogstun.sh /usr/local/bin/check_ogstun.sh
```
```
bash check_ogstun.sh
```
Scenario 3 should appears
## Configuration of routing Backhaul Internet

## Configuration PLMN amf.conf

# STEP 5 : OPEN-SOURCE 5G NETWORK  CONFIGURATION WEBUI

# STEP 6 : OPEN-SOURCE 5G NETWORK  CONFIGURATION SRSRAN_GNB



