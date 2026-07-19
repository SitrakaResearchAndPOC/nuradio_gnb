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

### 1.3.4. Checking Open5gs
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
ls open5gs-webui/webui/.next/
```
THIS DIRECTORY SHOULD EXIST : BUILD_ID
```
ls open5gs-webui/webui/.next/ | grep --color=always -E 'BUILD_ID|$'
```
```
ls open5gs-webui/webui/
```
THIS DIRECTORY SHOULD EXIST : server/  </br>
THIS DIRECTORY SHOULD EXIST  : static/  </br>
```
ls open5gs-webui/webui/ | grep --color=always -E \
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
sudo chmod +x "$HOME/nuradio/script_network/check_ogstun.sh"
```
```
sudo cp -rf "$HOME/nuradio/script_network/check_ogstun.sh" /usr/bin/check_ogstun.sh
```
```
bash check_ogstun.sh
```
OR
```
bash "$HOME/nuradio/script_network/check_ogstun.sh"
```
The goal is to have Scenario 3, 
```
bash check_ogstun.sh | grep "Scenario 3"
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
sudo chmod +x "$HOME/nuradio/script_network/configure_ogstun.sh"
```
```
sudo cp -rf "$HOME/nuradio/script_network/configure_ogstun.sh" /usr/bin/configure_ogstun.sh
```
```
bash configure_ogstun.sh
```
OR
```
bash "$HOME/nuradio/script_network/configure_ogstun.sh"
```
Scenario 3 should appears

### 3.1.4. Rechecking ogstun
```
bash check_ogstun.sh
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
sudo chmod +x "$HOME/nuradio/script_network/check_ipv4forward.sh"
```
```
sudo cp -rf "$HOME/nuradio/script_network/check_ipv4forward.sh" /usr/bin/check_ipv4forward.sh
```
```
bash check_ipv4forward.sh
```
OR
```
bash "$HOME/nuradio/script_network/check_ipv4forward.sh"
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
sudo chmod +x configure_ipv4forward.sh
```
```
sudo cp -rf configure_ipv4forward.sh /usr/local/bin/configure_ipv4forward.sh
```
```
bash configure_ipv4forward.sh
```
### 3.2.3. Rechecking IPv4 Forwading
```
bash configure_ipv4forward.sh
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
sudo chmod +x "$HOME/nuradio/script_network/check_iptableNATforward.sh"
```
```
sudo cp -rf "$HOME/nuradio/script_network/check_iptableNATforward.sh" /usr/local/bin/check_iptableNATforward.sh
```
```
bash check_iptableNATforward.sh
```
OR
```
bash "$HOME/nuradio/script_network/check_iptableNATforward.sh"
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
sudo chmod +x  "$HOME/nuradio/script_network/configure_iptableNATforward.sh"
```
```
sudo cp -rf  "$HOME/nuradio/script_network/configure_iptableNATforward.sh" /usr/local/bin/configure_iptableNATforward.sh
```
```
bash configure_iptableNATforward.sh
```
OR
```
bash  "$HOME/nuradio/script_network/configure_iptableNATforward.sh"
```
### 3.3.3. Rechecking IPTABLE NAT Forwading
```
bash check_iptableNATforward.sh
```
 
## 3.4. Configuration PLMN & DEBUG MODE
### 3.4.1. Configuration amf.yaml
* Create and change directory
```
mkdir -p "$HOME/nuradio/script1-amf" && cd "$HOME/nuradio/script1-amf"
```
* Configure AMF
Directly all configuraiton in one manipulation
```
sudo tee "$HOME/nuradio/script1-amf/configure_amf.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script1-amf/configure_amf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script1-amf/configure_amf.sh" /usr/bin/configure_amf.sh
```
```
bash configure_amf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script1-amf/configure_amf.sh"
```

* check AMF all 
```
sudo tee "$HOME/nuradio/script1-amf/check_amf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"
# part 1
printf "\n\n"
sed -n '1,19p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
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
sudo chmod +x "$HOME/nuradio/script1-amf/check_amf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script1-amf/check_amf.sh" /usr/bin/check_amf.sh
```
```
bash check_amf.sh
```
OR 
```
sudo bash "$HOME/nuradio/script1-amf/check_amf.sh" 
```

* Optionnal : Configure part1 AMF log
```
sudo tee "$HOME/nuradio/script1-amf/configure_amf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script1-amf/configure_amf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script1-amf/configure_amf_logger.sh" 
```
* Optionnal : Configure part2 AMF MCC & MNC
```
sudo tee "$HOME/nuradio/script1-amf/configure_amf_mcc_mnc.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script1-amf/configure_amf_mcc_mnc.sh"
```
```
sudo bash "$HOME/nuradio/script1-amf/configure_amf_mcc_mnc.sh"
```
*  Optionnal : Check part1 AMF log 
```
sudo tee "$HOME/nuradio/script1-amf/check_amf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script1-amf/check_amf_1.sh"
```
```
sudo bash "$HOME/nuradio/script1-amf/check_amf_1.sh" 
```
* Optionnal : Check part2 AMF : IP ADDRESS & MCC & MNC & TAC
```
sudo tee "$HOME/nuradio/script1-amf/check_amf_2.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script1-amf/check_amf_2.sh"
```
```
sudo bash "$HOME/nuradio/script1-amf/check_amf_2.sh" 
```
*  Optionnal : Check part3 AMF GNB Timer
```
sudo tee "$HOME/nuradio/script1-amf/check_amf_3.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script1-amf/check_amf_3.sh"
```
```
sudo bash "$HOME/nuradio/script1-amf/check_amf_3.sh"
```

*  Optionnal : Check part4 AMF Reject cause 
  
a little bit different, line by line

```
sudo tee "$HOME/nuradio/script1-amf/check_amf_4.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script1-amf/check_amf_4.sh"
```
```
sudo bash "$HOME/nuradio/script1-amf/check_amf_4.sh"
```

### 3.4.2. Configuration SMF.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script2-smf" && cd "$HOME/nuradio/script2-smf"
```
* Configure SMF all
```
sudo tee "$HOME/nuradio/script2-smf/configure_smf.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script2-smf/configure_smf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script2-smf/configure_smf.sh" /usr/bin/configure_smf.sh
```
```
sudo bash configure_smf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script2-smf/configure_smf.sh"
```

