#! /bin/sh

DISPLAY=:0 Xephyr -br -ac -noreset -screen 1920x1080 -keybd ephyr,,,xkbmodel=evdev,xkblayout=de :2
