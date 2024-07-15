<a name="readme-top"></a>

<div align="center">

<img height="160" src="st-launcher.ico">

<h1 align="center">SillyTavern Launcher - (STL)</h1>

<p align="center">
    【<a href="README-zh-cn.md">English</a> | 中文 | <a href="README-ja-jp.md">Japanese</a> | <a href="README-ko-kr.md">Korean</a> | <a href="README-nl-nl.md">Dutch</a> | <a href="README-fr-fr.md">French</a> | <a href="README-vi-vn.md">Vietnamese</a> | <a href="README-pt-pt.md">Portuguese</a> | <a href="README-es-es.md">Spanish</a>】
  
[![GitHub Stars](https://img.shields.io/github/stars/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/network)
[![GitHub Issues](https://img.shields.io/github/issues/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/SillyTavern/SillyTavern-Launcher.svg)](https://github.com/SillyTavern/SillyTavern-Launcher/pulls)
</div>

🔧 # 安装
## 🖥️ window
方法一
1.安装git（安装过git可以跳过），在键盘上：按“WINDOWS + R”打开“运行”对话框。然后，运行以下命令安装 git：
```shell
cmd /c winget install -e --id Git.Git
```
2. 在键盘上：按“WINDOWS + E”** 打开文件资源管理器，然后导航到要安装启动器的文件夹。进入所需文件夹后，在地址栏中键入“cmd”，然后按回车键。然后，运行以下命令：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher && start installer.bat
```

## 🐧 Linux
1. 打开你喜欢的终端并安装 git
2. Git 克隆 Sillytavern-Launcher：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
3. 以以下方式开始 installer.sh：
```shell
chmod +x install.sh && ./install.sh
```
4. 安装后，通过以下方式启动 launcher.sh：
```shell
chmod +x launcher.sh && ./launcher.sh
```


## 🍎 Mac
1. 打开终端并安装 brew：
```shell
/bin/bash -c “$（curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh）”
```
2. 使用以下命令安装 git：
```shell
brew install git
```
3. Git 克隆 Sillytavern-Launcher：
```shell
git clone https://github.com/SillyTavern/SillyTavern-Launcher.git && cd SillyTavern-Launcher
```
4. 以以下方式开始 installer.sh：
```shell
chmod +x install.sh && ./install.sh
```
5. 安装后，通过以下方式启动 launcher.sh：
```shell
chmod +x launcher.sh && ./launcher.sh
```

✨ # 特性
* 能够自动安装带有可选应用的核心app：
  * SillyTavern,
  * Extras,
  * XTTS,
  * 7-Zip,
  * FFmpeg,
  * Node.js,
  * yq,
  * Visual Studio BuildTools,
  * CUDA Toolkit

* 能够自动安装文本完成应用程序：
  * Text generation web UI oobabooga
  * koboldcpp
  * TabbyAPI

* 能够自动安装图像生成应用程序：
  * Stable Diffusion web UI
  * Stable Diffusion web UI Forge
  * ComfyUI
  * Fooocus

*自动更新所有应用程序
*备份和恢复SillyTavern
* 开关分支
* 模块编辑器
* 应用程序安装程序和卸载程序来管理应用程序
* 故障排除菜单可解决最常见的问题

#问题或建议？

|[![][discord-shield-badge]][discord-link] |[加入我们的 Discord 社区！](https://discord.gg/sillytavern)获得支持，分享角色和提示。|
|:---------------------------------------- |:------------------------------------------------------------------------------------------------------- |

# Screenshots
<img width="400" alt="image" src="https://github.com/SillyTavern/SillyTavern-Launcher/assets/61471128/96775287-df23-4976-980f-a0ce4dead9a5">
<img width="400" alt="image" src="https://github.com/SillyTavern/SillyTavern-Launcher/assets/61471128/b080c199-4b26-4246-931e-92cc0c4b47eb">

<div align="right">

[![][back-to-top]](#readme-top)
    
</div>


<!-- LINK GROUP -->
[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square
[discord-link]: https://discord.gg/sillytavern
[discord-shield]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=flat-square
[discord-shield-badge]: https://img.shields.io/discord/1100685673633153084?color=5865F2&label=discord&labelColor=black&logo=discord&logoColor=white&style=for-the-badge
