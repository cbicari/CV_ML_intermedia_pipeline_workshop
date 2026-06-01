# Computer Vision + OSC — Intermedia Arts Workshop

Send body and hand tracking data from your webcam to any software that speaks OSC (like Wekinator, Max/MSP, Pure Data, TouchDesigner...).

Both scripts send to `/wek/inputs` at `127.0.0.1:9000` — ready to plug into Wekinator directly.

---

## Windows — Install

**Step 1 — Open File Explorer and go to `C:\`**

Open any folder window, then click on the address bar at the top, type `C:\` and press Enter.

**Step 2 — Open a terminal here**

Right-click on an empty area of the folder (not on a file) and select **"Open in Terminal"**.

> If you don't see that option, hold **Shift** while right-clicking.

**Step 3 — Run these four commands, one by one**

```powershell
git clone https://github.com/cbicari/c-lab-scripts
Set-ExecutionPolicy Bypass -Scope Process
cd c-lab-scripts
.\install.ps1
```

That's it. The install script takes care of everything: Python 3.12, the virtual environment, all dependencies, and two shortcuts on your desktop — **Hand Tracking** and **Body Tracking**.

**Step 4 — Use the desktop shortcuts**

Just double-click a shortcut to launch. Launching one will automatically close the other. Press **Q** or close the window to stop.

> **Why `C:\` ?** Windows usernames with accented characters (e.g. `Étudiant`) break MediaPipe. Installing at `C:\` avoids this entirely.

---

## Linux / Mac — Install

**Step 1 — Open a terminal in the project folder**

**Step 2 — Run**

```bash
git clone https://github.com/cbicari/c-lab-scripts
cd c-lab-scripts
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Step 3 — Launch a script**

```bash
python hand_recognition.py
```
```bash
python mediapipe_body.py
```

Press **Q** or close the window to stop.

---

## Wekinator setup

| Setting | Value |
|---|---|
| OSC input port | `9000` |
| OSC address | `/wek/inputs` |
| Number of inputs | `63` (hand) or `66` (body) |

---

## Troubleshooting

**Camera not opening** — Try `detection_context(dev_id=1)` in the script to switch camera.

**`ModuleNotFoundError`** — Your terminal is not using the venv. On Linux/Mac run `source venv/bin/activate` first. On Windows, use the desktop shortcuts instead.

**Slow or laggy** — MediaPipe runs on CPU. Close other heavy applications.
