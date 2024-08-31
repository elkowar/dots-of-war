#!/bin/bash

list_sinks_with_details() {
    pactl list sinks | awk '
    BEGIN {
        sink_id = ""; sink_name = ""; desc = ""
    }
    /^Sink / {
        if (sink_id != "" && desc != "Ignore") {
            print sink_id"\t"desc
        }
        sink_id = $2;
        sink_name = "";
        desc = "";
    }
    /Name:/ {
        gsub(/Name: /, "", $0);
        sink_name = $0
    }
    /device.description =/ {
        gsub(/.*device.description = "/, "", $0);
        gsub(/"$/, "", $0);
        desc = $0
    }
    END {
    if (sink_id != "" && desc != "Ignore") {
            print sink_id"\t"desc
        }
    }'
}

SELECTED=$(list_sinks_with_details | column -t -s $'\t' | fzf --height=~100%)

if [ -z "$SELECTED" ]; then
    echo "No sink selected."
    exit 1
fi

SELECTED_SINK_ID=$(echo "$SELECTED" | awk '{print $1}')
SELECTED_SINK_NAME=$(pactl list sinks | awk -v id="$SELECTED_SINK_ID" '
  BEGIN { sink_id = ""; sink_name = "" }
  /^Sink / { sink_id = $2 }
  /Name:/ { gsub(/Name: /, "", $0); if (sink_id == id) sink_name = $0 }
  END { print sink_name }
')

# if the selected sink name is a bluez output, then its bluetooth.
# prompt the user to choose a card profile.
# TODO

# Set the default sink
pactl set-default-sink $SELECTED_SINK_NAME
echo "Sink $SELECTED_SINK_NAME set as default."
