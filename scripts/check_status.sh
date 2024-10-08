#!/bin/bash

# Created by justme_roms in Evernode Discord

# Log file path
LOG_FILE="/var/log/evernode_status.log"

LINES=1

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if the log file exists and create it if not
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
fi

# Check if evernode command exists
if ! command -v evernode &> /dev/null; then
    log_message "Error: $HOSTNAME evernode command not found or not executable. Exiting."
    tail "/var/log/evernode_status.log"
    exit 1
fi


#Check MOTD for Server Reboot
#############################
case $1 in
    server_reboot)
status=$(cat /run/motd.dynamic)
host_status=$(echo "$status" | grep -o 'System restart [^ ]*' | cut -d' ' -f3)
#echo "STATUS: $host_status"

        #host_status=$(echo "$status" | grep -o 'Host status: [^ ]*' | cut -d' ' -f3)

        # Check if the host status is "active"
        if [[ "$host_status" == "required" ]]; then
            #echo "*** System restart required ***"
            log_message "System Reboot Required, rebooting $HOSTNAME !!!"  
            #only get last line of log
            tail -n $LINES "/var/log/evernode_status.log"
            systemctl reboot
            exit 1
        else
            log_message "No system reboot required for $HOSTNAME"
            tail -n $LINES "/var/log/evernode_status.log"
            exit 1
        fi

        
        ;;
esac

## Evernode STATUS Checks
#########################
# Run the command to get the status and capture its output
status=$(evernode status)

# Extract the host status from the output
host_status=$(echo "$status" | grep -o 'Host status: [^ ]*' | cut -d' ' -f3)

host_lease=$(echo "$status" | grep -o 'Available Lease offers: [^ ]*' | cut -d' ' -f4)

echo "Availible leases: $host_lease"

case $1 in 
release)
    if [[ "$host_lease" == "0" ]]; then
        echo "resetting lease count !!!" 
        /usr/bin/evernode config resources 0 0 0 3
    fi
    ;;
esac

# Check if the host status is "active"
#status_echo
if [[ "$host_status" == "active" ]]; then
    log_message "Evernode $HOSTNAME is active. No action needed."
elif [[ "$host_status" == "inactive" ]]; then
    log_message "Evernode $HOSTNAME is inactive. Reboot required!"
    # Reboot using systemctl for more reliability
    
    case $1 in
    reboot)
        log_message "...rebooting $HOSTNAME !!!"
        LINES=2    
        systemctl reboot
        ;;
    esac
else
    log_message "Error: Unable to determine the $HOSTNAME status."
    exit 1
fi

#only get last line of log
tail -n $LINES "/var/log/evernode_status.log"