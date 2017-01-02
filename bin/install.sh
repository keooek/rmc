#!/bin/bash -xv

[[ ! -s "/opt/rmc/etc/media-center-config" ]] && echo "/opt/rmc/etc/media-center-config must exist to continue, please, fill up the corresponding template"
[[ -z "$(grep media-center-config ~/.bashrc)" ]] && echo "source /opt/rmc/etc/media-center-config" >> ~/.bashrc 
source /opt/rmc/etc/media-center-config

function sedeasy {
  sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

killall amuled amuleweb transmission-daemon forever_amule.sh forever_transmission.sh kodi kodi.bin
[ -z "$rmc_base_hd_input" ] && sudo rm -rf $rmc_base_hd_input 
sudo mkdir -p $rmc_base_hd_input 
sudo chown pi:pi $rmc_base_hd_input
cd $rmc_base_hd_input
mkdir ALL AMULE AMULE_TMP BOOKS BOOKS_PROCESSED MOVIES-EN MOVIES-SP MP3 OTHERS SHARE SKIPPED TORRENT_INCOMING TORRENT_TMP TVSHOWS-EN TVSHOWS-SP
mkdir -p $rmc_base/sw/flexget $rmc_base/log $rmc_base/tmp
sudo mkdir -p $rmc_base_hd_output
sudo chown pi:pi $rmc_base_hd_output
cd $rmc_base_hd_output
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

sudo apt-get -y remove openjdk*
sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com EEA14886
a="deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main"; b="/etc/apt/sources.list" ; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"
a="deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main"; b="/etc/apt/sources.list" ; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"
sudo apt-get update
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default


sudo apt-get -y install kodi

sudo apt-get install python-pip
sudo pip install --upgrade setuptools
sudo pip install flexget
flexget -V

cd $rmc_base/sw/filebot 
wget https://sourceforge.net/projects/filebot/files/filebot/HEAD/FileBot.jar.xz
unxz FileBot.jar.xz

sudo apt-get -y install amule amule-daemon
sudo apt-get -y install ssmtp mailutils mpack

sudo apt-get -y autoremove

sudo rpi-update

a="Port $rmc_sed_sshd_port"; b="/etc/ssh/sshd_config"; [ -z "$(grep "$a" $b)" ] && sudo /bin/su -c "echo '$a' >> $b"

[ -z "$(grep "gpu_mem=256" /boot/config.txt)" ] && sudo /bin/su -c "echo 'gpu_mem=256' >> /boot/config.txt"
[ -z "$(grep "filebot" ~/.profile)" ] && echo "export PATH=\$rmc_base/sw/filebot:\$PATH" >> ~/.profile

rm -rf ~/aMule
mkdir -p ~/.aMule
mkdir -p ~/.kodi/userdata

cp $rmc_base/templates/transmission_settings.json.template $rmc_base/etc/transmission_settings.json
cp $rmc_base/templates/amule.conf.template ~/.aMule/amule.conf
cp $rmc_base/templates/crontab.template $rmc_base/tmp/crontab.in
cp $rmc_base/templates/flexget/* $rmc_base/sw/flexget
cp $rmc_base/templates/sources.xml.template ~/.kodi/userdata/sources.xml
sudo cp $rmc_base/templates/ssmtp.conf.template $rmc_base/tmp/ssmtp.conf

#env|grep "rmc_"|sed 's/rmc_//' > $rmc_base/tmp/templates.tmp
env|grep "rmc_sed" > $rmc_base/tmp/templates.tmp
while read line ; do
 escaped_tmp=$(echo $line | cut -d'=' -f2)
 echo $escaped_tmp
 escaped=$(echo $escaped_tmp|sed 's/\//\\\//g')
 echo $escaped
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" $rmc_base/etc/transmission_settings.json
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" ~/.aMule/amule.conf
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" $rmc_base/sw/flexget/config-sp.yml
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" $rmc_base/sw/flexget/config-en.yml
 #sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" ~/.kodi/userdata/sources.xml
 sed -i "s/$(echo $line | cut -d'=' -f1)/$escaped/" $rmc_base/tmp/ssmtp.conf
done < $rmc_base/tmp/templates.tmp

sudo cp $rmc_base/tmp/ssmtp.conf /etc/ssmtp/ssmtp.conf

crontab -l | grep -v "no crontab for" | grep -v "MAIL=" | grep -v RMC_CRONTAB > $rmc_base/tmp/crontab.out
cat $rmc_base/tmp/crontab.out $rmc_base/tmp/crontab.in > $rmc_base/tmp/crontab.new
crontab $rmc_base/tmp/crontab.new

cd ~/.aMule
wget http://upd.emule-security.org/nodes.dat
wget http://upd.emule-security.org/server.met

sudo rm -rf /etc/transmission-daemon
sudo apt-get -y --purge remove transmission-daemon
sudo apt-get -y install transmission-daemon
sudo service transmission-daemon stop
killall transmission-daemon forever_transmission.sh
sudo cp $rmc_base/etc/transmission_settings.json /etc/transmission-daemon/settings.json
sudo service transmission-daemon start
sleep 3
sudo service transmission-daemon stop
killall transmission-daemon forever_transmission.sh
sedeasy "$rmc_sed_transmission_pass" "$(sudo grep rpc-password /etc/transmission-daemon/settings.json |cut -d\" -f4)" $rmc_base/etc/transmission_settings.json
sudo systemctl disable transmission-daemon
sudo chown -R pi:pi /var/lib/transmission-daemon /etc/transmission-daemon
sudo cp -pf $rmc_base/etc/transmission_settings.json /etc/transmission-daemon/settings.json
cp $rmc_base/etc/transmission_settings.json $rmc_base/sw/transmission/settings.json

mkdir -p ~/.config/autostart
cp $rmc_base/templates/kodi.desktop ~/.config/autostart

rm -rf ~/.kodi ; cd ~ ; tar zxvf $rmc_base/templates/kodi.tgz

sed -i 's/export rmc_sed_/#export rmc_sed_/' $rmc_base/etc/media-center-config

sudo reboot
