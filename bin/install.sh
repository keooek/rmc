#!/bin/bash -xv
[[ ! -s "/opt/rmc/etc/media-center-config" ]] && echo "/opt/rmc/etc/media-center-config must exist to continue, please, fill up the corresponding template"
[[ -z "$(grep media-center-config ~/.bashrc)" ]] && echo "source /opt/rmc/etc/media-center-config" >> ~/.bashrc 
source /opt/rmc/etc/media-center-config

sudo mkdir -p $base_hd_input 
sudo chown pi:pi $base_hd_input
cd $base_hd_input
mkdir ALL AMULE AMULE_TMP BOOKS BOOKS_PROCESSED MOVIES-EN MOVIES-SP MP3 OTHERS SHARE SKIPPED TORRENT_INCOMING TORRENT_TMP TVSHOWS-EN TVSHOWS-SP
mkdir -p $base/sw/flexget $base/log $base/tmp

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

sudo apt-get -y install kodi

sudo pip install flexget
flexget -V

cd $base/sw/filebot 
wget https://sourceforge.net/projects/filebot/files/filebot/HEAD/FileBot.jar.xz
unxz FileBot.jar.xz

sudo apt-get -y install transmission-daemon
sudo service transmission-daemon stop
sudo systemctl disable transmission-daemon
sudo chown pi:pi /var/lib/transmission-daemon

sudo apt-get -y install amule amule-daemon

sudo apt-get autoremove

sudo rpi-update

[ -z "$(grep "gpu_mem=256" /boot/config.txt)" ] && sudo /bin/su -c "echo 'gpu_mem=256' >> /boot/config.txt"
sudo /bin/su -c "echo "export PATH='$base/sw/filebot:$PATH'" >> ~/.profile
