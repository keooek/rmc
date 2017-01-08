#!/bin/bash -xv
#Retry again stuff in SKIPPED
mv -vf $rmc_base_hd_input/SKIPPED/* $rmc_base_hd_input/ALL

#Purge lock flexget
rm -f $rmc_base/sw/flexget/.config*lock

exit 0
