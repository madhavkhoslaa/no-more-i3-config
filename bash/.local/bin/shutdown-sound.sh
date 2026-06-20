#!/bin/bash

SOUND_FILE="$HOME/.local/share/shutdown-sound/gta-death.wav"

case "$1" in
    poweroff|halt)
        if [[ -f "$SOUND_FILE" ]]; then
            paplay "$SOUND_FILE" 2>/dev/null
        fi
        /usr/bin/systemctl "$@"
        ;;
    shutdown)
        if [[ -f "$SOUND_FILE" ]]; then
            paplay "$SOUND_FILE" 2>/dev/null
        fi
        /usr/bin/systemctl "$@"
        ;;
    *)
        /usr/bin/systemctl "$@"
        ;;
esac
