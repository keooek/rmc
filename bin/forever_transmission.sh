#!/bin/bash

cd $rmc_base/bin

while true; do
 pids_old=`ps ax |grep "/usr/bin/transmission-daemon"|grep -v grep | awk '{print $1}'`
 if [ -z "$pids_old" ]; then
  echo "$(date): Reinicio transmission-daemon" > $rmc_logs/forever_transmission_$(date +%Y%m%d-%H_%M_%S).txt 2>&1
  /usr/bin/transmission-daemon -g $rmc_base/sw/transmission --log-debug -e $rmc_logs/transmission.log
 fi
 sleep 60
done
