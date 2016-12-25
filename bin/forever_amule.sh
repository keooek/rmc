#!/bin/bash

cd $base_bin

while true; do

 # find pid
 var=$(/usr/bin/pgrep -c amuled)

 if [ $? -ne 0 ] # if not running
 then
  echo "$(date): Reinicio amule" > $logs/forever_amule_$(date +%Y%m%d-%H_%M_%S).txt 2>&1
  cd /home/pi/.aMule/
  killall amuled
  killall amuleweb
  rm /home/pi/.aMule/{muleLock,statistics.dat}
  nohup /usr/bin/amuled &
 fi

 sleep 60
done
