# STEP 0 : PREPARING SYSTEM
## 0.1. Installation Ubuntu 22.04
* Download and install ubuntu 22.04
* Use RAM >= 4Gio

## 0.2. Creation repository
```
[ -d "nuradio" ] && sudo rm -rf nuradio; mkdir nuradio && cd nuradio
```
## 0.3. Checking the nuradio directory  
```
pwd | grep nuradio
```
## 0.4. Installation utility
```
sudo apt update && sudo apt install -y wget curl neofetch zsh net-tools
```

## 0.5. Checking installation of utility
```
wget --version
```
```
neofetch
```
```
ifconfig
```
## 0.6. Installation CPU optimization
### 0.6.1. Installation
```
sudo apt install -y linux-lowlatency linux-headers-lowlatency linux-tools-lowlatency linux-cloud-tools-lowlatency
```
```
sudo apt install  -y cpuset stress-ng
```
### 0.6.2. Configuring grub adding menu mode
```
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
```
### 0.6.3. Checking grub for mode menu
```
cat /etc/default/grub | grep GRUB_TIMEOUT_STYLE | grep menu
```
### 0.6.4. Configuring grub timeout in second
```
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
```
## 0.6.5. Checking grub timeout in second
```
cat /etc/default/grub | grep GRUB_TIMEOUT | grep 5
```
## 0.7. Changing low latency as default Grub
### 0.7.1. Installation
```
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux '"$(ls /boot/vmlinuz* | grep lowlatency | sed 's|^/boot/vmlinuz-||')"'"/' /etc/default/grub
```
```
cat /etc/default/grub | grep GRUB_DEFAULT | grep lowlatency
```
### 0.7.2. Upgrading GRUB 
```
sudo update-grub
```
### 0.7.3. Rebooting
```
reboot
```

### 0.7.4. Checking after reboot
```
uname -r | grep lowlatency
```

# STEP 1 : OPEN-SOURCE 5G NETWORK INSTALL
## 1.1. Installing UHD
### 1.1.1. Installing UHD by source 
The installation is by source due to the GPSDO which need to be patched 
```
[ ! -d "$HOME/nuradio/script_install" ] && mkdir -p "$HOME/nuradio/script_install"
```
```
cd "$HOME/nuradio/script_install" && \
[ -f "install_uhd_v4.1.0.5.sh" ] && sudo rm -rf install_uhd_v4.1.0.5.sh; \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_uhd_v4.1.0.5.sh
```
```
chmod +x "$HOME/nuradio/script_install/install_uhd_v4.1.0.5.sh" && \
bash "$HOME/nuradio/script_install/install_uhd_v4.1.0.5.sh"
```
### 1.1.2. Checking UHD
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
### 1.1.3. Installing FW images
```
sudo uhd_images_downloader
```
OR,
```
sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py
```
### 1.1.4. Checking if FW is download completly
```
ls /usr/local/share/uhd/images
```
### 1.1.5. Checking with pluging USRP
```
uhd_find_devices
```
```
uhd_usrp_probe
```
```
sudo query_gpsdo_sensors 
```

## 1.2. Installing srsRAN
### 1.2.1. Installing srsRAN by source
```
[ ! -d "$HOME/nuradio/script_install" ] && mkdir -p "$HOME/nuradio/script_install"
```
```
cd "$HOME/nuradio/script_install" && \
[ -f "install_srsran_50fe9623c.sh" ] && sudo rm -rf install_srsran_50fe9623c.sh; \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_srsran_50fe9623c.sh
```
```
chmod +x "$HOME/nuradio/script_install/install_srsran_50fe9623c.sh" && \
bash "$HOME/nuradio/script_install/install_srsran_50fe9623c.sh"
```
### 1.2.2. Checking srsRAN
Verify 
```
[ -d "$HOME/nuradio/script_install/srsRAN_Project/build" ] && \
sudo make -C "$HOME/nuradio/script_install/srsRAN_Project/build" test -j "$(nproc --ignore=1)"
```
```
gnb --version
```
## 1.3. Installing Open5gs
### 1.3.1. Installing Mongodb
```
[ ! -d "$HOME/nuradio/script_install" ] && mkdir -p "$HOME/nuradio/script_install"
```
```
cd "$HOME/nuradio/script_install" && \
[ ! -f install_mongodb_6.0.sh ] && wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/main/files/install_mongodb_6.0.sh
```
```
chmod +x "$HOME/nuradio/script_install/install_mongodb_6.0.sh" && \
bash "$HOME/nuradio/script_install/install_mongodb_6.0.sh"
```

### 1.3.2. Checking MongoDB
```
mongod --version
```
```
sudo systemctl restart mongod
```
```
sudo systemctl status mongod
```

### 1.3.3. Installing Open5gs

```
[ ! -d "$HOME/nuradio/script_install" ] && mkdir -p "$HOME/nuradio/script_install"
```
```
cd "$HOME/nuradio/script_install" && \
[ ! -f install_open5gs_2.7.sh ] && \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_open5gs_2.7.sh
```
```
chmod +x "$HOME/nuradio/script_install/install_open5gs_2.7.sh" && \
bash "$HOME/nuradio/script_install/install_open5gs_2.7.sh"
```

### 1.3.5. Checking Open5gs
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

### 1.3.5. Installing NodeJS (WEBUI)
```
[ ! -d "$HOME/nuradio/script_install" ] && mkdir -p "$HOME/nuradio/script_install"
```
```
cd "$HOME/nuradio/script_install" && \
[ ! -f "install_webui.sh" ] && \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_webui.sh
```
```
chmod +x "$HOME/nuradio/script_install/install_webui.sh" && \
bash "$HOME/nuradio/script_install/install_webui.sh"
```

### 1.3.6. Checking NodeJS (WEBUI)
```
node -v
```
20.20.2
```
npm -v
```
10.8.2
### 1.3.7. Checking file of WEBUI
```
sudo ls "$HOME/nuradio/script_install/open5gs-webui/webui/.next/"
```
THIS DIRECTORY SHOULD EXIST : server/  </br>
THIS DIRECTORY SHOULD EXIST  : static/  </br>
```
sudo ls "$HOME/nuradio/script_install/open5gs-webui/webui/" | grep --color=always -E \
-e 'server|$' \
-e 'static|$'
```

### 1.3.8. Lauching Mongodb & WEBUI

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
## 2.1. Killing all processes on Open5Gs
### 2.1.1. Optionnal Alternative 1 
It's a bad Practice by Killing one by one
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
### 2.1.2. Alternative 2 (automated) : Killing all directly
* Listing all services (even the process is stopped)
```
sudo systemctl list-unit-files --type=service | grep open5gs 
```
* Counting all services (even the process is stopped)
```
sudo systemctl list-unit-files --type=service | grep ^open5gs | wc -l
```
18 because webui is in the service system

* Restarting all processes
```
sudo systemctl restart $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
* Showing all processes of open5Gs
```
ps aux | grep open5gs
```
More informations,
```
sudo systemctl status $(systemctl list-unit-files --type=service | grep open5gs | awk '{print $1}')
```
* Counting all processes
```
ps aux | grep 'open5gs' | wc -l | awk '{print $1-1}'
```
17 because the process webui doesn't begin by open5gs

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
0 will be the value </br> </br>
OR
```
ps aux | grep 'open5gs' | wc -l | awk '{print $1-1}'
```
0 will be the value 

## 2.2. Create and Start script on Open5Gs
### 2.2.1. Managing script
* Preparing directory
```
[ ! -d "$HOME/nuradio/script_open5gs" ] && mkdir -p "$HOME/nuradio/script_open5gs"
```
```
cd $HOME/nuradio/script_open5gs
```

* Showing all process of open5Gs
```
ps aux | grep open5gs
```
* Counting all processes
```
ps aux | grep '^open5gs' | wc -l
```

### 2.2.2. Script stop_5gc
* Creating script stop_5gc
```
[ ! -d "$HOME/nuradio/script_open5gs" ] && mkdir -p "$HOME/nuradio/script_open5gs"
```
```
cd "$HOME/nuradio/script_open5gs" && \
sudo tee "$HOME/nuradio/script_open5gs/stop_5gc" > /dev/null <<'EOF'
#!/usr/bin/zsh

########################################
# Clear Open5GS logs
########################################
# sudo rm -f /var/log/open5gs/*
sudo find /var/log/open5gs -type f -delete

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
sudo systemctl stop open5gs-seppd

########################################
# Stop Open5GS WebUI
########################################
sudo systemctl stop open5gs-webui
EOF
```
* Authorizing script stop_5g as executable
```
sudo chmod +x "$HOME/nuradio/script_open5gs/stop_5gc"
```
* Copying script stop_5g at binaries system
```
sudo cp -rf "$HOME/nuradio/script_open5gs/stop_5gc" /usr/bin/stop_5gc
```
### 2.2.3. Script start_5gc
* Creating script start_5gc
```
[ ! -d "$HOME/nuradio/script_open5gs" ] && mkdir -p "$HOME/nuradio/script_open5gs"
```
```
cd "$HOME/nuradio/script_open5gs" && \
sudo tee "$HOME/nuradio/script_open5gs/start_5gc" > /dev/null <<'EOF'
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
sudo systemctl restart open5gs-seppd

########################################
# Restart Open5GS WebUI
########################################
sudo systemctl restart open5gs-webui
EOF
```
* Authorizing script start_5gc as executable
```
sudo chmod +x "$HOME/nuradio/script_open5gs/start_5gc"
```
* Copying script start_5gc at binaries system
```
sudo cp -rf "$HOME/nuradio/script_open5gs/start_5gc" /usr/bin/start_5gc
```
### 2.2.4. Script 5gc
* creation script 5gc
```
[ ! -d "$HOME/nuradio/script_open5gs" ] && mkdir -p "$HOME/nuradio/script_open5gs"
```
```
cd $HOME/nuradio/script_open5gs && \
sudo tee "$HOME/nuradio/script_open5gs/5gc" > /dev/null <<'EOF'
#!/usr/bin/zsh

