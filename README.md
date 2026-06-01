# Computer Vision + OSC — Intermedia Arts Workshop

Send body and hand tracking data from your webcam to any software that speaks OSC (like Wekinator, Max/MSP, Pure Data, TouchDesigner...).

## What's in here

| Script | What it does |
|---|---|
| `hand_recognition.py` | Tracks 21 hand landmarks and sends them as OSC |
| `mediapipe_body.py` | Tracks 33 body pose landmarks and sends them as OSC |

Both scripts send a single OSC message to `127.0.0.1:9000` on the address `/wek/inputs`, followed by floats — ready to plug into **Wekinator** directly.

---

## Windows — Quick Install

Open PowerShell at `C:\` (right-click Start → Terminal) and run these four commands one by one:

```powershell
git clone https://github.com/cbicari/c-lab-scripts
Set-ExecutionPolicy Bypass -Scope Process
cd c-lab-scripts
.\install.ps1
```

That's it. The script installs Python 3.12 if needed, sets up the virtual environment, installs all dependencies, and places **Hand Tracking** and **Body Tracking** shortcuts on the desktop.

> **Important:** Clone to `C:\` — not inside your user folder (`C:\Users\...`). Accented characters in Windows usernames (e.g. `Étudiant`) break MediaPipe's internal file loader.

After setup, just double-click a desktop shortcut. Launching one will automatically close the other.

---

## Linux / Mac — Setup

### Step 1 — Install Python

You need Python 3.9, 3.10, 3.11, or 3.12. Check with `python3 --version` in a terminal. Download from [python.org](https://www.python.org/downloads/) if needed.

---

### Step 2 — Create a virtual environment

A virtual environment is an isolated space for your project's dependencies — it keeps things tidy and avoids conflicts with other Python projects.

Open a terminal (or Command Prompt on Windows) in this folder, then:

**Linux / Mac**
```bash
python3 -m venv venv
source venv/bin/activate
```

**Windows**
```bat
python -m venv venv
venv\Scripts\activate
```

Your prompt should now show `(venv)` — that means you're inside the environment.

---

### Step 3 — Install dependencies

```bash
pip install -r requirements.txt
```

This installs:
- **mediapipe** — Google's hand and body tracking
- **opencv-python** — webcam capture and image display
- **osc4py3** — sending OSC messages

---

### Step 4 — Run a script

Make sure your webcam is plugged in, then:

```bash
python hand_recognition.py
```
```bash
python mediapipe_body.py
```

A window will open showing your webcam feed with skeleton overlay. Press **Q** to quit.

---

### Step 5 — Connect to Wekinator (or any OSC app)

Both scripts send to `127.0.0.1` port `9000`, address `/wek/inputs`.

In **Wekinator**, set:
- Inputs: `66` for body pose, `63` for hand
- OSC port: `9000`
- Input address: `/wek/inputs`

---

## Troubleshooting

**Camera not opening** — Try changing the device index in the script (e.g. `detection_context(dev_id=1)`).

**`ModuleNotFoundError`** — Make sure your virtual environment is activated (you should see `(venv)` in your prompt) and that you ran `pip install -r requirements.txt`.

**`AttributeError: module 'mediapipe' has no attribute 'solutions'`** — Newer MediaPipe versions removed the legacy API. Make sure you're using the pinned version: delete your `venv` folder, recreate it, and run `pip install -r requirements.txt` again.

**Slow or laggy** — MediaPipe runs on CPU by default. Close other heavy applications.

**Windows: `venv\Scripts\activate` not working** — Run this first in PowerShell: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
