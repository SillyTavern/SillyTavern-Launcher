@echo off

:install_alltalk
title STL [INSTALL ALLTALK]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Voice Generation / Install AllTalk%reset%
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
    goto :install_alltalk_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_alltalk_pre
) else if "%gpu_choice%"=="0" (
    goto :app_installer_voice_generation
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_alltalk
)
:install_alltalk_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing AllTalk...

REM Check if the folder exists
if not exist "%voice_generation_dir%" (
    mkdir "%voice_generation_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "voice-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "voice-generation" folder already exists.%reset%
)
cd /d "%voice_generation_dir%"

set max_retries=3
set retry_count=0

:retry_install_alltalk
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning alltalk_tts repository...
git clone https://github.com/erew123/alltalk_tts.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_alltalk
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :home
)
cd /d "%alltalk_install_path%"

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named alltalk
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%alltalk%reset%
call conda create -n alltalk python=3.11.5 -y

REM Activate the alltalk environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%alltalk%reset%
call conda activate alltalk

REM Use the GPU choice made earlier to install requirements for alltalk
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalk]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%alltalk%reset%
    pip install torch==2.2.0+cu121 torchaudio==2.2.0+cu121 --upgrade --force-reinstall --extra-index-url https://download.pytorch.org/whl/cu121
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalk]%reset% %blue_fg_strong%[INFO]%reset% Installing deepspeed...
    curl -LO https://github.com/erew123/alltalk_tts/releases/download/DeepSpeed-14.0/deepspeed-0.14.0+ce78a63-cp311-cp311-win_amd64.whl
    pip install deepspeed-0.14.0+ce78a63-cp311-cp311-win_amd64.whl
    del deepspeed-0.14.0+ce78a63-cp311-cp311-win_amd64.whl
    goto :install_alltalk_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalk]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch in conda enviroment: %cyan_fg_strong%alltalk%reset%
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
    goto :install_alltalk_final
)
:install_alltalk_final
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[alltalk]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements from requirements_standalone.txt
pip install -r system\requirements\requirements_standalone.txt

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%AllTalk installed successfully%reset%
pause
goto :app_installer_voice_generation