sudo stop_5gc
sudo start_5gc
EOF
```
* Authorizing script 5gc as executable
```
sudo chmod +x "$HOME/nuradio/script_open5gs/5gc"
```
* Copying script 5g at binaries system
```
sudo cp -rf "$HOME/nuradio/script_open5gs/5gc" /usr/bin/5gc
```
### 2.2.5. Script restart_5gc
* Creating script restart_5gc
```
[ ! -d "$HOME/nuradio/script_open5gs" ] && mkdir -p "$HOME/nuradio/script_open5gs"
```
```
cd "$HOME/nuradio/script_open5gs" && \
sudo tee "$HOME/nuradio/script_open5gs/restart_5gc" > /dev/null <<'EOF'
#!/usr/bin/zsh

stop_5gc
start_5gc
EOF
```
* Authorizing script restart_5gc as executable
```
sudo chmod +x "$HOME/nuradio/script_open5gs/restart_5gc"
```
* Copying script restart_5gc at binaries system
```
sudo cp -rf "$HOME/nuradio/script_open5gs/restart_5gc" /usr/bin/restart_5gc 
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
## 3.1. Configuration OGSTUN
### 3.1.1. Script showing the 3 scenarios : 
* Explaing scenario of interfaces ogstun
Let's see our scenario, and explain each other : 

'Scenario 1' : OGSTUN Interface is not configured
1. ifconfig </br>
2. observe no interface named 'ogstun' </br>
3. sudo ip tuntap add name ogstun mode tun </br>
4. sudo ip addr add 10.45.0.1/16 dev ogstun </br>
5. sudo ip link set ogstun up </br>

'Scenario 2' : OGSTUN Interface is not with no IP Address

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

'Scenario 3' :  OGSTUN Interface is configured with IP Address </br>
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
* Checking ogstun

To see our scenario, let's create this script  : 
```
[ ! -d "$HOME/nuradio/script_network" ] && mkdir -p "$HOME/nuradio/script_network"
```
```
cd "$HOME/nuradio/script_network" && \
sudo tee "$HOME/nuradio/script_network/check_ogstun.sh" > /dev/null <<'EOF'
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

        ifconfig ogstun | \
        grep --color=always -E \
                -e "^ogstun:|" \
                -e "inet |" \
                -e "netmask |"  \
                -e "destination|"\
                -e "$"
    else
        echo
        echo "Scenario 2 : OGSTUN Interface has no IP Address"

        ifconfig ogstun | \
        grep --color=always -E \
                -e "^ogstun:|" \
                -e "$"
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
sudo chmod +x "$HOME/nuradio/script_network/check_ogstun.sh" && \
sudo cp -rf "$HOME/nuradio/script_network/check_ogstun.sh" /usr/bin/check_ogstun.sh
```
```
sudo check_ogstun.sh
```
OR
```
bash "$HOME/nuradio/script_network/check_ogstun.sh"
```
The goal is to have Scenario 3, 
```
sudo check_ogstun.sh | grep "Scenario 3"
```

### 3.1.2. Optionnal : If you want to del interface ogstun  : 
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

### 3.1.3. Configuring to the scenarios 3
```
[ ! -d "$HOME/nuradio/script_network" ] && mkdir -p "$HOME/nuradio/script_network"
```
```
cd "$HOME/nuradio/script_network" && \
sudo tee "$HOME/nuradio/script_network/configure_ogstun.sh" > /dev/null <<'EOF'
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
sudo chmod +x "$HOME/nuradio/script_network/configure_ogstun.sh" && \
sudo cp -rf "$HOME/nuradio/script_network/configure_ogstun.sh" /usr/bin/configure_ogstun.sh
```
```
sudo configure_ogstun.sh
```
OR
```
sudo bash "$HOME/nuradio/script_network/configure_ogstun.sh"
```
Scenario 3 should appears

### 3.1.4. Rechecking ogstun
```
sudo check_ogstun.sh
```
After lauching configure_ogstun.sh , scenario 3 should appears
## 3.2. Configuration Blackhaul : IPv4 Forwarding
### 3.2.1. Explaining and showing IPv4 Forwarding
* Explaining IPv4 Forwading
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
* Checking IPv4 Forwading
```
[ ! -d "$HOME/nuradio/script_network" ] && mkdir -p "$HOME/nuradio/script_network"
```
```
cd "$HOME/nuradio/script_network" && \
sudo tee "$HOME/nuradio/script_network/check_ipv4forward.sh" > /dev/null <<'EOF'
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
sudo chmod +x "$HOME/nuradio/script_network/check_ipv4forward.sh" && \
sudo cp -rf "$HOME/nuradio/script_network/check_ipv4forward.sh" /usr/bin/check_ipv4forward.sh
```
```
sudo check_ipv4forward.sh
```
OR
```
sudo bash "$HOME/nuradio/script_network/check_ipv4forward.sh"
```

The goal is to have  net.ipv4.ip_forwad = 1

### 3.2.2. Configure IPv4 forward
```
[ ! -d "$HOME/nuradio/script_network" ] && mkdir -p "$HOME/nuradio/script_network"
```
```
cd "$HOME/nuradio/script_network" && \
sudo tee "$HOME/nuradio/script_network/configure_ipv4forward.sh" > /dev/null <<'EOF'
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
    echo "Configure net.ipv4.ip_forward"

    sudo sysctl -w net.ipv4.ip_forward=1

    echo
    echo "IPv4 Forwarding enabled"

    sudo sysctl -a | grep --color=always -E "^net\.ipv4\.ip_forward = 1$"

fi

EOF
```
```
sudo chmod +x configure_ipv4forward.sh && \
sudo cp -rf configure_ipv4forward.sh /usr/bin/configure_ipv4forward.sh
```
```
sudo configure_ipv4forward.sh
```
### 3.2.3. Rechecking IPv4 Forwading
```
sudo configure_ipv4forward.sh
```
  
## 3.3. Configuration Blackhaul : IPTABLE NAT forwarding
### 3.3.1. Explaining and showing IPTABLE NAT forwarding
* Explaining IPTABLE NAT forwarding
1. sudo iptables -L -n -v -t nat
<div align="center">

<table border="1" align="center">
<tr>
<th align="center">IPTables NAT forwarding</th>
</tr>
<tr>
<td>

<pre>
$ sudo iptables -t nat -L -n -v

Chain POSTROUTING (policy ACCEPT)
 pkts bytes target     prot opt in  out     source      destination
    0     0 MASQUERADE all  --  *   <font color="green"><b>ogstun</b></font>  0.0.0.0/0   0.0.0.0/0
</pre>

</td>
</tr>
</table>

</div>

2. if ogstun 10.45.0.1/15 is not displayed
3. sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
* Checking IPTABLES  Forwading
```
[ ! -d "$HOME/nuradio/script_network" ] && mkdir -p "$HOME/nuradio/script_network"
```
```
cd "$HOME/nuradio/script_network" && \
sudo tee "$HOME/nuradio/script_network/check_iptableNATforward.sh" > /dev/null <<'EOF'
#!/bin/bash

check_iptableNATforward() {
    sudo iptables -t nat -L -n -v | grep -q "ogstun"
}

if check_iptableNATforward; then

    echo
    echo "IPTABLE NAT Forwarding enabled"
    echo

    sudo iptables -t nat -L -n -v | grep --color=always -E "ogstun|$"

    echo
    echo "No need to configure IPTABLE NAT Forwarding."

else

    echo
    echo "IPTABLE NAT Forwarding disabled"
    echo

    sudo iptables -t nat -L -n -v

fi

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_network/check_iptableNATforward.sh" && \
sudo cp -rf "$HOME/nuradio/script_network/check_iptableNATforward.sh" /usr/bin/check_iptableNATforward.sh
```
```
sudo check_iptableNATforward.sh
```
OR
```
sudo bash "$HOME/nuradio/script_network/check_iptableNATforward.sh"
```

### 3.3.2. Configuring IPTABLE NAT forwading
```
[ ! -d "$HOME/nuradio/script_network" ] && mkdir -p "$HOME/nuradio/script_network"
```
```
cd "$HOME/nuradio/script_network" && \
sudo tee "$HOME/nuradio/script_network/configure_iptableNATforward.sh" > /dev/null <<'EOF'
#!/bin/bash

check_iptableNATforward() {
    sudo iptables -t nat -L -n -v | grep -q "ogstun"
}

if check_iptableNATforward; then

    echo
    echo "IPTABLE NAT Forwarding enabled"
    echo

    sudo iptables -t nat -L -n -v | grep --color=always -E "ogstun|$"

    echo
    echo "No need to configure IPTABLE NAT Forwarding."

else

    echo
    echo "IPTABLE NAT Forwarding disabled"
    echo
    echo "Configure IPTABLE NAT Forwarding"

    sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE

    echo
    echo "IPTABLE NAT Forwarding enabled"
    echo

    sudo iptables -t nat -L -n -v | grep --color=always -E "ogstun|$"

fi

EOF
```
```
sudo chmod +x  "$HOME/nuradio/script_network/configure_iptableNATforward.sh" && \
sudo cp -rf  "$HOME/nuradio/script_network/configure_iptableNATforward.sh" /usr/bin/configure_iptableNATforward.sh
```
```
sudo configure_iptableNATforward.sh
```
OR
```
sudo bash  "$HOME/nuradio/script_network/configure_iptableNATforward.sh"
```
### 3.3.3. Rechecking IPTABLE NAT Forwading
```
bash check_iptableNATforward.sh
```
## 3.4. Configuring && Checking network final
### 3.4.1. Configuring network final
```
sudo tee "$HOME/nuradio/script_network/configure_network.sh" > /dev/null <<'EOF'
#!/bin/bash

set -e

echo "=== Network Configuration ==="

echo "1. Configuring OGSTUN interface..."
sudo configure_ogstun.sh

echo "2. Enabling IPv4 forwarding..."
sudo configure_ipv4forward.sh

echo "3. Configuring iptables NAT forwarding..."
sudo configure_iptableNATforward.sh

echo "=== Network configuration completed successfully. ==="
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_network/configure_network.sh"
```
```
sudo cp -rf  "$HOME/nuradio/script_network/configure_network.sh" /usr/bin/configure_network.sh
```
```
sudo configure_network.sh
```

