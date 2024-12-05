#!/usr/bin/env python3

import subprocess
import json


def get_workspaces():
    output = subprocess.check_output(["swaymsg", "-t", "get_workspaces"])
    return json.loads(output.decode("utf-8"))


def generate_workspace_data() -> dict:
    data = {}
    for wsp in get_workspaces():
        if wsp["output"] not in data:
            data[wsp["output"]] = []
        data[wsp["output"]].append(
            {
                "name": wsp["name"],
                "monitor": wsp["output"],
                "focused": wsp["focused"],
                "visible": wsp["visible"],
            }
        )
    return data


if __name__ == "__main__":
    process = subprocess.Popen(
        ["swaymsg", "-t", "subscribe", "-m", '["workspace"]', "--raw"],
        stdout=subprocess.PIPE,
    )
    if process.stdout is None:
        print("Error: could not subscribe to sway events")
        exit(1)
    while True:
        print(json.dumps(generate_workspace_data()), flush=True)
        line = process.stdout.readline().decode("utf-8")
        if line == "":
            break

# #!/usr/bin/env python3
#
# import subprocess
# import json
#
# WSP_COUNT = 5
# MONITOR_COUNT = 2
#
#
# def get_workspaces():
#     output = subprocess.check_output(["swaymsg", "-t", "get_workspaces"])
#     return json.loads(output.decode("utf-8"))
#
#
# def generate_workspace_data_for_monitor(monitor: int) -> list[dict]:
#     workspaces = {w["name"]: w for w in get_workspaces()}
#     data = []
#     for i in range(WSP_COUNT):
#         name = f"{monitor+1}{i+1}"
#         wsp_data = workspaces.get(name)
#         entry = {
#             "name": name,
#             "monitor": monitor,
#             "occupied": False,
#             "focused": False,
#             "visible": False,
#         }
#         if wsp_data is not None:
#             entry["focused"] = wsp_data["focused"]
#             entry["visible"] = wsp_data["visible"]
#             entry["occupied"] = True
#         data.append(entry)
#     return data
#
#
# def generate_workspace_data() -> dict:
#     return {i: generate_workspace_data_for_monitor(i) for i in range(MONITOR_COUNT)}
#
#
# if __name__ == "__main__":
#     process = subprocess.Popen(
#         ["swaymsg", "-t", "subscribe", "-m", '["workspace"]', "--raw"],
#         stdout=subprocess.PIPE,
#     )
#     if process.stdout is None:
#         print("Error: could not subscribe to sway events")
#         exit(1)
#     while True:
#         print(json.dumps(generate_workspace_data()), flush=True)
#         line = process.stdout.readline().decode("utf-8")
#         if line == "":
#             break
