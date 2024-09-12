# Most Basic Penetration Testing Lab (MBPTL)
Most Basic Penetration Testing Lab (MBPTL) is straight-forward hacking lab machine which designed for new comer who want to learn cyber security especially in Penetration Testing field. This is a self-deployed lab that runs inside Docker and is very easy to setup.

This lab is designed to be very straight-forward to introduce what steps can be taken during penetration testing and the tools related to these steps.

## Table of Contents
- [What you will learn here?](#what-you-will-learn-here)
- [Install Requirements](#install-requirements)
  - [Linux](#linux)
  - [Windows](#windows)
  - [MacOS](#macos)
- [Deploy the Machine](#deploy-the-machine)
- [Wrute Up](#write-up)
- [After finish this Lab?](#after-finish-this-lab)
  - [Recommended Tools](#recommended-tools)
- [License](#license)
- [Contact](#contact)

## What will you learn from this lab?
In this lab you will learn some basic penetration testing like:
- Reconnaissance
- Vulnerability Analysis
- Exploiting Vulnerable Apps
- Cracking Password
- Post Exploitation

## Install Requirements
### Linux
#### Installing Docker
```
curl -s https://get.docker.com/ | sudo sh -
```

#### Installing GIT
```
sudo apt install git
```

### Windows
#### Installing Docker
1. Download Docker Desktop for Windows from [Docker's official site](https://www.docker.com/products/docker-desktop/).
2. Run the installer and follow the installation steps.
3. After installation, ensure Docker Desktop is running.

#### Installing GIT
1. Download Git for Windows from [Git's official site](https://git-scm.com/download/win).
2. Run the installer and follow the installation steps.
3. Use Git Bash, which comes with the Git installation, for command-line operations.

### MacOS
#### Installing Docker
1. Download Docker Desktop for Mac from [Docker's official site](https://www.docker.com/products/docker-desktop/).
2. Open the downloaded `.dmg` file and drag Docker to your Applications folder.
3. Start Docker from the Applications folder.

#### Installing GIT
1. Open Terminal.
2. Install Git using Homebrew (if you have it installed) by running:
    ```bash
    brew install git
    ```
   If Homebrew is not installed, download Git directly from [Git's official site](https://git-scm.com/download/mac) and follow the installation instructions.


## Deploy the Machine
### Clone the Repository
```
git clone https://github.com/bayufedra/MBPTL
```

### Deploy
```
cd MBPTL/mbptl/
docker compose up -d
```

## Write Up
You can read the [Write Up](WRITEUP.md) for the solutions of this lab

## After finish this Lab?
Remember that this lab is for the first step to learn Penetration Testing to give you an image about what we doing in penetration testing and after finish this lab, you can continue to learn with another lab like:

### Learn Fundamental
- **Operating System**: All services on a computer run on top of an operating system. Understanding the operating system means knowing how processes, files, and access rights are managed, as well as identifying security vulnerabilities that can be exploited by attackers, such as privilege escalation, rootkits, or malware. Mastery of operating systems like Linux and Windows is essential in cybersecurity.
- **Networking**: All data from a computer is transferred through networks, whether local or public. Understanding networking fundamentals allows us to identify potential vulnerabilities like sniffing, man-in-the-middle (MitM) attacks, DDoS, or port scanning. This knowledge is crucial for protecting networks and ensuring that data is not intercepted or compromised.
- **Programming**: All computer services are built using programming languages. Understanding programming helps us find vulnerabilities or bugs in the code, such as SQL injection, buffer overflow, or cross-site scripting (XSS). With programming skills, we can also create automation scripts, such as auto-exploit scripts, as well as tools for penetration testing and security auditing.
- **Cryptography**: Cryptography is used to protect sensitive data. Understanding the basics of encryption, hashing, and other cryptographic methods allows us to identify weaknesses in encryption implementations, such as weak algorithms, poor key management, or attacks on encryption systems like brute-force and side-channel attacks.
- **CWE (Common Weakness Enumeration)**: CWE is a list of common software weaknesses. Understanding CWE helps us identify patterns of weaknesses in the code, such as poor input validation, memory management errors, or configuration mistakes that attackers frequently exploit. By understanding CWE, we can prevent weaknesses from appearing in software development and fix existing weaknesses.
- **CVE (Common Vulnerabilities and Exposures)**: CVE is a list of publicly known vulnerabilities and exposures found in software or systems. Each CVE represents a vulnerability that can be exploited by attackers if left unpatched. Understanding and staying updated with CVE helps us stay informed about the latest threats and apply necessary patches or mitigations to prevent attacks.

### Mastering Cyber Security Tools
#### Application Security
- **[Burp Suite](https://portswigger.net/burp)**: A comprehensive tool for application security testing.
- **[OWASP ZAP](https://www.zaproxy.org/)**: An open-source tool for finding vulnerabilities in web applications.
- **[Nikto](https://cirt.net/Nikto2)**: A web server scanner that checks for outdated versions, dangerous files, and server misconfigurations.
- **[Sqlmap](https://sqlmap.org/)**: A tool that automates the process of detecting and exploiting SQL injection flaws.
- **[Semgrep](https://semgrep.dev/)**: A static analysis tool that helps you find and fix security issues in your code by searching code patterns.
- **[Trivy](https://github.com/aquasecurity/trivy)**: A simple and comprehensive vulnerability scanner for software component also for containers.

#### Network Scanning, Enumeration and Security
- **[Nmap](https://nmap.org/)**: A network scanning tool to discover hosts and services on a computer network.
- **[Angry IP Scanner](https://angryip.org/)**: A fast and easy-to-use network scanner.
- **[Netcat](https://nc110.sourceforge.io/)**: A networking utility for debugging and investigating the network, can also be used for port scanning and banner grabbing.
- **[Aircrack-ng](https://www.aircrack-ng.org/)**: A set of tools for auditing wireless networks by capturing packets and cracking WiFi passwords.

#### Exploitation Frameworks
- **[Metasploit](https://www.metasploit.com/)**: A framework for developing, testing, and executing exploits against a remote target machine.
- **[Empire](https://github.com/EmpireProject/Empire)**: A post-exploitation framework that focuses on powershell and python agents.

#### Password Cracking
- **[John the Ripper](https://www.openwall.com/john/)**: A fast password cracker, currently available for many flavors of Unix, Windows, DOS, and OpenVMS.
- **[Hashcat](https://hashcat.net/hashcat/)**: The world's fastest and most advanced password recovery tool.

#### Vulnerability Scanning
- **[Nessus](https://www.tenable.com/products/nessus)**: One of the most popular tools for vulnerability assessment, used to identify and fix security vulnerabilities.
- **[OpenVAS](https://www.openvas.org/)**: An open-source vulnerability scanner.

#### OSINT (Open Source Intelligence)
- **[Maltego](https://www.maltego.com/)**: A powerful tool for link analysis and data mining in OSINT investigations.
- **[theHarvester](https://github.com/laramies/theHarvester)**: A tool for gathering email addresses, subdomains, and other information from search engines.


### More Hands-on Practice

| Lab Name | Description |
|----------|-------------|
| [DVWA](https://github.com/digininja/DVWA) | Here you will learn more about basic application vulnerabilities. |
| [BWAPP](http://www.itsecgames.com/) | BWAPP (Bee-box Web Application Penetration Project) offers more vulnerabilities compared to DVWA, making it ideal for advanced learning. |
| [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) | A modern, intentionally vulnerable web application for security training. Juice Shop covers a wide range of vulnerabilities and is a great tool for learning about web security. |
| [WebGoat](https://owasp.org/www-project-webgoat/) | A deliberately insecure application created by OWASP, allowing developers to learn about security vulnerabilities in web applications. |
| [Metasploitable2](https://sourceforge.net/projects/metasploitable/) | An intentionally vulnerable Linux virtual machine, which is great for learning about network and system-level vulnerabilities. |
| [Hack The Box](https://www.hackthebox.com/) | A platform where you can practice on various machines remotely, without needing to set up a local environment. Access is provided through a VPN. |
| [Try Hack Me](https://tryhackme.com/) | Similar to Hack The Box, Try Hack Me offers a variety of learning paths and challenges, with guided labs and more accessible content for beginners. |
| [VulnHub](https://www.vulnhub.com/) | A collection of vulnerable virtual machines, designed for practicing penetration testing in a controlled environment. |
| [OverTheWire](https://overthewire.org/wargames/) | A series of wargames that help you learn and practice security concepts in a fun and challenging way. |


## License

This repository is licensed under the GPL-3.0 license. See the [LICENSE](LICENSE) file for more information.

## Contact

For any inquiries or to connect with me, feel free to reach out on social media:

- **LinkedIn**: [Bayu Fedra](https://www.linkedin.com/in/bayufedra)
- **Instagram**: [@bayufedraa](https://www.instagram.com/bayufedraa)
- **Twitter/X**: [@bayufedraa](https://x.com/bayufedraa)

You can also [email me](mailto:bayufedra@gmail.com) for further questions.
