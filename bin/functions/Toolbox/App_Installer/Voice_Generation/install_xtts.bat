@echo off

:install_xtts
title STL [INSTALL XTTS]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Voice Generation / Install XTTS%reset%
echo ---------------------------------------------------------------
REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None CPU-only mode
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
    goto :install_xtts_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_xtts_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Using CPU-only mode
    goto :install_xtts_pre
) else if "%gpu_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_xtts
)
:install_xtts_pre
REM Check if the folder exists
if not exist "%voice_generation_dir%" (
    mkdir "%voice_generation_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "voice-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "voice-generation" folder already exists.%reset%
)
cd /d "%voice_generation_dir%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing XTTS...

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named xtts
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%xtts%reset%
call conda create -n xtts python=3.10 -y

REM Activate the xtts environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%xtts%reset%
call conda activate xtts

REM Use the GPU choice made earlier to install requirements for XTTS
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch==2.1.1+cu118 torchvision==0.16.1+cu118  torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
    goto :install_xtts_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
    goto :install_xtts_final
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing CPU-only version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch torchvision torchaudio
    goto :install_xtts_final
)
:install_xtts_final
REM Clone the xtts-api-server repository for voice examples
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning xtts-api-server repository...
git clone https://github.com/daswer123/xtts-api-server.git
cd /d "xtts-api-server"

REM Create requirements-custom.txt to install pip requirements
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Creating file: requirements-custom.txt%reset%
echo xtts-api-server > requirements-custom.txt
echo pydub >> requirements-custom.txt
echo stream2sentence >> requirements-custom.txt
echo spacy==3.7.4 >> requirements-custom.txt

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements in conda enviroment: %cyan_fg_strong%xtts%reset%
pip install -r requirements-custom.txt

REM Create folders for xtts
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating xtts folders...
mkdir "%xtts_install_path%"
mkdir "%xtts_install_path%\speakers"
mkdir "%xtts_install_path%\output"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding voice examples to speakers directory...
xcopy "%voice_generation_dir%\xtts-api-server\example\*" "%xtts_install_path%\speakers\" /y /e

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts-api-server directory...
rmdir /s /q "%voice_generation_dir%\xtts-api-server"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS installed successfully%reset%
pause
goto :app_installer_voice_generation