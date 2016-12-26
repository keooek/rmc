# Before executing this script please, install the latest full raspbian image from https://www.raspberrypi.org/downloads/raspbian/
#[ -e $base_etc/media-center-config ] && source ./settings.sh ; sudo mkdir $base ; sudo chown pi:pi $base ; echo "source $base_etc/media-center-config" >> ~/.bashrc
#[ ! -e ./settings.sh  ] && sudo mkdir /opt/rmc ; sudo chown pi:pi /opt/rmc ; cd /opt ; git clone https://github.com/keooek/rmc ; cd /opt/rmc

mkdir -p $base_hd_input
cd $base_hd_input
mkdir ALL  AMULE  AMULE_TMP  BOOKS  BOOKS_PROCESSED  MOVIES-EN  MOVIES-SP  MP3  OTHERS  PS3  SHARE  SKIPPED  TORRENT_INCOMING  TORRENT_TMP  TVSHOWS-EN  TVSHOWS-SP

apt-get update
apt-get upgrade
apt-get dist-upgrade
apt-get install openjdk-8-jdk

wget https://sourceforge.net/projects/filebot/files/filebot/HEAD/FileBot.jar.xz

sudo apt-get install python3.5
sudo apt-get install python-pip
sudo pip install --upgrade setuptools
sudo pip install virtualenv
virtualenv --system-site-packages $base_sw/flexget/
cd $base_sw 
bin/pip install flexget
#source $base_sw/flexget/bin/activate
~/flexget/bin/flexget params para cron

sudo apt-get install transmission-daemon

sudo apt-get install amule amule-daemon
