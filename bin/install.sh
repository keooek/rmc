#!/bin/bash -xv
echo [[ -s "/opt/rmc/etc/media-center-config" ]] && source "/opt/rmc/etc/media-center-config"" >> ~/.bashrc

sudo mkdir $base ; sudo chown pi:pi $base
mkdir -p $base_hd_input ; cd $base_hd_input
mkdir ALL AMULE AMULE_TMP BOOKS BOOKS_PROCESSED MOVIES-EN MOVIES-SP MP3 OTHERS SHARE SKIPPED TORRENT_INCOMING TORRENT_TMP TVSHOWS-EN TVSHOWS-SP
mkdir -p $base/sw/flexget $base/log $base/tmp

sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade

sudo apt-get install kodi

sudo pip install flexget
flexget -V

cd $base/sw/filebot ; wget https://sourceforge.net/projects/filebot/files/filebot/HEAD/FileBot.jar.xz

sudo apt-get install transmission-daemon
sudo service transmission-daemon stop
sudo systemctl disable transmission-daemon
sudo chown pi:pi /var/lib/transmission-daemon

sudo apt-get install amule amule-daemon

sudo rpi-update

[ -z "$(grep "gpu_mem=256" /boot/config.txt)" ] && sudo /bin/su -c "echo 'gpu_mem=256' >> /boot/config.txt"
