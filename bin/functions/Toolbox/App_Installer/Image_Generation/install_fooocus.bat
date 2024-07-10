@echo off

:install_fooocus
title STL [INSTALL FOOOCUS]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install Fooocus%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Fooocus...

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
:retry_install_fooocus
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the Fooocus repository...
git clone https://github.com/lllyasviel/Fooocus.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_fooocus
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_image_generation
)
cd /d "%fooocus_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named fooocus
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%fooocus%reset%
call conda create -n fooocus python=3.10 -y

REM Activate the fooocus environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment %cyan_fg_strong%fooocus%reset%
call conda activate fooocus

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements...
pip install -r requirements_versions.txt

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Fooocus successfully installed.%reset%
pause
goto :app_installer_image_generation