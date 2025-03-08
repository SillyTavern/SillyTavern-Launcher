<a name="readme-top"></a>

<div align="center">

<img height="160" src="st-launcher.ico">

<h1 align="center">SillyTavern Launcher - (STL)</h1>

<p align="center">
    <a href="README.md">English</a> | <a href="README-zh-cn.md">中文</a> | 繁體中文 | <a href="README-ja-jp.md">日本語</a> | <a href="README-ko-kr.md">한국어</a> | <a href="README-nl-nl.md">Nederlands</a> | <a href="README-fr-fr.md">Français</a> | <a href="README-vi-vn.md">Tiếng Việt</a> | <a href="README-pt-pt.md">Português</a> | <a href="README-es-es.md">Español</a>
  
[![GitHub Stars](https://img.shields.io/github/stars/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/network)
[![GitHub Issues](https://img.shields.io/github/issues/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/pulls)
</div>

# 🔧 安裝指南
## 🪟 Windows
1. 按下 **`Windows + R`** 開啟「執行」對話框後，輸入以下指令安裝 Git：
```shell
cmd /c winget install -e --id Git.Git
```
2. 按下 **`Windows + E`** 打開檔案總管，前往要安裝啟動器的資料夾，在地址欄輸入 `cmd` 並按 Enter ，執行：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher && start installer.bat
```

## 🐧 Linux
1. 開啟您偏好的終端機（Terminal）並安裝 Git
2. 使用以下指令從 GitHub 複製 SillyTavern Launcher：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
3. 執行安裝腳本（`installer.sh`）：
```shell
chmod +x install.sh && ./install.sh
```
4. 安裝完成後啟動 SillyTavern Launcher（`launcher.sh`）：
```shell
chmod +x launcher.sh && ./launcher.sh
```

## 🍎 Mac
1. 開啟終端機（Terminal）並安裝 Homebrew：
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2. 安裝 Git：
```shell
brew install git
```
3. 使用以下指令從 GitHub 複製 SillyTavern Launcher：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
4. 執行安裝腳本（`installer.sh`）：
```shell
chmod +x install.sh && ./install.sh
```
5. 安裝完成後啟動 SillyTavern Launcher（`launcher.sh`）：
```shell
chmod +x launcher.sh && ./launcher.sh
```

# ✨ 功能
## **核心工具**
管理 SillyTavern 及其他應用程式的關鍵工具

### **支援**
- SillyTavern
- 7-Zip, FFmpeg, Node.js, yq, Visual Studio BuildTools, CUDA Toolkit, Tailscale, w64devkit

### **功能**
- 安裝、解除安裝與設定核心工具
- 透過選單管理環境變數與設定

## **文字生成應用**
設定與管理文字生成模型與其應用程式

### **支援**
- Text Generation Web UI (oobabooga)
- KoboldCPP
- KoboldCPP Raw
- LlamaCPP
- TabbyAPI
- TabbyAPI（SillyTavern 擴充功能版）

### **功能**
- 透過選單安裝、啟動、移除並自訂各類文字生成模組

## **影像生成應用**
管理 AI 圖像生成應用程式。

### **支援**
- Stable Diffusion Web UI
- Stable Diffusion Web UI Forge
- ComfyUI
- Fooocus
- Ostris AI Toolkit

### **功能**
- 透過選單安裝、啟動、移除並調整設定

## **Voice Generation Apps**
Manage voice synthesis and processing tools.

### **語音合成應用**
- XTTS
- AllTalk
- AllTalk v2（包含診斷與微調模式）
- RVC（Retrieval-based Voice Conversion，支援即時語音轉換）

### **功能**
- 安裝、啟動、移除並調整語音處理工具的設定

## **Additional Features**
- **備份與還原**：建立並還原 SillyTavern 的備份
- **SSL 支援**：透過選單建立 SSL 憑證
- **故障排除工具**：
  - 檢測 VPN 問題
  - 取得 GPU 資訊
  - 檢查網路埠
  - 解決 GitHub 衝突
  - 清除快取（Node.js、npm、pip）
  - 匯出診斷資料
  - 重新啟動啟動器
  - Discord 伺服器
- **應用程式管理**：自動更新、切換不同的 Git 分支、安裝與移除應用程式
- **日誌記錄**：可在 `logs/` 目錄中查看日誌，以便排除錯誤
- **自訂設定**：在 `settings/` 目錄中設定快捷鍵與模組


# 有任何有疑問或建議？

| [![][discord-shield-badge]][discord-link] | [加入我們的 Discord 社群！](https://discord.gg/sillytavern) 取得支援、分享角色設定與 AI 提示詞。 |
| :---------------------------------------- | :------------------------------------------------------------------------------------------------------- |

# 截圖
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
