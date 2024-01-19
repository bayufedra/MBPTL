Write Up Most Basic Penetration Testing Labs (MBPTL)
==============
***Self-deployed Straight-forward hacking lab machine which designed for new comer who want to learn Penetration Testing field that running inside Docker for easy setup.***

**Repository:** *https://github.com/bayufedra/MBPTL/*

**Author:** *Fedra Bayu*

> In this case, target IP is 103.31.33.37

# Reconnaissance
### Port Scanning
There are various tools for conduct port scanning, but the most commonly used currently is nmap because of it's accuracy of the results. as an alternative there is masscan, rustscan and others.

#### Install Nmap
```
sudo apt install nmap
```

#### Basic scan
```
nmap 103.31.33.37
```

#### Result
```
attacker@MBPTL:~$ nmap 103.31.33.37
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-01 00:00 WIB
Nmap scan report for ip-37-33-31-103.xxx-1337.mbptl.io (103.31.33.37)
Host is up (0.00073s latency).
Not shown: 997 filtered ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
8080/tcp open  http-proxy

Nmap done: 1 IP address (1 host up) scanned in 4.76 seconds
```
We find two HTTP Ports open in port 80 and 8080

### Information Gathering


### Directory Scanning

# Vulnerability Analysis

# Exploitation
### 
### Cracking Password
### Gaining Access

# Post-Exploitation
### Reverse Shell
### Privilege Escalation
