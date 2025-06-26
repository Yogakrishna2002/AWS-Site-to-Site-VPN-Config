# 🔐 AWS Site-to-Site VPN – Hybrid Cloud Simulation

This project demonstrates a full **AWS Site-to-Site VPN setup** between two VPCs in different regions, simulating a real-world hybrid network connection between an **on-premises data center** and an **AWS private VPC**.

---

## 📌 Architecture Overview

- **AWS VPC (Mumbai)**  
  - CIDR: `10.0.0.0/16`  
  - Private Subnet: `10.0.2.0/24`  
  - Private EC2 (no public IP)

- **Simulated DC VPC (Virginia)**  
  - CIDR: `11.0.0.0/16`  
  - Public Subnet: `11.0.2.0/24`  
  - Public EC2 (VPN server with Libreswan)

- **Connectivity**:  
  - Static IPsec VPN using **Virtual Private Gateway**, **Customer Gateway**, and **Libreswan**

---

## 🛠️ Components Used

| Component | Description |
|----------|-------------|
| VPC | Two VPCs in different regions |
| EC2 | One private EC2 (AWS) and one public EC2 (VPN server) |
| VGW & CGW | VPN endpoints for tunnel |
| VPN Connection | IPsec tunnel using static routing |
| Libreswan | VPN software installed on DC EC2 |
| Tunnel IPs | VTI interface with AWS-assigned IPs |
| Route Tables | Routes between 10.0.0.0/16 ↔ 11.0.0.0/16 |
| Security Groups | ICMP and SSH rules for testing |

---

## ✅ Steps Summary

1. Create VPCs and subnets
2. Launch EC2 instances
3. Set up VGW and attach to AWS VPC
4. Create CGW pointing to DC EC2 public IP
5. Configure Site-to-Site VPN in AWS (static routing)
6. Install and configure **Libreswan** on DC EC2
7. Add IPsec tunnel config and secrets
8. Bring up tunnel and test private IP connectivity

---

## 🧪 Connectivity Test

```bash
# From DC EC2
ping 10.0.2.x

# From AWS EC2 (if return path allowed)
ping 11.0.2.x
