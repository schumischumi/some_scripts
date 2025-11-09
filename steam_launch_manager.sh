#!/bin/bash

monitor_dp_init_status=$(kscreen-doctor -o | grep -A 1 "DP-1" | grep -E "enabled|disabled" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
if [ "$monitor_dp_init_status" == "enabled" ]; then
    gamescope -f --hdr-enabled -w 3440 -h 1440 -r 60 --force-grab-cursor --mangoapp -- env DXVK_HDR=1 ENABLE_HDR_WSI=1 PROTON_ENABLE_HDR=1 PROTON_FSR4_UPGRADE=1 "$@"
else
    gamescope -f -- env PROTON_FSR4_UPGRADE=1 "$@"
fi
# gamescope -f --hdr-enabled -r 60 --mangoapp -- env DXVK_HDR=1 ENABLE_HDR_WSI=1 PROTON_ENABLE_HDR=1 PROTON_FSR4_UPGRADE=1 WINEDLLOVERRIDES=dxgi=n,b %command%
