
cd /home/pi/jenkins/
#nohup ./maintenance_jenkins.sh &
#nohup ./start_jenkins.sh &

cd /home/pi/.aMule/
killall amuled
killall amuleweb
rm /home/pi/.aMule/{muleLock,statistics.dat}
nohup /usr/bin/amuled &

killall transmission-daemon
/usr/bin/transmission-daemon -g /etc/transmission-daemon --log-debug -e /home/pi/logs/transmission.log

sleep 30
#/home/pi/bin/forever_qbittorrent.sh
nohup /home/pi/bin/forever_amule.sh &
nohup /home/pi/bin/forever_transmission.sh &
#bash -ic "pok"

#/etc/init.d/transmission-daemon start
#/etc/init.d/amule-daemon start
#/etc/init.d/rtorrent-init start
