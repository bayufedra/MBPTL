#!/bin/bash

# MBPTL (Most Basic Penetration Testing Lab) - Automated Setup Script
# This script automates the entire setup process for the penetration testing lab

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if Docker is running
docker_running() {
    docker info >/dev/null 2>&1
}

# Function to install dependencies based on OS
install_dependencies() {
    local os=$(uname -s)
    
    print_status "Detected OS: $os"
    
    case $os in
        "Linux")
            print_status "Installing dependencies on Linux..."
            
            # Check if running as root
            if [[ $EUID -eq 0 ]]; then
                print_warning "Running as root. This is not recommended for security reasons."
            fi
            
            # Update package list
            print_status "Updating package list..."
            if command_exists apt-get; then
                sudo apt-get update
                sudo apt-get install -y git
                curl -s https://get.docker.com/ | sudo sh -
            elif command_exists yum; then
                sudo yum update -y
                sudo yum install -y git docker docker-compose
            elif command_exists dnf; then
                sudo dnf update -y
                sudo dnf install -y git docker docker-compose
            elif command_exists pacman; then
                sudo pacman -Syu --noconfirm git docker docker-compose
            else
                print_error "Unsupported package manager. Please install git, docker, and docker-compose manually."
                exit 1
            fi
            
            # Start and enable Docker service
            sudo systemctl start docker
            sudo systemctl enable docker
            
            # Add user to docker group
            sudo usermod -aG docker $USER
            print_warning "You may need to log out and log back in for Docker group changes to take effect."
            ;;
            
        "Darwin")
            print_status "Installing dependencies on macOS..."
            
            if command_exists brew; then
                print_status "Using Homebrew to install dependencies..."
                brew install git docker docker-compose
            else
                print_error "Homebrew not found. Please install Homebrew first:"
                print_error "Visit: https://brew.sh/"
                print_error "Then run: brew install git docker docker-compose"
                exit 1
            fi
            ;;
            
        "MINGW"*|"CYGWIN"*|"MSYS"*)
            print_status "Windows detected. Please install the following manually:"
            print_error "1. Git for Windows: https://git-scm.com/download/win"
            print_error "2. Docker Desktop: https://www.docker.com/products/docker-desktop/"
            print_error "3. Make sure Docker Desktop is running before proceeding"
            exit 1
            ;;
            
        *)
            print_error "Unsupported operating system: $os"
            print_error "Please install git, docker, and docker-compose manually"
            exit 1
            ;;
    esac
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_deps=()
    
    # Check Git
    if command_exists git; then
        print_success "Git is installed: $(git --version)"
    else
        print_error "Git is not installed"
        missing_deps+=("git")
    fi
    
    # Check Docker
    if command_exists docker; then
        print_success "Docker is installed: $(docker --version)"
        
        # Check if Docker is running
        if docker_running; then
            print_success "Docker is running"
        else
            print_error "Docker is installed but not running"
            print_status "Please start Docker and try again"
            exit 1
        fi
    else
        print_error "Docker is not installed"
        missing_deps+=("docker")
    fi
    
    # Check Docker Compose
    if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
        if command_exists docker-compose; then
            print_success "Docker Compose is installed: $(docker-compose --version)"
        else
            print_success "Docker Compose (plugin) is available: $(docker compose version)"
        fi
    else
        print_error "Docker Compose is not installed"
        missing_deps+=("docker-compose")
    fi
    
    # Handle missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_status "Would you like to install missing dependencies? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            install_dependencies
            print_status "Please run this script again after installation completes"
            exit 0
        else
            print_error "Cannot proceed without required dependencies"
            exit 1
        fi
    fi
}