* Check SMF all
```
sudo tee "$HOME/nuradio/script2-smf/check_smf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"
# part1 to part4
printf "\n\n"
sed -n '1,51p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*dns[[:space:]]*:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.8\.8([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.4\.4([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8888([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8844([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script2-smf/check_smf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script2-smf/check_smf.sh" /usr/bin/check_smf.sh
```
```
sudo bash check_smf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script2-smf/check_smf.sh"
```

* Optionnal : Configure SMF part1 logger
```
sudo tee "$HOME/nuradio/script2-smf/configure_smf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script2-smf/configure_smf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script2-smf/configure_smf_logger.sh"
```
* Optionnal : Check part1 SMF LOG 
```
sudo tee "$HOME/nuradio/script2-smf/check_smf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script2-smf/check_smf_1.sh"
```
```
sudo bash "$HOME/nuradio/script2-smf/check_smf_1.sh"
```

* Optionnal : Check part2 SMF IP address 
```
sudo tee "$HOME/nuradio/script2-smf/check_smf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"
sed -n '1,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script2-smf/check_smf_2.sh"
```
```
sudo bash "$HOME/nuradio/script2-smf/check_smf_2.sh"
```

* Optionnal : Check part3 SMF DNS 
```
sudo tee "$HOME/nuradio/script2-smf/check_smf_3.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script2-smf/check_smf_3.sh"
```
```
sudo bash "$HOME/nuradio/script2-smf/check_smf_3.sh"
```

