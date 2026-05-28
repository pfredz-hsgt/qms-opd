# QMS-OPD — System Requirements

> **Queue Management System for Outpatient Departments (OPD)**
> Real-time queue calling system built with Python/Flask + Socket.IO, with Firebase cloud integration.

---

## Table of Contents
1. [System Architecture Overview](#system-architecture-overview)
2. [Server Requirements](#server-requirements)
   - [Windows (Local Deployment)](#option-a-windows-local-deployment)
   - [Linux (Production Deployment)](#option-b-linux-production-deployment)
3. [Client Requirements](#client-requirements)
   - [Staff Panel](#staff-panel-pc)
   - [Public Display Screen](#public-display-screen)
   - [Patient Mobile Portal](#patient-mobile-portal)
4. [Network Requirements](#network-requirements)
5. [Cloud / External Services](#cloud--external-services)
6. [Environment Variables](#environment-variables)
7. [Directory & Storage Requirements](#directory--storage-requirements)

---

## System Architecture Overview

```
┌──────────────────────────────────────────────┐
│              QMS-OPD Server                  │
│         (Flask + Socket.IO backend)          │
│   Hosts: Staff Panel, Display, Dashboard     │
└──────────┬───────────────────────────────────┘
           │ WebSocket (Socket.IO) + REST API
     ──────┴──────────────────────────────
     │                                   │
┌────▼──────┐   ┌─────────────┐   ┌──────▼──────────┐
│  Staff PC │   │ Display TV  │   │ Patient's Phone  │
│  Browser  │   │   Browser   │   │  (Firebase PWA)  │
└───────────┘   └─────────────┘   └─────────────────┘
                                          │
                               ┌──────────▼──────────┐
                               │  Firebase Realtime   │
                               │  Database + FCM Push │
                               └─────────────────────┘
```

---

## Server Requirements

### Option A: Windows (Local Deployment)

This is the recommended deployment method for a single-site, LAN-only setup.

#### Hardware (Minimum)
| Component | Minimum | Recommended |
|:----------|:--------|:------------|
| **CPU** | Dual-core 1.6 GHz | Quad-core 2.0 GHz+ |
| **RAM** | 2 GB | 4 GB |
| **Storage** | 500 MB free (OS + app) | 2 GB+ (for media video files) |
| **Network** | Wired LAN (100 Mbps) | Gigabit LAN |
| **Display Output** | 1 port (optional, for display PC) | 2 ports (server + display) |

#### Software
| Software | Version | Notes |
|:---------|:--------|:------|
| **Windows OS** | Windows 10 / Windows 11 | Windows Server 2019+ also supported |
| **Python** | 3.8 or later | 3.11+ recommended |
| **pip** | Latest | Installed with Python |
| **Git** | Latest | Required for in-app auto-update feature |
| **Google Chrome** | Latest | Required for kiosk display (`2.LaunchDisplay.bat`) |
| **Microsoft Edge** | Latest | Required for staff panel kiosk (`3.LaunchPanel.bat`) |

#### Python Packages (via `pip install`)
```
Flask
Flask-SocketIO
firebase-admin
eventlet
```
> Install with: `pip install flask flask-socketio firebase-admin eventlet`

---

### Option B: Linux (Production Deployment)

Recommended for stable, always-on deployments (e.g., Ubuntu Server hosted alongside other services).

#### Hardware (Minimum)
| Component | Minimum | Recommended |
|:----------|:--------|:------------|
| **CPU** | 1 vCPU / Single-core | 2 vCPU |
| **RAM** | 512 MB | 1–2 GB |
| **Storage** | 1 GB free | 5 GB+ (for media files and logs) |
| **Network** | Stable internet or LAN | Wired Gigabit LAN |

#### Operating System
| OS | Version |
|:---|:--------|
| **Ubuntu** | 20.04 LTS, 22.04 LTS, or 24.04 LTS (recommended) |
| **Debian** | 11 (Bullseye) or later |
| Other RHEL/Arch-based distros should work but are untested. |

#### System Packages (via `apt`)
```bash
sudo apt install python3 python3-pip python3-venv git
```

#### Python Packages (via `pip` in virtualenv)
```
flask
flask-socketio
eventlet
gunicorn
firebase-admin
python-dotenv
```
> Install with: `pip install -r linux_deploy/requirements.txt`

#### Process Manager (choose one)
| Tool | Notes |
|:-----|:------|
| **PM2** *(recommended)* | Already available if Node.js apps are hosted on the same server. Handles auto-restart when the update API triggers `os._exit(1)`. |
| **systemd** | Use `linux_deploy/qms.service`. Copy to `/etc/systemd/system/` and enable. |

#### Reverse Proxy (choose one, optional but recommended)
| Tool | Config File | Notes |
|:-----|:------------|:------|
| **Nginx** | `linux_deploy/nginx_qms.conf` | Preferred. Handles WebSocket upgrades for Socket.IO. |
| **Apache** | `linux_deploy/apache_qms.conf` | Requires `mod_proxy`, `mod_proxy_wstunnel`, `mod_rewrite`. |

> ⚠️ **WebSocket support is mandatory** in the reverse proxy configuration. The application uses Socket.IO (WebSockets) for real-time updates. Misconfiguring this will break the display and staff panel.

---

## Client Requirements

### Staff Panel (PC)

The staff counter PC used to call patient numbers.

| Requirement | Detail |
|:------------|:-------|
| **Browser** | Microsoft Edge (latest) — launched via `3.LaunchPanel.bat` in app mode |
| **Alternative Browser** | Any modern browser (Chrome, Firefox) — access `http://<server-ip>:5000/` |
| **Network** | Must be on the same LAN as the server, or have access to the server's IP |
| **Screen** | Any resolution; interface is mobile-responsive |
| **Input** | Keyboard and/or touchscreen (virtual keypad supported) |
| **Audio** | Not required on staff panel |

### Public Display Screen

The large screen in the patient waiting area showing called numbers and health media.

| Requirement | Detail |
|:------------|:-------|
| **Browser** | Google Chrome (latest) — launched via `2.LaunchDisplay.bat` in kiosk mode |
| **Network** | Must be on the same LAN as the server |
| **Screen Resolution** | 1920×1080 (Full HD) recommended; supports other resolutions |
| **Audio Output** | Required — the display plays audio chimes and Text-to-Speech announcements |
| **Video Playback** | Hardware-accelerated video playback recommended (for MP4/WebM media loop) |
| **User Interaction** | Requires a single click on first load to enable browser audio autoplay |
| **OS** | Windows 10/11 (with Chrome installed) |

### Patient Mobile Portal

A Progressive Web App (PWA) for patients to check their queue status on their own devices.

| Requirement | Detail |
|:------------|:-------|
| **URL** | [https://qms-hybrid.firebaseapp.com](https://qms-hybrid.firebaseapp.com) (hosted on Firebase) |
| **Browser** | Any modern mobile browser (Chrome for Android, Safari for iOS) |
| **Network** | Patient device requires internet access (connects to Firebase, not the local server) |
| **Push Notifications** | Supported on Android (Chrome). iOS support pending testing. |
| **Installation** | Can be installed as a PWA (Add to Home Screen) |

---

## Network Requirements

| Requirement | Detail |
|:------------|:-------|
| **LAN** | All server and client devices must be on the same local network |
| **Server IP** | Assign a **static IP** to the server machine (currently configured as `10.77.232.94`) |
| **Default Port** | `5000` (TCP) — must be open/accessible on the server firewall |
| **WebSocket** | The network must not block WebSocket connections (port 5000 or proxied via 80/443) |
| **Internet Access** | Required on the **server** for Firebase cloud sync, push notifications, and the auto-update feature |
| **Firewall** | Allow inbound TCP on port `5000` (or `80`/`443` if using a reverse proxy) |

---

## Cloud / External Services

These external services are required for full functionality. The app will still run locally without them, but cloud sync and push notifications will be unavailable.

| Service | Purpose | Required? |
|:--------|:--------|:----------|
| **Firebase Realtime Database** | Syncs live queue status to the cloud for the patient portal | Required for patient portal |
| **Firebase Cloud Messaging (FCM)** | Sends push notifications to patients when their number is called | Required for push notifications |
| **Firebase Hosting** | Hosts the patient-facing PWA at `qms-hybrid.firebaseapp.com` | Required for patient portal |
| **GitHub** (`pfredz-hsgt/qms-opd3`) | Source repository; used by the in-app auto-update feature | Required for auto-update |

#### Firebase Setup Requirements
- A Firebase project must be created at [Firebase Console](https://console.firebase.google.com/).
- **`serviceAccountKey.json`** — The Firebase Admin SDK credentials file. Must be placed in the project root directory. **This file is secret and must not be committed to version control.**
- Firebase Realtime Database must be enabled with the **Asia Southeast 1** region (`asia-southeast1`).
- Firebase Cloud Messaging must be enabled in the Firebase project.

---

## Environment Variables

The server behaviour can be customized via environment variables (or set directly in `app.py` defaults):

| Variable | Default | Description |
|:---------|:--------|:------------|
| `SECRET_KEY` | `a_default_secret_key_change_in_production` | Flask session secret key. **Change this in production.** |
| `HOST` | `0.0.0.0` | Network interface to bind to. `0.0.0.0` allows LAN access. |
| `PORT` | `5000` | TCP port the server listens on. |
| `DEBUG` | `False` | Enable Flask debug mode. Set to `False` in production. |
| `MAX_CALLS` | `4` | Number of recent calls to keep in memory and display on screen. |
| `MEDIA_FOLDER` | `static/media` | Path to the folder containing display videos (`.mp4`, `.webm`, `.ogg`). |
| `LOGS_FOLDER` | `logs` | Path to the folder where CSV call logs are written. |
| `CSV_FILENAME` | `call_logs.csv` | Filename of the CSV call log. |
| `CORS_ORIGINS` | `*` | Allowed CORS origins for Socket.IO connections. Restrict in production. |

---

## Directory & Storage Requirements

| Path | Purpose | Notes |
|:-----|:--------|:------|
| `static/media/` | Video files played on the display screen during idle | Accepts `.mp4`, `.webm`, `.ogg`. Add/remove files freely; app auto-detects them. |
| `logs/` | CSV call log files | Auto-created on startup. Ensure write permissions. |
| `serviceAccountKey.json` | Firebase Admin SDK credentials | Must be manually placed in the project root. Not included in the repository. |
| `templates/` | HTML templates for Staff Panel, Display, and Dashboard | Part of the repository. Do not move. |
| `public/` | Patient PWA files (also deployed to Firebase Hosting) | Served locally at `/portal` for testing. |

---

## Quick Start Summary

### Windows (Simplest)
1. Install Python 3.8+
2. Run: `pip install flask flask-socketio firebase-admin eventlet`
3. Place `serviceAccountKey.json` in the project root
4. Double-click `deploy/1.Start-Server.bat`
5. Open `deploy/2.LaunchDisplay.bat` on the display PC
6. Open `deploy/3.LaunchPanel.bat` on each staff counter PC

### Linux (Production)
1. Install Python 3.8+, Git: `sudo apt install python3 python3-venv git`
2. Clone repo: `git clone https://github.com/pfredz-hsgt/qms-opd3.git qms-opd`
3. Create virtualenv: `python3 -m venv venv && source venv/bin/activate`
4. Install deps: `pip install -r linux_deploy/requirements.txt`
5. Place `serviceAccountKey.json` in the project root
6. Start with PM2: `pm2 start app.py --name "qms-opd" --interpreter ./venv/bin/python`
7. (Optional) Configure Nginx using `linux_deploy/nginx_qms.conf`
