import os
from pathlib import Path
import subprocess
import time

root = Path(__file__).resolve().parent
device = "4710FBEC-A06B-45D2-AE7E-56C31D0C079D"
app = "/tmp/kinaround-store-watch-derived/Build/Products/Debug-watchsimulator/KinAroundWatch.app"
dest = root / "screenshots" / "watch-ultra"
dest.mkdir(parents=True, exist_ok=True)


def sim(*args, check=True, env=None):
    subprocess.run(["xcrun", "simctl", *args], check=check, env=env)


sim("bootstatus", device, "-b")
sim("install", device, app)
for index, screen in enumerate(["map", "detail", "devices"], 1):
    sim("terminate", device, "com.kinaround.app.watchkitapp", check=False)
    sim("launch", device, "com.kinaround.app.watchkitapp",
        env=dict(os.environ, SIMCTL_CHILD_KINAROUND_CAPTURE_SCREEN=screen))
    time.sleep(12 if screen == "map" else 5)
    sim("io", device, "screenshot", str(dest / f"{index:02}-{screen}.png"))
