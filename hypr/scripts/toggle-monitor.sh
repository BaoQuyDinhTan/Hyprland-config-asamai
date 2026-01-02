#!/usr/bin/env bash

INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"

# Known resolutions
INT_W=1920
INT_H=1200
EXT_W=1920
EXT_H=1080

STATE_FILE="$HOME/.cache/hypr-monitor-mode"

[ -f "$STATE_FILE" ] || echo "dual" > "$STATE_FILE"
MODE=$(cat "$STATE_FILE")

# Check if HDMI connector exists (even if disabled)
if hyprctl monitors all | grep -q "$EXTERNAL"; then
    HDMI_EXISTS=1
else
    HDMI_EXISTS=0
fi

if [ "$MODE" = "dual" ]; then
    # → Laptop only
    hyprctl keyword monitor "$EXTERNAL,disable"
    hyprctl keyword monitor "$INTERNAL,${INT_W}x${INT_H}@60,0x0,1"

    echo "single" > "$STATE_FILE"
else
    # → Dual monitors
    hyprctl keyword monitor "$INTERNAL,${INT_W}x${INT_H}@60,0x0,1"

    if [ "$HDMI_EXISTS" = "1" ]; then
        hyprctl keyword monitor "$EXTERNAL,${EXT_W}x${EXT_H}@120,0x-$EXT_H,1"
    fi

    echo "dual" > "$STATE_FILE"
fi

