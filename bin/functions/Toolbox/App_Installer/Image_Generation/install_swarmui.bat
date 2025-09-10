@echo off

:install_swarmui
title STL [INSTALL SWARMUI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install SwarmUI%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SwarmUI...

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
:retry_install_swarmui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the SwarmUI repository...
git clone https://github.com/mcmonkeyprojects/SwarmUI.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_swarmui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_image_generation
)
cd /d "%swarmui_install_path%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing .NET SDK 8...
winget install -e --id Microsoft.DotNet.SDK.8  

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SwarmUI installed Successfully.%reset%
pause
goto :install_swarmui_menu