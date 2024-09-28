<a name="readme-top"></a>

<div align="center">

<img height="160" src="st-launcher.ico">

<h1 align="center">SillyTavern Launcher - (STL)</h1>

<p align="center">
    【English | <a href="README-de_de.md">German</a> | <a href="README-zh-cn.md">Chinese</a> | <a href="README-ja-jp.md">Japanese</a> | <a href="README-ko-kr.md">Korean</a> | <a href="README-nl-nl.md">Dutch</a> | <a href="README-fr-fr.md">French</a> | <a href="README-vi-vn.md">Vietnamese</a> | <a href="README-pt-pt.md">Portuguese</a> | <a href="README-es-es.md">Spanish</a>】
  
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
* Ability to automatically install Core apps with optional apps:
  * SillyTavern,
  * Extras,
  * XTTS,
  * 7-Zip,
  * FFmpeg,
  * Node.js,
  * yq,
  * Visual Studio BuildTools,
  * CUDA Toolkit

* Ability to automaticly install Text Completion apps:
  * Text generation web UI oobabooga
  * koboldcpp
  * TabbyAPI

* Ability to automaticly install Image Generation apps:
  * Stable Diffusion web UI
  * Stable Diffusion web UI Forge
  * ComfyUI
  * Fooocus

* Auto update all apps
* Backup and Restore SillyTavern
* Switch branch
* Module editors
* App installer & uninstaller to manage applications
* Troubleshooting menu to fix most common problems

# Questions or suggestions?

| [![][discord-shield-badge]][discord-link] | [Join our Discord community!](https://discord.gg/sillytavern) Get support, share characters and prompts. |
| :---------------------------------------- | :------------------------------------------------------------------------------------------------------- |

# Screenshots
<img width="400" alt="image" src="https://github.com/user-attachments/assets/b4c69b21-f8ce-4ee8-81c1-78de8204b95e">
<img width="400" alt="image" src="https://github.com/user-attachments/assets/f821a4bb-4e52-47f3-b714-13621dd25991">


<div align="right">

[![][back-to-top]](#readme-top)
    
</div>


<!-- LINK GROUP -->
[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square
[discord-link]: https://discord.gg/sillytavern
[discord-shield]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=flat-square
[discord-shield-badge]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=for-the-badge
