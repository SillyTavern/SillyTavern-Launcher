<a name="readme-top"></a>

<div align="center">

<img height="160" src="st-launcher.ico">

<h1 align="center">SillyTavern Launcher - (STL)</h1>

<p align="center">
    【<a href="README.md">English</a> | German | <a href="README-zh-cn.md">Chinese</a> | <a href="README-ja-jp.md">Japanese</a> | <a href="README-ko-kr.md">Korean</a> | <a href="README-nl-nl.md">Dutch</a> | <a href="README-fr-fr.md">French</a> | <a href="README-vi-vn.md">Vietnamese</a> | <a href="README-pt-pt.md">Portuguese</a> | <a href="README-es-es.md">Spanish</a>】
  
[![GitHub Stars](https://img.shields.io/github/stars/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/network)
[![GitHub Issues](https://img.shields.io/github/issues/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/pulls)
</div>

# 🔧 Installation
## 🪟 Windows
1.  Auf deiner Tastatur: Drücke **`WINDOWS + R`**, um das Dialogfeld Ausführen zu öffnen. Führe dann den folgenden Befehl aus, um Git zu installieren:
```shell
cmd /c winget install -e --id Git.Git
```
2. Auf deiner Tastatur: Drücke **`WINDOWS + E`** , um den Datei-Explorer zu öffnen, und navigiere dann zu dem Ordner, in dem du den Launcher installieren möchtest. Sobald du im gewünschten Ordner bist, gib `cmd` in die Adressleiste ein und drücke die Eingabetaste. Führe dann den folgenden Befehl aus:
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher && start installer.bat
```

## 🐧 Linux
1. Öffne dein bevorzugtes Terminal und installiere git
2. Git klone den Sillytavern-Launcher mit: 
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
3. Starte installer.sh mit: 
```shell
chmod +x install.sh && ./install.sh
```
4. Nach der Installation starte die Datei launcher.sh mit: 
```shell
chmod +x launcher.sh && ./launcher.sh
```

## 🍎 Mac
1. Öffne ein Terminal und installiere brew mit: 
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2. Installiere git mit: 
```shell
brew install git
```
3. Git klone den Sillytavern-Launcher mit: 
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
4. Starte installer.sh mit: 
```shell
chmod +x install.sh && ./install.sh
```
5. Nach der Installation starte die Datei launcher.sh mit: 
```shell
chmod +x launcher.sh && ./launcher.sh
```

# ✨ Features
* Möglichkeit zur automatischen Installation von Core-Apps mit optionalen Apps:
  * SillyTavern,
  * Extras,
  * XTTS,
  * 7-Zip,
  * FFmpeg,
  * Node.js,
  * yq,
  * Visual Studio BuildTools,
  * CUDA Toolkit

* Möglichkeit zur automatischen Installation von Textvervollständigungs-Apps:
  * Web-Benutzeroberfläche zur Textgenerierung oobabooga
  * koboldcpp
  * TabbyAPI

* Möglichkeit zur automatischen Installation von Image Generation-Apps:
  * Stable Diffusion web UI
  * Stable Diffusion web UI Forge
  * ComfyUI
  * Fooocus

* Alle Apps automatisch aktualisieren
* Sichern und Wiederherstellen von SillyTavern
* Zweig wechseln
* Modul-Editoren
* App-Installer und Deinstallationsprogramm zum Verwalten von Anwendungen
* Menü zur Fehlerbehebung zur Behebung der häufigsten Probleme

# Fragen oder Anregungen?

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
