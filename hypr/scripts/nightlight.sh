#!/bin/bash

# Path to store the current temperature
TEMP_FILE="/tmp/gammastep_current_temp"

# Default temperature (Daylight)
DEFAULT_TEMP=6500
# Minimum temperature (Very Orange)
MIN_TEMP=1500
# Step size (How much to change per press)
STEP=500

function get_current_temp {
    if [ -f "$TEMP_FILE" ]; then
        cat "$TEMP_FILE"
    else
        echo "$DEFAULT_TEMP"
    fi
}

case "$1" in
    "increase")
        # "Increase" night light means LOWER temperature (more orange)
        CURRENT=$(get_current_temp)
        NEW_TEMP=$((CURRENT - STEP))

        if [ "$NEW_TEMP" -lt "$MIN_TEMP" ]; then
            NEW_TEMP=$MIN_TEMP
        fi

        echo "$NEW_TEMP" > "$TEMP_FILE"
        
        # Kill existing gammastep and start new one in manual mode (-O)
        pkill gammastep
        gammastep -O "$NEW_TEMP" &
        
        notify-send "Night Light" "Temperature: ${NEW_TEMP}K" -t 1000
        ;;
        
    "reset")
        # Remove the temp file and restart gammastep in auto mode
        rm -f "$TEMP_FILE"
        pkill gammastep
        
        # RESTORE: Change these coordinates to your location!
        # If you don't use coordinates, just run "gammastep &"
        gammastep -l 21.0:105.8 &  
        
        notify-send "Night Light" "Reset to Automatic Mode" -t 1000
        ;;
esac
