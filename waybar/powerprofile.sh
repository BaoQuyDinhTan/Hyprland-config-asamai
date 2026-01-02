#!/bin/bash

# Function to print the current status in JSON format
get_json() {
    current=$(powerprofilesctl get)
    if [ "$current" == "balanced" ]; then
        echo '{"text": "Tbinh", "tooltip": "Mode: Balanced", "class": "balanced"}'
    elif [ "$current" == "performance" ]; then
        echo '{"text": "KhoeVL", "tooltip": "Mode: Performance", "class": "performance"}'
    else
        echo '{"text": "ChillChill", "tooltip": "Mode: Power Saver", "class": "power-saver"}'
    fi
}

# Logic: Check if we are "toggling" or just "reading"
if [ "$1" == "toggle" ]; then
    # 1. Change the profile
    current=$(powerprofilesctl get)
    if [ "$current" == "balanced" ]; then
        powerprofilesctl set performance
    elif [ "$current" == "performance" ]; then
        powerprofilesctl set power-saver
    else
        powerprofilesctl set balanced
    fi
    
    # 2. Signal Waybar to refresh immediately
    pkill -SIGRTMIN+8 waybar
else
    # Just print the status (this stops the infinite loop)
    get_json
fi
