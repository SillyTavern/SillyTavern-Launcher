@echo off

:install_tabbyapi
title STL [INSTALL TABBYAPI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install TabbyAPI%reset%
echo -------------------------------------------------------------
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
    goto :install_tabbyapi_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_tabbyapi_pre
) else if "%gpu_choice%"=="0" (
    goto :app_installer_text_completion
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_tabbyapi
)

:install_tabbyapi_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing TabbyAPI...

REM Check if the folder exists
if not exist "%text_completion_dir%" (
    mkdir "%text_completion_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)
cd /d "%text_completion_dir%"

set max_retries=3
set retry_count=0

:retry_install_tabbyapi
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the tabbyAPI repository...
git clone https://github.com/theroyallab/tabbyAPI.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_tabbyapi
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_text_completion
)

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named tabbyapi
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%tabbyapi%reset%
call conda create -n tabbyapi python=3.11 -y

REM Activate the conda environment named tabbyapi 
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%tabbyapi%reset%
call conda activate tabbyapi

cd /d "%tabbyapi_install_path%"
REM Use the GPU choice made earlier to install requirements for tabbyapi
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[tabbyapi]%reset% %blue_fg_strong%[INFO]%reset% Setting TabbyAPI to use NVIDIA GPUs: %cyan_fg_strong%tabbyapi%reset%
    echo cu121 > "gpu_lib.txt" 
    goto :install_tabbyapi_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[tabbyapi]%reset% %blue_fg_strong%[INFO]%reset% Setting TabbyAPI to use AMD GPUs: %cyan_fg_strong%tabbyapi%reset%
    echo amd > "gpu_lib.txt" 
    goto :install_tabbyapi_final
)

:install_tabbyapi_final
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downgrading numpy to: %cyan_fg_strong%1.26.4%reset%
pip install numpy==1.26.4

echo Loading solely the API may not be your optimal usecase. 
echo Therefore, a config.yml exists to tune initial launch parameters and other configuration options.
echo.
echo A config.yml file is required for overriding project defaults. 
echo If you are okay with the defaults, you don't need a config file!
echo.
echo If you do want a config file, copy over config_sample.yml to config.yml. All the fields are commented, 
echo so make sure to read the descriptions and comment out or remove fields that you don't need.
echo.

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%TabbyAPI installed successfully.%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating TabbyAPI Dependencies...
echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] This process could take a while, typically around 10 minutes or less. Please be patient and do not close this window until the update is complete.%reset%

REM Run the update process and log the output
python start.py --update-deps > %log_dir%\tabby_update_log.txt 2>&1

REM Scan the log file for the specific success message
findstr /c:"Dependencies updated. Please run TabbyAPI" %log_dir%\tabby_update_log.txt >nul
if %errorlevel% == 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% OK
) else (
    echo %red_bg%[ERROR] TabbyAPI Update Failed. Please run the installer again%reset%
)

REM Delete the log file
del %log_dir%\tabby_update_log.txt

REM Continue with the rest of the script
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%TabbyAPI Dependencies updated successfully.%reset%
pause