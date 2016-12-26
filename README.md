# rmc

Please, install the latest full raspbian image from https://www.raspberrypi.org/downloads/raspbian/
Configure network settings with static ip (recommended ethernet connection), enable ssh service.

In order to get the more stable system the root file system should be in a hard driver, for this particular if you have an empty HD (delete all partitions before) use:

git clone https://github.com/adafruit/Adafruit-Pi-ExternalRoot-Helper

cd Adafruit-Pi-ExternalRoot-Helper
sudo ./adafruit-pi-externalroot-helper -d /dev/sda

...where /dev/sda is the external USB you wish to use for a root filesystem.

Recommended installation dir /opt/rmc, in case to use default execute:

sudo mkdir /opt/rmc ; sudo chown pi:pi /opt/rmc ; cd /opt ; git clone https://github.com/keooek/rmc 

Before install modify the /opt/rmc/templates/media-center-config.template

cd /opt/rmc/bin ; ./install.sh

If not execute "git clone https://github.com/keooek/rmc" wherever you want and change templates/media-center-config.template file in $base to select your custom installation dir.

Then execute:

bin/install.sh

