# STEP 0 : PREPARING SYSTEM
## Installation Ubuntu 22.04
* Download and install ubuntu 22.04
* Use RAM >= 4Gio

## Creation repository
```
[ -d "nuradio" ] && sudo rm -rf nuradio; mkdir nuradio && cd nuradio
```
## Checking the nuradio directory  
```
pwd | grep nuradio
```
## Installation utility
```
sudo apt update && sudo apt install -y wget curl neofetch zsh net-tools
```

## Checking installation of utility
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
### Configuring grub adding menu mode
```
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
```
### Checking grub for mode menu
```
cat /etc/default/grub | grep GRUB_TIMEOUT_STYLE | grep menu
```
### Configuring grub timeout in second
```
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
```
## Checking grub timeout in second
```
cat /etc/default/grub | grep GRUB_TIMEOUT | grep 5
```
## Changing low latency as default Grub
```
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux '"$(ls /boot/vmlinuz* | grep lowlatency | sed 's|^/boot/vmlinuz-||')"'"/' /etc/default/grub
```
```
cat /etc/default/grub | grep GRUB_DEFAULT | grep lowlatency
```
### Upgrading GRUB 
```
sudo update-grub
```
### Rebooting
```
reboot
```

### Checking after reboot
```
uname -r | grep lowlatency
```

# STEP 1 : OPEN-SOURCE 5G NETWORK INSTALL
## Installing UHD
### Installing UHD by source 
The installation is by source due to the GPSDO which need to be patched 
```
cd $HOME/nuradio
```
```
[ -f "install_uhd_v4.1.0.5.sh" ] && sudo rm -rf install_uhd_v4.1.0.5.sh; \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_uhd_v4.1.0.5.sh
```
```
chmod +x install_uhd_v4.1.0.5.sh && bash install_uhd_v4.1.0.5.sh
```
### Checking UHD
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
### Installing FW images
```
sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py
```
or directly : 
```
sudo uhd_images_downloader
```
### Checking if FW is download completly
```
ls /usr/local/share/uhd/images
```
### Checking with pluging USRP
```
uhd_find_devices
```
```
uhd_usrp_probe
```
```
sudo query_gpsdo_sensors 
```

## Installing srsRAN
### Installing srsRAN by source
```
[ -f "srsran_50fe9623c_install.sh" ] && sudo rm -rf srsran_50fe9623c_install.sh; wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/srsran_50fe9623c_install.sh
```
```
chmod +x srsran_50fe9623c_install.sh && bash srsran_50fe9623c_install.sh
```
### Checking srsRAN
Verify 
```
[ -d "srsRAN_Project/build" ] && sudo make -C srsRAN_Project/build test -j "$(nproc --ignore=1)"
```
```
gnb --version
```
## Installing Open5gs
### Installing Mongodb
```
[ ! -f install_mongodb_6.0.sh ] && wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/main/files/install_mongodb_6.0.sh
```
```
chmod +x install_mongodb_6.0.sh && bash install_mongodb_6.0.sh
```

### Checking MongoDB
```
mongod --version
```
```
sudo systemctl restart mongod
```
```
sudo systemctl status mongod
```

### Installing Open5gs
```
[ ! -f install_open5gs_2.7.sh ] && \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_open5gs_2.7.sh
```
```
chmod +x install_open5gs_2.7.sh && bash install_open5gs_2.7.sh
```
### Checking Open5gs
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

### Installing NodeJS (WEBUI)
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
ls open5gs-webui/webui/.next/
```
THIS DIRECTORY SHOULD EXIST : BUILD_ID
```
ls open5gs-webui/webui/
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

Taping on broswer :
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

# STEP 2 : OPEN-SOURCE 5G NETWORK ADMIN
## Killing all processes on Open5Gs
### Alternative 1 (Bad Practice + Optionnal) : Killing one by one
```
ps aux | grep open5gs
```
Find all processes and kill one by one like 'for EXAMPLE' : 
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
### Alternative 2 (automated) : Killing all directly
* Restarting all processes
```
sudo systemctl restart $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```

* Showing all processes of open5Gs
```
ps aux | grep open5gs
```
```
sudo systemctl list-unit-files --type=service | grep open5gs 
```
```
sudo systemctl status $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```

* Counting all processes
```
ps aux | grep '^open5gs' | wc -l
```
OR
```
sudo systemctl list-unit-files --type=service | grep ^open5gs | wc -l
```

* Stopping all processes
```
sudo systemctl stop $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
* Status all processes
```
sudo systemctl status $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
* Showing all process after stopping 
```
ps aux | grep open5gs
```
* Counting all processes after stopping
```
ps aux | grep '^open5gs' | wc -l
```
OR 
```
systemctl list-unit-files --type=service | grep ^open5gs | wc -l
```

## Create and Start script on Open5Gs
* Showing all process of open5Gs
```
ps aux | grep open5gs
```
* Counting all processes
```
ps aux | grep '^open5gs' | wc -l
```

### Script stop_5gc
* Creating script stop_5gc
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
* Authorizing script stop_5g as executable
```
sudo chmod +x stop_5gc
```
* Copying script stop_5g at binaries system
```
sudo cp -rf stop_5gc /usr/bin/stop_5gc
```
### Script start_5gc
* Creating script start_5gc
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
* Authorizing script start_5gc as executable
```
sudo chmod +x start_5gc
```
* Copying script start_5gc at binaries system
```
sudo cp -rf start_5gc /usr/bin/start_5gc
```
### Script 5gc
* creation script 5gc
```
sudo tee 5gc > /dev/null <<'EOF'
#!/usr/bin/zsh

sudo stop_5gc
sudo start_5gc
EOF
```
* Authorizing script 5gc as executable
```
sudo chmod +x 5gc
```
* Copying script 5g at binaries system
```
sudo cp -rf 5gc /usr/bin/5gc
```
### Script restart_5gc
* Creating script restartç_5gc
```
sudo tee restart_5gc > /dev/null <<'EOF'
#!/usr/bin/zsh

stop_5gc
start_5gc
EOF
```
* Authorizing script restart_5gc as executable
```
sudo chmod +x restart_5gc
```
* Copying script restart_5gc at binaries system
```
sudo cp -rf restart_5gc /usr/bin/restart_5gc 
```
* Showing all process of open5Gs
```
ps aux | grep open5gs
```
* Counting all processes
```
ps aux | grep '^open5gs' | wc -l
```

