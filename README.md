<a name="readme-top"></a>

<div align="center">

<img height="160" src="st-launcher.ico">

<h1 align="center">SillyTavern Launcher - (STL)</h1>

<p align="center">
    【English | <a href="README-zh-cn.md">Chinese</a> | <a href="README-ja-jp.md">Japanese</a> | <a href="README-ko-kr.md">Korean</a> | <a href="README-nl-nl.md">Dutch</a> | <a href="README-fr-fr.md">French</a> | <a href="README-vi-vn.md">Vietnamese</a> | <a href="README-pt-pt.md">Portuguese</a> | <a href="README-es-es.md">Spanish</a>】
  
[![GitHub Stars](https://img.shields.io/github/stars/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/network)
[![GitHub Issues](https://img.shields.io/github/issues/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/pulls)
</div>

# 🔧 Installation
## 🪟 Windows
1.  On your keyboard: press **`WINDOWS + R`** to open Run dialog box. Then, run the following command to install git:
```shell
cmd /c winget install -e --id Git.Git
```
2. On your keyboard: press **`WINDOWS + E`** to open File Explorer, then navigate to the folder where you want to install the launcher. Once in the desired folder, type `cmd` into the address bar and press enter. Then, run the following command:
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher && start installer.bat
```

## 🐧 Linux
1. Open your favorite terminal and install git
2. Git clone the Sillytavern-Launcher with: 
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
3. Start the installer.sh with: 
```shell
chmod +x install.sh && ./install.sh
```
4. After installation start the launcher.sh with: 
```shell
chmod +x launcher.sh && ./launcher.sh
```

## 🍎 Mac
1. Open a terminal and install brew with: 
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2. Install git with: 
```shell
brew install git
```
3. Git clone the Sillytavern-Launcher with: 
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
4. Start the installer.sh with: 
```shell
chmod +x install.sh && ./install.sh
```
5. After installation start the launcher.sh with: 
```shell
chmod +x launcher.sh && ./launcher.sh
```

# ✨ Features
## **Core Utilities**
Manage essential tools for SillyTavern and other applications.

### **Supported Apps:**
- SillyTavern
- 7-Zip, FFmpeg, Node.js, yq, Visual Studio BuildTools, CUDA Toolkit, Tailscale, w64devkit

### **Functions:**
- Install, uninstall, and configure core utilities
- Edit environment variables and configurations via menu options

## **Text Completion Apps**
Set up and manage text generation platforms.

### **Supported Apps:**
- Text Generation Web UI (oobabooga)
- KoboldCPP
- KoboldCPP Raw
- LlamaCPP
- TabbyAPI
- TabbyAPI with ST Extensions

### **Functions:**
- Install, launch, uninstall, and customize modules through menu selections

## **Image Generation Apps**
Handle image generation platforms.

### **Supported Apps:**
- Stable Diffusion Web UI
- Stable Diffusion Web UI Forge
- ComfyUI
- Fooocus
- Ostris AI Toolkit

### **Functions:**
- Install, launch, uninstall, and tweak settings via the menu system

## **Voice Generation Apps**
Manage voice synthesis and processing tools.

### **Supported Apps:**
- XTTS
- AllTalk
- AllTalk v2 (with diagnostic and fine-tuning modes)
- RVC (Retrieval-based Voice Conversion, including real-time support)

### **Functions:**
- Install, launch, uninstall, and adjust configurations for voice generation tools

## **Additional Features**
- **Backup and Restore:** Create and restore SillyTavern backups.
- **SSL Support:** Generate SSL certificates via a dedicated menu.
- **Troubleshooting:**
  - Detect VPN issues
  - Gather GPU information
  - Check ports
  - Resolve GitHub conflicts
  - Clear caches (Node.js, npm, pip)
  - Export diagnostic data
  - Restart the launcher
  - Discord Servers
- **App Management:** Auto-update, switch branches, manage installations/uninstallations.
- **Logging:** View logs for troubleshooting (`logs/` directory).
- **Custom Settings:** Configure custom shortcuts and modules (`settings/` directory).


# Questions or suggestions?

| [![][discord-shield-badge]][discord-link] | [Join our Discord community!](https://discord.gg/sillytavern) Get support, share characters and prompts. |
| :---------------------------------------- | :------------------------------------------------------------------------------------------------------- |

# Screenshots
## Windows
<img width="400" alt="image" src="https://github.com/user-attachments/assets/ac9edfe4-b5a7-4d7f-a21c-acd702b3d2fe">
<img width="400" alt="image" src="https://github.com/user-attachments/assets/8830d523-87e1-4e0a-8fb0-75d8a48d763f">

## Linux
<img width="400" alt="image" src="https://github.com/user-attachments/assets/e1db688d-7cb0-4fbc-825c-3560ca4b901d">
<img width="400" alt="image" src="https://github.com/user-attachments/assets/180b9fbb-e4b4-4992-bb0c-72386f30a513">


<div align="right">

[![][back-to-top]](#readme-top)
    
</div>


<!-- LINK GROUP -->
[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square
[discord-link]: https://discord.gg/sillytavern
[discord-shield]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=flat-square
[discord-shield-badge]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=for-the-badge
