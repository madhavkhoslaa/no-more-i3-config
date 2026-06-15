#!/usr/bin/env bash

HYPR_DIR="/run/user/1000/hypr/$HYPRLAND_INSTANCE_SIGNATURE"
SOCKET="$HYPR_DIR/.socket.sock"
MARKER="$HYPR_DIR/.socket.sock.proxy"

start_proxy() {
    python3 /home/vroomer/.config/hypr/ws-proxy.py &
    PROXY_PID=$!
    for i in $(seq 1 10); do
        if [ -S "$SOCKET" ] && python3 -c "
import socket, sys
try:
    s = socket.socket(socket.AF_UNIX)
    s.settimeout(1)
    s.connect('$SOCKET')
    s.close()
    sys.exit(0)
except:
    sys.exit(1)
" 2>/dev/null; then
            return 0
        fi
        sleep 0.1
    done
    return 1
}

# Check if proxy already running
if [ -f "$MARKER" ]; then
    OLD_PID=$(cat "$MARKER")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "ws-proxy already running (pid $OLD_PID)" >&2
    else
        echo "ws-proxy: stale marker, restarting" >&2
        rm -f "$MARKER"
        start_proxy || echo "ws-proxy failed to start" >&2
    fi
else
    start_proxy || echo "ws-proxy failed to start" >&2
fi

waybar "$@"
