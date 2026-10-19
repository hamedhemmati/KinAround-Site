"""Capture real views from the temporary, isolated sample-data app."""
import os
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parent
APP = Path("/tmp/kinaround-store-derived/Build/Products/Debug-iphonesimulator/KinAround.app")
DEVICES = {
    "iphone-large": "2EDCCDEC-F525-42C1-9945-C931287624BD",
    "ipad-13": "A8300DAD-977D-4987-8B30-72AA4558AFF7",
}


def sim(*args, env=None, check=True):
    return subprocess.run(["xcrun", "simctl", *args], env=env, check=check)


for folder, device in DEVICES.items():
    dest = ROOT / "raw" / folder
    dest.mkdir(parents=True, exist_ok=True)
    sim("bootstatus", device, "-b")
    sim("install", device, str(APP))
    sim("status_bar", device, "override", "--time", "9:41", "--dataNetwork", "wifi",
        "--wifiMode", "active", "--wifiBars", "3", "--batteryState", "charged", "--batteryLevel", "100")
    sim("ui", device, "appearance", "light")
    for index, screen in enumerate(["map", "detail", "places", "circles", "settings"], 1):
        sim("terminate", device, "com.kinaround.app", check=False)
        env = dict(os.environ, SIMCTL_CHILD_KINAROUND_CAPTURE_SCREEN=screen)
        sim("launch", device, "com.kinaround.app", env=env)
        time.sleep(12 if screen == "map" else 5)
        sim("io", device, "screenshot", str(dest / f"{index:02}-{screen}.png"))
