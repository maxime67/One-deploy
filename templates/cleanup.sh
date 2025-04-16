#!/bin/bash
# This script runs only the cleanup playbook to purge all middleware
set -e

# Display help message
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: ./cleanup.sh [target]"
  echo ""
  echo "Options:"
  echo "  target    Specific target to clean (haproxy, front, api). If not specified, cleans all targets."
  echo ""
  echo "Examples:"
  echo "  ./cleanup.sh            # Clean all targets"
  echo "  ./cleanup.sh haproxy    # Clean only HAProxy servers"
  echo "  ./cleanup.sh front      # Clean only frontend servers"
  echo "  ./cleanup.sh api        # Clean only API servers"
  exit 0
fi

# Set up variables
INVENTORY="inventory/hosts.yml"
TARGET=""

# Handle specific target if provided
if [ ! -z "$1" ]; then
  TARGET="-l $1"
  echo "Cleaning only $1 servers..."
else
  echo "Cleaning all servers..."
fi

# Run the cleanup playbook
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${INVENTORY} ${TARGET} playbooks/cleanup.yml -v

echo "Cleanup completed!"