### 3.4.2. Checking network final
```
sudo tee "$HOME/nuradio/script_network/check_network.sh" > /dev/null <<'EOF'
#!/bin/bash

set -e

echo "=== Checking Network  ==="

echo "1. Checking OGSTUN interface..."
sudo check_ogstun.sh

echo "2. Enabling IPv4 forwarding..."
sudo check_ipv4forward.sh

echo "3. Configuring iptables NAT forwarding..."
sudo check_iptableNATforward.sh

echo "=== Checking Network completed successfully. ==="
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_network/check_network.sh"
```
```
sudo cp -rf "$HOME/nuradio/script_network/check_network.sh" /usr/bin/check_network.sh
```
```
sudo check_network.sh
```

## 3.5. Configuration PLMN & DEBUG MODE
### 3.5.1. Configuration amf.yaml
* Create and change directory
```
mkdir -p "$HOME/nuradio/script_amf_index1" && cd "$HOME/nuradio/script_amf_index1"
```
* Configure AMF
Directly all configuraiton in one manipulation
```
sudo tee "$HOME/nuradio/script_amf_index1/configure_amf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"

# echo "===== Avant ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"

# Remplace mcc: 999 par mcc: 001
sudo sed -Ei \
's/^([[:space:]]*mcc[[:space:]]*:[[:space:]]*)999([[:space:]]*(#.*)?)$/\1001\2/' \
"$CONFIG"

# Remplace mnc: 70 par mnc: 01
sudo sed -Ei \
's/^([[:space:]]*mnc[[:space:]]*:[[:space:]]*)70([[:space:]]*(#.*)?)$/\101\2/' \
"$CONFIG"

# Remplace tac: 1 par tac: 77
sudo sed -Ei \
's/^([[:space:]]*tac[[:space:]]*:[[:space:]]*)1([[:space:]]*(#.*)?)$/\177\2/' \
"$CONFIG"

# echo
# echo "===== Après ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/configure_amf.sh" && \
sudo cp -rf "$HOME/nuradio/script_amf_index1/configure_amf.sh" /usr/bin/configure_amf.sh
```
```
sudo configure_amf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_amf_index1/configure_amf.sh"
```

* check AMF all 
```
sudo tee "$HOME/nuradio/script_amf_index1/check_amf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"
# part 1 && add all other : amf , address sbi and scp
printf "\n\n"
sed -n '1,19p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*amf:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.5([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri[[:space:]]*:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"
    
# part 2
# printf "\n\n"
sed -n '20,49p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.5([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"
# part 3
# printf "\n\n"
sed -n '50,208p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*time[[:space:]]*:" \
    -e "^[[:space:]]*t3512[[:space:]]*:" \
    -e "^[[:space:]]*value[[:space:]]*:[[:space:]]*540.*$" \
    -e "$"

# part 4
# printf "\n\n"
for i in $(seq 209 239); do
    line=$(sed -n "${i}p" "$CONFIG")
    
    if [ "$i" -eq 226 ]; then
        echo "$line" | grep --color=always -E \
            -e "^[[:space:]]*#[[:space:]]*-[[:space:]]*plmn_id[[:space:]]*:" \
            -e "$"
    else
        echo "$line" | grep --color=always -E \
            -e "^[[:space:]]*#[[:space:]]*access_control[[:space:]]*:" \
            -e "^[[:space:]]*#[[:space:]]*-[[:space:]]*default_reject_cause[[:space:]]*:[[:space:]]*13.*$" \
            -e "^[[:space:]]*#[[:space:]]*reject_cause[[:space:]]*:[[:space:]]*15.*$" \
            -e "^[[:space:]]*#[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
            -e "^[[:space:]]*#[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
            -e "$"
    fi
done

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/check_amf.sh" && \
sudo cp -rf "$HOME/nuradio/script_amf_index1/check_amf.sh" /usr/bin/check_amf.sh
```
```
sudo check_amf.sh
```
OR 
```
sudo bash "$HOME/nuradio/script_amf_index1/check_amf.sh" 
```

* Optionnal : Configure part1 AMF log
```
sudo tee "$HOME/nuradio/script_amf_index1/configure_amf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/configure_amf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_amf_index1/configure_amf_logger.sh" 
```
* Optionnal : Configure part2 AMF MCC & MNC
```
sudo tee "$HOME/nuradio/script_amf_index1/configure_amf_mcc_mnc.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

# echo "===== Avant ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"

# Remplace mcc: 999 par mcc: 001
sudo sed -Ei \
's/^([[:space:]]*mcc[[:space:]]*:[[:space:]]*)999([[:space:]]*(#.*)?)$/\1001\2/' \
"$CONFIG"

# Remplace mnc: 70 par mnc: 01
sudo sed -Ei \
's/^([[:space:]]*mnc[[:space:]]*:[[:space:]]*)70([[:space:]]*(#.*)?)$/\101\2/' \
"$CONFIG"

# Remplace tac: 1 par tac: 77
sudo sed -Ei \
's/^([[:space:]]*tac[[:space:]]*:[[:space:]]*)1([[:space:]]*(#.*)?)$/\177\2/' \
"$CONFIG"

# echo
# echo "===== Après ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/configure_amf_mcc_mnc.sh"
```
```
sudo bash "$HOME/nuradio/script_amf_index1/configure_amf_mcc_mnc.sh"
```
*  Optionnal : Check part1 AMF log 
```
sudo tee "$HOME/nuradio/script_amf_index1/check_amf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/check_amf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_amf_index1/check_amf_1.sh" 
```
* Optionnal : Check part2 AMF : IP ADDRESS & MCC & MNC & TAC
```
sudo tee "$HOME/nuradio/script_amf_index1/check_amf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

printf "\n\n"

sed -n '20,49p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.5([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/check_amf_2.sh"
```
```
sudo bash "$HOME/nuradio/script_amf_index1/check_amf_2.sh" 
```
*  Optionnal : Check part3 AMF GNB Timer
```
sudo tee "$HOME/nuradio/script_amf_index1/check_amf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

printf "\n\n"
sed -n '40,69p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*time[[:space:]]*:" \
    -e "^[[:space:]]*t3512[[:space:]]*:" \
    -e "^[[:space:]]*value[[:space:]]*:[[:space:]]*540.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/check_amf_3.sh"
```
```
sudo bash "$HOME/nuradio/script_amf_index1/check_amf_3.sh"
```

*  Optionnal : Check part4 AMF Reject cause 
  
a little bit different, line by line

```
sudo tee "$HOME/nuradio/script_amf_index1/check_amf_4.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

printf "\n\n"
for i in $(seq 209 239); do
    line=$(sed -n "${i}p" "$CONFIG")
    
    if [ "$i" -eq 226 ]; then
        echo "$line" | grep --color=always -E \
            -e "^[[:space:]]*#[[:space:]]*-[[:space:]]*plmn_id[[:space:]]*:" \
            -e "$"
    else
        echo "$line" | grep --color=always -E \
            -e "^[[:space:]]*#[[:space:]]*access_control[[:space:]]*:" \
            -e "^[[:space:]]*#[[:space:]]*-[[:space:]]*default_reject_cause[[:space:]]*:[[:space:]]*13.*$" \
            -e "^[[:space:]]*#[[:space:]]*reject_cause[[:space:]]*:[[:space:]]*15.*$" \
            -e "^[[:space:]]*#[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
            -e "^[[:space:]]*#[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
            -e "$"
    fi
done

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_amf_index1/check_amf_4.sh"
```
```
sudo bash "$HOME/nuradio/script_amf_index1/check_amf_4.sh"
```

### 3.5.2. Configuration SMF.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_smf_index2" && cd "$HOME/nuradio/script_smf_index2"
```
* Configure SMF all
```
sudo tee "$HOME/nuradio/script_smf_index2/configure_smf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_smf_index2/configure_smf.sh" && \
sudo cp -rf "$HOME/nuradio/script_smf_index2/configure_smf.sh" /usr/bin/configure_smf.sh
```
```
sudo configure_smf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_smf_index2/configure_smf.sh"
```

* Check SMF all
```
sudo tee "$HOME/nuradio/script_smf_index2/check_smf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"
# part1 to part4 ; and add smf, sbi, upf and upd address
printf "\n\n"
sed -n '1,51p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*smf:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*dns[[:space:]]*:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.8\.8([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.4\.4([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8888([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8844([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*upf:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.7:7777([[:space:]]*#.*)?$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_smf_index2/check_smf.sh" && \
sudo cp -rf "$HOME/nuradio/script_smf_index2/check_smf.sh" /usr/bin/check_smf.sh
```
```
sudo check_smf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_smf_index2/check_smf.sh"
```

* Optionnal : Configure SMF part1 logger
```
sudo tee "$HOME/nuradio/script_smf_index2/configure_smf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_smf_index2/configure_smf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_smf_index2/configure_smf_logger.sh"
```
* Optionnal : Check part1 SMF LOG 
```
sudo tee "$HOME/nuradio/script_smf_index2/check_smf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_smf_index2/check_smf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_smf_index2/check_smf_1.sh"
```

* Optionnal : Check part2 SMF IP address 
```
sudo tee "$HOME/nuradio/script_smf_index2/check_smf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"
sed -n '1,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_smf_index2/check_smf_2.sh"
```
```
sudo bash "$HOME/nuradio/script_smf_index2/check_smf_2.sh"
```

* Optionnal : Check part3 SMF DNS 
```
sudo tee "$HOME/nuradio/script_smf_index2/check_smf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"
sed -n '23,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*dns[[:space:]]*:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.8\.8([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.4\.4([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8888([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8844([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_smf_index2/check_smf_3.sh"
```
```
sudo bash "$HOME/nuradio/script_smf_index2/check_smf_3.sh"
```

* Optionnal : Check part4 SMF OTHER ADDRESS (CLIENT SCP) 
```
sudo tee "$HOME/nuradio/script_smf_index2/check_smf_4.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_smf_index2/check_smf_4.sh"
```
```
sudo bash "$HOME/nuradio/script_smf_index2/check_smf_4.sh"
```

### 3.5.3. Configuration upf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_upf_index3" && cd "$HOME/nuradio/script_upf_index3"
```
* Configure UPF all
```
sudo tee "$HOME/nuradio/script_upf_index3/configure_upf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_upf_index3/configure_upf.sh" && \
sudo cp -rf "$HOME/nuradio/script_upf_index3/configure_upf.sh" /usr/bin/configure_upf.sh
```
```
sudo configure_upf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_upf_index3/configure_upf.sh"
```

