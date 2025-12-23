#!/bin/bash

# Configuration
TELNET_IP=""
USERNAME="root"
PASSWORD="AK2040jk"
FILE="ak_tuya_ipc"
PORT="10000"
BINARY_PATH="/tmp/bin/$FILE"

# 1. Check if the process is already running via Telnet
# We do a quick check first to avoid unnecessary uploads
RUNNING=$( (sleep 2; echo "$USERNAME"; sleep 1; echo "$PASSWORD"; sleep 1; echo "ps"; sleep 1; echo "exit") | telnet "$TELNET_IP" 2>/dev/null | grep "$BINARY_PATH")

if [ ! -z "$RUNNING" ]; then
    echo "Process is already running, exit quietly for cron"
    exit 0
fi

echo "Service not found. Starting upload and execution..."

# 2. Start the listener on the camera
{
  sleep 2; echo "$USERNAME"
  sleep 1; echo "$PASSWORD"
  sleep 1; echo "mkdir -p /tmp/bin"
  sleep 1; echo "rm -f /tmp/bin/ak_tuya_ipc"
  # Clean up any crashed instances
  sleep 1; echo "pkill -f tuya_daemon.sh"
  sleep 1; echo "pkill $FILE"
  # Start listener
  sleep 1; echo "nc -l -p $PORT > $BINARY_PATH &" 
  sleep 10;
} | telnet "$TELNET_IP"

# 3. Send the file from local machine
if [ -f "$FILE" ]; then
    nc -w 5 "$TELNET_IP" "$PORT" < "$FILE"
else
    echo "Error: Local binary $FILE not found."
    exit 1
fi

# 4. Set permissions and execute
HOST_DATE=$(date +"%m%d%H%M%Y")
(
  sleep 2; echo "$USERNAME"
  sleep 1; echo "$PASSWORD"
  sleep 1; echo "chmod +x $BINARY_PATH"
  sleep 1; echo "rm -f /tmp/init_rtsp_success_flag"
  sleep 1; echo "$BINARY_PATH &"
  sleep 5; echo "date $HOST_DATE"
  sleep 1; echo "exit"
) | telnet "$TELNET_IP"

echo "Deployment complete."

