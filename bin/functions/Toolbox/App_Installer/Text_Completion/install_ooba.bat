@echo off

:install_ooba
title STL [INSTALL OOBABOOGA]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install oobabooga%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% installing Text generation web UI oobabooga...

REM Check if the folder exists
if not exist "%stl_root%/text-completion" (
    mkdir "%stl_root%/text-completion"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)
cd /d "%stl_root%/text-completion"


set max_retries=3
set retry_count=0

:retry_install_ooba
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the text-generation-webui repository...
git clone https://github.com/oobabooga/text-generation-webui.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_ooba
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :ooba_install_exit
)

cd /d "%ooba_install_path%"
start "" "start_windows.bat"
echo %yellow_fg_strong%[INFO]%reset% Another Command Window will open, wait for the installation to finish then
pause

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Text generation web UI oobabooga Installed Successfully.%reset%
pause

:ooba_install_exit
goto :app_installer_text_completion