* Check UPF all

If you add smf in upf; the relation between them will be more active </br>
the easy way, is that the smf find the upf not also upf find the smf </br>

```
sudo tee "$HOME/nuradio/script_upf_index3/check_upf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

# Part1 and part2 & upf, addres upf 
printf "\n\n"
sed -n '1,27p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*upf:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.7([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_upf_index3/check_upf.sh" && \
sudo cp -rf "$HOME/nuradio/script_upf_index3/check_upf.sh" /usr/bin/check_upf.sh
```
```
sudo check_upf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_upf_index3/check_upf.sh"
```

* Configure UPF Logger
```
sudo tee "$HOME/nuradio/script_upf_index3/configure_upf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_upf_index3/configure_upf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_upf_index3/configure_upf_logger.sh"
```
* Optionnal : Check part1 UPF LOG 
```
sudo tee "$HOME/nuradio/script_upf_index3/check_upf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_upf_index3/check_upf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_upf_index3/check_upf_1.sh"
```

* Optionnal : Check part2 UPF IP ADDRESS
```
sudo tee "$HOME/nuradio/script_upf_index3/check_upf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

printf "\n\n"

sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.7([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_upf_index3/check_upf_2.sh"
```
```
sudo bash "$HOME/nuradio/script_upf_index3/check_upf_2.sh"
```

### 3.5.4. Configuration nrf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_nrf_index4" && cd "$HOME/nuradio/script_nrf_index4"
```
* Configure NRF
```
sudo tee "$HOME/nuradio/script_nrf_index4/configure_nrf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

# PART1 : LOG
# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"

# PART 2 : MCC & MNC
# echo "===== Avant ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"

# Remplace mcc: 999 par mcc: 001
sudo sed -Ei \
's/^([[:space:]]*mcc[[:space:]]*:[[:space:]]*)999([[:space:]]*(#.*)?)$/\1001\2/' \
"$CONFIG"

# Remplace mnc: 70 par mnc: 01
sudo sed -Ei \
's/^([[:space:]]*mnc[[:space:]]*:[[:space:]]*)70([[:space:]]*(#.*)?)$/\101\2/' \
"$CONFIG"

# Remplace tac: 1 par tac: 77
sudo sed -Ei \
's/^([[:space:]]*tac[[:space:]]*:[[:space:]]*)1([[:space:]]*(#.*)?)$/\177\2/' \
"$CONFIG"

# echo
# echo "===== Après ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nrf_index4/configure_nrf.sh" && \
sudo cp -rf "$HOME/nuradio/script_nrf_index4/configure_nrf.sh" /usr/bin/configure_nrf.sh
```
```
sudo configure_nrf.sh
```
OR, 
```
sudo bash "$HOME/nuradio/script_nrf_index4/configure_nrf.sh"
```

* Check NRF 
```
sudo tee "$HOME/nuradio/script_nrf_index4/check_nrf.sh" > /dev/null << 'EOF'
#!/bin/bash
CONFIG="/etc/open5gs/nrf.yaml"

# PART 1 to part2 && nrf, sbi, addres
printf "\n\n"
sed -n '1,19p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*nrf:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.10([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nrf_index4/check_nrf.sh" && \
sudo cp -rf "$HOME/nuradio/script_nrf_index4/check_nrf.sh" /usr/bin/check_nrf.sh
```
```
sudo check_nrf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_nrf_index4/check_nrf.sh"
```
In configuration, if nrf is not commented, it's not directly used , go tho SCP after to NRF

* Optionnal : Configure part1 NRF LOGGER
```
sudo tee "$HOME/nuradio/script_nrf_index4/configure_nrf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```

```
sudo chmod +x "$HOME/nuradio/script_nrf_index4/configure_nrf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_nrf_index4/configure_nrf_logger.sh"
```
* Optionnal : Configure part2 NRF MCC & MNC & TAC
```
sudo tee "$HOME/nuradio/script_nrf_index4/configure_nrf_mcc_mnc.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

# echo "===== Avant ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"

# Remplace mcc: 999 par mcc: 001
sudo sed -Ei \
's/^([[:space:]]*mcc[[:space:]]*:[[:space:]]*)999([[:space:]]*(#.*)?)$/\1001\2/' \
"$CONFIG"

# Remplace mnc: 70 par mnc: 01
sudo sed -Ei \
's/^([[:space:]]*mnc[[:space:]]*:[[:space:]]*)70([[:space:]]*(#.*)?)$/\101\2/' \
"$CONFIG"

# Remplace tac: 1 par tac: 77
sudo sed -Ei \
's/^([[:space:]]*tac[[:space:]]*:[[:space:]]*)1([[:space:]]*(#.*)?)$/\177\2/' \
"$CONFIG"

# echo
# echo "===== Après ====="
# grep -nE 'mcc|mnc|tac' "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nrf_index4/configure_nrf_mcc_mnc.sh"
```
```
sudo bash "$HOME/nuradio/script_nrf_index4/configure_nrf_mcc_mnc.sh"
```

* Optionnal : Check part1 NRF LOG
```
sudo tee "$HOME/nuradio/script_nrf_index4/check_nrf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nrf_index4/check_nrf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_nrf_index4/check_nrf_1.sh"
```

* Optionnal : Check part2 NRF MCC MNC TAC
```
sudo tee "$HOME/nuradio/script_nrf_index4/check_nrf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nrf_index4/check_nrf_2.sh"
```
```
sudo bash "$HOME/nuradio/script_nrf_index4/check_nrf_2.sh"
```

  
### 3.5.5. Configuration scp.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_scp_index5" && cd "$HOME/nuradio/script_scp_index5"
```
* Configure scp all
```
sudo tee "$HOME/nuradio/script_scp_index5/configure_scp.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_scp_index5/configure_scp.sh" && \
sudo cp -rf "$HOME/nuradio/script_scp_index5/configure_scp.sh" /usr/bin/configure_scp.sh
```
```
sudo configure_scp.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_scp_index5/configure_scp.sh"
```

* Check scp
```
sudo tee "$HOME/nuradio/script_scp_index5/check_scp.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

# part1 to part3
printf "\n\n"
sed -n '1,18p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.200([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*nrf:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.10:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_scp_index5/check_scp.sh" && \
sudo cp -rf "$HOME/nuradio/script_scp_index5/check_scp.sh" /usr/bin/check_scp.sh
```
```
sudo check_scp.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_scp_index5/check_scp.sh"
```
* Optionnal : Configure part1 scp log
```
sudo tee "$HOME/nuradio/script_scp_index5/configure_scp_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_scp_index5/configure_scp_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_scp_index5/configure_scp_logger.sh"
```

* Optionnal : Check part1 scp log
```
sudo tee "$HOME/nuradio/script_scp_index5/check_scp_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_scp_index5/check_scp_1.sh"
```
```
sudo bash "$HOME/nuradio/script_scp_index5/check_scp_1.sh"
```

* Optionnal : Check part2 scp IP address
```
sudo tee "$HOME/nuradio/script_scp_index5/check_scp_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.200([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_scp_index5/check_scp_2.sh"
```
```
sudo bash "$HOME/nuradio/script_scp_index5/check_scp_2.sh"
```

* Optionnal : Check part3 scp other ip address for scp
Not directly connected to nrf , go tho SCP after to nrf
```
sudo tee  "$HOME/nuradio/script_scp_index5/check_scp_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*nrf:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.10:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_scp_index5/check_scp_3.sh"
```
```
sudo bash "$HOME/nuradio/script_scp_index5/check_scp_3.sh"
```

### 3.5.6. Configuration ausf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_ausf_index6" && cd "$HOME/nuradio/script_ausf_index6"
```
* Configure AUSF all
```
sudo tee "$HOME/nuradio/script_ausf_index6/configure_ausf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_ausf_index6/configure_ausf.sh" && \
sudo cp -rf "$HOME/nuradio/script_ausf_index6/configure_ausf.sh" /usr/bin/configure_ausf.sh
```
```
sudo configure_ausf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_ausf_index6/configure_ausf.sh"
```

* Check AUSF all
```
sudo tee "$HOME/nuradio/script_ausf_index6/check_ausf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"
# part1 to part3 & and add ausf and sbi
printf "\n\n"
sed -n '1,20p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*ausf:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.11([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_ausf_index6/check_ausf.sh" && \
sudo cp -rf "$HOME/nuradio/script_ausf_index6/check_ausf.sh" /usr/bin/check_ausf.sh
```
```
sudo check_ausf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_ausf_index6/check_ausf.sh"
```

* Optionnal : Configure part1 AUSF Log
```
sudo tee "$HOME/nuradio/script_ausf_index6/configure_ausf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_ausf_index6/configure_ausf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_ausf_index6/configure_ausf_logger.sh"
```

* Optionnal : Check part1 AUSF log
```
sudo tee "$HOME/nuradio/script_ausf_index6/check_ausf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_ausf_index6/check_ausf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_ausf_index6/check_ausf_1.sh"
```

* Optionnal : Check part2 AUSF ip address
```
sudo tee "$HOME/nuradio/script_ausf_index6/check_ausf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"

printf "\n\n"
sed -n '11,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.11([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_ausf_index6/check_ausf_2.sh"
```
```
bash "$HOME/nuradio/script_ausf_index6/check_ausf_2.sh"
```

