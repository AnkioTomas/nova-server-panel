#!/bin/bash
echo "
 ______                                _                                             ______                        _ 
|  ___ \                              | |                                           (_____ \                      | |
| |   | |  ___   _   _   ____  ___     \ \    ____   ____  _   _   ____   ____  ___  _____) )  ____  ____    ____ | |
| |   | | / _ \ | | | | / _  |(___)     \ \  / _  ) / ___)| | | | / _  ) / ___)(___)|  ____/  / _  ||  _ \  / _  )| |
| |   | || |_| | \ V / ( ( | |      _____) )( (/ / | |     \ V / ( (/ / | |         | |      ( ( | || | | |( (/ / | |
|_|   |_| \___/   \_/   \_||_|     (______/  \____)|_|      \_/   \____)|_|         |_|       \_||_||_| |_| \____)|_|
                                                                                                                     
"
PANEL_TITLE="Nova-Server-Panel"
VERSION="1.0.0"
DOWNLOAD="http://192.168.21.1:9008/server_1.1.0.zip"
# Function for colored output
info() {
    echo -e "\033[37m[${PANEL_TITLE}] $*\033[0m"
}

warning() {
    echo -e "\033[33m[${PANEL_TITLE}] $*\033[0m"
}

success() {
    echo -e "\033[34m[${PANEL_TITLE}] $*\033[0m"
}


error() {
    echo -e "\033[31m[${PANEL_TITLE}] $*\033[0m"
}

abort() {
    echo -e "\033[31m[${PANEL_TITLE}] $*\033[0m"
    exit 1
}

is_running_in_docker() {
    if [ -f /.dockerenv ]; then
        return 0
    elif grep -qE "/docker|/lxc" /proc/1/cgroup 2>/dev/null; then
        return 0
    elif grep -qE "/docker|/lxc" /proc/self/cgroup 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if user is root
check_root() {
    if [ "$(id -u)" != "0" ]; then
        echo_red "Error: This script must be run as root"
        exit 1
    fi
}

# Function to check if Docker is installed, install if not
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo_yellow "Docker not found. Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        echo_green "Docker installed successfully."
    else
        echo_green "Docker is already installed."
    fi
}

# Function to check if Docker-compose is installed, install if not
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        echo_yellow "Docker-compose not found. Installing Docker-compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/latest/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo_green "Docker-compose installed successfully."
    else
        echo_green "Docker-compose is already installed."
    fi
}

# Function to check if Docker service is running, start if not
check_docker_service() {
    if ! sudo systemctl is-active --quiet docker; then
        echo_yellow "Docker service is not running. Starting Docker service..."
        if ! sudo systemctl start docker; then
            echo_red "Failed to start Docker service. Exiting."
            exit 1
        fi
        echo_green "Docker service started successfully."
    else
        echo_green "Docker service is already running."
    fi
}

# Function to install 苍穹守护


# Main script execution
echo_green "Starting setup..."

# Check if user is root
check_root

# Check and install Docker and Docker-compose
check_docker
check_docker_compose

# Check Docker service status and start if necessary
check_docker_service

echo_green "Setup complete."
