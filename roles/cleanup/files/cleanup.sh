#!/bin/bash
set -e

echo "Starting VM cleanup process..."

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if running as root
check_root() {
    if [ "$(id -u)" != "0" ]; then
        log_message "Error: This script must be run as root"
        exit 1
    fi
}

# Main cleanup function
cleanup_system() {
    log_message "Stopping services..."
    systemctl stop docker nginx 2>/dev/null || true

    log_message "Cleaning package manager cache..."
    if command -v apt-get &> /dev/null; then
        apt-get clean
        apt-get autoclean
    elif command -v yum &> /dev/null; then
        yum clean all
    fi

    log_message "Removing temporary files..."
    rm -rf /tmp/* /var/tmp/*

    log_message "Truncating log files..."
    find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;
    find /var/log -type f -name "*.gz" -delete

    if [ -w /proc/sys/vm/drop_caches ]; then
        echo 3 > /proc/sys/vm/drop_caches
    else
        log_message "Warning: Cannot clear system cache, /proc/sys/vm/drop_caches is read-only"
    fi
    log_message "Clearing bash history..."
    rm -f ~/.bash_history
    history -c

    log_message "Current disk usage:"
    df -h
}

# Execute cleanup
check_root
cleanup_system

log_message "Cleanup completed successfully!"