* Optionnal : Check part3 AUSF other ip address (scp)
```
sudo tee "$HOME/nuradio/script_ausf_index6/check_ausf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_ausf_index6/check_ausf_3.sh"
```
```
bash "$HOME/nuradio/script_ausf_index6/check_ausf_3.sh"
```
use directly scp not nrf
### 3.5.7. Configuration udm.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_udm_index7" && cd "$HOME/nuradio/script_udm_index7"
```
* Configure UDM
```
sudo tee "$HOME/nuradio/script_udm_index7/configure_udm.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udm_index7/configure_udm.sh" && \
sudo cp -rf "$HOME/nuradio/script_udm_index7/configure_udm.sh" /usr/bin/configure_udm.sh
```
```
sudo configure_udm.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_udm_index7/configure_udm.sh"
```

* Check UDM all
```
sudo tee "$HOME/nuradio/script_udm_index7/check_udm.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

# part1 to part3 & add udm and sbi
printf "\n\n"
sed -n '1,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*udm:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.12([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udm_index7/check_udm.sh"  && \
sudo cp -rf "$HOME/nuradio/script_udm_index7/check_udm.sh" /usr/bin/check_udm.sh
```
```
sudo check_udm.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_udm_index7/check_udm.sh"
```

* Optionnal : Configure part1 UDM log
```
sudo tee "$HOME/nuradio/script_udm_index7/configure_udm_logger.sh" > /dev/null << 'EOF'

#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udm_index7/configure_udm_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_udm_index7/configure_udm_logger.sh"
```


* Optionnal  : Check part1 UDM log
```
sudo tee "$HOME/nuradio/script_udm_index7/check_udm_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udm_index7/check_udm_1.sh"
```
```
sudo bash "$HOME/nuradio/script_udm_index7/check_udm_1.sh"
```

* Optionnal : Check part2 UDM ip address
```
sudo tee "$HOME/nuradio/script_udm_index7/check_udm_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.12([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udm_index7/check_udm_2.sh"
```
```
sudo bash "$HOME/nuradio/script_udm_index7/check_udm_2.sh"
```

* Optionnal : Check part3 UDM other ip address (scp)
```
sudo tee "$HOME/nuradio/script_udm_index7/check_udm_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

printf "\n\n"
sed -n '20,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udm_index7/check_udm_3.sh"
```
```
sudo bash "$HOME/nuradio/script_udm_index7/check_udm_3.sh"
```
Use directly scp not nrf

### 3.5.8. Configuration pcf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_pcf_index8" && cd "$HOME/nuradio/script_pcf_index8"
```
* Configure PCF all
```
sudo tee "$HOME/nuradio/script_pcf_index8/configure_pcf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x  "$HOME/nuradio/script_pcf_index8/configure_pcf.sh" && \
sudo cp -rf  "$HOME/nuradio/script_pcf_index8/configure_pcf.sh" /usr/bin/configure_pcf.sh
```
```
sudo configure_pcf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_pcf_index8/configure_pcf.sh"
```
* Check PCF all
```
sudo tee "$HOME/nuradio/script_pcf_index8/check_pcf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

# part1 to part3 & add pcf and sbi
printf "\n\n"
sed -n '1,25p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*pcf:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.13([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_pcf_index8/check_pcf.sh" && \
sudo cp -rf "$HOME/nuradio/script_pcf_index8/check_pcf.sh" /usr/bin/check_pcf.sh
```
```
sudo check_pcf.sh
```
OR,
```
bash "$HOME/nuradio/script_pcf_index8/check_pcf.sh"
```
* Optionnal : Configure part1 PCF log
```
sudo tee "$HOME/nuradio/script_pcf_index8/configure_pcf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_pcf_index8/configure_pcf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_pcf_index8/configure_pcf_logger.sh"
```

* Optionnal : Check part1 PCF log
```
sudo tee "$HOME/nuradio/script_pcf_index8/check_pcf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_pcf_index8/check_pcf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_pcf_index8/check_pcf_1.sh"
```


* Optionnal : Check part2 PCF ip address
```
sudo tee "$HOME/nuradio/script_pcf_index8/check_pcf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.13([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_pcf_index8/check_pcf_2.sh"
```
```
sudo bash "$HOME/nuradio/script_pcf_index8/check_pcf_2.sh"
```
* Optionnal : Check part3 PCF other address (scp) 
```
sudo tee "$HOME/nuradio/script_pcf_index8/check_pcf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

printf "\n\n"
sed -n '5,35p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_pcf_index8/check_pcf_3.sh"
```
```
sudo bash "$HOME/nuradio/script_pcf_index8/check_pcf_3.sh"
```

### 3.5.9. Configuration nssf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_nssf_index9" && cd "$HOME/nuradio/script_nssf_index9"
```
* Configure NSSF all
```
sudo tee "$HOME/nuradio/script_nssf_index9/configure_nssf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nssf_index9/configure_nssf.sh" && \
sudo cp -rf "$HOME/nuradio/script_nssf_index9/configure_nssf.sh" /usr/bin/configure_nssf.sh
```
```
sudo configure_nssf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_nssf_index9/configure_nssf.sh"
```
* Check nssf 
```
sudo tee "$HOME/nuradio/script_nssf_index9/check_nssf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

# PART 1 to part3 && add nssf and sbi
printf "\n\n"
sed -n '1,23p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*nssf:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.14([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"
    
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nssf_index9/check_nssf.sh" && \
sudo cp -rf "$HOME/nuradio/script_nssf_index9/check_nssf.sh" /usr/bin/check_nssf.sh
```
```
sudo check_nssf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_nssf_index9/check_nssf.sh"
```


* Optionnal : Configure part1 nssf log
```
sudo tee "$HOME/nuradio/script_nssf_index9/configure_nssf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

# echo "Avant :"
# grep -n "level" "$CONFIG"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

# echo
# echo "Après :"
# grep -n "level" "$CONFIG"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nssf_index9/configure_nssf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_nssf_index9/configure_nssf_logger.sh"
```

* Optionnal : Check nssf part1 log
```
sudo tee "$HOME/nuradio/script_nssf_index9/check_nssf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nssf_index9/check_nssf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_nssf_index9/check_nssf_1.sh"
```


* Optionnal : Configure nssf part2 ip address
```
sudo tee "$HOME/nuradio/script_nssf_index9/check_nssf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.14([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nssf_index9/check_nssf_2.sh"
```
```
sudo bash "$HOME/nuradio/script_nssf_index9/check_nssf_2.sh"
```

* Optionnal : Configure part3 nssf other ip address (scp)
```
sudo tee "$HOME/nuradio/script_nssf_index9/check_nssf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_nssf_index9/check_nssf_3.sh"
```
```
sudo bash "$HOME/nuradio/script_nssf_index9/check_nssf_3.sh"
```

### 3.5.10. Configuration bsf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_bsf_index10" && cd "$HOME/nuradio/script_bsf_index10"
```
* Configure BSF all
```
sudo tee "$HOME/nuradio/script_bsf_index10/configure_bsf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_bsf_index10/configure_bsf.sh" && \
sudo cp -rf "$HOME/nuradio/script_bsf_index10/configure_bsf.sh" /usr/bin/configure_bsf.sh
```
```
sudo configure_bsf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_bsf_index10/configure_bsf.sh"
```
* Check BSF
```
sudo tee check_bsf.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

# PART 1 to Part 3 & add bsf and sbi
printf "\n\n"
sed -n '1,20p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*bsf:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.15([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_bsf_index10/check_bsf.sh" && \
sudo cp -rf "$HOME/nuradio/script_bsf_index10/check_bsf.sh" /usr/bin/check_bsf.sh
```
```
sudo check_bsf.sh
```
OR,
```
sudo bash  "$HOME/nuradio/script_bsf_index10/check_bsf.sh"
```

* Optionnal : Configure part1 BSF log
```
sudo tee "$HOME/nuradio/script_bsf_index10/configure_bsf_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_bsf_index10/configure_bsf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_bsf_index10/configure_bsf_logger.sh"
```
* Optionnal : Check part1 BSF log
```
sudo tee check_bsf_1.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_bsf_index10/check_bsf_1.sh"
```
```
sudo bash "$HOME/nuradio/script_bsf_index10/check_bsf_1.sh"
```

* Optionnal : Check part2 BSF ip address
```
sudo tee "$HOME/nuradio/script_bsf_index10/check_bsf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.15([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_bsf_index10/check_bsf_2.sh"
```
```
sudo bash "$HOME/nuradio/script_bsf_index10/check_bsf_2.sh"
```

* Optionnal : Check part3 BSF other ip address (scp) 
```
sudo tee "$HOME/nuradio/script_bsf_index10/check_bsf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_bsf_index10/check_bsf_3.sh"
```
```
sudo bash "$HOME/nuradio/script_bsf_index10/check_bsf_3.sh"
```

### 3.5.11. Configuration udr.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script_udr_index11" && cd "$HOME/nuradio/script_udr_index11"
```
* Configure UDR all
```
sudo tee "$HOME/nuradio/script_udr_index11/configure_udr.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udr_index11/configure_udr.sh" && \
sudo cp -rf "$HOME/nuradio/script_udr_index11/configure_udr.sh" /usr/bin/configure_udr.sh
```
```
sudo configure_udr.sh
```
OR,
```
sudo bash "$HOME/nuradio/script_udr_index11/configure_udr.sh"
```
* Check UDR all
```
sudo tee "$HOME/nuradio/script_udr_index11/check_udr.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

# PART1 to PART3 && udr && sbi
printf "\n\n"
sed -n '1,21p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*udr:[[:space:]]*$" \
    -e "^[[:space:]]*sbi:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.20([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udr_index11/check_udr.sh" && \
sudo cp -rf "$HOME/nuradio/script_udr_index11/check_udr.sh" /usr/bin/check_udr.sh
```
```
sudo check_udr.sh
```
OR 
```
sudo bash "$HOME/nuradio/script_udr_index11/check_udr.sh"
```

* Optionnal : Configure part1 UDR log
```
sudo tee "$HOME/nuradio/script_udr_index11/configure_udr_logger.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