* Optionnal : Check part4 SMF OTHER ADDRESS (CLIENT SCP) 
```
sudo tee "$HOME/nuradio/script2-smf/check_smf_4.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script2-smf/check_smf_4.sh"
```
```
sudo bash "$HOME/nuradio/script2-smf/check_smf_4.sh"
```

### 3.4.3. Configuration upf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script3-upf" && cd "$HOME/nuradio/script3-upf"
```
* Configure UPF all
```
sudo tee "$HOME/nuradio/script3-upf/configure_upf.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script3-upf/configure_upf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script3-upf/configure_upf.sh" /usr/bin/configure_upf.sh
```
```
sudo bash configure_upf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script3-upf/configure_upf.sh"
```

* Check UPF all

If you add smf in upf; the relation between them will be more active </br>
the easy way, is that the smf find the upf not also upf find the smf </br>

```
sudo tee "$HOME/nuradio/script3-upf/check_upf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

# Part1 and part2
printf "\n\n"
sed -n '1,27p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.7([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script3-upf/check_upf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script3-upf/check_upf.sh" /usr/bin/check_upf.sh
```
```
sudo bash check_upf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script3-upf/check_upf.sh"
```

* Configure UPF Logger
```
sudo tee "$HOME/nuradio/script3-upf/configure_upf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script3-upf/configure_upf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script3-upf/configure_upf_logger.sh"
```
* Optionnal : Check part1 UPF LOG 
```
sudo tee "$HOME/nuradio/script3-upf/check_upf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script3-upf/check_upf_1.sh"
```
```
sudo bash "$HOME/nuradio/script3-upf/check_upf_1.sh"
```

* Optionnal : Check part2 UPF IP ADDRESS
```
sudo tee "$HOME/nuradio/script3-upf/check_upf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

printf "\n\n"

sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.7([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script3-upf/check_upf_2.sh"
```
```
sudo bash "$HOME/nuradio/script3-upf/check_upf_2.sh"
```

### 3.4.4. Configuration nrf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script4-nrf" && cd "$HOME/nuradio/script4-nrf"
```
* Configure NRF
```
sudo tee "$HOME/nuradio/script4-nrf/configure_nrf.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script4-nrf/configure_nrf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script4-nrf/configure_nrf.sh" /usr/bin/configure_nrf.sh
```
```
sudo bash configure_nrf.sh
```
OR, 
```
sudo bash "$HOME/nuradio/script4-nrf/configure_nrf.sh"
```

* Check NRF 
```
sudo tee "$HOME/nuradio/script4-nrf/check_nrf.sh" > /dev/null << 'EOF'
#!/bin/bash
CONFIG="/etc/open5gs/nrf.yaml"

# PART 1 to part2
printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script4-nrf/check_nrf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script4-nrf/check_nrf.sh" /usr/bin/check_nrf.sh
```
```
sudo bash check_nrf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script4-nrf/check_nrf.sh"
```
In configuration, if nrf is not commented, it's not directly used , go tho SCP after to NRF

* Optionnal : Configure part1 NRF LOGGER
```
sudo tee "$HOME/nuradio/script4-nrf/configure_nrf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script4-nrf/configure_nrf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script4-nrf/configure_nrf_logger.sh"
```
* Optionnal : Configure part2 NRF MCC & MNC & TAC
```
sudo tee "$HOME/nuradio/script4-nrf/configure_nrf_mcc_mnc.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script4-nrf/configure_nrf_mcc_mnc.sh"
```
```
sudo bash "$HOME/nuradio/script4-nrf/configure_nrf_mcc_mnc.sh"
```

* Optionnal : Check part1 NRF LOG
```
sudo tee "$HOME/nuradio/script4-nrf/check_nrf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script4-nrf/check_nrf_1.sh"
```
```
sudo bash "$HOME/nuradio/script4-nrf/check_nrf_1.sh"
```

* Optionnal : Check part2 NRF MCC MNC TAC
```
sudo tee "$HOME/nuradio/script4-nrf/check_nrf_2.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script4-nrf/check_nrf_2.sh"
```
```
sudo bash "$HOME/nuradio/script4-nrf/check_nrf_2.sh"
```

  
### 3.4.5. Configuration scp.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script5-scp" && cd "$HOME/nuradio/script5-scp"
```
* Configure scp all
```
sudo tee "$HOME/nuradio/script5-scp/configure_scp.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script5-scp/configure_scp.sh"
```
```
sudo cp -rf "$HOME/nuradio/script5-scp/configure_scp.sh" /usr/bin/configure_scp.sh
```
```
sudo bash configure_scp.sh
```
OR,
```
sudo bash "$HOME/nuradio/script5-scp/configure_scp.sh"
```

* Check scp
```
sudo tee "$HOME/nuradio/script5-scp/check_scp.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

# part1 to part3
printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.200([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*nrf:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.10:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script5-scp/check_scp.sh"
```
```
sudo cp -rf "$HOME/nuradio/script5-scp/check_scp.sh" /usr/bin/check_scp.sh
```
```
sudo bash check_scp.sh
```
OR,
```
sudo bash "$HOME/nuradio/script5-scp/check_scp.sh"
```
* Optionnal : Configure part1 scp log
```
sudo tee "$HOME/nuradio/script5-scp/configure_scp_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script5-scp/configure_scp_logger.sh"
```
```
sudo bash "$HOME/nuradio/script5-scp/configure_scp_logger.sh"
```

* Optionnal : Check part1 scp log
```
sudo tee "$HOME/nuradio/script5-scp/check_scp_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script5-scp/check_scp_1.sh"
```
```
sudo bash "$HOME/nuradio/script5-scp/check_scp_1.sh"
```

* Optionnal : Check part2 scp IP address
```
sudo "$HOME/nuradio/script5-scp/tee check_scp_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.200([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script5-scp/check_scp_2.sh"
```
```
sudo bash "$HOME/nuradio/script5-scp/check_scp_2.sh"
```

* Optionnal : Check part3 scp other ip address for scp
Not directly connected to nrf , go tho SCP after to nrf
```
sudo "$HOME/nuradio/script5-scp/tee check_scp_3.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script5-scp/check_scp_3.sh"
```
```
sudo bash "$HOME/nuradio/script5-scp/check_scp_3.sh"
```

### 3.4.6. Configuration ausf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script6-ausf" && cd "$HOME/nuradio/script6-ausf"
```
* Configure AUSF all
```
sudo tee "$HOME/nuradio/script6-ausf/configure_ausf.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script6-ausf/configure_ausf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script6-ausf/configure_ausf.sh" /usr/bin/configure_ausf.sh
```
```
sudo bash configure_ausf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script6-ausf/configure_ausf.sh"
```

* Check AUSF all
```
sudo tee "$HOME/nuradio/script6-ausf/check_ausf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"
# part1 to part3
printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.11([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script6-ausf/check_ausf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script6-ausf/check_ausf.sh" /usr/bin/check_ausf.sh
```
```
sudo bash check_ausf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script6-ausf/check_ausf.sh"
```

* Optionnal : Configure part1 AUSF Log
```
sudo tee "$HOME/nuradio/script6-ausf/configure_ausf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script6-ausf/configure_ausf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script6-ausf/configure_ausf_logger.sh"
```
* Optionnal : Check part1 AUSF log
```
sudo "$HOME/nuradio/script6-ausf/tee check_ausf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script6-ausf/check_ausf_1.sh"
```
```
sudo bash "$HOME/nuradio/script6-ausf/check_ausf_1.sh"
```

* Optionnal : Check part2 AUSF ip address
```
sudo tee "$HOME/nuradio/script6-ausf/check_ausf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/ausf.yaml"

printf "\n\n"
sed -n '11,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.11([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script6-ausf/check_ausf_2.sh"
```
```
bash "$HOME/nuradio/script6-ausf/check_ausf_2.sh"
```

* Optionnal : Check part3 AUSF other ip address (scp)
```
sudo "$HOME/nuradio/script6-ausf/tee check_ausf_3.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script6-ausf/check_ausf_3.sh"
```
```
bash "$HOME/nuradio/script6-ausf/check_ausf_3.sh"
```
use directly scp not nrf
### 3.4.7. Configuration udm.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script7-udm" && cd "$HOME/nuradio/script7-udm"
```
* Configure UDM
```
sudo tee "$HOME/nuradio/script7-udm/configure_udm.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script7-udm/configure_udm.sh"
```
```
sudo cp -rf "$HOME/nuradio/script7-udm/configure_udm.sh" /usr/bin/configure_udm.sh
```
```
sudo bash configure_udm.sh
```
OR,
```
sudo bash "$HOME/nuradio/script7-udm/configure_udm.sh"
```

* Check UDM all
```
sudo tee "$HOME/nuradio/script7-udm/check_udm.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

# part1 to part3
printf "\n\n"
sed -n '1,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.12([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \   
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script7-udm/check_udm.sh"
```
```
sudo cp -rf "$HOME/nuradio/script7-udm/check_udm.sh /usr/bin/check_udm.sh"
```
```
sudo bash check_udm.sh
```
OR,
```
sudo bash "$HOME/nuradio/script7-udm/check_udm.sh"
```

* Optionnal : Configure part1 UDM log
```
sudo tee "$HOME/nuradio/script7-udm/configure_udm_logger.sh" > /dev/null << 'EOF'

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
sudo chmod +x "$HOME/nuradio/script7-udm/configure_udm_logger.sh"
```
```
sudo bash "$HOME/nuradio/script7-udm/configure_udm_logger.sh"
```


* Optionnal  : Check part1 UDM log
```
sudo tee "$HOME/nuradio/script7-udm/check_udm_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script7-udm/check_udm_1.sh"
```
```
sudo bash "$HOME/nuradio/script7-udm/check_udm_1.sh"
```

* Optionnal : Check part2 UDM ip address
```
sudo tee "$HOME/nuradio/script7-udm/check_udm_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udm.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.12([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script7-udm/check_udm_2.sh"
```
```
sudo bash "$HOME/nuradio/script7-udm/check_udm_2.sh"
```

* Optionnal : Check part3 UDM other ip address (scp)
```
sudo "$HOME/nuradio/script7-udm/tee check_udm_3.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script7-udm/check_udm_3.sh"
```
```
sudo bash "$HOME/nuradio/script7-udm/check_udm_3.sh"
```
Use directly scp not nrf

### 3.4.8. Configuration pcf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script8-pcf" && cd "$HOME/nuradio/script8-pcf"
```
* Configure PCF all
sudo tee "$HOME/nuradio/script8-pcf/configure_pcf.sh" > /dev/null << 'EOF'
```
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
sudo chmod +x  "$HOME/nuradio/script8-pcf/configure_pcf.sh"
```
```
sudo cp -rf  "$HOME/nuradio/script8-pcf/configure_pcf.sh" /usr/bin/configure_pcf.sh
```
```
sudo bash configure_pcf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script8-pcf/configure_pcf.sh"
```
* Check PCF all
```
sudo tee "$HOME/nuradio/script8-pcf/check_pcf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

# part1 to part3
printf "\n\n"
sed -n '1,40p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.13([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script8-pcf/check_pcf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script8-pcf/check_pcf.sh" /usr/bin/check_pcf.sh
```
```
bash check_pcf.sh
```
OR,
```
bash "$HOME/nuradio/script8-pcf/check_pcf.sh"
```
* Optionnal : Configure part1 PCF log
```
sudo tee "$HOME/nuradio/script8-pcf/configure_pcf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script8-pcf/configure_pcf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script8-pcf/configure_pcf_logger.sh"
```

* Optionnal : Check part1 PCF log
```
sudo tee "$HOME/nuradio/script8-pcf/check_pcf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
chmod +x "$HOME/nuradio/script8-pcf/check_pcf_1.sh"
```
```
bash "$HOME/nuradio/script8-pcf/check_pcf_1.sh"
```


* Optionnal : Check part2 PCF ip address
```
sudo tee "$HOME/nuradio/script8-pcf/check_pcf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/pcf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.13([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script8-pcf/check_pcf_2.sh"
```
```
bash "$HOME/nuradio/script8-pcf/check_pcf_2.sh"
```
* Optionnal : Check part3 PCF other address (scp) 
```
sudo tee "$HOME/nuradio/script8-pcf/check_pcf_3.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script8-pcf/check_pcf_3.sh"
```
```
bash "$HOME/nuradio/script8-pcf/check_pcf_3.sh"
```

### 3.4.9. Configuration nssf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script9-nssf" && cd "$HOME/nuradio/script9-nssf"
```
* Configure NSSF all
```
sudo tee "$HOME/nuradio/script9-nssf/configure_nssf.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script9-nssf/configure_nssf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script9-nssf/configure_nssf.sh" /usr/bin/configure_nssf.sh
```
```
sudo bash configure_nssf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script9-nssf/configure_nssf.sh"
```
* Check nssf 
```
sudo tee "$HOME/nuradio/script9-nssf/check_nssf.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

# PART 1 to part3
printf "\n\n"
sed -n '1,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.14([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"
    
EOF
```
```
sudo chmod +x "$HOME/nuradio/script9-nssf/check_nssf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script9-nssf/check_nssf.sh" /usr/bin/check_nssf.sh
```
```
sudo bash check_nssf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script9-nssf/check_nssf.sh"
```


* Optionnal : Configure part1 nssf log
```
sudo tee "$HOME/nuradio/script9-nssf/configure_nssf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script9-nssf/configure_nssf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script9-nssf/configure_nssf_logger.sh"
```

* Optionnal : Check nssf part1 log
```
sudo tee "$HOME/nuradio/script9-nssf/check_nssf_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
chmod +x "$HOME/nuradio/script9-nssf/check_nssf_1.sh"
```
```
sudo bash "$HOME/nuradio/script9-nssf/check_nssf_1.sh"
```


* Optionnal : Configure nssf part2 ip address
```
sudo tee "$HOME/nuradio/script9-nssf/check_nssf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.14([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script9-nssf/check_nssf_2.sh"
```
```
sudo bash "$HOME/nuradio/script9-nssf/check_nssf_2.sh"
```

* Optionnal : Configure part3 nssf other ip address (scp)
```
sudo tee "$HOME/nuradio/script9-nssf/check_nssf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nssf.yaml"

printf "\n\n"
sed -n '20,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script9-nssf/check_nssf_3.sh"
```
```
sudo bash "$HOME/nuradio/script9-nssf/check_nssf_3.sh"
```

### 3.4.10. Configuration bsf.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script10-bsf" && cd "$HOME/nuradio/script10-bsf"
```
* Configure BSF all
```
sudo tee "$HOME/nuradio/script10-bsf/configure_bsf.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script10-bsf/configure_bsf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script10-bsf/configure_bsf.sh" /usr/bin/configure_bsf.sh
```
```
sudo bash configure_bsf.sh
```
OR,
```
sudo bash "$HOME/nuradio/script10-bsf/configure_bsf.sh"
```
* Check BSF
```
sudo tee check_bsf.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

# PART 1 to Part 3
printf "\n\n"
sed -n '1,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.15([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"
EOF
```
```
sudo chmod +x "$HOME/nuradio/script10-bsf/check_bsf.sh"
```
```
sudo cp -rf "$HOME/nuradio/script10-bsf/check_bsf.sh" /usr/bin/check_bsf.sh
```
```
sudo bash check_bsf.sh
```
OR,
```
sudo bash  "$HOME/nuradio/script10-bsf/check_bsf.sh"
```

* Optionnal : Configure part1 BSF log
```
sudo tee "$HOME/nuradio/script10-bsf/configure_bsf_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script10-bsf/configure_bsf_logger.sh"
```
```
sudo bash "$HOME/nuradio/script10-bsf/configure_bsf_logger.sh"
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
chmod +x "$HOME/nuradio/script10-bsf/check_bsf_1.sh"
```
```
sudo bash "$HOME/nuradio/script10-bsf/check_bsf_1.sh"
```

* Optionnal : Check part2 BSF ip address
```
sudo "$HOME/nuradio/script10-bsf/tee check_bsf_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.15([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script10-bsf/check_bsf_2.sh"
```
```
sudo bash "$HOME/nuradio/script10-bsf/check_bsf_2.sh"
```

* Optionnal : Check part3 BSF other ip address (scp) 
```
sudo tee "$HOME/nuradio/script10-bsf/check_bsf_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/bsf.yaml"

printf "\n\n"
sed -n '20,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script10-bsf/check_bsf_3.sh"
```
```
sudo bash "$HOME/nuradio/script10-bsf/check_bsf_3.sh"
```

### 3.4.11. Configuration udr.yaml
* Create and change directory
```
mkdir "$HOME/nuradio/script11-udr" && cd "$HOME/nuradio/script11-udr"
```
* Configure UDR all
```
sudo tee "$HOME/nuradio/script11-udr/configure_udr.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script11-udr/configure_udr.sh"
```
```
sudo cp -rf "$HOME/nuradio/script11-udr/configure_udr.sh" /usr/bin/configure_udr.sh
```
```
sudo bash configure_udr.sh
```
OR,
```
sudo bash "$HOME/nuradio/script11-udr/configure_udr.sh"
```
* Check UDR all
```
sudo tee "$HOME/nuradio/script11-udr/check_udr.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

# PART 1
printf "\n\n"
sed -n '1,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.20([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script11-udr/check_udr.sh"
```
```
sudo cp -rf "$HOME/nuradio/script11-udr/check_udr.sh" /usr/bin/check_udr.sh
```
```
sudo bash check_udr.sh
```
OR 
```
sudo bash "$HOME/nuradio/script11-udr/check_udr.sh"
```

* Optionnal : Configure part1 UDR log
```
sudo tee "$HOME/nuradio/script11-udr/configure_udr_logger.sh" > /dev/null << 'EOF'
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
sudo chmod +x "$HOME/nuradio/script11-udr/configure_udr_logger.sh"
```
```
sudo bash "$HOME/nuradio/script11-udr/configure_udr_logger.sh"
```
* Optionnal : Check part1 UDR log
```
sudo tee "$HOME/nuradio/script11-udr/check_udr_1.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
chmod +x "$HOME/nuradio/script11-udr/check_udr_1.sh"
```
```
sudo bash "$HOME/nuradio/script11-udr/check_udr_1.sh"
```

* Optionnal : Check part2 UDR ip address
```
sudo tee "$HOME/nuradio/script11-udr/check_udr_2.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

printf "\n\n"
sed -n '9,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.20([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script11-udr/check_udr_2.sh"
```
```
sudo bash "$HOME/nuradio/script11-udr/check_udr_2.sh"
```

* Optionnal : Check part3 UDR other ip address (scp)
```
sudo tee "$HOME/nuradio/script11-udr/check_udr_3.sh" > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/udr.yaml"

printf "\n\n"
sed -n '20,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x "$HOME/nuradio/script11-udr/check_udr_3.sh"
```
```
sudo bash "$HOME/nuradio/script11-udr/check_udr_3.sh"
```

# STEP 4 : OPEN-SOURCE 5G NETWORK  CONFIGURATION WEBUI

# STEP 5 : OPEN-SOURCE 5G NETWORK  CONFIGURATION SRSRAN_GNB



