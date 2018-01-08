#!/bin/bash -xv

while ! pid=$(pidof pulseaudio) ; do
 sleep 2
done
#pulseaudio starts several times, take first daemon
pid=$(awk -F " " '{print $1}' <<< $pid)
user=`ps -p $pid -o user=`
export `strings /proc/$pid/environ | grep DBUS_SESSION_BUS_ADDRESS`
export `strings /proc/$pid/environ | grep XDG_RUNTIME_DIR`
export `strings /proc/$pid/environ | grep LANG`

sink="bluez_card.00_1D_43_AA_35_A7"
changed_headset="no"; [[ ! -z "$(grep "ALSA:default" /home/pi/.kodi/userdata/guisettings.xml)" ]] && changed_headset="yes"
changed_hdmi="no"; [[ ! -z "$(grep "PI:Both" /home/pi/.kodi/userdata/guisettings.xml)" ]] && changed_hdmi="yes"

while true; do
 if [[ ! -z $(pidof pulseaudio) && ! -z $(pidof kodi_v7.bin) ]] ; then
  if [[ "$(/usr/bin/pactl list cards short)" == *$sink* ]] ; then
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
