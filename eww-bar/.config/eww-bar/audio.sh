#!/usr/bin/env bash




speaker_sink_id=$(pamixer --list-sinks | grep "Komplete_Audio_6" | awk '{print $1}')
game_sink_id=$(pamixer --list-sinks | grep "stereo-game" | awk '{print $1}')

volume=$(pamixer --get-volume)

