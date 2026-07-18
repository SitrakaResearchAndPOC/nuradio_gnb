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
cd $HOME/nuradio
```
```
[ -f "install_uhd_v4.1.0.5.sh" ] && sudo rm -rf install_uhd_v4.1.0.5.sh; \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_uhd_v4.1.0.5.sh
```
```
chmod +x install_uhd_v4.1.0.5.sh && bash install_uhd_v4.1.0.5.sh
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
sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py
```
or directly : 
```
sudo uhd_images_downloader
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
[ -f "srsran_50fe9623c_install.sh" ] && sudo rm -rf srsran_50fe9623c_install.sh; wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/srsran_50fe9623c_install.sh
```
```
chmod +x srsran_50fe9623c_install.sh && bash srsran_50fe9623c_install.sh
```
### 1.2.2. Checking srsRAN
Verify 
```
[ -d "srsRAN_Project/build" ] && sudo make -C srsRAN_Project/build test -j "$(nproc --ignore=1)"
```
```
gnb --version
```
## 1.3. Installing Open5gs
### 1.3.1. Installing Mongodb
```
[ ! -f install_mongodb_6.0.sh ] && wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/main/files/install_mongodb_6.0.sh
```
```
chmod +x install_mongodb_6.0.sh && bash install_mongodb_6.0.sh
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
[ ! -f install_open5gs_2.7.sh ] && \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_open5gs_2.7.sh
```
```
chmod +x install_open5gs_2.7.sh && bash install_open5gs_2.7.sh
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
[ ! -f install_webui.sh ] && \
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nuradio_gnb/refs/heads/main/files/install_webui.sh
```
```
chmod +x install_webui.sh && bash install_webui.sh
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
ls open5gs-webui/webui/.next/ | grep "BUILD_ID"
```
```
ls open5gs-webui/webui/
```
THIS DIRECTORY SHOULD EXIST : server/  </br>
```
ls open5gs-webui/webui/ | grep "server"
```

THIS DIRECTORY SHOULD EXIST  : static/  </br>
```
ls open5gs-webui/webui/ | grep "static"
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
18 because the process webui doesn't begin by open5gs

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
### 2.2.3. Script start_5gc
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
### 2.2.4. Script 5gc
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
### 2.2.5. Script restart_5gc
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
sudo chmod +x check_ogstun.sh
```
```
sudo cp -rf check_ogstun.sh /usr/local/bin/check_ogstun.sh
```
```
bash check_ogstun.sh
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
sudo cp -rf configure_ogstun.sh /usr/local/bin/configure_ogstun.sh
```
```
bash configure_ogstun.sh
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
sudo cp -rf check_ipv4forward.sh /usr/local/bin/check_ipv4forward.sh
```
```
bash check_ipv4forward.sh
```
The goal is to have  net.ipv4.ip_forwad = 1

### 3.2.2. Configure IPv4 forward
```
sudo tee configure_ipv4forward.sh > /dev/null <<'EOF'
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
sudo tee check_iptableNATforward.sh > /dev/null <<'EOF'
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
sudo chmod +x check_iptableNATforward.sh
```

```
sudo cp -rf check_iptableNATforward.sh /usr/local/bin/check_iptableNATforward.sh
```
```
bash check_iptableNATforward.sh
```
### 3.3.2. Configuring IPTABLE NAT forwading
```
sudo tee configure_iptableNATforward.sh > /dev/null <<'EOF'
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
sudo chmod +x configure_iptableNATforward.sh
```
```
sudo cp -rf configure_iptableNATforward.sh /usr/local/bin/configure_iptableNATforward.sh
```
```
bash configure_iptableNATforward.sh
```
### 3.3.3. Rechecking IPTABLE NAT Forwading
```
bash check_iptableNATforward.sh
```
 
## 3.4. Configuration PLMN & DEBUG MODE
### 3.4.1. Configuration amf.yaml
* Create and change directory
```
mkdir 1-amf && cd 1-amf
```
* Configure AMF
Directly all configuraiton in one manipulation
```
sudo tee configure_amf.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_amf.sh
```
```
sudo bash configure_amf.sh
```


* Configure AMF log
```
sudo tee configure_amf_logger.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_amf_logger.sh
```
```
sudo bash configure_amf_logger.sh 
```
* Configure AMF MCC & MNC
```
sudo tee configure_amf_mcc_mnc.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_amf_mcc_mnc.sh
```
```
sudo bash configure_amf_mcc_mnc.sh
```
* check AMF all 
```
sudo tee check_amf.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"
# part 1
printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
    
