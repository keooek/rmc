#!/bin/bash -xv
[[ ! -s "/opt/rmc/etc/media-center-config" ]] && echo "/opt/rmc/etc/media-center-config must exist to continue, please, fill up the corresponding template"
[[ -z "$(grep media-center-config ~/.bashrc)" ]] && echo "source /opt/rmc/etc/media-center-config" >> ~/.bashrc 
source /opt/rmc/etc/media-center-config

sudo mkdir -p $base_hd_input 
sudo chown pi:pi $base_hd_input
cd $base_hd_input
mkdir ALL AMULE AMULE_TMP BOOKS BOOKS_PROCESSED MOVIES-EN MOVIES-SP MP3 OTHERS SHARE SKIPPED TORRENT_INCOMING TORRENT_TMP TVSHOWS-EN TVSHOWS-SP
mkdir -p $base/sw/flexget $base/log $base/tmp
sudo mkdir -p $base_hd_output
sudo chown pi:pi $base_hd_output
cd $base_hd_output
mkdir MOVIES-3D-EN MOVIES-3D-SP MOVIES-EN MOVIES-OLD-EN MOVIES-OLD-SP MOVIES-SP TVSHOWS-EN TVSHOWS-SP YOUTUBE-MUSIC

a="pi hard nofile 16384"; b="/etc/security/limits.conf" ; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"
a="pi soft nofile 8192"; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"
a="vm.min_free_kbytes = 32768"; b="/etc/sysctl.conf" ; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"
a="net.core.rmem_max = 4194304" ; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"
a="net.core.wmem_max = 1048576" ; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"
#smsc95xx.turbo_mode=N in /boot/cmdline.txt

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

sudo apt-get -y install kodi

sudo pip install flexget
flexget -V
cp $base/templates/flexget/* $base_sw/flexget

cd $base/sw/filebot 
wget https://sourceforge.net/projects/filebot/files/filebot/HEAD/FileBot.jar.xz
unxz FileBot.jar.xz

sudo apt-get -y install amule amule-daemon

sudo apt-get -y autoremove

sudo rpi-update

[ -z "$(grep "gpu_mem=256" /boot/config.txt)" ] && sudo /bin/su -c "echo 'gpu_mem=256' >> /boot/config.txt"
[ -z "$(grep "filebot" ~/.profile)" ] && echo "export PATH=\$base/sw/filebot:\$PATH" >> ~/.profile

mkdir -p ~/.aMule

cp $base/templates/transmission_settings.json.template $base/etc/transmission_settings.json
cp $base/templates/amule.conf.template ~/.aMule/amule.conf
cp $base/templates/crontab.template $base/tmp/crontab.in
cp $base/templates/start_post_boot.sh.template $base_bin/start_post_boot.sh

env|grep "rmc_"|sed 's/rmc_//' > $base/tmp/templates.tmp
while read line ; do
 escaped_tmp=$(echo $line | cut -d'=' -f2)
 echo $escaped_tmp
 escaped=$(echo $escaped_tmp|sed 's/\//\\\//g')
 echo $escaped
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" $base/etc/transmission_settings.json
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" ~/.aMule/amule.conf
# sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" $base/tmp/crontab.in
# sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" $base_bin/start_post_boot.sh
done < $base/tmp/templates.tmp

crontab -l | grep -v RMC_CRONTAB > $base/tmp/crontab.out
cat $base/tmp/crontab.out $base/tmp/crontab.in > $base/tmp/crontab.new
crontab $base/tmp/crontab.new

cd ~/.aMule
wget http://upd.emule-security.org/nodes.dat
wget http://upd.emule-security.org/server.met

cp $base/etc/transmission_settings.json $base_sw/transmission/settings.json
sudo apt-get -y --purge remove transmission-daemon
sudo apt-get -y install transmission-daemon
sudo service transmission-daemon stop
sudo systemctl disable transmission-daemon
sudo chown -R pi:pi /var/lib/transmission-daemon /etc/transmission-daemon
sudo cp -pf $base/etc/transmission_settings.json /etc/transmission-daemon/settings.json


sudo reboot
