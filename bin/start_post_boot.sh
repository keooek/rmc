
cd /home/pi/jenkins/
#nohup ./maintenance_jenkins.sh &
#nohup ./start_jenkins.sh &

cd /home/pi/.aMule/
killall amuled
killall amuleweb
rm /home/pi/.aMule/{muleLock,statistics.dat}
nohup /usr/bin/amuled &

killall transmission-daemon
/usr/bin/transmission-daemon -g /etc/transmission-daemon --log-debug -e $logs/transmission.log

sleep 30
#$base_bin/forever_qbittorrent.sh
nohup $base_bin/forever_amule.sh &
nohup $base_bin/forever_transmission.sh &
#bash -ic "pok"

#/etc/init.d/transmission-daemon start
#/etc/init.d/amule-daemon start
#/etc/init.d/rtorrent-init start
