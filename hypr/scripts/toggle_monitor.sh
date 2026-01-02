#!/bin/bash

# Check if HDMI-A-1 is currently enabled in the monitor list
if hyprctl monitors | grep "HDMI-A-1"; then
    # If it is enabled, DISABLE it (Laptop only mode)
    hyprctl keyword monitor "HDMI-A-1, disable"
    hyprctl keyword monitor "eDP-1, 1920x1200@60, 0x0, 1"
else
    # If it is disabled, ENABLE it (Dual monitor mode)
    hyprctl keyword monitor "HDMI-A-1, 1920x1080@120, 0x0, 1"
    hyprctl keyword monitor "eDP-1, 1920x1200@60, 0x1080, 1"
fi
