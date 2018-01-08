#!/bin/bash -xv

cd /home/pi/.aMule/
wget http://upd.emule-security.org/nodes.dat
wget http://upd.emule-security.org/server.met
rm nodes.dat.* server.met.*
killall amuled
killall amuleweb
rm /home/pi/.aMule/{muleLock,statistics.dat}
nohup /usr/bin/amuled &

killall transmission-daemon
/usr/bin/transmission-daemon -g $rmc_base/sw/transmission --log-debug -e $rmc_logs/transmission.log

sleep 30
#$rmc_base/bin/forever_qbittorrent.sh
nohup $rmc_base/bin/forever_amule.sh &
nohup $rmc_base/bin/forever_transmission.sh &
nohup $rmc_base/bin/set_headset_kodi.sh &

