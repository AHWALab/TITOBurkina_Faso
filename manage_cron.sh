#!/bin/bash

# Script to manage TITO cron job
# Usage: ./manage_cron.sh [install|remove|status]

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/pipeline.sh"
# Added 7 min delay so that latestIMERG is available
CRON_SCHEDULE="7 * * * *"
CRON_JOB="$CRON_SCHEDULE $SCRIPT_PATH"

install_cron() {
    # Check if cron job already exists
    if crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
        echo "✓ Cron job already exists"
        crontab -l | grep "$SCRIPT_PATH"
        return 0
    fi
    
    # Add cron job
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    
    if [ $? -eq 0 ]; then
        echo "✓ Cron job installed successfully"
        echo "  Schedule: Every hour with 7 min delay for IMERG at hh:07"
        echo "  Command: $SCRIPT_PATH"
    else
        echo "✗ Failed to install cron job"
        return 1
    fi
}

remove_cron() {
    # Check if cron job exists
    if ! crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
        echo "✓ Cron job not found (already removed)"
        return 0
    fi
    
    # Remove cron job
    crontab -l 2>/dev/null | grep -vF "$SCRIPT_PATH" | crontab -
    
    if [ $? -eq 0 ]; then
        echo "✓ Cron job removed successfully"
    else
        echo "✗ Failed to remove cron job"
        return 1
    fi
}

show_status() {
    echo "Checking TITO cron job status..."
    echo ""
    
    # Check if cron service is running
    if systemctl is-active --quiet cron 2>/dev/null || systemctl is-active --quiet crond 2>/dev/null; then
        echo "✓ Cron service is running"
    else
        echo "⚠ Cron service may not be running"
        echo "  Try: sudo systemctl start cron"
    fi
    echo ""
    
    if crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
        echo "✓ Cron job is INSTALLED"
        echo ""
        echo "Current configuration:"
        crontab -l | grep "$SCRIPT_PATH"
        echo ""
        echo "Recent logs:"
        ls -lht "$SCRIPT_DIR/data/logs/tito_hourly_"*.log 2>/dev/null | head -5 || echo "  No logs found yet"
    else
        echo "✗ Cron job is NOT installed"
    fi
}

# Main logic
case "$1" in
    install)
        install_cron
        ;;
    remove)
        remove_cron
        ;;
    status)
        show_status
        ;;
    *)
        echo "TITO Cron Job Manager"
        echo ""
        echo "Usage: $0 [install|remove|status]"
        echo ""
        echo "Commands:"
        echo "  install  - Install cron job to run TITO every hour"
        echo "  remove   - Remove the TITO cron job"
        echo "  status   - Check if cron job is installed"
        echo ""
        echo "Example:"
        echo "  $0 install"
        exit 1
        ;;
esac
