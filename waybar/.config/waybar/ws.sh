#!/bin/bash
WS=$1
active=$(hyprctl activeworkspace -j | jq -r '.id')
if [ "$WS" = "$active" ]; then
    echo "{\"text\": \"[$WS]\", \"class\": \"active\"}"
else
    echo "{\"text\": \"$WS\", \"class\": \"\"}"
fi
