!/bin/bash
# setup.sh – Libreswan VPN Configuration Script for Simulated DC EC2

# 1. Update system and install Libreswan
echo "[+] Installing Libreswan..."
sudo dnf --enablerepo=fedora install libreswan -y

# 2. Enable IP forwarding
echo "[+] Configuring IP forwarding..."
sudo tee -a /etc/sysctl.conf > /dev/null <<EOF
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.accept_source_route = 0
EOF
sudo sysctl -p

# 3. Configure ipsec.conf to include tunnel conf
sudo sed -i 's/^#include/include/' /etc/ipsec.conf

# 4. Create AWS VPN configuration (replace IPs with actual values)
echo "[+] Creating IPsec tunnel configuration..."
sudo tee /etc/ipsec.d/aws.conf > /dev/null <<EOF
conn Tunnel1
    authby=secret
    auto=start
    type=tunnel
    ike=aes128-sha1;modp2048
    esp=aes128-sha1
    keyexchange=ike
    left=13.250.64.164
    leftid=13.250.64.164
    leftsubnet=11.0.0.0/16
    leftsourceip=169.254.129.74
    right=3.7.52.164
    rightid=3.7.52.164
    rightsubnet=10.0.0.0/16
    rightsourceip=169.254.129.73
    ikelifetime=28800s
    salifetime=3600s
    dpddelay=10
    dpdtimeout=30
    dpdaction=restart
    mtu=1436
    fragmentation=yes
EOF

# 5. Create secrets file
echo "[+] Setting pre-shared key..."
sudo tee /etc/ipsec.d/aws.secrets > /dev/null <<EOF
13.250.64.164 3.7.52.164 : PSK "SCwBrhOSSaf45Q0MA0pNJHScMuRCtyGn"
EOF

# 6. Configure tunnel interface
echo "[+] Configuring tunnel interface..."
sudo ip addr add 169.254.129.74/30 dev ip_vti0
sudo ip link set ip_vti0 up
sudo ip route add 10.0.0.0/16 via 169.254.129.73 dev ip_vti0

# 7. Start IPsec service and tunnel
echo "[+] Starting IPsec service..."
sudo ipsec auto --add Tunnel1
sudo systemctl restart ipsec
sudo ipsec auto --up Tunnel1

# 8. Show tunnel status
sudo ipsec status

echo "[+] VPN tunnel setup complete."

# Note: Replace public/private IPs and PSK with values from your AWS VPN config