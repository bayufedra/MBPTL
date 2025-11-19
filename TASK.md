# MBPTL (Most Basic Penetration Testing Lab) - Flag Collection Guide

## Overview
This document outlines the complete process for discovering and collecting all **17 flags** across the MBPTL environment. The lab is designed to simulate real-world penetration testing scenarios and demonstrate various attack vectors and techniques.

## Flag Checklist

### **Phase 1: Reconnaissance (Flags 1-3)**
- **Flag 1**: Page source analysis (HTML comments)
- **Flag 2**: HTTP header analysis (`curl -I`)
- **Flag 3**: Alternative web service discovery (port 8080)

### **Phase 2: Web Enumeration (Flag 4)**
- **Flag 4**: Administrator panel discovery (`/administrator/`)

### **Phase 3: SQL Injection (Flags 5-7)**
- **Flag 5**: SQL injection vulnerability discovery (`details.php?id=1'`)
- **Flag 6**: Database flag extraction (SQLMap)
- **Flag 7**: Admin panel access (credentials)

### **Phase 4: Post-Exploitation (Flags 8-9)**
- **Flag 8**: User-level flag (`/flag/user.txt`)
- **Flag 9**: Root-level flag (`/flag/root.txt`)

### **Phase 5: SOC Analysis (Flags 10-12)**
- **Flag 10**: Web access log analysis (`/var/log/apache2/access.log`)
- **Flag 11**: Command history analysis (`/root/.bash_history`)
- **Flag 12**: Shell configuration analysis (`/root/.bashrc`)

### **Phase 6: Network Pivoting (Flags 13-14)**
- **Flag 13**: Internal application discovery (port 5000, reachable only from the compromised container)
- **Flag 14**: Server-Side Template Injection (SSTI)

### **Phase 7: Binary Exploitation (Flags 15-17)**
- **Flag 15**: Binary analysis and reverse engineering
- **Flag 16**: Internal service discovery (port 31337, reachable only from the compromised container)
- **Flag 17**: Buffer overflow exploitation


## Need Help?

For detailed step-by-step solutions, see the [Write-up Guide](writeup/README.md).
