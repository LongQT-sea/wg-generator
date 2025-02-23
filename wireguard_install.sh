#!/bin/bash

# Need root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check distro
OS_NAME=$(lsb_release -is 2>/dev/null)
OS_VERSION=$(lsb_release -rs 2>/dev/null | cut -d. -f1)

if [[ "$OS_NAME" == "Debian" && "$OS_VERSION" -lt 11 ]] || 
   [[ "$OS_NAME" == "Ubuntu" && "$OS_VERSION" -lt 22 ]]; then
    echo "This script requires Debian or Ubuntu."
    exit 1
fi

apt update && apt install wireguard iptables resolvconf -y

# Replace config below with the one you generated
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = #key

[Peer]
PublicKey = #key

EOF

# Enable and start the service
systemctl enable --now wg-quick@wg0

wg show