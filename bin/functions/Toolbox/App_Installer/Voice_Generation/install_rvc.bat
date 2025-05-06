@echo off

:install_rvc
title STL [INSTALL RVC]
cls
echo %blue_fg_strong%/ Home / Install RVC%reset%
echo ---------------------------------------------------------------
REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. AMD/Intel DirectML
echo 4. Intel Arc IPEX
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
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to: NVIDIA
    goto :install_rvc_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to: AMD
    goto :install_rvc_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to: AMD/Intel DirectML
    goto :install_rvc_pre
) else if "%gpu_choice%"=="4" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to: Intel Arc IPEX
    goto :install_rvc_pre
) else if "%gpu_choice%"=="0" (
    goto :app_installer_voice_generation
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_rvc
)
:install_rvc_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing RVC...

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

:retry_install_rvc
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the Retrieval-based-Voice-Conversion-WebUI repository...
git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_rvc
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :home
)
cd /d "%rvc_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named rvc
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%rvc%reset%
call conda create -n rvc python=3.10.9 -y

REM Activate the rvc environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%rvc%reset%
call conda activate rvc

REM Downgrade pip to version 24.0.0 because fairseq from facebookresearch fails at pip-24.2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downgrading pip-24.2 to: %cyan_fg_strong%pip-24.0%reset%
python -m pip install pip==24.0.0

REM Use the GPU choice made earlier to install requirements for RVC
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[rvc]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version from requirements.txt in conda enviroment: %cyan_fg_strong%rvc%reset%
    pip install torch==2.2.1+cu121 torchaudio==2.2.1+cu121 --upgrade --force-reinstall --extra-index-url https://download.pytorch.org/whl/cu121
    pip install -r requirements.txt
    goto :install_rvc_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[rvc]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version from requirements-amd.txt in conda enviroment: %cyan_fg_strong%rvc%reset%
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
    pip install -r requirements-amd.txt
    goto :install_rvc_final
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[rvc]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD/Intel DirectML version from requirements-dml.txt in conda enviroment: %cyan_fg_strong%rvc%reset%
    pip install torch torchvision torchaudio
    pip install -r requirements-dml.txt
    goto :install_rvc_final
) else if "%GPU_CHOICE%"=="4" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[rvc]%reset% %blue_fg_strong%[INFO]%reset% Installing Intel Arc IPEX version from  requirements-ipex.txt in conda enviroment: %cyan_fg_strong%rvc%reset%
    pip install torch torchvision torchaudio
    pip install -r requirements-ipex.txt
    goto :install_rvc_final
)
:install_rvc_final
REM Install pip packages that are not in requirements list
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip modules for GUI
pip install FreeSimpleGUI
pip install sounddevice
REM pip install python-dotenv


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%RVC successfully installed.%reset%
echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] In order to start RVC correctly please install FFMPEG from: / Home / Toolbox / App Installer / Core Utilities / Install FFmpeg%reset%
pause
goto :app_installer_voice_generation