#!/bin/bash
# Script to set brightness using ddcutil
# Default brightness: 100 (can be overridden by passing an argument)

DEFAULT_BRIGHTNESS=100
BRIGHTNESS=${1:-$DEFAULT_BRIGHTNESS}  # Use first argument, or default to 100

DEFAULT_MONITOR=7
MONITOR=DEFAULT_MONITOR  # Use first argument, or default to 100

ddcutil --bus=$MONITOR setvcp 10 $BRIGHTNESS
