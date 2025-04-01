#!/bin/bash


# Get the status of HDMI-A-1
status=$(kscreen-doctor -o | grep -A 1 "HDMI-A-1" | grep -E "enabled|disabled" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')

# Check if the status is "enabled"
if [ "$status" == "enabled" ]; then
    # Perform action if enabled (e.g., set a variable to x)
    x="The screen is enabled. Disabling it."
    kscreen-doctor output.HDMI-A-1.disable

# Check if the status is "disabled"
elif [ "$status" == "disabled" ]; then
    # Perform action if disabled (e.g., set a variable to y)
    y="The screen is disabled. enabling it"
    kscreen-doctor output.HDMI-A-1.enable

# If neither "enabled" nor "disabled" is found, show a KDE message box
else
    kdialog --msgbox "Could not determine the status of HDMI-A-1."
fi