# part 2
printf "\n\n"
sed -n '20,49p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"
# part 3
printf "\n\n"
sed -n '40,69p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*time[[:space:]]*:" \
    -e "^[[:space:]]*t3512[[:space:]]*:" \
    -e "^[[:space:]]*value[[:space:]]*:[[:space:]]*540.*$" \
    -e "$"

# part 4
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
sudo chmod +x check_amf.sh
```
```
sudo bash check_amf.sh 
```

*  Check AMF part1
```
sudo tee check_amf_1.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
EOF
```
```
sudo chmod +x check_amf_1.sh
```
```
sudo bash check_amf_1.sh 
```
*  Check AMF part2
```
sudo tee check_amf_2.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/amf.yaml"

printf "\n\n"

sed -n '20,49p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"

EOF
```
```
sudo chmod +x check_amf_2.sh
```
```
sudo bash check_amf_2.sh 
```
*  Check AMF part3
```
sudo tee check_amf_3.sh > /dev/null << 'EOF'
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
sudo chmod +x check_amf_3.sh
```
```
sudo bash check_amf_3.sh
```
*  Check AMF part4
  
a little bit different, line by line

```
sudo tee check_amf_4.sh > /dev/null << 'EOF'
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
sudo chmod +x check_amf_4.sh
```
```
sudo bash check_amf_4.sh
```

### 3.4.2. Configuration SMF.yaml
* Create and change directory
```
mkdir 2-smf && cd 2-smf
```
* Configure SMF all
```
sudo tee configure_smf.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_smf.sh
```
```
sudo bash configure_smf.sh
```
* Configure SMF logger
```
sudo tee configure_smf_logger.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_smf_logger.sh
```
```
sudo bash configure_smf_logger.sh
```
* Check SMF all
```
sudo tee check_smf.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"
# part1
printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
# part2
printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "$"

# part3
printf "\n\n"
sed -n '11,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "$"

# part4
printf "\n\n"
sed -n '23,50p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*dns[[:space:]]*:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.8\.8([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*8\.8\.4\.4([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8888([[:space:]]*#.*)?$" \
    -e "^[[:space:]]*-[[:space:]]*2001:4860:4860::8844([[:space:]]*#.*)?$" \
    -e "$"

