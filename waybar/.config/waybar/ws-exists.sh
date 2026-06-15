#!/bin/bash
hyprctl workspaces -j | jq -e '.[] | select(.id == '$1')' > /dev/null 2>&1
