# MBPTL Installation Guide

## Overview

MBPTL (Most Basic Penetration Testing Lab) is a beginner-friendly cybersecurity learning environment designed to teach fundamental penetration testing concepts through hands-on practice.

## Prerequisites

**System Requirements:**
- **OS**: Linux, macOS, or Windows
- **RAM**: 2GB minimum
- **Storage**: 1GB free space
- **Network**: Internet connection for Docker images

**Required Software:**
- **Docker**: Version 20.10+ with Docker Compose
- **Git**: For cloning the repository

## Quick Installation

### Option 1: Automated Setup (Recommended)
```bash
git clone https://github.com/bayufedra/MBPTL
cd MBPTL
chmod +x setup.sh
./setup.sh
```

### Option 2: Manual Setup
```bash
# Clone and start
git clone https://github.com/bayufedra/MBPTL
cd MBPTL/mbptl/
docker compose up -d

# Verify installation
docker ps
```

## Platform-Specific Installation

### Linux
```bash
# Ubuntu/Debian
curl -s https://get.docker.com/ | sudo sh
sudo usermod -aG docker $USER

# CentOS/RHEL/Fedora
sudo yum install -y docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

### macOS
```bash
# Using Homebrew
brew install --cask docker
brew install git

# Or download from Docker's website
```

### Windows
1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Download [Git for Windows](https://git-scm.com/download/win)
3. Use Git Bash for command-line operations

## Verification

**Check if everything is running:**
```bash
docker ps
```

**You should see 3 containers:**
- `mbptl-main` (main web application)
- `mbptl-internal` (binary service)
- `mbptl-app` (internal web app)

**Test access:**
- Main App: http://localhost:80
- Admin Panel: http://localhost:8080/administrator/

## Troubleshooting

**Lab won't start:**
```bash
docker ps -a
docker compose down
docker compose up -d
```

**Port conflicts:**
- Stop conflicting services or change ports in `.env` file

**Permission issues (Linux/macOS):**
```bash
sudo usermod -aG docker $USER
# Log out and back in
```

**Need help?** Check the [Write-up Guide](writeup/README.md) for detailed solutions.

## Lab Management

**Start the lab:**
```bash
cd mbptl/
docker compose up -d
```

**Stop the lab:**
```bash
cd mbptl/
docker compose down
```

**View logs:**
```bash
docker compose logs
docker logs mbptl-main
```

**Reset the lab:**
```bash
cd mbptl/
docker compose down -v
docker compose up -d
```

## Next Steps

1. **Start Learning**: Access http://localhost:80
2. **Follow the Guide**: Read the [Write-up](writeup/README.md) for step-by-step solutions
3. **Collect Flags**: Complete all 17 flags to master penetration testing
4. **Practice**: Experiment with different tools and techniques

---

**Happy Learning!**

*This lab is designed for educational purposes. All vulnerabilities are intentional and part of the learning experience.*
