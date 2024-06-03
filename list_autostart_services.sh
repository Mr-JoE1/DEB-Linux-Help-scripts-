#!/bin/bash

# Define colors for log output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Function to print colored log messages
log() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print script header
log $BLUE "*********************************************************"
log $BLUE "* Script to List All Auto-Start Services and Programs   *"
log $BLUE "* Usage: sudo ./list_autostart_services.sh              *"
log $BLUE "* Author: M@H3R                                         *"
log $BLUE "*********************************************************"

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    log $RED "This script must be run as root. Use sudo."
    exit 1
fi

log $BLUE "Starting the script to list all auto-start services and programs..."

# List all enabled systemd services
log $YELLOW "Listing all enabled systemd services..."
systemctl list-unit-files --type=service --state=enabled | tee /tmp/enabled_services.log
log $GREEN "Enabled systemd services listed and saved to /tmp/enabled_services.log"

# List all running systemd services
log $YELLOW "Listing all running systemd services..."
systemctl list-units --type=service --state=running | tee /tmp/running_services.log
log $GREEN "Running systemd services listed and saved to /tmp/running_services.log"

# List all services in SysVinit runlevels
log $YELLOW "Listing all services in SysVinit runlevels..."
ls /etc/rc*.d/ | tee /tmp/sysvinit_services.log
log $GREEN "SysVinit services listed and saved to /tmp/sysvinit_services.log"

# Check the status of all services (systemd)
log $YELLOW "Checking the status of all systemd services..."
systemctl list-unit-files --type=service | tee /tmp/all_services_status.log
log $GREEN "Systemd services status listed and saved to /tmp/all_services_status.log"

# List all upstart services if present
if command -v initctl &> /dev/null; then
    log $YELLOW "Listing all upstart services..."
    initctl list | tee /tmp/upstart_services.log
    log $GREEN "Upstart services listed and saved to /tmp/upstart_services.log"
fi

log $BLUE "Script completed successfully. All logs are saved in /tmp/"

# Display the summary of logs
log $BLUE "Summary of logs:"
log $BLUE "/tmp/enabled_services.log - List of enabled systemd services"
log $BLUE "/tmp/running_services.log - List of running systemd services"
log $BLUE "/tmp/sysvinit_services.log - List of SysVinit services in runlevels"
log $BLUE "/tmp/all_services_status.log - Status of all systemd services"
log $BLUE "/tmp/upstart_services.log - List of upstart services (if present)"
