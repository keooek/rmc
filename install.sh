# Before executing this script please, install the latest full raspbian image from https://www.raspberrypi.org/downloads/raspbian/
[ -e ./settings.sh  ] && source ./settings.sh ; sudo mkdir $base ; sudo chown pi:pi $base
[ ! -e ./settings.sh  ] && sudo mkdir /opt/rmc ; sudo chown pi:pi /opt/rmc ; cd /opt ; git clone https://github.com/keooek/rmc ; cd /opt/rmc
apt-get update
apt-get upgrade
apt-get dist-upgrade
apt-get install openjdk-8-jdk
