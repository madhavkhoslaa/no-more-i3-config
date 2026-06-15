#!/bin/bash
active=$(hyprctl activeworkspace -j | jq -r '.id')
workspaces=$(hyprctl workspaces -j | jq -r '.[].id' | sort)

output=""
for ws in $workspaces; do
    if [ "$ws" = "$active" ]; then
        output+="[$ws] "
    else
        output+="$ws "
    fi
done

echo "$output"
