#!/bin/bash

# Define the service to be restarted and the email to send notifications to
SERVICE_NAME="haproxy"
#SERVICE_NAME="nginx"
#SERVICE_NAME="apache"
#SERVICE_NAME="apach2"
EMAIL="abdul.rehan@sirmaindia.com"

# Get the current CPU and memory usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Get current date and time for logging
CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Check if CPU usage is greater than or equal to 90%
if (( $(echo "$CPU_USAGE >= 90" | bc -l) )); then
    echo "[$CURRENT_TIME] CPU usage is above 90%. Restarting service..." | tee -a /var/log/service_restart.log
    systemctl restart $SERVICE_NAME

    # Send email notification
    echo "[$CURRENT_TIME] CPU usage was above 90%. The $SERVICE_NAME service has been restarted." | mail -s "$SERVICE_NAME Restart Notification" $EMAIL
fi

# Check if Memory usage is greater than or equal to 90%
if (( $(echo "$MEMORY_USAGE >= 90" | bc -l) )); then
    echo "[$CURRENT_TIME] Memory usage is above 90%. Restarting service..." | tee -a /var/log/service_restart.log
    systemctl restart $SERVICE_NAME

    # Send email notification
    echo "[$CURRENT_TIME] Memory usage was above 90%. The $SERVICE_NAME service has been restarted." | mail -s "$SERVICE_NAME Restart Notification" $EMAIL
fi

# Optional: Log current system status for tracking purposes
echo "[$CURRENT_TIME] Current CPU usage: $CPU_USAGE%" >> /var/log/service_restart.log
echo "[$CURRENT_TIME] Current Memory usage: $MEMORY_USAGE%" >> /var/log/service_restart.log
