#!/bin/bash
sudo apt update
 
sudo apt install -y git cmake build-essential libboost-all-dev libusb-1.0-0-dev python3-dev python3-mako python3-numpy python3-requests python3-setuptools libfftw3-dev libcomedi-dev libgps-dev libgmp-dev swig pkg-config gedit

# sudo git clone https://github.com/EttusResearch/uhd.git
[ ! -d uhd ] && git clone https://github.com/EttusResearch/uhd.git
sudo chown -R $USER:$USER ~/uhd

cd uhd/

sudo git checkout v4.1.0.5

ls

# PATCH OF GPSDO 
 ( grep -qF 'static const std::regex gp_msg_regex("^\\$G.*$");' host/lib/usrp/gps_ctrl.cpp ||   sed -i '/static const std::regex gp_msg_regex/{s|^|// |;a\
static const std::regex gp_msg_regex("^\\\\$G.*$");
}' host/lib/usrp/gps_ctrl.cpp ) && ( grep -qF 'if(msg.substr(1,2) == "GN"){ msg.replace(1, 2, "GP");}' host/lib/usrp/gps_ctrl.cpp ||   sed -i '/msgs\[msg\.substr(1, 5)\] = msg;/i\
        if(msg.substr(1,2) == "GN"){ msg.replace(1, 2, "GP");}
' host/lib/usrp/gps_ctrl.cpp )

cd host/

sudo mkdir build

cd build/

sudo cmake .. 

sudo make -j $(nproc --ignore 1)

sudo make install

sudo ldconfig

sudo ln -s /usr/local/lib/uhd/utils/query_gpsdo_sensors /usr/local/bin/query_gpsdo_sensors
# sudo ln -s  $(query_gpsdo_sensors) /usr/local/bin/query_gpsdo_sensors

# NEED FOR VERIFICATION
# sudo uhd_images_downloader 
# sudo query_gpsdo_sensors 
