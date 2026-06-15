#!/bin/bash

entries="⏻ Shutdown\n⭮ Reboot\n⏾ Suspend\n Lock\n󰍃 Logout"

selected=$(echo -e "$entries" | wofi --width 150 --height 200 --dmenu --cache-file /dev/null --prompt "" --hide-input)

case $selected in
    "⏻ Shutdown")
        systemctl poweroff ;;
    "⭮ Reboot")
        systemctl reboot ;;
    "⏾ Suspend")
        systemctl suspend ;;
    " Lock")
        hyprlock ;;
    "󰍃 Logout")
        hyprctl dispatch exit ;;
esac
