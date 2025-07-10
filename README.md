# Most Basic Penetration Testing Lab (MBPTL)

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL%203.0-green.svg)](https://opensource.org/licenses/GPL-3.0)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)

A straightforward penetration testing lab designed for newcomers who want to learn cybersecurity, especially in the penetration testing field. This is a self-deployed lab that runs inside Docker and is very easy to set up.

This lab is designed to be very straightforward to introduce what steps can be taken during penetration testing and the tools related to these steps.

## 📖 Table of Contents

- [Installation Requirements](#installation-requirements)
  - [Linux](#linux)
  - [Windows](#windows)
  - [macOS](#macos)
- [Deployment](#deployment)
- [Lab Structure](#lab-structure)
- [Environment Variables](#environment-variables)
- [Write-up](#write-up)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)
  - [Fundamental Knowledge](#fundamental-knowledge)
  - [Recommended Tools](#recommended-tools)
  - [Practice Labs](#practice-labs)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## 🎯 What You'll Learn

In this lab, you will learn fundamental penetration testing concepts:

- **Reconnaissance** - Information gathering and target enumeration
- **Vulnerability Analysis** - Identifying security weaknesses
- **Exploitation** - Exploiting vulnerable applications
- **Password Cracking** - Breaking authentication mechanisms
- **Post Exploitation** - Maintaining access and privilege escalation
- **Pivoting** - Moving between networks and accessing internal systems

## 📋 Prerequisites

Before starting this lab, you should have:

- Basic understanding of Linux command line
- Familiarity with networking concepts
- Knowledge of web technologies (PHP, SQL)

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/bayufedra/MBPTL

# Navigate to the lab directory
cd MBPTL/mbptl/

# Deploy the lab (Docker will automatically pull images from Docker Hub)
docker compose up -d
```

**Note:** The lab now uses pre-built Docker images from Docker Hub for easier setup. Docker will automatically pull the required images:
- `bayufedra/mbptl-main:latest`
- `bayufedra/mbptl-internal:latest`

## 💻 Installation Requirements

### Linux

#### Installing Docker
```bash
curl -s https://get.docker.com/ | sudo sh -
```

#### Installing Git
```bash
sudo apt install git
```

### Windows

#### Installing Docker
1. Download Docker Desktop for Windows from [Docker's official site](https://www.docker.com/products/docker-desktop/).
2. Run the installer and follow the installation steps.
3. After installation, ensure Docker Desktop is running.

#### Installing Git
1. Download Git for Windows from [Git's official site](https://git-scm.com/download/win).
2. Run the installer and follow the installation steps.
3. Use Git Bash, which comes with the Git installation, for command-line operations.

### macOS

#### Installing Docker
1. Download Docker Desktop for Mac from [Docker's official site](https://www.docker.com/products/docker-desktop/).
2. Open the downloaded `.dmg` file and drag Docker to your Applications folder.
3. Start Docker from the Applications folder.

#### Installing Git
1. Open Terminal.
2. Install Git using Homebrew (if you have it installed) by running:
    ```bash
    brew install git
    ```
   If Homebrew is not installed, download Git directly from [Git's official site](https://git-scm.com/download/mac) and follow the installation instructions.

## 🏗️ Deployment

### Step 1: Clone the Repository
```bash
git clone https://github.com/bayufedra/MBPTL
```

### Step 2: Deploy the Lab
```bash
cd MBPTL/mbptl/
docker compose up -d
```

Docker will automatically pull the required images from Docker Hub:
- `bayufedra/mbptl-main:latest`
- `bayufedra/mbptl-internal:latest`

### Step 3: Verify Deployment
Once deployed, you should be able to access:
- Main application: `http://{MACHINE_IP:-127.0.0.1}:80`
- Administrator panel: `http://{MACHINE_IP:-127.0.0.1}:8080/administrator/`
- Internal service: `http://127.0.0.1:1337/` (accessible after pivoting)

## 🏛️ Lab Structure

The lab consists of two containers that simulate a real-world network environment:

### Main Container (`mbptl-main`)
- **Purpose**: Primary target with web applications
- **Services**: 
  - Web application with SQL injection vulnerability (Port 80)
  - Administrator panel with file upload vulnerability (Port 8080)
  - MySQL database (Port 3306)
- **Objective**: Initial compromise and privilege escalation

### Internal Container (`mbptl-internal`)
- **Purpose**: Secondary target in internal network
- **Services**: 
  - Flask web application with template injection vulnerability (Port 1337)
- **Objective**: Pivoting target after compromising the main container
- **Access**: Only accessible from within the main container's network

### Learning Path
1. **Reconnaissance** → Discover open ports and services
2. **Vulnerability Analysis** → Identify SQL injection in main application
3. **Exploitation** → Extract credentials and gain initial access
4. **Post Exploitation** → Upload shell and escalate privileges
5. **Pivoting** → Access internal network and compromise secondary target

## ⚙️ Environment Variables

### Database Configuration
- `MYSQL_ROOT_PASSWORD`: Root password for MySQL database
- `MYSQL_DATABASE`: Database name
- `MYSQL_USER`: Database user
- `MYSQL_PASSWORD`: Database user password

### Port Configuration
- `WEB1_PORT`: Port for web interface (default: 80)
- `WEB2_PORT`: Port for API (default: 8080)
- `DB_PORT`: Port for database (default: 3306)
- `WEB_INTERNAL_PORT`: Port for internal service (default: 1337)

## 📝 Write-up

You can read the [Write-up](writeup/README.md) for detailed solutions and walkthroughs of this lab.

## 🔧 Troubleshooting

### Common Issues

**Docker containers not starting:**
```bash
# Check Docker status
docker ps -a

# Restart containers
docker compose down
docker compose up -d
```

**Docker images not pulling:**
```bash
# Manually pull the images
docker pull bayufedra/mbptl-main:latest
docker pull bayufedra/mbptl-internal:latest

# Then start the services
docker compose up -d
```

**Port conflicts:**
- If ports 80 or 8080 are already in use, modify the `docker-compose.yml` file to use different ports.

**Permission issues:**
```bash
# On Linux/macOS, ensure your user is in the docker group
sudo usermod -aG docker $USER
```

## 🎓 Next Steps

Remember that this lab is the first step in learning penetration testing. It gives you an overview of what we do in penetration testing. After completing this lab, you can continue learning with other resources:

### Fundamental Knowledge

- **Operating Systems**: Understanding how processes, files, and access rights are managed is essential. Mastery of Linux and Windows helps identify vulnerabilities like privilege escalation, rootkits, or malware.

- **Networking**: All data transfers through networks. Understanding networking fundamentals helps identify vulnerabilities like sniffing, man-in-the-middle (MitM) attacks, DDoS, or port scanning.

- **Programming**: All computer services are built using programming languages. Understanding programming helps find vulnerabilities like SQL injection, buffer overflow, or cross-site scripting (XSS).

- **Cryptography**: Understanding encryption, hashing, and cryptographic methods helps identify weaknesses in encryption implementations and prevent attacks like brute-force and side-channel attacks.

- **CWE (Common Weakness Enumeration)**: A list of common software weaknesses that helps identify patterns like poor input validation, memory management errors, or configuration mistakes.

- **CVE (Common Vulnerabilities and Exposures)**: A list of publicly known vulnerabilities that helps stay informed about the latest threats and apply necessary patches.

### Recommended Tools

#### Application Security
- **[Burp Suite](https://portswigger.net/burp)**: Comprehensive application security testing
- **[OWASP ZAP](https://www.zaproxy.org/)**: Open-source web application vulnerability scanner
- **[Nikto](https://cirt.net/Nikto2)**: Web server scanner for outdated versions and misconfigurations
- **[Sqlmap](https://sqlmap.org/)**: Automated SQL injection detection and exploitation
- **[Semgrep](https://semgrep.dev/)**: Static analysis tool for finding security issues in code
- **[Trivy](https://github.com/aquasecurity/trivy)**: Vulnerability scanner for software components and containers

#### Network Security
- **[Nmap](https://nmap.org/)**: Network scanning and host discovery
- **[Angry IP Scanner](https://angryip.org/)**: Fast and easy-to-use network scanner
- **[Netcat](https://nc110.sourceforge.io/)**: Networking utility for debugging and port scanning
- **[Aircrack-ng](https://www.aircrack-ng.org/)**: Wireless network auditing tools

#### Exploitation Frameworks
- **[Metasploit](https://www.metasploit.com/)**: Framework for developing and executing exploits
- **[Empire](https://github.com/EmpireProject/Empire)**: Post-exploitation framework with PowerShell and Python agents

#### Password Cracking
- **[John the Ripper](https://www.openwall.com/john/)**: Fast password cracker for multiple platforms
- **[Hashcat](https://hashcat.net/hashcat/)**: Advanced password recovery tool

#### Vulnerability Scanning
- **[Nessus](https://www.tenable.com/products/nessus)**: Popular vulnerability assessment tool
- **[OpenVAS](https://www.openvas.org/)**: Open-source vulnerability scanner

#### OSINT (Open Source Intelligence)
- **[Maltego](https://www.maltego.com/)**: Link analysis and data mining tool
- **[theHarvester](https://github.com/laramies/theHarvester)**: Email and subdomain gathering tool

### Practice Labs

| Lab Name | Description | Difficulty |
|----------|-------------|------------|
| [DVWA](https://github.com/digininja/DVWA) | Basic application vulnerabilities | Beginner |
| [BWAPP](http://www.itsecgames.com/) | Advanced web application vulnerabilities | Intermediate |
| [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) | Modern vulnerable web application | Beginner-Intermediate |
| [WebGoat](https://owasp.org/www-project-webgoat/) | Deliberately insecure OWASP application | Beginner |
| [Metasploitable2](https://sourceforge.net/projects/metasploitable/) | Vulnerable Linux VM for system-level testing | Intermediate |
| [Hack The Box](https://www.hackthebox.com/) | Remote penetration testing platform | All Levels |
| [Try Hack Me](https://tryhackme.com/) | Guided learning paths and challenges | All Levels |
| [VulnHub](https://www.vulnhub.com/) | Collection of vulnerable VMs | All Levels |
| [OverTheWire](https://overthewire.org/wargames/) | Security concept wargames | All Levels |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This repository is licensed under the GPL-3.0 license. See the [LICENSE](LICENSE) file for more information.

## 📞 Contact

For any inquiries or to connect with me, feel free to reach out:

- **LinkedIn**: [Bayu Fedra](https://www.linkedin.com/in/bayufedra)
- **Instagram**: [@bayufedraa](https://www.instagram.com/bayufedraa)
- **Twitter/X**: [@bayufedraa](https://x.com/bayufedraa)
- **Email**: [bayufedra@gmail.com](mailto:bayufedra@gmail.com)

---

⭐ **If you find this lab helpful, reccomend it to your friends!**
