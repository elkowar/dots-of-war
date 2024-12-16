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
        # if temp < 50:
            # fan_speed = 20
        # if temp < 60:
            # fan_speed = 30
        # elif temp < 70:
            # fan_speed = 40
        # elif temp < 80:
            # fan_speed = 60
        # else:
            # fan_speed = 100
        if temp < 60:
            fan_speed = 60
        if temp < 60:
            fan_speed = 60
        elif temp < 70:
            fan_speed = 60
        elif temp < 80:
            fan_speed = 70
        else:
            fan_speed = 100

    print("setting fan speed to " + str(fan_speed) + "%, temp is " + str(temp))
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
