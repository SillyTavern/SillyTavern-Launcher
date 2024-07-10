@echo off

:install_llamacpp
title STL [INSTALL LLAMACPP]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install llamacpp%reset%
echo -------------------------------------------------------------

REM Check if the folder exists
if not exist "%w64devkit_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] w64devkit not found.%reset%
    echo %red_fg_strong%w64devkit is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install w64devkit go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install w64devkit%reset%
    pause
    goto :app_installer_core_utilities
)

REM Check if the folder exists
if not exist "%text_completion_dir%" (
    mkdir "%text_completion_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)

REM Check if the folder exists
if not exist "%llamacpp_install_path%" (
    mkdir "%llamacpp_install_path%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "dev-llamacpp"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "dev-llamacpp" folder already exists.%reset%
)
cd /d "%llamacpp_install_path%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing llamacpp...

set max_retries=3
set retry_count=0

:retry_install_llamacpp
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the llamacpp repository...
git clone https://github.com/ggerganov/llama.cpp.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_llamacpp
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_text_completion
)
cd /d "llama.cpp"
make

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed llamacpp%reset%
pause
goto :app_installer_text_completion