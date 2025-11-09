#!/bin/bash

monitor_dp_init_status=$(kscreen-doctor -o | grep -A 1 "DP-1" | grep -E "enabled|disabled" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
monitor_htdmi_init_status=$(kscreen-doctor -o | grep -A 1 "HDMI-A-2" | grep -E "enabled|disabled" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
tv_hdmi_init_status=$(kscreen-doctor -o | grep -A 1 "HDMI-A-1" | grep -E "enabled|disabled" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
init_audio=$(pactl get-default-sink)
hdmi_audio="alsa_output.pci-0000_03_00.1.hdmi-stereo"

echo "monitor_dp_init_status $monitor_dp_init_status"
echo "monitor_htdmi_init_status $monitor_htdmi_init_status"
echo "tv_hdmi_init_status $tv_hdmi_init_status"


if [ "$monitor_dp_init_status" == "enabled" ]; then
    echo "The DP-1 is enabled. Disabling it."
    kscreen-doctor output.DP-1.disable
fi
if [ "$monitor_htdmi_init_status" == "enabled" ]; then
    echo "The HDMI-A-2 is enabled. Disabling it."
    kscreen-doctor output.HDMI-A-2.disable
fi
if [ "$tv_hdmi_init_status" == "disabled" ]; then
    echo "The HDMI-A-1 is disabled Enabling it."
    kscreen-doctor output.HDMI-A-1.enable
fi

pactl set-default-sink "$hdmi_audio"


steam -tenfoot


pactl set-default-sink "$init_audio"

if [ "$monitor_dp_init_status" == "enabled" ]; then
    echo "The DP-1 is disabled. Enabling it."
    kscreen-doctor output.DP-1.enable
fi
if [ "$monitor_htdmi_init_status" == "enabled" ]; then
    echo "The HDMI-A-2 is disabled. Enabling it."
    kscreen-doctor output.HDMI-A-2.enable
fi
if [ "$tv_hdmi_init_status" == "disabled" ]; then
    echo "The HDMI-A-1 is enabled. Enabling it."
    kscreen-doctor output.HDMI-A-1.disable
fi
