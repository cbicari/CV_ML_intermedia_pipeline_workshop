# Computer Vision + OSC — Intermedia Arts Workshop

## What this is

This repo is a starting pipeline for building a **creative digital instrument**: you move in front of a camera, and that movement ends up controlling sound, visuals, lights, or anything else you can imagine — through machine learning, without you having to write any ML code yourself.

It's built from three pieces of software, each doing one job, talking to each other over the network on your own computer:

```
  Webcam
    |
    v
[1] Computer vision (this repo)          reads your hand or body position
    |  OSC  ->  127.0.0.1 : 9000  ->  /wek/inputs
    v
[2] Wekinator                            learns a mapping from your movement to any output you define
    |  OSC  ->  127.0.0.1 : 12000 ->  /wek/outputs
    v
[3] Ossia Score (or Max/MSP, Pure Data, TouchDesigner...)   turns that mapping into sound, visuals, etc.
```

- **[1] This repo** uses [MediaPipe](https://developers.google.com/mediapipe) to track your hand or body from a webcam feed, and streams the raw coordinates out as [OSC](https://en.wikipedia.org/wiki/Open_Sound_Control) messages.
- **[2] [Wekinator](http://www.wekinator.org/)** is a machine-learning tool built for exactly this kind of work: you show it examples ("when my hand is *here*, I want the output to be *this*"), it trains a model, and from then on it maps your live input to an output in real time — no code required. See the official [detailed instructions](https://doc.gold.ac.uk/~mas01rf/Wekinator/instructions/), or the copy bundled in this repo at [documentation/wekinator-documentation.pdf](documentation/wekinator-documentation.pdf).
- **[3] [Ossia Score](https://ossia.io/)** receives Wekinator's output over OSC and lets you patch it into sound, visuals, or anything else it can control. You could just as easily patch Wekinator's output into Max/MSP, Pure Data, TouchDesigner, or any other software that understands OSC.

---

## Understanding OSC, `127.0.0.1`, and ports

Because this pipeline is three separate programs talking to each other, it's worth understanding *how* they talk — this is where most setup problems come from.

- **OSC (Open Sound Control)** is a simple network message format used a lot in creative-coding and media art tools. It's just a way of sending a text address (like `/wek/inputs`) plus a list of numbers, from one program to another.
- **`127.0.0.1`** (also called `localhost`) is a special address that always means "this same computer." Even though the three programs never leave your machine, they still talk over the network stack — it's just a network of one.
- **A port** is like a channel number. Your computer can have many programs listening for network messages at once; the port number is how a message knows which program should receive it. Two programs can't both *listen* on the same port at the same time — but any number of programs can *send* to the same port.

In this pipeline, there are two separate OSC hops, each with its own port:

| Hop | Sends from | Sends to | Address | Port |
|---|---|---|---|---|
| 1 | This repo's scripts | Wekinator | `/wek/inputs` | `9000` |
| 2 | Wekinator | Ossia Score (or other) | `/wek/outputs` | `12000` |

> **Heads up:** Wekinator's own built-in default input port is `6448`, not `9000` — this repo's scripts are written to send on `9000` instead. When you set up your Wekinator project, you must type `9000` into the **input port** field on Wekinator's setup screen so it actually listens where our scripts are sending. The output port (`12000`) *is* Wekinator's default, so you shouldn't need to change anything on that side unless you want to.

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
.\install\install.ps1
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
pip install -r install/requirements.txt
```

**Step 3 — Launch a script**

```bash
python scripts/hand_recognition.py
```
```bash
python scripts/mediapipe_body.py
```

Press **Q** or close the window to stop.

---

## Setting up Wekinator (hop 1 → 2)

Run one of the tracking scripts first — Wekinator needs to see incoming messages while you configure it.

On Wekinator's project setup screen, fill in:

| Setting | Value |
|---|---|
| Input port | `9000` |
| Input message (OSC address) | `/wek/inputs` |
| Number of inputs | `63` for hand tracking, `66` for body tracking |
| Output message (OSC address) | `/wek/outputs` (default) |
| Output host / port | `localhost` / `12000` (default) |
| Number of outputs | however many outputs you want to control |

Once your inputs are recognized (you'll see the values move on Wekinator's screen as you move in front of the camera), you can record examples, train, and run — see the [detailed instructions](https://doc.gold.ac.uk/~mas01rf/Wekinator/instructions/) for the record/train/run workflow itself, which this README doesn't repeat.

---

## Patching into Ossia Score (hop 2 → 3)

With Wekinator running and sending output, open Ossia Score and add an OSC input device that listens on the same port Wekinator is sending to:

1. Add a new **OSC** device.
2. Set it to listen locally on port `12000` (or whatever port you configured as Wekinator's output port above).
3. Ossia should start showing incoming values under the address `/wek/outputs` as Wekinator runs.
4. Map that value onto whatever parameter you want to control (audio, visuals, etc.) using Ossia's own patching tools.

> A ready-made example Ossia Score project may be added here later. For now, patching it by hand as above is the version — it'll work regardless of which OS or Ossia Score version you're on, since it doesn't depend on a saved project file at all.

---

## Troubleshooting

**Camera not opening** — Try `detection_context(dev_id=1)` in the script to switch camera.

**`ModuleNotFoundError`** — Your terminal is not using the venv. On Linux/Mac run `source venv/bin/activate` first. On Windows, use the desktop shortcuts instead.

**Slow or laggy** — MediaPipe runs on CPU. Close other heavy applications.

**Wekinator isn't reacting to my movement** — Make sure the input port on Wekinator's setup screen is set to `9000`, not its default of `6448`.

**Ossia Score isn't receiving anything** — Make sure Ossia's OSC device is listening on the same port Wekinator is configured to send output to (`12000` by default), and that Wekinator is actually running (not just trained).