sudo sed -Ei \
's/^([[:space:]]*)#?[[:space:]]*(level[[:space:]]*:[[:space:]]*)[^#[:space:]]+/\1\2debug/' \
"$CONFIG"

sudo sed -Ei \
'/^[[:space:]]*level[[:space:]]*:/s/^[[:space:]]*/  /' \
"$CONFIG"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udr_index11/configure_udr_logger.sh"
```
```
sudo bash "$HOME/nuradio/script_udr_index11/configure_udr_logger.sh"
```
* Optionnal : Check part1 UDR log
```
sudo tee "$HOME/nuradio/script_udr_index11/check_udr_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
chmod +x "$HOME/nuradio/script_udr_index11/check_udr_1.sh"
```
```
sudo bash "$HOME/nuradio/script_udr_index11/check_udr_1.sh"
```

* Optionnal : Check part2 UDR ip address
```
sudo tee "$HOME/nuradio/script_udr_index11/check_udr_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.20([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udr_index11/check_udr_2.sh"
```
```
sudo bash "$HOME/nuradio/script_udr_index11/check_udr_2.sh"
```

* Optionnal : Check part3 UDR other ip address (scp)
```
sudo tee "$HOME/nuradio/script_udr_index11/check_udr_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_udr_index11/check_udr_3.sh"
```
```
sudo bash "$HOME/nuradio/script_udr_index11/check_udr_3.sh"
```

# STEP 4 : OPEN-SOURCE 5G NETWORK  CONFIGURATION WEBUI
## 4.1. Running all process before configuring
```
sudo systemctl restart mongod
```
```
sudo systemctl status mongod
```
```
sudo stop_5gc && 5gc
```
```
sudo ps aux | grep open5gs
```
Open in navigator 
```
localhost:9999
```
USER is
```
admin
```
PASSWORD is 
```
1423
```
Clic "ADD A SUBSCRIBER"
## 4.2. Configure "Subscriber configuration/IMSI" 
Copy and paste IMSI
```
001010000560123
```
## 4.3. Configure "Subscriber configuration/Subscriber key"
Copy and past key Ki
```
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
```
## 4.4. Configure "Subscriber configuration/Operator key (OPc/OP)"
Make sure that "USIM type" is "OPc" </br>
Copy and paste OPC 
```
9ED73ED8F0FD186430CA9D7ED728EA0F
```
## 4.5. Configure "Session configurations/[DNN/APN]"
copy and paste DNN/APN
```
apn
```
Choose DNN/APN type 
```
ipv4
```
## 4.6. Configure "PCC Rules/[second "+" ]/[DNN/APN] "
copy and paste DNN/APN for the second "+"
```
ims
```
Choose DNN/APN type for the second "+"
```
ipv4
```

# STEP 5 : OPEN-SOURCE 5G NETWORK  CONFIGURATION SRSRAN_GNB
## 5.1. Creating directory of gnb script
```
mkdir "$HOME/nuradio/script_gnb" && cd "$HOME/nuradio/script_gnb"
```
## 5.2. Downloading the gnb configuration
```
cd && \
[ -f gnb_n3.yml ] && rm -f gnb_n3.yml; wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/fork_nuradio_5G_Network/refs/heads/main/srsRAN_Project/gnb_n3.yml
```
## 5.3. Configuring and checking the gnb 
### 5.3.1. Configuring and checking gnb about AMF
```
sudo tee cd "$HOME/nuradio/script_gnb/configure_gnb_amf.sh" > /dev/null <<'EOF'
#!/bin/bash

sudo sed -i \
  -e 's/^\([[:space:]]*addr:\).*/\1 127.0.0.5/' \
  -e 's/^\([[:space:]]*bind_addr:\).*/\1 127.0.0.66/' \
  gnb*.yml
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/configure_gnb_amf.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/configure_gnb_amf.sh" /usr/bin/configure_gnb_amf.sh
```
```
sudo configure_gnb_amf.sh
```
```
sudo tee "$HOME/nuradio/script_gnb/check_gnb_amf.sh" > /dev/null << 'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*addr:[[:space:]]*127\.0\.0\.5([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*bind_addr:[[:space:]]*127\.0\.0\.66([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/check_gnb_amf.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/check_gnb_amf.sh" /usr/bin/check_gnb_amf.sh
```
```
sudo check_gnb_amf.sh
```
### 5.3.2  Configuring and checking gnb about SDR & CLOCK
```
sudo tee "$HOME/nuradio/script_gnb/configure_gnb_sdr_clock.sh" > /dev/null <<'EOF'
#!/bin/bash

sudo sed -i \
  -e 's/^[[:space:]]*device_args:.*/  device_args: type=b200                                          # Optionally pass arguments to the selected RF driver./' \
  -e 's/^[[:space:]]*clock:.*/  clock: gpsdo/' \
  -e 's/^[[:space:]]*sync:.*/  sync: gpsdo/' \
  gnb*.yml

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/configure_gnb_sdr_clock.sh" && \
sudo cp -f "$HOME/nuradio/script_gnb/configure_gnb_sdr_clock.sh" /usr/bin/configure_gnb_sdr_clock.sh
```
```
sudo configure_gnb_sdr_clock.sh
```
```
sudo tee "$HOME/nuradio/script_gnb/check_gnb_sdr_clock.sh" > /dev/null << 'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*device_args:[[:space:]]*type=b200([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*clock:[[:space:]]*gpsdo([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*sync:[[:space:]]*gpsdo([[:space:]]*#.*)?$" \
    -e "^"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/check_gnb_sdr_clock.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/check_gnb_sdr_clock.sh" /usr/bin/check_gnb_sdr_clock.sh
```
```
sudo check_gnb_sdr_clock.sh
```

### 5.3.3. Configuring and checking gnb about GAIN TRX
```
sudo tee "$HOME/nuradio/script_gnb/configure_gnb_gain_trx.sh" > /dev/null <<'EOF'
#!/bin/bash

sudo sed -i \
  -e 's/^[[:space:]]*tx_gain:.*/  tx_gain: 70                                                     # Transmit gain of the RF might need to adjusted to the given situation./' \
  -e 's/^[[:space:]]*rx_gain:.*/  rx_gain: 60                                                     # Receive gain of the RF might need to adjusted to the given situation./' \
  gnb*.yml

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/configure_gnb_gain_trx.sh" && \
sudo cp -f "$HOME/nuradio/script_gnb/configure_gnb_gain_trx.sh" /usr/bin/configure_gnb_gain_trx.sh
```
```
sudo configure_gnb_gain_trx.sh
```
```
tee "$HOME/nuradio/script_gnb/check_gnb_gain_trx.sh" > /dev/null <<'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*tx_gain:[[:space:]]*70([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*rx_gain:[[:space:]]*60([[:space:]]*#.*)?$" \
    -e "^"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/check_gnb_gain_trx.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/check_gnb_gain_trx.sh" /usr/bin/check_gnb_gain_trx.sh
```
```
sudo check_gnb_gain_trx.sh
```
### 5.3.5. Configuring and checking gnb about BAND
```
tee "$HOME/nuradio/script_gnb/configure_gnb_band.sh" > /dev/null <<'EOF'
#!/bin/bash

sudo sed -i \
  -e 's/^[[:space:]]*dl_arfcn:.*/  dl_arfcn: 368500                                                # ARFCN of the downlink carrier (center frequency)/' \
  -e 's/^[[:space:]]*band:.*/  band: 3                                                         # The NR band./' \
  -e 's/^[[:space:]]*channel_bandwidth_MHz:.*/  channel_bandwidth_MHz: 10                                       # Bandwith in MHz. Number of PRBs will be automatically derived./' \
  -e 's/^[[:space:]]*common_scs:.*/  common_scs: 15                                                  # Subcarrier spacing in kHz used for data./' \
  gnb*.yml

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/configure_gnb_band.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/configure_gnb_band.sh" /usr/bin/configure_gnb_band.sh
```
```
sudo configure_gnb_band.sh
```
```
tee "$HOME/nuradio/script_gnb/check_gnb_band.sh" > /dev/null <<'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*dl_arfcn:[[:space:]]*368500([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*band:[[:space:]]*3([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*channel_bandwidth_MHz:[[:space:]]*10([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*common_scs:[[:space:]]*15([[:space:]]*#.*)?$" \
    -e "^"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/check_gnb_band.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/check_gnb_band.sh" /usr/bin/check_gnb_band.sh
```
```
sudo  check_gnb_band.sh
```
### 5.3.5. Configuring and checking gnb about PLMN
```
sudo tee "$HOME/nuradio/script_gnb/configure_gnb_plmn.sh" > /dev/null <<'EOF'
#!/bin/bash

sudo sed -i \
  -e 's/^[[:space:]]*plmn:.*/  plmn: "00101"                                                   # PLMN broadcasted by the gNB./' \
  -e 's/^[[:space:]]*tac:.*/  tac: 77                                                         # Tracking area code (needs to match the core configuration)./' \
  -e 's/^[[:space:]]*pci:.*/  pci: 1/' \
  gnb*.yml

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/configure_gnb_plmn.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/configure_gnb_plmn.sh" /usr/bin/configure_gnb_plmn.sh
```
```
sudo configure_gnb_plmn.sh
```
```
sudo tee "$HOME/nuradio/script_gnb/check_gnb_plmn.sh" > /dev/null <<'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*plmn:[[:space:]]*\"00101\"([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*tac:[[:space:]]*77([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*pci:[[:space:]]*1([[:space:]]*#.*)?$" \
    -e "^"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/check_gnb_plmn.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/check_gnb_plmn.sh" /usr/bin/check_gnb_plmn.sh
