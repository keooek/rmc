#!/bin/bash -xv
/usr/bin/curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Clean", "id": "mybash"}' -H 'content-type: application/json;' http://$rmc_kodi_ip/jsonrpc