# part 5
printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*scp:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.200:7777([[:space:]]*#.*)?$" \
    -e "$"


EOF
```
```
sudo chmod +x check_smf.sh
```
```
sudo bash check_smf.sh
```
* Check SMF part1
```
sudo tee check_smf_1.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x check_smf_1.sh
```
```
sudo bash check_smf_1.sh
```

* Check SMF part2
```
sudo tee check_smf_2.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x check_smf_2.sh
```
```
sudo bash check_smf_2.sh
```

* Check SMF part3
```
sudo tee check_smf_3.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/smf.yaml"

printf "\n\n"

sed -n '11,39p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.4([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x check_smf_3.sh
```
```
sudo bash check_smf_3.sh
```

* Check SMF part4
```
sudo tee check_smf_4.sh > /dev/null << 'EOF'
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
sudo chmod +x check_smf_4.sh
```
```
sudo bash check_smf_4.sh
```

* Check SMF part5
```
sudo tee check_smf_5.sh > /dev/null << 'EOF'
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
sudo chmod +x check_smf_5.sh
```
```
sudo bash check_smf_5.sh
```

### 3.4.3. Configuration upf.yaml
* Create and change directory
```
mkdir 3-upf && cd 3-upf
```
* Configure UPF
```
sudo tee configure_upf.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_upf.sh
```
```
sudo bash configure_upf.sh
```
* Configure UPF Logger
```
sudo tee configure_upf_logger.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_upf_logger.sh
```
```
sudo bash configure_upf_logger.sh
```

* Check UPF all
If you add smf in upf; the relation between them will be more active </br>
the easy way, is that the smf find the upf not also upf find the smf </br>

```
sudo tee check_upf.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

printf "\n\n"
sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.7([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x check_upf.sh
```
```
sudo bash check_upf.sh
```

* Check UPF part1
```
sudo tee check_upf_1.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

printf "\n\n"

sed -n '1,30p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x check_upf_1.sh
```
```
sudo bash check_upf_1.sh
```

* Check UPF part2
```
sudo tee check_upf_2.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/upf.yaml"

printf "\n\n"

sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.7([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x check_upf_2.sh
```
```
sudo bash check_upf_2.sh
```

### 3.4.4. Configuration nrf.yaml
* Create and change directory
```
mkdir 4-nrf && cd 4-nrf
```
* Configure NRF
```
sudo tee configure_nrf_logger.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_nrf.sh
```
```
sudo bash configure_nrf.sh
```

* Configure NRF LOGGER
```
sudo tee configure_nrf.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_nrf_logger.sh
```
```
sudo bash configure_nrf_logger.sh
```
* Configure NRF MCC & MNC & TAC
```
sudo tee configure_nrf_mcc_mnc.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_nrf_mcc_mnc.sh
```
```
sudo bash configure_nrf_mcc_mnc.sh
```

* Check NRF 
```
sudo tee check_nrf.sh > /dev/null << 'EOF'
#!/bin/bash
CONFIG="/etc/open5gs/nrf.yaml"

# PART 1
printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

# PART 2
printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*mcc[[:space:]]*:[[:space:]]*001.*$" \
    -e "^[[:space:]]*mnc[[:space:]]*:[[:space:]]*01.*$" \
    -e "^[[:space:]]*tac[[:space:]]*:[[:space:]]*77.*$" \
    -e "$"

# PART 3
printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.10([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
sudo chmod +x check_nrf.sh
```
```
sudo bash check_nrf.sh
```
In configuration, if nrf is not commented, it's not directly used , go tho SCP after to NRF

* Check NRF part1
```
sudo tee check_nrf_1.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"
EOF
```
```
sudo chmod +x check_nrf_1.sh
```
```
sudo bash check_nrf_1.sh
```

* Check NRF part2
```
sudo tee check_nrf_2.sh > /dev/null << 'EOF'
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
sudo chmod +x check_nrf_2.sh
```
```
sudo bash check_nrf_2.sh
```

* Check NRF part3
```
sudo tee check_nrf_3.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/nrf.yaml"

printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.10([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x check_nrf_3.sh
```
```
sudo bash check_nrf_3.sh
```

  
### 3.4.5. Configuration scp.yaml
* Create and change directory
```
mkdir 5-scp && cd 5-scp
```
* Configure scp
```
sudo tee configure_scp.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_scp.sh
```
```
sudo bash configure_scp.sh
```

* Configure scp logger
```
sudo tee configure_scp_logger.sh > /dev/null << 'EOF'
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
sudo chmod +x configure_scp_logger.sh
```
```
sudo bash configure_scp_logger.sh
```
* Check scp
```
sudo tee check_scp.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

# part1
printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

# part2
printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.200([[:space:]]*#.*)?$" \
    -e "$"

# part3
printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*nrf:[[:space:]]*$" \
    -e "^[[:space:]]*-[[:space:]]*uri:[[:space:]]*http://127\.0\.0\.10:7777([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x check_scp.sh
```
```
sudo bash check_scp.sh
```

* Check scp part1
```
sudo tee check_scp_1.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

printf "\n\n"
sed -n '1,37p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*level[[:space:]]*:[[:space:]]*debug.*$" \
    -e "$"

EOF
```
```
sudo chmod +x check_scp_1.sh
```
```
sudo bash check_scp_1.sh
```

* Check scp part2
```
sudo tee check_scp_2.sh > /dev/null << 'EOF'
#!/bin/bash

CONFIG="/etc/open5gs/scp.yaml"

printf "\n\n"
sed -n '5,33p' "$CONFIG" | grep --color=always -E \
    -e "^[[:space:]]*-[[:space:]]*address[[:space:]]*:[[:space:]]*127\.0\.0\.200([[:space:]]*#.*)?$" \
    -e "$"

EOF
```
```
sudo chmod +x check_scp_2.sh
```
```
sudo bash check_scp_2.sh
```

* Check scp part3
```
Not directly connected to nrf , go tho SCP after to nrf
sudo tee check_scp_3.sh > /dev/null << 'EOF'
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
sudo chmod +x check_scp_3.sh
```
```
sudo bash check_scp_3.sh
```

### 3.4.6. Configuration ausf.yaml
* Create and change directory
```
mkdir 6-ausf && cd 6-ausf
```
* Configure AUSF

### 3.4.7. Configuration udm.yaml
* Create and change directory
```
mkdir 7-udm && cd 7-udm
```
* Configure UDM

### 3.4.8. Configuration pcf.yaml
* Create and change directory
```
mkdir 8-pcf && cd 8-pcf
```
* Configure PCF

### 3.4.9. Configuration nssf.yaml
* Create and change directory
```
mkdir 9-nssf && cd 9-nssf
```
* Configure NSSF

### 3.4.10. Configuration bsf.yaml
* Create and change directory
```
mkdir 10-bsf && cd 10-bsf
```
* Configure BSF

### 3.4.11. Configuration udr.yaml
* Create and change directory
```
mkdir 11-udr && cd 11-udr
```
* Configure UDR









# STEP 4 : OPEN-SOURCE 5G NETWORK  CONFIGURATION WEBUI

# STEP 5 : OPEN-SOURCE 5G NETWORK  CONFIGURATION SRSRAN_GNB



