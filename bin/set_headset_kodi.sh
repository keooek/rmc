#!/bin/bash

#First connect device automatically

# bluetoothctl
# power on
# agent on
# default-agent
# scan on
# pair 00:1D:43:6D:03:26
# connect 00:1D:43:6D:03:26

#list cards pulseaudio
#pactl list cards short

while ! pid=$(pidof pulseaudio) ; do
 sleep 2
done
#pulseaudio starts several times, take first daemon
pid=$(awk -F " " '{print $1}' <<< $pid)
user=`ps -p $pid -o user=`
export `strings /proc/$pid/environ | grep DBUS_SESSION_BUS_ADDRESS`
export `strings /proc/$pid/environ | grep XDG_RUNTIME_DIR`
export `strings /proc/$pid/environ | grep LANG`

#list already paired devices here
list_sink="bluez_card.00_1D_43_AA_35_A7 bluez_card.E9_08_EF_0A_33_24"
changed_headset="no"; [ ! -z "$(grep "ALSA:default" /home/pi/.kodi/userdata/guisettings.xml)" ] && changed_headset="yes"
changed_hdmi="no"; [ ! -z "$(grep "PI:Both" /home/pi/.kodi/userdata/guisettings.xml)" ] && changed_hdmi="yes"

while true; do
 if [[ ! -z $(pidof pulseaudio) && ! -z $(pidof kodi_v7.bin) ]] ; then
  exists_sink=false
  for sink_tmp in $list_sink ; do
   if [[ "$(/usr/bin/pactl list cards short)" == *$sink_tmp* ]] ; then
    exists_sink=true
    sink=$sink_tmp
   fi
  done
  if [[ "$exists_sink" == true ]] ; then
   if [[ $changed_headset == "no" ]] ; then
    card="$(/usr/bin/pactl list cards short| grep $sink | cut -f1)"
    /usr/bin/pacmd set-card-profile $sink a2dp_sink
    /usr/bin/curl -H 'content-type: application/json;' http://$rmc_kodi_ip/jsonrpc --data-binary '{ "jsonrpc": "2.0", "method": "Settings.SetSettingValue", "params":{"setting": "audiooutput.audiodevice", "value": "ALSA:default"}, "id": "mybash"}'
    changed_headset="yes"
    changed_hdmi="no"
   fi
  else
   if [[ $changed_hdmi == "no" ]] ; then
    /usr/bin/curl -H 'content-type: application/json;' http://$rmc_kodi_ip/jsonrpc --data-binary '{ "jsonrpc": "2.0", "method": "Settings.SetSettingValue", "params":{"setting": "audiooutput.audiodevice", "value": "PI:Both"}, "id": "mybash"}'
    changed_headset="no"
    changed_hdmi="yes" 
   fi
  fi
 fi
 sleep 2
done
