#!/bin/bash

sudo service mysql status

echo ""
echo "starting mysql service..."
echo ""

sudo service mysql start
sudo service mysql status


sudo mysql <<EOF
USE mysql;
CREATE USER '$(whoami)'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO '$(whoami)'@'localhost';
FLUSH PRIVILEGES;
EOF
