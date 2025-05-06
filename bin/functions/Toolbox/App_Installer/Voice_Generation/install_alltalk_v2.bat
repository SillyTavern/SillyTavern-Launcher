@echo off

:install_alltalk_v2
title STL [INSTALL ALLTALK V2]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Voice Generation / Install AllTalk V2%reset%
echo ---------------------------------------------------------------
REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 0. Cancel

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
set "gpu_info="
for /f "tokens=*" %%i in ('powershell -Command "Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name -First 1"') do (
    set "gpu_info=%%i"
)

echo.
echo %blue_bg%╔════ GPU INFO ═════════════════════════════════╗%reset%
echo %blue_bg%║                                               ║%reset%
echo %blue_bg%║* %gpu_info:~1%                   ║%reset%
echo %blue_bg%║                                               ║%reset%
echo %blue_bg%╚═══════════════════════════════════════════════╝%reset%
echo.

endlocal
set /p gpu_choice=Enter number corresponding to your GPU: 

REM GPU menu - Backend
REM Set the GPU choice in an environment variable for choise callback
set "GPU_CHOICE=%gpu_choice%"

REM Check the user's response
if "%gpu_choice%"=="1" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA
    goto :install_alltalk_v2_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_alltalk_v2_pre
) else if "%gpu_choice%"=="0" (
    goto :app_installer_voice_generation
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_alltalk_v2
)
:install_alltalk_v2_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing AllTalk...

REM Check and create folder
if not exist "%voice_generation_dir%" (
    mkdir "%voice_generation_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "voice-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "voice-generation" folder already exists.%reset%
)
cd /d "%voice_generation_dir%"

REM Clone repository
set max_retries=3
set retry_count=0

:retry_install_alltalk_v2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning alltalk_tts repository...
git clone -b alltalkbeta https://github.com/erew123/alltalk_tts

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_alltalk_v2
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :home
)
cd /d "%alltalk_v2_install_path%"


REM Detect Windows version using Build Number
for /f %%i in ('powershell -NoProfile -Command "(Get-ItemProperty 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion').CurrentBuild"') do (
    set "BuildNumber=%%i"
)

REM Get OS Display Version (21H2, 22H2, etc.) with fallback
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "try { $v = (Get-ComputerInfo | Select-Object -ExpandProperty OSDisplayVersion); if (!$v) { (Get-ItemProperty 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion').ReleaseId } else { $v } } catch { 'Unknown' }"`) do (
    set "OSDisplayVersion=%%i"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected OS Build Number: %cyan_fg_strong%%BuildNumber%%reset%
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% OS Display Version: %cyan_fg_strong%%OSDisplayVersion%%reset%

set /a BuildNumberInt=%BuildNumber%
if %BuildNumberInt% GEQ 22000 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Windows 11 detected - Using Windows 11 SDK
    set VS_COMMAND=VisualStudioSetup.exe --add Microsoft.VisualStudio.Component.VC.v143.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22621 --passive --wait
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Windows 10 detected - Using Windows 10 SDK
    set VS_COMMAND=VisualStudioSetup.exe --add Microsoft.VisualStudio.Component.VC.v143.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --passive --wait
)

:install_vs
REM Install Visual Studio Community
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Visual Studio Community...
curl -L -o "VisualStudioSetup.exe" "https://aka.ms/vs/17/release/vs_community.exe"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Python C and SDK Requirements...
%VS_COMMAND%

REM Activate Miniconda and create environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%alltalkv2%reset%
call conda create -n alltalkv2 python=3.11.9 -y
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%alltalkv2%reset%
call conda activate alltalkv2

REM Use the GPU choice made earlier to install requirements for alltalkv2
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda environment: %cyan_fg_strong%alltalkv2%reset%
    call conda install -y pytorch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 pytorch-cuda=12.1 -c pytorch -c nvidia

    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing deepspeed...
    curl -LO https://github.com/erew123/alltalk_tts/releases/download/DeepSpeed-14.0/deepspeed-0.14.0+ce78a63-cp311-cp311-win_amd64.whl
    pip install deepspeed-0.14.0+ce78a63-cp311-cp311-win_amd64.whl
    del deepspeed-0.14.0+ce78a63-cp311-cp311-win_amd64.whl
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD dependencies...
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
)

:install_alltalk_v2_final
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing eSpeak NG...
msiexec /i system\espeak-ng\espeak-ng-X64.msi /qn

echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing Faiss...
call conda install -y pytorch::faiss-cpu

echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing FFmpeg...
call conda install -y -c conda-forge "ffmpeg=*=*gpl*"
call conda install -y -c conda-forge "ffmpeg=*=h*_*" --no-deps

echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements from requirements_standalone.txt
pip install -r system\requirements\requirements_standalone.txt

echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Updating Gradio...
pip install gradio==4.32.2 REM 4.44.1 is bugged

REM Downgrade transformers for XTTS streaming support
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Updating transformers...
pip install transformers==4.42.4

REM Temporary fix for Exception in ASGI application
pip install pydantic==2.10.6

echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalkv2]%reset% %blue_fg_strong%[INFO]%reset% Installing Parler...
pip install -r system\requirements\requirements_parler.txt
call conda clean --all --force-pkgs-dirs -y

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%AllTalk V2 installed successfully%reset%
pause
goto :app_installer_voice_generation
