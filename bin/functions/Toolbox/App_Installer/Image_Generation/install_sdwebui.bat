@echo off

:install_sdwebui
title STL [INSTALL STABLE DIFFUSION WEBUI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install Stable Diffusion web UI%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Stable Diffusion web UI...

REM Check if the folder exists
if not exist "%image_generation_dir%" (
    mkdir "%image_generation_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "image-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "image-generation" folder already exists.%reset%
)
cd /d "%image_generation_dir%"


set max_retries=3
set retry_count=0
:retry_install_sdwebui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the stable-diffusion-webui repository...
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_sdwebui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_image_generation
)
cd /d "%sdwebui_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named sdwebui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%sdwebui%reset%
call conda create -n sdwebui python=3.10.6 -y

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebui%reset%
call conda activate sdwebui

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements
pip install civitdl

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Stable Diffusion web UI installed Successfully.%reset%
pause
goto :install_sdwebui_menu