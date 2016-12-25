#!/bin/bash
# NWN Server Process Monitor
while true; do

#Get in the right directory
NWN_DIR=/home/pi/bin
cd $NWN_DIR

# Command to run
RESTART="/usr/bin/qbittorrent"

#path to pgrep command
PGREP="/usr/bin/pgrep -c"

# daemon name
HTTPD="qbittorrent"

# find pid
var=$(/usr/bin/pgrep -c qbittorrent)

if [ $? -ne 0 ] # if not running
then
 # restart 
 echo "$(date): Reinicio qbittorrent" > /home/pi/bin/log/forever_qbittorrent_$(date +%Y%m%d-%H_%M_%S).txt 2>&1
 export DISPLAY=:0
 $RESTART

fi

sleep 3
done