```
```
sudo check_gnb_plmn.sh
```


### 5.3.6. Checking gnb ONLY FOR UE
```
sudo tee "$HOME/nuradio/script_gnb/check_gnb_for_ue.sh" > /dev/null <<'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*pdcch:[[:space:]]*$" \
    -e "^[[:space:]]*dedicated:[[:space:]]*$" \
    -e "^[[:space:]]*ss2_type:[[:space:]]*common([[:space:]]*)?$" \
    -e "^[[:space:]]*dci_format_0_1_and_1_1:[[:space:]]*false([[:space:]]*)?$" \
    -e "^[[:space:]]*prach:[[:space:]]*$" \
    -e "^[[:space:]]*prach_config_index:[[:space:]]*1([[:space:]]*)?$" \
    -e "^"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/check_gnb_for_ue.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/check_gnb_for_ue.sh" /usr/bin/check_gnb_for_ue.sh
```
```
sudo check_gnb_for_ue.sh
```
### 5.3.7. Configuring and checking gnb about LOG
```
sudo tee "$HOME/nuradio/script_gnb/configure_gnb_log.sh" > /dev/null <<'EOF'
#!/bin/bash

sudo sed -i \
  -e 's/^[[:space:]]*filename:.*/  filename: \/tmp\/gnb.log                                          # Path of the log file./' \
  -e 's/^[[:space:]]*all_level:.*/  all_level: debug                                                # Logging level applied to all layers./' \
  gnb*.yml

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/configure_gnb_log.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/configure_gnb_log.sh" /usr/bin/configure_gnb_log.sh
```
```
sudo configure_gnb_log.sh
```
```
sudo tee "$HOME/nuradio/script_gnb/check_gnb_log.sh" > /dev/null <<'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*log:[[:space:]]*([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*filename:[[:space:]]*/tmp/gnb\.log([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*all_level:[[:space:]]*debug([[:space:]]*#.*)?$" \
    -e "^"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gnb/check_gnb_log.sh" && \
sudo cp -rf "$HOME/nuradio/script_gnb/check_gnb_log.sh" /usr/bin/check_gnb_log.sh
```
```
sudo check_gnb_log.sh
```


### 5.3.8. Configuring and checking gnb about PCAP
```
sudo tee  "$HOME/nuradio/script_gnb/configure_gnb_pcap.sh" > /dev/null <<'EOF'
#!/bin/bash

sudo sed -i \
  -e 's/^[[:space:]]*mac_enable:.*/  mac_enable: true                                               # Set to true to enable MAC-layer PCAPs./' \
  -e 's/^[[:space:]]*mac_filename:.*/  mac_filename: \/tmp\/gnb_mac.pcap                                 # Path where the MAC PCAP is stored./' \
  -e 's/^[[:space:]]*ngap_enable:.*/  ngap_enable: true                                              # Set to true to enable NGAP PCAPs./' \
  -e 's/^[[:space:]]*ngap_filename:.*/  ngap_filename: \/tmp\/gnb_ngap.pcap                               # Path where the NGAP PCAP is stored./' \
  gnb*.yml

EOF
```
```
sudo chmod +x  "$HOME/nuradio/script_gnb/configure_gnb_pcap.sh" && \
sudo cp -rf  "$HOME/nuradio/script_gnb/configure_gnb_pcap.sh" /usr/bin/configure_gnb_pcap.sh
```
```
sudo configure_gnb_pcap.sh
```
```
sudo tee  "$HOME/nuradio/script_gnb/check_gnb_pcap.sh" > /dev/null <<'EOF'
#!/bin/bash

printf "\n\n"
cat gnb*.yml | grep --color=always -E \
    -e "^[[:space:]]*pcap:[[:space:]]*$" \
    -e "^[[:space:]]*mac_enable:[[:space:]]*true([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*mac_filename:[[:space:]]*/tmp/gnb_mac\.pcap([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*ngap_enable:[[:space:]]*true([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*ngap_filename:[[:space:]]*/tmp/gnb_ngap\.pcap([[:space:]]*#.*)?$" \
    -e "^"

