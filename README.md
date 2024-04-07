# UBUNTU 22.04 (jammy)
# NURADIO GNB
apt-get install vim zsh net-tools
# INSTALLING DRIVER
guide install uhd is at [guide_uhd](https://files.ettus.com/manual/page_install.html)
```
apt update
```
```
apt-get install libuhd-dev uhd-host
```
```
cd /usr/lib/uhd/utils
```
```
sudo ./uhd_images_downloader.py
```
```
cd /usr/share/uhd/images
```
```
exit
```

# INSTALLING SRSRAN
guide install srsRAN is at [guide_srsRAN](https://docs.srsran.com/projects/project/en/latest/user_manuals/source/installation.html#manual-installation)
```
sudo su
```
```
sudo apt-get install cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev
```
```
sudo apt-get install git
```
```
git clone https://github.com/srsRAN/srsRAN_Project.git
```
```
cd srsRAN_Project
```
```
mkdir build
```
```
cd build
```
```
cmake ../
```
```
make -j $(nproc)
```
```
make test -j $(nproc)
```
```
make install
```
```
ldconfig
```

# INSTALLING OPEN5GS
guide install open5Gs [guide_open5Gs](https://open5gs.org/open5gs/docs/guide/01-quickstart/)
## installing certificate
```
sudo apt update
```
```
sudo apt install gnupg
```
```
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
```
```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
```
## installing mongodb
```
sudo apt update
```
```
sudo apt install -y mongodb-org
```
```
sudo systemctl start mongod
```
(if '/usr/bin/mongod' is not running) </br>
```
sudo systemctl enable mongod
```
(ensure to automatically start it on system boot) </br>
checking by 
```
sudo systemctl status mongod
```

## installing open5gs
```
sudo add-apt-repository ppa:open5gs/latest
```
```
sudo apt update
```
```
sudo apt install open5gs
```
```
cd /etc/open5gs
```
```
ls
```
```
ps aux | grep open5gs
```
# INSTALLING WEB UI
```
apt update
```
## Download and import the Nodesource GPG key
```
sudo apt update
```
```
sudo apt install -y ca-certificates curl gnupg
```
```
sudo mkdir -p /etc/apt/keyrings
```
```
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
```
## Create deb repository
```
NODE_MAJOR=20
```
```
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
```
## Install Nodejs
```
sudo apt update
```
```
sudo apt install nodejs -y
```
## installing Webgui
```
curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -
```
Testing on navigator by taping : localhost:9999


# SCRIPT FOR RUNNING 5G
## stopping services
stop service Open5Gs one by one : 
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
sudo systemctl stop open5gs-spguwd
```
```
sudo systemctl stop open5gs-sgwcd
```
## verifying process
```
ps aux | grep open5gs
```
## automatically script for stoping 5G
Open5Gs start on script
```
cd /usr/bin
```
```
sudo touch 5gc
```
```
sudo touch stop_5gc
```
```
sudo vim stop_5gc
```
script for stoping will be
```
#!/usr/bin/zsh

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
sudo systemctl stop open5gs-webui
sudo systemctl stop open5gs-udrd
```
tape :wq
## automatically script for starting 5G
```
sudo vim 5gc
```
script for starting will be
```
#!/usr/bin/zsh
sudo rm /var/log/open5gs/
sudo systemctl restart open5gs-smfd
sudo systemctl restart open5gs-amfd
sudo systemctl restart open5gs-upfd
sudo systemctl restart open5gs-nrfd
sudo systemctl restart open5gs-scpd
sudo systemctl restart open5gs-ausfd
sudo systemctl restart open5gs-udmd
sudo systemctl restart open5gs-pcfd
sudo systemctl restart open5gs-nssfd
sudo systemctl restart open5gs-bsfd
sudo systemctl restart open5gs-udrd
sudo systemctl restart open5gs-webui
```
tape :wq
## Execution permission of script
```
chmod +x 5gc
```
```
chmod +x stop_5gc
```
## Test lauching the script
```
5gc
```
```
ps aux | grep open5gs
```
```
stop_5gc
```
```
ps aux | grep open5gs
```
Testing navigator by using : localhost:9999

# CONFIGURATIONS
## CONFIGURATION OSGTUN
```
cd /etc/open5gs
```
```
ifconfig
```
The screen should appears ogstun and, it should be well configured; if it is not the case, run this tree commands
```
sudo ip tuntap add name ogstun mode tun
```
```
sudo ip addr add 10.45.0.1/16 dev ogstun
```
```
sudo ip link set ogstun up
```
## CONFIGURATION IP_FORWARDING ENABLE FOR SHARING INTERNET
check if ip forward is active for sharing internet
```
sudo sysctl -a | grep ip_forward
```
see and verify if net.ipv4.ip_forward = 0, configure it, and transform by net.ipv4.ip_forward = 1 by running this command
```
sudo sysctl -w net.ipv4.ip_forward=1
```
Recheck the ip_forwarding
```
sudo sysctl -a | grep ip_forward
```
## CONFIGURE IPTABLE TO NAT
check if iptable is correctly activate for ogstun
```
sudo iptables -L -n -V -t nat
```
see if ogstun 10.45.0.1/16 is displayed (masquerade) or not, if not running : 
```
sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
```

## VERIFY ALL CONFIGURATIONS  
```
cd /etc/open5gs
```
```
ls
```
## verify amf.yaml
```
sudo vim amf.yaml
```
Uncomment level_info in logger and change level info to level debug: </br>
It should be like this
```
logger : 
level debug
```
configure also the three plmn if possible </nr>
you can change also timer value but generally don't touch that </br>
you can configure also reject cause : </br>
access_control </br>
## verify smf.yaml
```
sudo vim smf.yaml
```
make the same as amf, change level info to level debug
verify the dns 
## verify upf.yaml
```
sudo vim upf.yaml
```
make the same as amf, change level info to level debug

# CONFIGURE WEB GUI
## lauch the 5GCore network
```
5gc
```
tape on navigator : localhost:9999 </br>
user_name : admin </br>
pass_word : 1432 </br>
## add subscriber
click ADD SUBSCRIBER </br>
configure : IMSI , K: , OPC </br>
configure apn </br>
and set to ipv4 </br>
add also apn for PCC rule for ims </br>

# CONFIGURE GNB 
```
cd srsRAN_Project/configs
```
```
wget https://github.com/SitrakaResearchAndPOC/fork_nuradio_5G_Network/blob/main/srsRAN_Project/gnb_n3.yml
```
or 
```
wget https://github.com/SitrakaResearchAndPOC/fork_nuradio_5G_Network/blob/main/srsRAN_Project/gnb_n28.yml
```
```
vim gnb_n3.yml
```
Replace add and bind_addr
```
addr : 172.0.0.5
```
```
bind_addr : 172.0.0.66
```
Configure clock and sync, (comment if not need) </br>
```
clock : external 
```
```
sync : external
```
configure bandwith and scs </br>
plmn should match  </br>
plmn with pci configuration is optimal </br>
configure pcap if needed </br>

## verifying nrf.yaml
```
vim nrf.yaml
```
change plmn id correctly </br>
tape :wq

# 5G NETWORK RUNNING
Plug usrp devices
# capturing traffic by wireshark
```
sudo tcpdump -i any -w 5gc.pcap
```
# running 5G core network
```
5gc
```
``` 
ps aux | grep open5gs
```
# checking active port Open5Gs using netstat  
```
sudo netstat -tulpn | grep open5gs
```
# monitoring logfile in realtimes
```
sudo tail -f /var/log/open5gs/amf.log
```
# preparing gpsdo if the equipement exist
```
cd /usr/lib/uhd/utils
```
```
sudo .query_gpsdo_sensors
```
```
cd ~/srsRAN_Project/configs
```
```
sudo gnb -C gnb_n3.yml
```
# STOPING 5G CORE
stop_5g
