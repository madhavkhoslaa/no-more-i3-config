#!/bin/bash

SOUND_FILE="$HOME/.local/share/sounds/gta5_death.wav"

if [[ "$1" = "poweroff" && -f "$SOUND_FILE" ]]; then
    paplay "$SOUND_FILE" &
    PLAY_PID=$!
    sleep 2
    kill "$PLAY_PID" 2>/dev/null
    wait "$PLAY_PID" 2>/dev/null
fi

systemctl "$@"
