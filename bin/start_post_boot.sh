#!/bin/bash -xv
cd /home/pi/.aMule/
killall amuled
killall amuleweb
rm /home/pi/.aMule/{muleLock,statistics.dat}
nohup /usr/bin/amuled &

killall transmission-daemon
/usr/bin/transmission-daemon -g $base_sw/transmission --log-debug -e $logs/transmission.log

sleep 30
#$base_bin/forever_qbittorrent.sh
nohup $base_bin/forever_amule.sh &
nohup $base_bin/forever_transmission.sh &

