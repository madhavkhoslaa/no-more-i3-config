#!/bin/bash

entries="⏻ Shutdown\n⭮ Reboot\n⏾ Suspend\n Lock\n󰍃 Logout"

selected=$(echo -e "$entries" | wofi --width 150 --height 200 --dmenu --cache-file /dev/null --prompt "" --hide-input)

SHUTDOWN_SOUND="$HOME/.local/bin/shutdown-sound.sh"

case $selected in
    "⏻ Shutdown")
        if [[ -x "$SHUTDOWN_SOUND" ]]; then
            "$SHUTDOWN_SOUND" poweroff
        else
            systemctl poweroff
        fi ;;
    "⭮ Reboot")
        if [[ -x "$SHUTDOWN_SOUND" ]]; then
            "$SHUTDOWN_SOUND" reboot
        else
            systemctl reboot
        fi ;;
    "⏾ Suspend")
        systemctl suspend ;;
    " Lock")
        hyprlock ;;
    "󰍃 Logout")
        hyprctl dispatch exit ;;
esac
