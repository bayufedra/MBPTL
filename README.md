# Most Basic Penetration Testing Lab (MBPTL)

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL%203.0-green.svg)](https://opensource.org/licenses/GPL-3.0)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Black Hat Arsenal EU 2025](https://img.shields.io/badge/Black%20Hat%20Arsenal-EU%202025-red.svg)](https://www.blackhat.com/eu-25/arsenal/schedule/#mbptl---most-basic-penetration-testing-lab-48622)

> **🎯 Perfect for beginners!** A comprehensive, hands-on penetration testing lab designed to teach cybersecurity fundamentals through practical exercises.

**Getting started?** Follow the [**Task Guide**](TASK.md) to understand how to collect all 17 flags. **Need detailed solutions?** Check out the [**Write-up Guide**](writeup/README.md) for step-by-step instructions. Don't worry if you don't understand everything at first because this lab is designed to introduce fundamental tools, concepts, and workflows commonly used in cybersecurity and penetration testing. The goal is to help you become familiar with the topics and tools involved, even if you're still learning.

## 📖 Table of Contents

- [Quick Start](#-quick-start)
- [Task Guide](#-task-guide)
- [What You'll Learn](#-what-youll-learn)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Lab Architecture](#-lab-architecture)
- [Troubleshooting](#-troubleshooting)
- [Next Steps](#-next-steps)
- [Contributing](#-contributing)
- [Contact](#-contact)

## 🚀 Quick Start

```bash
# Clone and start the lab in 3 commands
git clone https://github.com/bayufedra/MBPTL
cd MBPTL/mbptl/
docker compose up -d
```

**Access your lab:**  http://localhost:80

## 📋 Task Guide

**📖 Read [TASK.md](TASK.md) to understand the complete flag collection process!**

The task guide provides an overview of all 17 flags organized by penetration testing phases, helping you understand what to look for as you progress through the lab. Use it alongside your reconnaissance and exploitation efforts.

## 📚 What You'll Learn

This lab covers **complete penetration testing methodology** with **17 hands-on flags**. Complete the lab in this order:

1. **🔍 Reconnaissance** → Information gathering and target enumeration
2. **🎯 Vulnerability Assessment** → Identifying security weaknesses
3. **💥 Exploitation** → Exploiting vulnerable applications and services
4. **🔐 Password Cracking** → Breaking authentication mechanisms
5. **🔓 Post-Exploitation** → Maintaining access and privilege escalation
6. **🌐 Network Pivoting** → Moving between networks and accessing internal systems
7. **⚡ Binary Exploitation** → Exploiting memory corruption vulnerabilities in compiled programs
8. **🔬 Reverse Engineering** → Analyzing software to understand its functionality and identify vulnerabilities
9. **🛡️ SOC Analysis** → Log analysis and forensic techniques

## 📋 Prerequisites

**System Requirements:**
- **OS**: Linux, macOS, or Windows
- **RAM**: 2GB minimum
- **Storage**: 1GB free space
- **Network**: Internet connection for Docker images

**Required Software:**
- **Docker**: Version 20.10+ with Docker Compose
- **Git**: For cloning the repository

**Recommended Skills (Will be more helpful):**
- **Linux fundamentals**: Basic experience with command line operations for file management and system navigation
- **Networking basics**: Understanding of IP addressing, ports, and core network protocols
- **Web technologies**: Familiarity with HTTP requests/responses, web servers, and client–server architecture

## 🛠️ Installation

**Automated Setup (Recommended):**
```bash
git clone https://github.com/bayufedra/MBPTL
cd MBPTL
chmod +x setup.sh
./setup.sh
```

**For manual setup and detailed installation instructions, see [INSTALL.md](INSTALL.md)**

## 🏗️ Lab Architecture

The lab simulates a realistic network environment with **3 interconnected containers**:

### 🎯 **Main Container** (`mbptl-main`)
**Primary target with web applications**
- **Port 80**: Web application with SQL injection vulnerability
- **Port 8080**: Administrator panel with file upload vulnerability  
- **Port 3306**: Local MySQL database
- **Objective**: Initial compromise and privilege escalation

### 🔒 **Internal Container** (`mbptl-internal`)
**Internal service for binary exploitation**
- **Port 31337**: Custom binary service with buffer overflow vulnerability
- **Objective**: Binary exploitation and reverse engineering
- **Access**: Only accessible after compromising main container

### 🌐 **Web Internal Container** (`mbptl-app`)
**Internal web application for pivoting**
- **Port 5000**: Flask application with template injection vulnerability
- **Objective**: Advanced web application exploitation
- **Access**: Only accessible after compromising main container

## 🔧 Troubleshooting

### Common Issues

**Lab won't start:**
```bash
# Check container status
docker ps -a

# Restart the lab
cd mbptl/
docker compose down
docker compose up -d
```

**Port conflicts:**
- If ports 80, 8080, or 3306 are in use, modify the `.env` file or use different ports.

**Permission issues (Linux/macOS):**
```bash
sudo usermod -aG docker $USER
# Log out and back in
```

## 🎓 Next Steps

Completing MBPTL is just the beginning of your cybersecurity journey! To continue building your expertise, develop a strong foundation across these essential knowledge domains:

### 🎯 **Fundamental Knowledge Areas**

**Operating Systems**  
Learn how processes, files, and access rights are managed in Linux and Windows. This foundation helps you identify and exploit vulnerabilities like privilege escalation, rootkit installations, and malware persistence.

**Networking Fundamentals**  
Since all systems communicate over networks, understanding core protocols, routing, and network architectures enables you to detect and exploit risks such as packet sniffing, man-in-the-middle (MitM) attacks, DDoS, and unauthorized port scanning.

**Programming**  
Applications are built with code, and most security vulnerabilities stem from programming flaws. Understanding how code works allows you to identify and exploit issues like SQL injection, buffer overflow, and cross-site scripting (XSS).

**Cryptography**  
Master encryption, hashing, and cryptographic protocols to evaluate security implementations, identify weaknesses, and defend against attacks like brute-force, side-channel exploitation, and cryptographic failures.

**Threat Intelligence Frameworks**  
Familiarize yourself with **CWE (Common Weakness Enumeration)** to recognize common weakness patterns like poor input validation, memory management errors, and configuration mistakes. Stay current with **CVE (Common Vulnerabilities and Exposures)** to stay informed about the latest threats and necessary security patches.

### 🛠️ **Essential Tools to Learn**

- **Application Security**: [Burp Suite](https://portswigger.net/burp), [OWASP ZAP](https://www.zaproxy.org/), [Nikto](https://cirt.net/Nikto2), [Sqlmap](https://sqlmap.org/), [Semgrep](https://semgrep.dev/), [Trivy](https://github.com/aquasecurity/trivy)
- **Network Security**: [Nmap](https://nmap.org/), [Angry IP Scanner](https://angryip.org/), [Netcat](https://nc110.sourceforge.io/), [Aircrack-ng](https://www.aircrack-ng.org/)
- **Exploitation Frameworks**: [Metasploit](https://www.metasploit.com/), [Empire](https://github.com/EmpireProject/Empire)
- **Password Cracking**: [John the Ripper](https://www.openwall.com/john/), [Hashcat](https://hashcat.net/hashcat/)
- **Vulnerability Scanning**: [Nessus](https://www.tenable.com/products/nessus), [OpenVAS](https://www.openvas.org/)
- **OSINT**: [Maltego](https://www.maltego.com/), [theHarvester](https://github.com/laramies/theHarvester)

### 🏆 **Practice Platforms**
| Platform | Difficulty | Focus |
|----------|------------|-------|
| [DVWA](https://github.com/digininja/DVWA) | Beginner | Web vulnerabilities |
| [OverTheWire](https://overthewire.org/) | Beginner-Intermediate | Wargames |
| [TryHackMe](https://tryhackme.com/) | Beginner-Advanced | Guided learning |
| [VulnHub](https://www.vulnhub.com/) | All Levels | Vulnerable VMs |
| [HackTheBox](https://www.hackthebox.com/) | Intermediate-Expert | Real-world scenarios |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the GPL-3.0 license. See the [LICENSE](LICENSE) file for more information.

## 📞 Contact

**Author**: Bayu Fedra  
**Email**: [bayufedra@gmail.com](mailto:bayufedra@gmail.com)  
**LinkedIn**: [Bayu Fedra](https://www.linkedin.com/in/bayufedra)  
**Twitter**: [@bayufedraa](https://x.com/bayufedraa)

---

⭐ **If you find this lab helpful, please give it a star and recommend it to your friends!**
