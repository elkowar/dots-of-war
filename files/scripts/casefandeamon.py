#!/usr/bin/env python3
import re
import time
import subprocess

fans=["fan2", "fan3"]
default_fan_speed = 30


def run_fan_check():
    fan_speed = default_fan_speed
    sensors_out = subprocess.check_output(['sensors'])
    sensors_out = sensors_out.decode('UTF-8').splitlines()
    tdie_temp = [x for x in sensors_out if x.startswith("Tdie")]

    if len(tdie_temp) > 0:
        temp = tdie_temp[0]
        temp = float(re.findall(r"^Tdie:\s*\+(.*?)°C.+", temp)[0])
        if temp < 50:
            fan_speed = 0
        elif temp < 60:
            fan_speed = 10
        elif temp < 70:
            fan_speed = 20
        elif temp < 75:
            fan_speed = 30
        elif temp < 80:
            fan_speed = 50
        elif temp < 85:
            fan_speed = 100

    print("applying fan curve to " + str(fan_speed) + "%, temp is " + str(temp))
    for fan in fans:
        subprocess.run(["liquidctl", "set", fan, "speed", str(fan_speed)])


while True:
    try:
        run_fan_check()
    except:
        print("There was a problem while running the fan curve")
    time.sleep(5)


    # cm-rgb-cli

# run as casefan.service (systemctl enable casefan)
