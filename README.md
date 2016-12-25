# rmc

Before executing this install script please, install the latest full raspbian image from https://www.raspberrypi.org/downloads/raspbian/
Configure network settings (recommended ethernet connection), enable ssh service.

Recommended installation dir /opt/rmc, in case to use default execute:

sudo mkdir /opt/rmc ; sudo chown pi:pi /opt/rmc ; cd /opt ; git clone https://github.com/keooek/rmc ; cd /opt/rmc/bin ; ./install.sh

If not execute "git clone https://github.com/keooek/rmc" wherever you want and change etc/media-center-config file in $base to select your custom installation dir.

Then execute:

bin/install.sh