# STEP 3 : OPEN-SOURCE 5G NETWORK CONFIGURATION OPEN5GS
## Configuration OGSTUN
### Script showing the 3 scenarios : 
Let's see our scenario, and explain each other : 
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
<font color="green"><b>ogstun</b></font>: flags=4241&lt;UP,POINTOPOINT,NOARP,MULTICAST&gt; mtu 1400
        inet6 fe80::0c02:ce67:6831 prefixlen 64 scopeid 0x20&lt;link&gt;
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

To see our scenario, let's create this script  : 
```
sudo tee check_ogstun.sh > /dev/null <<'EOF'
#!/bin/bash

INTERFACE="ogstun"
IP_ADDR="10.45.0.1/16"

check_ogstun() {
    ip link show "$INTERFACE" >/dev/null 2>&1
}

check_ip() {
    ip addr show "$INTERFACE" | grep -q "$IP_ADDR"
}

# Vérification de la configuration actuelle
if check_ogstun; then
    if check_ip; then
        echo
        echo "Scenario 3 : OGSTUN Interface is configured with IP Address"
        ifconfig ogstun | grep --color=always -E \
"^ogstun:|"\
"inet |"\
"netmask |"\
"destination|"\
"$"
    else
        echo
        echo "Scenario 2 : OGSTUN Interface has no IP Address"
        ifconfig ogstun | grep --color=always -E \
"^ogstun:|"\
"$"
    fi
else
    echo
    echo "Scenario 1 : OGSTUN Interface is not configured"
    ifconfig
fi

echo
echo
ip addr show "$INTERFACE"

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
The goal is to have schenario 3, 

### Optionnal : If you want to del interface ogstun  : 
Launch the command or directly restart computer
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

INTERFACE="ogstun"
IP_ADDR="10.45.0.1/16"

check_ogstun() {
    ip link show "$INTERFACE" >/dev/null 2>&1
}

check_ip() {
    ip addr show "$INTERFACE" | grep -q "$IP_ADDR"
}

if check_ogstun; then
    if check_ip; then
        scenario="scenario3"
        echo "$scenario"
        echo "The configuration is good, no modification."
    else
        scenario="scenario2"
        echo "$scenario"

        sudo ip addr add "$IP_ADDR" dev "$INTERFACE"
        sudo ip link set "$INTERFACE" up
    fi
else
    scenario="scenario1"
    echo "$scenario"

    sudo ip tuntap add name "$INTERFACE" mode tun
    sudo ip addr add "$IP_ADDR" dev "$INTERFACE"
    sudo ip link set "$INTERFACE" up
fi

# Vérification finale
if check_ogstun && check_ip; then
    scenario="scenario3"
else
    scenario="FAILED"
fi

echo "Scenario after process: $scenario"

ip addr show "$INTERFACE"
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

### Rechecking ogstun
```
bash check_ogstun.sh
```
After lauching configure_ogstun.sh , scenario 3 should appears
## Configuration Blackhaul : IPv4 Forwarding
### Explaining and showing IPv4 Forwarding
Ensure IPv4 forwarding is enabled

1. Check current status:
<div align="center">

<table border="1" align="center">
<tr>
<th align="center">IPv4 Forwarding</th>
</tr>
<tr>
<td>

<pre>
$ sudo sysctl -a | grep ip_forward
<font color="green"><b>net.ipv4.ip_forward = 1</b></font>
net.ipv4.ip_forward_update_priority = 1
net.ipv4.ip_forward_use_pmtu = 0
</pre>

</td>
</tr>
</table>

</div>

2. If net.ipv4.ip_forward = 0, enable it temporarily: </br>

3. sudo sysctl -w net.ipv4.ip_forward=1 </br></br> 

Note : </br>
Open5GS laptop requires internet connection to provide data service to UE </br>

```
sudo tee check_ipv4forward.sh > /dev/null <<'EOF'
#!/bin/bash

check_ipv4forward() {
    [ "$(sudo sysctl -n net.ipv4.ip_forward)" = "1" ]
}

if check_ipv4forward; then

    echo
    echo "IPv4 Forwarding enabled"

    sudo sysctl -a | grep --color=always -E "^net\.ipv4\.ip_forward = 1$"

    echo
    echo "No need to configure IPv4 Forwarding."

else

    echo
    echo "IPv4 Forwarding disabled"

    sudo sysctl -a | grep --color=always -E "^net\.ipv4\.ip_forward = 0$"

fi

EOF
```
```
sudo chmod +x check_ipv4forward.sh
```
```
cp -rf check_ipv4forward.sh /usr/local/bin/check_ipv4forward.sh
```
```
bash check_ipv4forward.sh
```
The goal is to have 


## Configuration Blackhaul : IPTables NAT forwarding
### Explaining and showing IPTables NAT forwarding


## Configuration PLMN amf.conf

# STEP 4 : OPEN-SOURCE 5G NETWORK  CONFIGURATION WEBUI

# STEP 5 : OPEN-SOURCE 5G NETWORK  CONFIGURATION SRSRAN_GNB



