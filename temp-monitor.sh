#!/bin/bash

# by Paul Colby (http://colby.id.au), no rights reserved ;)
OUTPUT=temperature-$(date -d "today" +"%Y%m%d%H%M").csv
# Temperature inputs.

PREV_TOTAL=0
PREV_IDLE=0

echo "time,temperature,cpu" > $OUTPUT
while true; do
  # Get the total CPU statistics, discarding the 'cpu ' prefix.
  CPU=(`sed -n 's/^cpu\s//p' /proc/stat`)
  IDLE=${CPU[3]} # Just the idle CPU time.

  # Calculate the total CPU time.
  TOTAL=0
  for VALUE in "${CPU[@]}"; do
    let "TOTAL=$TOTAL+$VALUE"
  done

  # Calculate the CPU usage since we last checked.
  let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"

  # Calculate highest CPU Temperature.
  HIGH_TEMP=$(echo $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000)))

  # Redirect CPU temperature and % of CPU usage to file.
  echo "$(date '+%H:%M:%S'),${HIGH_TEMP},${DIFF_USAGE}" >> $OUTPUT

  # Remember the total and idle CPU times for the next check.
  PREV_TOTAL="$TOTAL"
  PREV_IDLE="$IDLE"

  # Wait before checking again.
  sleep 1
done
