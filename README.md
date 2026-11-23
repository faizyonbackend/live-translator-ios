# 🌐 Live Translator (100% Offline & Private iOS App)

A native iOS live language translation application that works **completely offline with zero APIs and 100% on-device privacy**.

---

## 🚀 Key Features

* **100% Offline & Private:** Built on Apple's native on-device neural engine frameworks (`TranslationSession`, `SFSpeechRecognizer`, and `AVSpeechSynthesizer`). Zero network requests or audio data ever leaves the device.
* **Dual-Speaker Split Screen:** Designed for face-to-face conversation. Includes a flip mode (180° rotation) so two people sitting across a table can each read their own side comfortably.
* **Real-Time Speech-to-Text:** Live voice transcription on-device.
* **Automatic Voice Playback:** Speaks the translated result aloud in natural localized system voices.
* **Tiny App Footprint:** Unlike heavy open-source models (which take 1+ GB), this app relies on Apple's system translation models and is under **15 MB**.

---

## 🛠️ Project Structure

```
live-translator-ios/
├── .github/
│   └── workflows/
│       └── build.yml               # Free automated macOS cloud build pipeline
├── Sources/
│   ├── LiveTranslatorApp.swift      # Main SwiftUI entry point
│   ├── Info.plist                  # Microphone & Speech recognition privacy descriptions
│   ├── Models/
│   │   └── Language.swift          # Supported offline language definitions
│   ├── Services/
│   │   ├── SpeechRecognizer.swift  # 100% on-device STT (Speech framework)
│   │   └── SpeechSynthesizer.swift # On-device TTS (AVFoundation)
│   └── Views/
│       ├── ContentView.swift       # Face-to-face conversation UI
│       └── LanguagePickerView.swift# Language selector modal
├── project.yml                     # XcodeGen configuration
├── .gitignore
└── README.md
```

---

## 📦 How to Build from Windows (No Mac Needed!)

Since you are developing on Windows, this project uses **GitHub Actions' free macOS cloud runners** to compile the app into an installable `.ipa` file:

### Step 1: Initialize Git and Push to GitHub

Open PowerShell in `E:\codes\projects\live-translator-ios`:

```powershell
cd E:\codes\projects\live-translator-ios
git init
git add .
git commit -m "Initial commit for Offline Live Translator"
```

Create a new repository on your GitHub account (e.g., `live-translator-ios`), then push:

```powershell
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/live-translator-ios.git
git push -u origin main
```

---

### Step 2: Automatic Cloud Compilation

1. As soon as you push to GitHub, open the **Actions** tab on your GitHub repository.
2. You will see the **"Build iOS Offline Live Translator"** workflow running on a macOS cloud runner.
3. In about 2–3 minutes, the build will complete with a green checkmark.
4. Click on the completed workflow run. Under **Artifacts** at the bottom, download **`LiveTranslator-iOS-IPA`**.

---

### Step 3: Install onto Your iPhone from Windows

You can install the `.ipa` directly onto your iPhone over a standard USB cable using free Windows tools:

#### Using Sideloadly (Recommended for Windows):
1. Download **[Sideloadly](https://sideloadly.io/)** (Free for Windows).
2. Connect your iPhone to your Windows PC using your USB cable (tap "Trust this computer" on your iPhone if prompted).
3. Open Sideloadly:
   * Drag and drop `LiveTranslator.ipa` into Sideloadly.
   * Enter your standard Apple ID (used solely to sign the app for personal use).
   * Click **Start**.
4. Once completed, the app will appear on your iPhone home screen!

> **First-time iOS trust setup:**  
> On your iPhone, go to **Settings > General > VPN & Device Management**, tap your Apple ID, and tap **"Trust"**.

---

## 🌍 Downloading Offline Languages on iPhone

When you first use translation on your iPhone:
1. iOS will prompt you to download the offline language pack for the selected language pair (e.g., Spanish, French, German).
2. You can also pre-download offline languages at any time on your iPhone by going to:  
   **Settings ➔ Translate ➔ Downloaded Languages**.
3. Once downloaded, you can turn on **Airplane Mode** and test live translation anywhere in the world with zero internet!
