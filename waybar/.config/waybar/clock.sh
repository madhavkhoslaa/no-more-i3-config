#!/bin/bash
date_fmt=$(date '+%I:%M %p')
tooltip=$(date '+%A, %B %d, %Y  %I:%M:%S %p  %Z')
echo "{\"text\": \"  $date_fmt\", \"tooltip\": \"$tooltip\"}"
