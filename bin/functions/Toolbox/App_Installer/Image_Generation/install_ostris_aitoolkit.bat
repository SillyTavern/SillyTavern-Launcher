@echo off

:install_ostrisaitoolkit
title STL [INSTALL OSTRIS AI TOOLKIT]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install Ostris AI Toolkit%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Ostris AI Toolkit...

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
:retry_install_ostrisaitoolkit
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the ostris ai-toolkit repository...
git clone https://github.com/ostris/ai-toolkit.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_ostrisaitoolkit
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_image_generation
)
cd /d "%ostrisaitoolkit_install_path%"
git submodule update --init --recursive

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named ostrisaitoolkit
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%ostrisaitoolkit%reset%
call conda create -n ostrisaitoolkit python=3.11 -y

REM Activate the ostrisaitoolkit environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%ostrisaitoolkit%reset%
call conda activate ostrisaitoolkit

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Ostris AI Toolkit installed Successfully.%reset%
pause
goto :install_ostrisaitoolkit_menu