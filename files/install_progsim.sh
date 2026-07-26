#!/bin/bash

sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends policykit-1 \
        systemd \
        systemd-sysv \
        build-essential \
        gcc \
        g++ \
        make \
        pkg-config \
        git \
        swig \
        pcscd \
        pcsc-tools \
        libccid \
        libpcsclite-dev \
        python3 \
        python3-dev \
        python3-venv \
        python3-full \
        python3-setuptools \
        python3-pip \
        python3-pycryptodome \
        python3-pyscard && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

sudo mkdir -p "$HOME/nuradio/script_progsim"

sudo cd "$HOME/nuradio/script_progsim" && \
sudo git clone https://github.com/osmocom/pysim.git && \
    cd pysim && \
    python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt && \
    cd  ..

sudo cd "$HOME/nuradio/script_progsim" && \
sudo git clone https://github.com/sysmocom/sysmo-usim-tool.git && \
    cd sysmo-usim-tool && \
    python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --upgrade pip setuptools wheel pytlv  pyscard  && \
    cd  ..


sudo echo '#!/bin/bash\n\
set -e\n\
\n\
# --- DBUS ---\n\
if pgrep -x dbus-daemon > /dev/null || pgrep -x dbus-broker > /dev/null; then\n\
    echo "[+] DBus already running"\n\
else\n\
    echo "[+] Starting DBus..."\n\
    service dbus start || true\n\
fi\n\
\n\
# --- POLKIT ---\n\
if pgrep -x polkitd > /dev/null; then\n\
    echo "[+] polkit already running"\n\
else\n\
    echo "[+] Starting polkit..."\n\
    service polkit start || systemctl start polkit || true\n\
fi\n\
\n\
# --- PCSCD ---\n\
if pgrep -x pcscd > /dev/null; then\n\
    echo "[+] pcscd already running"\n\
else\n\
    echo "[+] Starting pcscd..."\n\
    service pcscd enable \n\
    service pcscd start || systemctl start pcscd || true\n\
fi\n\
\n\
# --- STATUS ---\n\
echo "[+] Checking services..."\n\
ps aux | grep -E "dbus|polkit|pcscd" || true\n\
\n\
' > "$HOME/nuradio/script_progsim/start_services.sh"


sudo chmod +x "$HOME/nuradio/script_progsim/start_services.sh"

sudo cp -rf "$HOME/nuradio/script_progsim/start_services.sh" /usr/bin/start_services.sh


sudo echo '#!/bin/bash\n\
set -e\n\
\n\
echo "[+] Showing DBus..."\n\
service dbus status || true\n\
\n\
echo "[+] Showing polkit..."\n\
service polkit status || systemctl status polkit || true\n\
\n\
echo "[+] Showing pcscd..."\n\
service pcscd enable \n\
service pcscd status || systemctl status pcscd || true\n\
\n\
echo "[+] Checking services..."\n\
ps aux | grep -E "dbus|polkit|pcscd" || true\n\
\n' > "$HOME/nuradio/script_progsim/show_services.sh"

sudo chmod +x "$HOME/nuradio/script_progsim/show_services.sh"

cp -rf  "$HOME/nuradio/script_progsim/show_services.sh" /usr/bin/show_services.sh

sudo echo '\n\
# --- AUTO START SERVICES (SIM LAB SILENT) ---\n\
\n\
# DBUS\n\
if ! pgrep -x dbus-daemon > /dev/null && ! pgrep -x dbus-broker > /dev/null; then\n\
    echo "[+] Running Dbus" \n\
    service dbus start > /dev/null 2>&1 || true\n\
fi\n\
\n\
# POLKIT (OPTIONAL)\n\
if ! pgrep -x polkitd > /dev/null; then\n\
    echo "[+] Running Polkit" \n\
    service polkit start > /dev/null 2>&1 || true\n\
fi\n\
\n\
# PCSCD\n\
if ! pgrep -x pcscd > /dev/null; then\n\
    echo "[+] Running Pcscd" \n\
    service pcscd enable > /dev/null 2>&1 || true\n\
    service pcscd start > /dev/null 2>&1 || true\n\
fi\n\
' >> /root/.bashrc

sudo start_services.sh
sudo show_services.sh
