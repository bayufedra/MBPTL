# MOST BASIC PENETRATION TESTING LAB - CHANGELOG

All notable changes to the Most Basic Penetration Testing Lab (MBPTL) will be documented in this file.

## [2.1.0] - 2025-10-20

### Added
- **Direct Binary Download**: Download button for MBPTL-Internal service binaries
- **Enhanced Learning Path**: SOC team perspective challenges
- **Automated Setup**: Setup script with dependency checking
- **Beginner Guidance**: Disclaimer and WriteUP.md recommendations
- **New Flag System**: Individual flags for each step (17 total flags)

### Changed
- **Performance Optimization**: Reduced Docker image size from 1GB+ to 700MB
- **Password Enhancement**: Administrator password now in rockyou.txt wordlist
- **Buffer Overflow Challenge**: Simplified binary exploitation (removed ROP requirement)
- **Documentation**: Enhanced README.md with installation guides for Linux, Windows, and macOS

## [2.0.0] - 2025-07-10

### Changed
- **Container Consolidation**: Migrated from multi-container to single Docker image
  - Web services (ports 80, 8080) and database (port 3306) unified
- **Enhanced Learning Path**: Added reverse engineering, binary exploitation, and modern web security topics
- **Network Pivoting**: Added containers accessible via network pivoting (ports 31337, 5000)

### Added
- **Docker Hub Integration**: Pre-built images available on Docker Hub
- **Advanced Exploitation**: Buffer overflow and reverse engineering challenges
- **Network Segmentation**: Network topology simulation
- **Documentation**: Detailed write-ups and learning materials

## [1.0.0] - 2024-01-17

### Added
- Initial release of MBPTL
- Basic documentation and setup instructions
- Step-by-step learning materials for beginners
