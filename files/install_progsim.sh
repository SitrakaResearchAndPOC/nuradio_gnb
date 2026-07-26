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
        python3-pyscard 
        
sudo mkdir -p "$HOME/nuradio/script_progsim"

echo "Installing pysim"

sudo rm -rf "$HOME/nuradio/script_progsim/pysim" && \
cd "$HOME/nuradio/script_progsim" && \
sudo git clone https://github.com/osmocom/pysim.git && \
sudo chown -R $USER:$USER  "$HOME/nuradio/script_progsim/pysim" && \
    cd pysim && \
    python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt && \
    cd  ..

echo "Installing sysmo-usim-tool"
sudo rm -rf "$HOME/nuradio/script_progsim/sysmo-usim-tool" && \
cd "$HOME/nuradio/script_progsim" && \
sudo git clone https://github.com/sysmocom/sysmo-usim-tool.git && \
sudo chown -R $USER:$USER  "$HOME/nuradio/script_progsim/sysmo-usim-tool" && \
    cd sysmo-usim-tool && \
    python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --upgrade pip setuptools wheel pytlv  pyscard  && \
    cd  ..


sudo tee "$HOME/nuradio/script_progsim/start_services.sh" > /dev/null <<'EOF'
#!/bin/bash
set -e

# --- DBUS ---
if pgrep -x dbus-daemon > /dev/null || pgrep -x dbus-broker > /dev/null; then
    echo "[+] DBus already running"
else
    echo "[+] Starting DBus..."
    service dbus start || true
fi

# --- POLKIT ---
if pgrep -x polkitd > /dev/null; then
    echo "[+] polkit already running"
else
    echo "[+] Starting polkit..."
    service polkit start || systemctl start polkit || true
fi

# --- PCSCD ---
if pgrep -x pcscd > /dev/null; then
    echo "[+] pcscd already running"
else
    echo "[+] Starting pcscd..."
    systemctl start pcscd || true
fi

echo "[+] Checking services..."
ps aux | grep -E "dbus|polkit|pcscd" || true
EOF

sudo chmod +x "$HOME/nuradio/script_progsim/start_services.sh"

sudo cp -rf "$HOME/nuradio/script_progsim/start_services.sh" /usr/bin/start_services.sh

sudo tee "$HOME/nuradio/script_progsim/show_services.sh" > /dev/null <<'EOF'
#!/bin/bash
set -e

echo "[+] Showing DBus..."
service dbus status || true

echo "[+] Showing polkit..."
service polkit status || systemctl status polkit || true

echo "[+] Showing pcscd..."
systemctl status pcscd || true

echo "[+] Checking services..."
ps aux | grep -E "dbus|polkit|pcscd" || true
EOF

sudo chmod +x "$HOME/nuradio/script_progsim/show_services.sh"

sudo cp -rf  "$HOME/nuradio/script_progsim/show_services.sh" /usr/bin/show_services.sh

sudo tee -a /root/.bashrc > /dev/null <<'EOF'

# --- AUTO START SERVICES (SIM LAB SILENT) ---

# DBUS
if ! pgrep -x dbus-daemon > /dev/null && ! pgrep -x dbus-broker > /dev/null; then
    echo "[+] Running Dbus"
    service dbus start > /dev/null 2>&1 || true
fi

# POLKIT (OPTIONAL)
if ! pgrep -x polkitd > /dev/null; then
    echo "[+] Running Polkit"
    service polkit start > /dev/null 2>&1 || true
fi

# PCSCD
if ! pgrep -x pcscd > /dev/null; then
    echo "[+] Running Pcscd"
    systemctl enable pcscd > /dev/null 2>&1 || true
    systemctl start pcscd > /dev/null 2>&1 || true
fi

EOF

sudo start_services.sh