# Function to check if ports are available
check_ports() {
    print_status "Checking if required ports are available..."
    
    # Read ports from .env file
    local ports=()
    if [ -f mbptl/.env ]; then
        # Extract port values from .env file
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ $key =~ ^[[:space:]]*# ]] && continue
            [[ -z $key ]] && continue
            
            # Check if this is a port configuration
            if [[ $key =~ ^[[:space:]]*(WEB[12]_PORT|DB_PORT|SERVICE_INTERNAL_PORT|WEB_INTERNAL_PORT)[[:space:]]*$ ]]; then
                # Remove any whitespace and quotes from value
                value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/^"//;s/"$//')
                if [[ $value =~ ^[0-9]+$ ]]; then
                    ports+=($value)
                fi
            fi
        done < mbptl/.env
    fi
    
    # If no ports found in .env, use defaults
    if [ ${#ports[@]} -eq 0 ]; then
        ports=(80 8080 3306 31337 5000)
        print_warning "No port configuration found in .env, using default ports"
    fi
    
    local occupied_ports=()
    
    for port in "${ports[@]}"; do
        if lsof -i :$port >/dev/null 2>&1; then
            occupied_ports+=($port)
        fi
    done
    
    if [ ${#occupied_ports[@]} -gt 0 ]; then
        print_warning "The following ports are already in use: ${occupied_ports[*]}"
        print_warning "This may cause conflicts with the lab. Consider stopping services using these ports."
        print_status "Do you want to continue anyway? (y/n)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_error "Aborting due to port conflicts"
            exit 1
        fi
    else
        print_success "All required ports are available"
    fi
}

# Function to check .env file exists
check_env_file() {
    if [ -f mbptl/.env ]; then
        print_success ".env file found"
    else
        print_error ".env file not found"
        print_status "Please create a .env file with the required configuration"
        print_status "You can copy from the example in the documentation"
        exit 1
    fi
}

# Function to stop existing containers
stop_existing_containers() {
    print_status "Stopping any existing lab containers..."
    
    # Change to mbptl directory
    cd mbptl
    
    # Use docker-compose if available, otherwise use docker compose
    if command_exists docker-compose; then
        docker-compose down -v 2>/dev/null || true
    else
        docker compose down -v 2>/dev/null || true
    fi
    
    # Return to parent directory
    cd ..
    
    print_success "Existing containers stopped"
}

# Function to start the lab
start_lab() {
    print_status "Starting the penetration testing lab..."
    
    # Change to mbptl directory
    cd mbptl
    
    # Use docker-compose if available, otherwise use docker compose
    if command_exists docker-compose; then
        docker-compose up -d
    else
        docker compose up -d
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Lab started successfully!"
    else
        print_error "Failed to start the lab"
        exit 1
    fi
    
    # Return to parent directory
    cd ..
}

# Function to verify lab is running
verify_lab() {
    print_status "Verifying lab is running correctly..."
    
    # Wait a moment for containers to fully start
    sleep 10
    
    # Check if containers are running
    local containers=("mbptl-main" "mbptl-internal" "mbptl-app")
    local running_containers=0
    
    for container in "${containers[@]}"; do
        if docker ps --format "table {{.Names}}" | grep -q "^$container$"; then
            print_success "Container $container is running"
            ((running_containers++))
        else
            print_error "Container $container is not running"
        fi
    done
    
    if [ $running_containers -eq ${#containers[@]} ]; then
        print_success "All containers are running successfully!"
    else
        print_error "Some containers failed to start"
        print_status "Check container logs with: docker logs <container_name>"
        exit 1
    fi
}

# Function to display lab information
display_lab_info() {
    print_success "🎉 MBPTL Lab is now running!"
    echo
    print_status "Lab Access Information:"
    echo "  📱 Main Application:     http://localhost:80"
    echo "  🔧 Administrator Panel:  http://localhost:8080/administrator/"
    echo "  🗄️ Database:             localhost:3306"
    echo "  🔒 Internal Service:     localhost:31337 (accessible after pivoting)"
    echo "  🌐 Web Internal Service: http://localhost:5000 (accessible after pivoting)"
    echo
    print_status "Default Credentials:"
    echo "  👤 Admin Username: admin"
    echo "  🔑 Admin Password: P@ssw0rd!"
    echo
    print_status "Useful Commands:"
    echo "  📊 View running containers: docker ps"
    echo "  📝 View container logs:     docker logs <container_name>"
    echo "  🛑 Stop the lab:           cd mbptl && docker compose down"
    echo "  🔄 Restart the lab:        cd mbptl && docker compose restart"
    echo
    print_status "📖 Read the write-up for detailed solutions: writeup/README.md"
    echo
    print_success "Happy hacking! 🚀"
}

# Main execution
main() {
    echo "=========================================="
    echo "  MBPTL - Automated Setup Script"
    echo "  Most Basic Penetration Testing Lab"
    echo "=========================================="
    echo
    
    # Check prerequisites
    check_prerequisites
    
    # Check port availability
    check_ports
    
    # Check .env file exists
    check_env_file
    
    # Stop existing containers
    stop_existing_containers
    
    # Start the lab
    start_lab
    
    # Verify lab is running
    verify_lab
    
    # Display lab information
    display_lab_info
}

# Run main function
main "$@"