EOF
```
```
sudo chmod +x  "$HOME/nuradio/script_gnb/check_gnb_pcap.sh" && \
sudo cp -rf  "$HOME/nuradio/script_gnb/check_gnb_pcap.sh" /usr/bin/check_gnb_pcap.sh
```
```
sudo check_gnb_pcap.sh	
```
# 6. Configuration WIRESHARK
## 6.1. Installation  of wireshark
```
sudo apt update \
sudo apt install wireshark-qt
```
```
sudo usermod -aG wireshark nuradio
```
```
newgrp wireshark
```
```
sudo chown $USER:$USER /tmp/* \
sudo chmod 664 /tmp/*
```
```
sudo dumpcap -i any -w /tmp/open5gs_all.pcap
```
# 7. Configuration GPSDO
## 7.1. Creating directory
```
[ ! -d "$HOME/nuradio/script_gpsdo" ] && mkdir -p "$HOME/nuradio/script_gpsdo"
```
## 7.2. Script to wat gpsdo alignment
```
sudo tee "$HOME/nuradio/script_gpsdo/wait_gpsdo_alignment.sh" >/dev/null <<'EOF'
#!/usr/bin/env bash

LOG=/tmp/query_gpsdo_sensors.log
rm -rf $LOG
sudo touch $LOG
sudo chown $USER:$USER $LOG

LOG=/tmp/query_gpsdo_sensors.log

START_TIME=$(date +%s)

is_gpsdo_aligned=false

while [ "$is_gpsdo_aligned" = false ]; do

    sudo query_gpsdo_sensors >"$LOG" 2>&1

    if tr -s '[:space:]' ' ' < "$LOG" | \
        grep -qi "GPS and UHD Device time are aligned."; then

        is_gpsdo_aligned=true

    else
        sleep 5

        CURRENT_TIME=$(date +%s)
        ELAPSED=$((CURRENT_TIME - START_TIME))

        printf "\rElapsed time: %02d seconds - Checking GPSDO..." "$ELAPSED"
    fi

done

END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))

echo
echo "GPSDO synchronized."
echo "Total time: ${TOTAL_TIME} seconds."
echo "is_gpsdo_aligned=$is_gpsdo_aligned"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gpsdo/wait_gpsdo_alignment.sh"
```
```
sudo cp -rf "$HOME/nuradio/script_gpsdo/wait_gpsdo_alignment.sh" /usr/bin/wait_gpsdo_alignment.sh
```
```
sudo wait_gpsdo_alignment.sh
```
## 7.3. Script to check gpsdo alignment
```
sudo tee "$HOME/nuradio/script_gpsdo/check_gpsdo_alignment.sh" > /dev/null <<'EOF'
#!/usr/bin/env bash

LOG=/tmp/query_gpsdo_sensors.log
rm -rf "$LOG"
sudo touch "$LOG"
sudo chown "$USER:$USER" "$LOG"

START_TIME=$(date +%s)

is_gpsdo_aligned=false
is_gpsdo_gpgga=false

while [ "$is_gpsdo_aligned" = false ]; do

    sudo query_gpsdo_sensors >"$LOG" 2>&1

    if tr -s '[:space:]' ' ' < "$LOG" | \
        grep -qi "GPS and UHD Device time are aligned."; then

        is_gpsdo_aligned=true

    else
        sleep 5

        CURRENT_TIME=$(date +%s)
        ELAPSED=$((CURRENT_TIME - START_TIME))

        printf "\rElapsed time: %02d seconds - Checking GPSDO..." "$ELAPSED"
    fi

done


# Vérification GPGGA après synchronisation GPSDO
if grep -qi '\$GPGGA' "$LOG"; then
    is_gpsdo_gpgga=true
fi


END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))

echo
echo "GPSDO synchronized."
echo "Total time: ${TOTAL_TIME} seconds."
echo "is_gpsdo_aligned=$is_gpsdo_aligned"
echo "is_gpsdo_gpgga=$is_gpsdo_gpgga"


if [ "$is_gpsdo_aligned" = true ] && [ "$is_gpsdo_gpgga" = true ]; then

    echo
    echo "GPSDO + GPGGA check:"

    SAT_COUNT=$(sudo query_gpsdo_sensors 2>/dev/null | \
    grep -E "^[[:space:]]*GPS_GPGGA[[:space:]]*:" | \
    awk -F',' '{print $8}')


    sudo query_gpsdo_sensors 2>/dev/null | \
    grep --color=always -E \
    -e "^[[:space:]]*GPS[[:space:]]+Locked.*$" \
    -e "^[[:space:]]*GPS[[:space:]]+and[[:space:]]+UHD[[:space:]]+Device[[:space:]]+time[[:space:]]+are[[:space:]]+aligned\..*$" \
    -e "GPS_GPGGA:|GPGGA|,$SAT_COUNT," \
    -e "$"


elif [ "$is_gpsdo_aligned" = true ]; then

    echo
    echo "GPSDO alignment check:"

    sudo query_gpsdo_sensors 2>/dev/null | \
    grep --color=always -E \
    -e "^[[:space:]]*GPS[[:space:]]+Locked.*$" \
    -e "^[[:space:]]*GPS[[:space:]]+and[[:space:]]+UHD[[:space:]]+Device[[:space:]]+time[[:space:]]+are[[:space:]]+aligned\..*$" \
    -e "$"


else

    echo
    echo "Error synchronization"

fi
EOF
```
```
sudo chmod +x "$HOME/nuradio/script_gpsdo/check_gpsdo_alignment.sh"
```
```
sudo cp -rf "$HOME/nuradio/script_gpsdo/check_gpsdo_alignment.sh" /usr/bin/check_gpsdo_alignment.sh
```
```
sudo check_gpsdo_alignment.sh
```

# 8. Configuration CPUSET & TASKSET
## 8.1. Optimization
* KERNEL REAL TIME (USING LOW LATENCY) & OVERCLOCK FREQUENCY (USING CPU POWER)
* SHIELDING PROCESS ( PROCESS SYSTEM AND PROCESS WILL BE SEPARATED USING CSET SHIELD)
* SETTING PROCESS (USING CSET CPU) AND LABELLING PROCESS TO BE USED ON SET CPU (USING TASKSET)

## 8.2. Separating CPU
eg : 
* Total cpus : 12 cpus numbered 0-11
* system will be at 0-1 cpus; the rest will be shielding cpu will be at 2-11 named part_all
* the user cpu will be divided in two part :
* first part will be named part1 which is 2-6 cpus and the number of cpu is 5 named part1_number_cpu
* second part will be named part2 which is 7-11 cpus and the number of cpu is 5 named part2_number_cpu
```
part_all=2-11
```
```
part1=2-6
```
```
part1_number_cpu=5
```
```
part2=7-11
```
```
part2_number_cpu=5
```
## 8.3. Shielding all cpu parts
```
sudo cset shield --cpu=$part_all --kthread=on
```
```
sudo cset set --list --recurse
```
```
root
├── system   CPU 0-1
└── user     CPU 2-11
```
## 8.4. Dividing the shielding cpu in two parts
The process will be represented as cpu named organized on file : 
* the first part of cpu part is /user/cpu_part1
* the second part of cpu part is /user/cpu_part2
### 8.4.1. Destroying all cpu part before 
```
sudo cset set --destroy /user/cpu_part1
```
```
sudo cset set --destroy /user/cpu_part2
```
### 8.4.2. Creating all cpu part on shielding cpu
```
sudo cset set --set=/user/cpu_part1 --cpu=$part1
```
```
sudo cset set --set=/user/cpu_part2 --cpu=$part2
```
### 8.4.3. Checking all cpu part on shielding cpu
```
sudo cset set --list --recurse
```
```
root
├── system          CPU 0-1
└── user            CPU 2-11
    ├── cpu_part1   CPU 2-6
    └── cpu_part2   CPU 7-11
```
## 8.5. Stress testing of cpuset
### 8.5.1. Testing for all cpu part on stress testing
```
cpupower frequency-set -g performance && \ 
sudo cset proc --set=/user/cpu_part1 --exec -- taskset -c $part1 stress-ng --cpu $part1_number_cpu --timeout 3000s
```
```
cpupower frequency-set -g performance && \ 
sudo cset proc --set=/user/cpu_part2 --exec -- taskset -c $part2 stress-ng --cpu $part1_number_cpu --timeout 3000s
```
### 8.5.2. Testing for binary program part 1
eg : 5gc
```
sudo cpupower frequency-set -g performance && \
sudo cset proc --set=/user/cpu_part1 --exec -- taskset -c $part1 sudo 5gc
```
### 8.5.2. Testing for binary program part 2
```
sudo cpupower frequency-set -g performance && \
sudo cset proc --set=/user/cpu_part2 --exec -- taskset -c $part2 sudo check_gpsdo_alignment.sh && sudo gnb -c gnb_n3.yml
```
# 9. Configuring SIMCARD by PYSIM
## 9.1. Installing tools
```
rm -rf py_sim ; mkdir py_sim && cd py_sim
```
```
sudo apt update && \
sudo apt install docker.io wget
```
Verify :
```
sudo docker --version
```
```
wget --version
```
## 9.2. Downloading Tools
```
[ -f Dockerfile ] && rm -rf Dockerfile ; \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/PySim_Docker/refs/heads/main/Dockerfile
```
Verify by
```
cat Dockerfile
```
Result should be like [Dockerfile](https://raw.githubusercontent.com/SitrakaResearchAndPOC/PySim_Docker/refs/heads/main/Dockerfile)
## 9.3. Building images
```
sudo docker build -t progsim:v1 .
```
Verfy by 
```
sudo docker images
```
## 9.4. Launching container
```
sudo docker rm -f progsim 2> /dev/null ; \
sudo docker run -tid --privileged --device=/dev/bus/usb \
-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
-v /home/user/:/home/user/.Xauthority:ro \
-v /run/pcscd:/run/pcscd \
--net=host --env="DISPLAY=$DISPLAY" \
--env="LC_ALL=C.UTF-8" --env="LANG=C.UTF-8" \
--name progsim --hostname progsim progsim:v1
```
Verify by : 
```
sudo docker ps
```
If you want, see the script by using
```
sudo docker exec -it progsim cat show_services.sh
```
Result should be like [show_services.sh](https://github.com/SitrakaResearchAndPOC/PySim_Docker/blob/main/show_services.sh)
```
sudo docker exec -it progsim cat start_services.sh
```
Result should be like at [start_services.sh](https://github.com/SitrakaResearchAndPOC/PySim_Docker/blob/main/start_services.sh)
```
sudo docker exec -it progsim cat /root/.bashrc
```
Result should be like at [bashrc](https://github.com/SitrakaResearchAndPOC/PySim_Docker/blob/main/bashrc)


## 9.5. Testing SIM Card Reader
Showing all services if it's run
```
sudo docker exec -it progsim bash show_services.sh
```
Plug and Verify card reader :
```
sudo docker exec -it progsim bash -c 'pcsc_scan'
```
Tape ctrl+C when it stop </br></br>

Showing all service if it's run 
```
sudo docker exec -it progsim bash show_services.sh
```
All services should be run

## 9.6. Manipulating SIM card by PySIM
```
suod docker exec -it progsim bash -c 'cd pysim  && \
python3 -m venv .venv && \
source .venv/bin/activate && \
./pySim-read.py -p 0'
```
Not test yet pySim-prog.py

## 9.7. Manipulating SIM card by SYSMO Tools
Rules :  </br>
Miniscule if you want to show </br>
Majuscule if you want to write </br>

* ADM : 
```
63036416
```

* For help : 
```
sudo docker exec -it progsim bash -c  'cd sysmo-usim-tool/ && \
python3 -m venv .venv && \
source .venv/bin/activate && \
python3 sysmo-isim-tool.sja2.py --help'
```

* For OPc :
```
sudo docker exec -it progsim bash -c  'cd sysmo-usim-tool/ && \
python3 -m venv .venv && \
source .venv/bin/activate && \
python3 sysmo-isim-tool.sja2.py -o  -a <ADM> '
```

* For keys : 
```
sudo docker exec -it progsim bash -c  'cd sysmo-usim-tool/ && \
python3 -m venv .venv && \
source .venv/bin/activate && \
python3 sysmo-isim-tool.sja2.py -k  -a <ADM> '
```

* For authentication : 
```
sudo docker exec -it progsim bash -c  'cd sysmo-usim-tool/ && \
python3 -m venv .venv && \
source .venv/bin/activate && \
python3 sysmo-isim-tool.sja2.py -t  -a  <ADM> '
```

* For all parameters : 
```
sudo docker exec -it progsim bash -c  'cd sysmo-usim-tool/ && \
python3 -m venv .venv && \
source .venv/bin/activate && \
python3 sysmo-isim-tool.sja2.py -t -k -o -a <ADM> '
```
* Programming SIM
```
sudo docker exec -it progsim bash -c 'cd pysim  && \
python3 -m venv .venv && \
source .venv/bin/activate && \
./pySim-prog.py -p 0 --mcc 001 --mnc 01 \
-t sysmoISIM-SJA2  --imsi 001010000560123 \
--iccid 8988211000000012345 \
--ki FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF \
--opc 9ED73ED8F0FD186430CA9D7ED728EA0F \ 
--pin-adm <ADM>'
```
* Programming authentication
```
sudo docker exec -it progsim bash -c  'cd sysmo-usim-tool/ && \
python3 -m venv .venv && \
source .venv/bin/activate && \
python3 sysmo-isim-tool.sja2.py  -T MILENAGE:MILENAGE -a <ADM> '
```
* Verify all parameters
```
sudo docker exec -it progsim bash -c  'cd sysmo-usim-tool/ && \
python3 -m venv .venv && \
source .venv/bin/activate && \
python3 sysmo-isim-tool.sja2.py -t -k -o -a <ADM> '
```

# STEP 6 : RUNNING
## 6.1. Terminal 1 : Launching capture wireshark
```
sudo dumpcap -i any -w /tmp/open5gs_all.pcap
```
## 6.2. Terminal 2 : Launching log AMF
```
tail -f /var/log/open5gs/amf.log | grep -i --color=always -E "gnb[[:space:]]*-?[[:space:]]*N2[[:space:]]+accepted|$"
```
## 6.3. Terminal 3 : Configuring and start 5G core && gnb
### 6.3.1. Configuring network for open5gs
```
sudo configure_network.sh
```
### 6.3.2. Checking network for open5gs
```
sudo check_network.sh
```
### 6.3.3. Launching mongo
* Launching mongo without cpuset & taskset
```
sudo systemctl restart mongod
```
* Launching mongo with cpuset & taskset
```
sudo systemctl stop mongod && \
sudo cpupower frequency-set -g performance && \
sudo cset proc --set=/user/cpu_part1 --exec -- taskset -c $part1 sudo systemctl start mongod
```
### 6.3.4. Checking mongo
```
sudo systemctl status mongod
```
### 6.3.5. Stopping core 5G
```
sudo stop_5gc 
```
### 6.3.6. Launching core 5G
* Launching 5GC without cpuset & taskset
```
sudo 5gc
```
* Launching 5GC with cpuset & taskset
```
sudo cpupower frequency-set -g performance && \
sudo cset proc --set=/user/cpu_part1 --exec -- taskset -c $part1 sudo 5gc
```
### 6.3.7. Checking process of open5gs
```
sudo ps aux | grep open5gs
```
### 6.3.8. Launching gnb 
* Launching GNB without cpuset & taskset
```
sudo check_gpsdo_alignment.sh && sudo gnb -c gnb_n3.yml
```
* Launching GNB with cpuset & taskset
```
sudo cpupower frequency-set -g performance && \
sudo cset proc --set=/user/cpu_part2 --exec -- taskset -c $part2 sudo check_gpsdo_alignment.sh && sudo gnb -c gnb_n3.yml
```

## 6.4. Terminal 4 : Wireshark
```
sudo wireshark 
```
Open /tmp/open5gs_all.pcap
