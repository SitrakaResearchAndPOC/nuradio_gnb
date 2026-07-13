#!/bin/sh
# INSTALLING MONGO DB
sudo apt install -y gnupg curl
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg --dearmor --yes  -o /usr/share/keyrings/mongodb-server-6.0.gpg
grep -qxF 'deb [signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse' /etc/apt/sources.list.d/mongodb-org-6.0.list 2>/dev/null || echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse' | sudo tee -a /etc/apt/sources.list.d/mongodb-org-6.0.list > /dev/null
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl restart mongod
