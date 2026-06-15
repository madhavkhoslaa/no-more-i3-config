#!/bin/bash
SOCKET="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

rename_workspaces() {
    workspaces=$(hyprctl workspaces -j | jq -r '.[].id' | sort)
    active=$(hyprctl activeworkspace -j | jq -r '.id')
    for ws in $workspaces; do
        if [ "$ws" = "$active" ]; then
            hyprctl renameworkspace "$ws" "[$ws]" > /dev/null 2>&1
        else
            hyprctl renameworkspace "$ws" "$ws" > /dev/null 2>&1
        fi
    done
}

rename_workspaces
socat -u "UNIX-CONNECT:$SOCKET" - 2>/dev/null | while read -r line; do
    case "$line" in
        workspace\>*) rename_workspaces ;;
        focusedmon\>*) rename_workspaces ;;
    esac
done
