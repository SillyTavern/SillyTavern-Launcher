@echo off
REM SillyTavern Launcher (STL)
REM Created by: Deffcolony
REM
REM Description:
REM This script can launch, backup and uninstall apps
REM
REM This script is intended for use on Windows systems.
REM report any issues or bugs on the GitHub repository.
REM
REM GitHub: https://github.com/SillyTavern/SillyTavern-Launcher
REM Issues: https://github.com/SillyTavern/SillyTavern-Launcher/issues
title STL [STARTUP CHECK]
setlocal

REM ANSI Escape Code for Colors
set "reset=[0m"

REM Strong Foreground Colors
set "white_fg_strong=[90m"
set "red_fg_strong=[91m"
set "green_fg_strong=[92m"
set "yellow_fg_strong=[93m"
set "blue_fg_strong=[94m"
set "magenta_fg_strong=[95m"
set "cyan_fg_strong=[96m"

REM Normal Background Colors
set "red_bg=[41m"
set "blue_bg=[44m"
set "yellow_bg=[43m"

REM Environment Variables (7-Zip)
set "zip7version=7z2301-x64"
set "zip7_install_path=%ProgramFiles%\7-Zip"
set "zip7_download_path=%TEMP%\%zip7version%.exe"

REM Environment Variables (FFmpeg)
set "ffmpeg_url=https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z"
set "ffdownload_path=%~dp0ffmpeg.7z"
set "ffextract_path=C:\ffmpeg"
set "ffmpeg_path_bin=%ffextract_path%\bin"

REM Environment Variables (Node.js)
set "node_installer_path=%temp%\NodejsInstaller.msi"

REM Environment Variables (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM Environment Variables (miniconda3)
set "miniconda_path=%userprofile%\miniconda3"
set "miniconda_path_mingw=%userprofile%\miniconda3\Library\mingw-w64\bin"
set "miniconda_path_usrbin=%userprofile%\miniconda3\Library\usr\bin"
set "miniconda_path_bin=%userprofile%\miniconda3\Library\bin"
set "miniconda_path_scripts=%userprofile%\miniconda3\Scripts"

REM Environment Variables (w64devkit)
set "w64devkit_path=C:\w64devkit"
set "w64devkit_path_bin=%w64devkit_path%\bin"


REM Define variables to track module status (EXTRAS)
set "extras_modules_path=%~dp0bin\settings\modules-extras.txt"
set "cuda_trigger=false"
set "rvc_trigger=false"
set "talkinghead_trigger=false"
set "caption_trigger=false"
set "summarize_trigger=false"
set "listen_trigger=false"
set "whisper_trigger=false"
set "edge_tts_trigger=false"

REM Define variables to track module status (XTTS)
set "xtts_modules_path=%~dp0bin\settings\modules-xtts.txt"
set "xtts_cuda_trigger=false"
set "xtts_hs_trigger=false"
set "xtts_deepspeed_trigger=false"
set "xtts_cache_trigger=false"
set "xtts_listen_trigger=false"
set "xtts_model_trigger=false"

REM Define variables to track module status (STABLE DIFUSSION WEBUI)
set "sdwebui_modules_path=%~dp0bin\settings\modules-sdwebui.txt"
set "sdwebui_autolaunch_trigger=false"
set "sdwebui_api_trigger=false"
set "sdwebui_listen_trigger=false"
set "sdwebui_port_trigger=false"
set "sdwebui_optsdpattention_trigger=false"
set "sdwebui_themedark_trigger=false"
set "sdwebui_skiptorchcudatest_trigger=false"
set "sdwebui_lowvram_trigger=false"
set "sdwebui_medvram_trigger=false"

REM Define variables to track module status (TEXT GENERATION WEBUI OOBABOOGA)
set "ooba_modules_path=%~dp0bin\settings\modules-ooba.txt"
set "ooba_autolaunch_trigger=false"
set "ooba_extopenai_trigger=false"
set "ooba_listen_trigger=false"
set "ooba_listenport_trigger=false"
set "ooba_apiport_trigger=false"
set "ooba_verbose_trigger=false"



REM Define variables for logging
set "log_path=%~dp0bin\logs.log"
set "log_invalidinput=[ERROR] Invalid input. Please enter a valid number."
set "echo_invalidinput=%red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%"

REM Check if the folder exists
if not exist "%~dp0bin" (
    mkdir "%~dp0bin"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "bin"  
)

REM Check if the folder exists
if not exist "%~dp0bin\settings" (
    mkdir "%~dp0bin\settings"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "settings"  
)


REM Create modules-extras if it doesn't exist
if not exist %extras_modules_path% (
    type nul > %extras_modules_path%
)
REM Load modules-extras flags from modules
for /f "tokens=*" %%a in (%extras_modules_path%) do set "%%a"


REM Create modules-xtts if it doesn't exist
if not exist %xtts_modules_path% (
    type nul > %xtts_modules_path%
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%xtts_modules_path%) do set "%%a"


REM Create modules-sdwebui if it doesn't exist
if not exist %sdwebui_modules_path% (
    type nul > %sdwebui_modules_path%
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%sdwebui_modules_path%) do set "%%a"


REM Create modules-ooba if it doesn't exist
if not exist %ooba_modules_path% (
    type nul > %ooba_modules_path%
)
REM Load modules-ooba flags from modules-ooba
for /f "tokens=*" %%a in (%ooba_modules_path%) do set "%%a"


REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%winget_path%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%winget_path%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "winget_path is:%cyan_fg_strong% %winget_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%winget added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] winget already exists in PATH.%reset%
)

REM Check if Winget is installed; if not, then install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Winget is not installed on this system.%reset%
    REM Check if the folder exists
    if not exist "%~dp0bin" (
        mkdir "%~dp0bin"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "bin"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "bin" folder already exists.%reset%
    )
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Winget...
    curl -L -o "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    start "" "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Winget installed successfully. Please restart the Launcher.%reset%
    pause
    exit
) else (
    echo %blue_fg_strong%[INFO] Winget is already installed.%reset%
)

REM Check if Git is installed if not then install git
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Git is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Git using Winget...
    winget install -e --id Git.Git
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Git is installed. Please restart the Launcher.%reset%
    pause
    exit
) else (
    echo %blue_fg_strong%[INFO] Git is already installed.%reset%
)

REM Check if Miniconda3 is installed if not then install Miniconda3
call conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Miniconda3 is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Miniconda3 using Winget...
    winget install -e --id Anaconda.Miniconda3
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Miniconda3 installed successfully. Please restart the Installer.%reset%
    pause
    exit
) else (
    echo %blue_fg_strong%[INFO] Miniconda3 is already installed.%reset%
)

REM Change the current directory to 'sillytavern' folder
cd /d "%~dp0SillyTavern"

REM Check for updates
git fetch origin

for /f %%i in ('git rev-list HEAD...origin/%current_branch%') do (
    set "update_status=%yellow_fg_strong%Update Available%reset%"
    goto :found_update
)

set "update_status=%green_fg_strong%Up to Date%reset%"
:found_update


REM ############################################################
REM ################## HOME - FRONTEND #########################
REM ############################################################
:home
title STL [HOME]
cls
echo %blue_fg_strong%/ Home%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Start SillyTavern
echo 2. Start SillyTavern + Remote Link
echo 3. Start Extras
echo 4. Start XTTS
echo 5. Update
echo 6. Toolbox
echo 7. Support
echo 0. Exit

REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo ======== VERSION STATUS =========
echo SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo SillyTavern: %update_status%
echo Launcher: V1.1.2
echo =================================

set "choice="
set /p "choice=Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM ################## HOME - BACKEND #########################
if "%choice%"=="1" (
    call :start_st
) else if "%choice%"=="2" (
    call :start_st_rl
) else if "%choice%"=="3" (
    call :start_extras
) else if "%choice%"=="4" (
    call :start_xtts
) else if "%choice%"=="5" (
    call :update
) else if "%choice%"=="6" (
    call :toolbox
) else if "%choice%"=="7" (
    call :support
) else if "%choice%"=="0" (
    exit
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :home
)


:start_st
REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] node command not found in PATH.%reset%
    echo %red_fg_strong%Node.js is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install Node.js go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install Node.js%reset%
    pause
    goto :home
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% SillyTavern launched in a new window.
start cmd /k "title SillyTavern && cd /d %~dp0SillyTavern && call npm install --no-audit && node server.js && pause && popd"
goto :home

:start_st_rl
REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] node command not found in PATH.%reset%
    echo %red_fg_strong%Node.js is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install Node.js go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install Node.js%reset%
    pause
    goto :home
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% SillyTavern launched in a new window.
start cmd /k "title SillyTavern && cd /d %~dp0SillyTavern && call npm install --no-audit && node server.js && pause && popd"
start "" "%~dp0SillyTavern\Remote-Link.cmd"
goto :home

:start_extras
REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the extras environment
call conda activate extras

REM Start SillyTavern Extras with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Extras launched in a new window.

REM Read modules-extras and find the extras_start_command line
set "extras_start_command="

for /F "tokens=*" %%a in ('findstr /I "extras_start_command=" "%extras_modules_path%"') do (
    set "%%a"
)

if not defined extras_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled!%reset%
    echo %red_bg%Please make sure at least one of the modules are enabled from Edit Extras Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit Extras Modules menu.%reset%
    pause
    goto :edit_extras_modules
)

set "extras_start_command=%extras_start_command:extras_start_command=%"
start cmd /k "title SillyTavern Extras && cd /d %~dp0SillyTavern-extras && %extras_start_command%"
goto :home

:start_xtts
REM Activate the xtts environment
call conda activate xtts

REM Start XTTS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% XTTS launched in a new window.

REM Read modules-xtts and find the xtts_start_command line
set "xtts_start_command="

for /F "tokens=*" %%a in ('findstr /I "xtts_start_command=" "%xtts_modules_path%"') do (
    set "%%a"
)

if not defined xtts_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled!%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit XTTS Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit XTTS Modules menu.%reset%
    pause
    goto :edit_xtts_modules
)

set "xtts_start_command=%xtts_start_command:xtts_start_command=%"
start cmd /k "title XTTSv2 API Server && cd /d %~dp0xtts && %xtts_start_command%"
goto :home


:update
title STL [UPDATE]
REM Update SillyTavern-Launcher
set max_retries=3
set retry_count=0

:retry_update_st_launcher
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating SillyTavern-Launcher...
cd /d "%~dp0"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_st_launcher
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update SillyTavern-Launcher repository after %max_retries% retries.%reset%
    pause
    goto :home
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern-Launcher updated successfully.%reset%

REM Update SillyTavern
set max_retries=3
set retry_count=0

:retry_update_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating SillyTavern...
cd /d "%~dp0SillyTavern"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_st
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update SillyTavern repository after %max_retries% retries.%reset%
    pause
    goto :home
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern updated successfully.%reset%


REM Check if SillyTavern-extras directory exists
if not exist "%~dp0SillyTavern-extras" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] SillyTavern-extras directory not found. Skipping extras update.%reset%
    goto :update_xtts
)

REM Update SillyTavern-extras
set max_retries=3
set retry_count=0

:retry_update_extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating SillyTavern-extras...
cd /d "%~dp0SillyTavern-extras"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_extras
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update SillyTavern-extras repository after %max_retries% retries.%reset%
    pause
    goto :home
)

:update_xtts
REM Check if XTTS directory exists
if not exist "%~dp0xtts" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] xtts directory not found. Skipping XTTS update.%reset%
    pause
    goto :home
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating XTTS...
call conda activate xtts
pip install --upgrade xtts-api-server
call conda deactivate
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS updated successfully.%reset%
pause
goto :home




REM ############################################################
REM ################# TOOLBOX - FRONTEND #######################
REM ############################################################
:toolbox
title STL [TOOLBOX]
cls
echo %blue_fg_strong%/ Home / Toolbox%reset%
echo -------------------------------------------------------------
echo What would you like to do?
REM color 7
echo 1. App Launcher
echo 2. App Installer
echo 3. App Uninstaller
echo 4. Editor
echo 5. Backup
echo 6. Switch branch
echo 7. Troubleshooting
echo 0. Back

set /p toolbox_choice=Choose Your Destiny: 

REM ################# TOOLBOX - BACKEND #######################
if "%toolbox_choice%"=="1" (
    call :app_launcher
) else if "%toolbox_choice%"=="2" (
    call :app_installer
) else if "%toolbox_choice%"=="3" (
    call :app_uninstaller
) else if "%toolbox_choice%"=="4" (
    call :editor
) else if "%toolbox_choice%"=="5" (
    call :backup
) else if "%toolbox_choice%"=="6" (
    call :switch_brance
) else if "%toolbox_choice%"=="7" (
    call :troubleshooting
) else if "%toolbox_choice%"=="0" (
    goto :home
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :toolbox
)


REM ############################################################
REM ############## APP LAUNCHER - FRONTEND #####################
REM ############################################################
:app_launcher
title STL [APP LAUNCHER]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Launcher%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Text Completion
echo 2. Image Generation
echo 0. Back

set /p app_launcher_choice=Choose Your Destiny: 

REM ############## APP INSTALLER - BACKEND ####################
if "%app_launcher_choice%"=="1" (
    call :app_launcher_text_completion
) else if "%app_launcher_choice%"=="2" (
    call :app_launcher_image_generation
) else if "%app_launcher_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher
)


REM ############################################################
REM ########## APP LAUNCHER TEXT COMPLETION - FRONTEND #########
REM ############################################################
:app_launcher_text_completion
title STL [APP LAUNCHER TEXT COMPLETION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Launcher / Text Completion%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Start Text generation web UI (oobabooga)
echo 2. Start koboldcpp
echo 3. Start TabbyAPI
echo 0. Back

set /p app_launcher_txt_comp_choice=Choose Your Destiny: 

REM ########## APP LAUNCHER TEXT COMPLETION - BACKEND #########
if "%app_launcher_txt_comp_choice%"=="1" (
    call :start_ooba
) else if "%app_launcher_txt_comp_choice%"=="2" (
    call :start_koboldcpp
) else if "%app_launcher_txt_comp_choice%"=="3" (
    call :start_tabbyapi
) else if "%app_launcher_txt_comp_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_text_completion
)

:start_ooba
REM Start Text generation web UI oobabooga with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Text generation web UI oobabooga launched in a new window.

REM Read modules-ooba and find the ooba_start_command line
set "ooba_start_command="

for /F "tokens=*" %%a in ('findstr /I "ooba_start_command=" "%ooba_modules_path%"') do (
    set "%%a"
)

if not defined ooba_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit OOBA Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit OOBA Modules menu.%reset%
    pause
    goto :edit_ooba_modules
)

set "ooba_start_command=%ooba_start_command:ooba_start_command=%"

REM Start Text generation web UI oobabooga with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Text generation web UI oobabooga launched in a new window.
start cmd /k "title OOBA && cd /d %~dp0text-completion\text-generation-webui && %ooba_start_command%"
goto :app_launcher_text_completion


:start_koboldcpp
REM Start koboldcpp with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% koboldcpp launched in a new window.

cd /d "%~dp0text-completion\dev-koboldcpp"
start "" "koboldcpp.exe"
goto :app_launcher_text_completion


:start_tabbyapi
REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the extras environment
call conda activate tabbyapi

REM Start TabbyAPI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% TabbyAPI launched in a new window.

start cmd /k "title TabbyAPI && cd /d %~dp0text-completion\tabbyAPI && python start.py"
goto :app_launcher_text_completion


REM ############################################################
REM ######## APP LAUNCHER IMAGE GENERATION - FRONTEND #########
REM ############################################################
:app_launcher_image_generation
title STL [APP LAUNCHER IMAGE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Launcher / Image Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Start Stable Diffusion web UI
echo 2. Start Stable Diffusion web UI Forge
echo 3. Start ComfyUI
echo 4. Start Fooocus
echo 0. Back

set /p app_launcher_img_gen_choice=Choose Your Destiny: 

REM ######## APP LAUNCHER IMAGE GENERATION - BACKEND #########
if "%app_launcher_img_gen_choice%"=="1" (
    call :start_sdwebui
) else if "%app_launcher_img_gen_choice%"=="2" (
    goto :start_sdwebuiforge
) else if "%app_launcher_img_gen_choice%"=="3" (
    goto :start_comfyui
) else if "%app_launcher_img_gen_choice%"=="4" (
    goto :start_fooocus
) else if "%app_launcher_img_gen_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_image_generation
)


:start_sdwebui
cd /d "%~dp0image-generation\stable-diffusion-webui"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebui%reset%
call conda activate sdwebui


REM Read modules-sdwebui and find the sdwebui_start_command line
set "sdwebui_start_command="

for /F "tokens=*" %%a in ('findstr /I "sdwebui_start_command=" "%sdwebui_modules_path%"') do (
    set "%%a"
)

if not defined sdwebui_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit SDWEBUI Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit SDWEBUI Modules menu.%reset%
    pause
    goto :edit_sdwebui_modules
)

set "sdwebui_start_command=%sdwebui_start_command:sdwebui_start_command=%"

REM Start Stable Diffusion WebUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Stable Diffusion WebUI launched in a new window.
start cmd /k "title SDWEBUI && cd /d %~dp0image-generation\stable-diffusion-webui && %sdwebui_start_command%"
goto :app_launcher_image_generation

:start_sdwebuiforge
cd /d "%~dp0image-generation\stable-diffusion-webui-forge"

REM Start Stable Diffusion WebUI Forge with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Stable Diffusion WebUI Forge launched in a new window.
start "" "webui-user.bat"
goto :app_launcher_image_generation

:start_comfyui
REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%comfyui%reset%
call conda activate comfyui

REM Start ComfyUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% ComfyUI launched in a new window.
start cmd /k "title ComfyUI && cd /d %~dp0image-generation\ComfyUI && python main.py --auto-launch --listen --port 7901"
goto :app_launcher_image_generation


:start_fooocus
REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the fooocus environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%fooocus%reset%
call conda activate fooocus

REM Start Fooocus with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Fooocus launched in a new window.
start cmd /k "title Fooocus && cd /d %~dp0image-generation\fooocus && python entry_with_update.py"
goto :app_launcher_image_generation


REM ############################################################
REM ############## APP INSTALLER - FRONTEND ####################
REM ############################################################
:app_installer
title STL [APP INSTALLER]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Text Completion
echo 2. Image Generation
echo 3. Core Utilities
echo 0. Back

set /p app_installer_choice=Choose Your Destiny: 

REM ############## APP INSTALLER - BACKEND ####################
if "%app_installer_choice%"=="1" (
    call :app_installer_text_completion
) else if "%app_installer_choice%"=="2" (
    call :app_installer_image_generation
) else if "%app_installer_choice%"=="3" (
    call :app_installer_core_utilities
) else if "%app_installer_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer
)


REM ############################################################
REM ######## APP INSTALLER TEXT COMPLETION - FRONTEND ##########
REM ############################################################
:app_installer_text_completion
title STL [APP INSTALLER TEXT COMPLETION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install Text generation web UI oobabooga
echo 2. koboldcpp [Install options]
echo 3. Install TabbyAPI
echo 0. Back

set /p app_installer_txt_comp_choice=Choose Your Destiny: 

REM ######## APP INSTALLER TEXT COMPLETION - BACKEND ##########
if "%app_installer_txt_comp_choice%"=="1" (
    call :install_ooba
) else if "%app_installer_txt_comp_choice%"=="2" (
    call :install_koboldcpp_menu
) else if "%app_installer_txt_comp_choice%"=="3" (
    call :install_tabbyapi
) else if "%app_installer_txt_comp_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_text_completion
)


:install_ooba
title STL [INSTALL OOBABOOGA]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install oobabooga%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% installing Text generation web UI oobabooga...

REM Check if the folder exists
if not exist "%~dp0text-completion" (
    mkdir "%~dp0text-completion"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)
cd /d "%~dp0text-completion"


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
    goto :app_installer_text_completion
)

cd /d "text-generation-webui"
start "" "start_windows.bat"
echo When the installation is finished:
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Text generation web UI oobabooga Installed Successfully.%reset%
goto :app_installer_text_completion



REM ############################################################
REM ######## APP INSTALLER KOBOLDCPP - FRONTEND ################
REM ############################################################
:install_koboldcpp_menu
title STL [APP INSTALLER KOBOLDCPP]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / koboldcpp%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install koboldcpp from prebuild .exe [Recommended]
echo 2. Build dll files and compile the .exe installer [Advanced]
echo 0. Back

set /p app_installer_koboldcpp_choice=Choose Your Destiny: 

REM ######## APP INSTALLER KOBOLDCPP - BACKEND ##########
if "%app_installer_koboldcpp_choice%"=="1" (
    call :install_koboldcpp
) else if "%app_installer_koboldcpp_choice%"=="2" (
    call :install_koboldcpp_raw
) else if "%app_installer_koboldcpp_choice%"=="0" (
    goto :app_installer_text_completion
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_koboldcpp_menu
)


:install_koboldcpp
title STL [INSTALL KOBOLDCPP]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install koboldcpp%reset%
echo -------------------------------------------------------------

REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 0. Cancel

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
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
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="0" (
    goto :install_koboldcpp_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_koboldcpp
)

:install_koboldcpp_pre
REM Check if text-completion folder exists
if not exist "%~dp0text-completion" (
    mkdir "%~dp0text-completion"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)

REM Check if dev-koboldcpp folder exists
if not exist "%~dp0text-completion\dev-koboldcpp" (
    mkdir "%~dp0text-completion\dev-koboldcpp"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "dev-koboldcpp"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "dev-koboldcpp" folder already exists.%reset%
)
cd /d "%~dp0text-completion\dev-koboldcpp"

REM Use the GPU choice made earlier to install koboldcpp
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading koboldcpp.exe for: %cyan_fg_strong%NVIDIA%reset% 
    curl -L -o "%~dp0text-completion\dev-koboldcpp\koboldcpp.exe" "https://github.com/LostRuins/koboldcpp/releases/latest/download/koboldcpp.exe"
    start "" "koboldcpp.exe"
    goto :install_koboldcpp_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading koboldcpp_rocm.exe for: %cyan_fg_strong%AMD%reset% 
    curl -L -o "%~dp0text-completion\dev-koboldcpp\koboldcpp_rocm.exe" "https://github.com/YellowRoseCx/koboldcpp-rocm/releases/latest/download/koboldcpp_rocm.exe"
    start "" "koboldcpp_rocm.exe"
    goto :install_koboldcpp_final
)

:install_koboldcpp_final
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed koboldcpp%reset%
pause
goto :app_installer_text_completion

:install_koboldcpp_raw
title STL [INSTALL KOBOLDCPP RAW]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install koboldcpp RAW%reset%
echo -------------------------------------------------------------

REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] 7z command not found in PATH.%reset%
    echo %red_fg_strong%7-Zip is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install 7-Zip%reset%
    pause
    goto :app_installer_core_utilities
)

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named koboldcpp
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%koboldcpp%reset%
call conda create -n koboldcpp python=3.11 -y

REM Activate the conda environment named koboldcpp 
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%koboldcpp%reset%
call conda activate koboldcpp

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements
pip install pyinstaller

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing koboldcpp...
cd /d "%~dp0"

REM Check if the folder exists
if not exist "%~dp0text-completion" (
    mkdir "%~dp0text-completion"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)

cd /d "text-completion"
REM Check if the folder exists
if not exist "dev-koboldcpp" (
    mkdir "dev-koboldcpp"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "dev-koboldcpp"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "dev-koboldcpp" folder already exists.%reset%
)
cd /d "dev-koboldcpp"

REM Check if file exists
if not exist "make.sh" (
    echo make -C "${1}" > "make.sh"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created new file: "make.sh"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "make.sh" already exists.%reset%
)

set max_retries=3
set retry_count=0

:retry_install_koboldcpp
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the koboldcpp repository...
git clone https://github.com/LostRuins/koboldcpp.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_koboldcpp
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_text_completion
)

REM Add new lines to CMakeLists.txt
cd /d "koboldcpp"
echo add_compile_options("$<$<C_COMPILER_ID:MSVC>:-utf-8>")>> CMakeLists.txt
echo add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:-utf-8>")>> CMakeLists.txt
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% successfully added new lines to: CMakeLists.txt

REM Download w64devkit zip archive
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading w64devkit...
curl -L -o "%~dp0text-completion\dev-koboldcpp\w64devkit-1.21.0.zip" "https://github.com/skeeto/w64devkit/releases/download/v1.21.0/w64devkit-1.21.0.zip"

REM Extract w64devkit zip archive
7z x "%~dp0text-completion\dev-koboldcpp\w64devkit-1.21.0.zip" -o"%~dp0text-completion\dev-koboldcpp\w64devkit-1.21.0"

REM Move w64devkit to root of C
move /Y "%~dp0text-completion\dev-koboldcpp\w64devkit-1.21.0\w64devkit" "C:\w64devkit"

REM Remove leftovers
del "%~dp0text-completion\dev-koboldcpp\w64devkit-1.21.0.zip"
rd /S /Q "%~dp0text-completion\dev-koboldcpp\w64devkit-1.21.0"

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%w64devkit_path_bin%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%w64devkit_path_bin%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "w64devkit_path_bin is:%cyan_fg_strong% %w64devkit_path_bin%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%w64devkit added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] w64devkit already exists in PATH.%reset%
)

make
PyInstaller --noconfirm --onefile --clean --console --collect-all customtkinter --icon "./niko.ico" --add-data "./winclinfo.exe;." --add-data "./OpenCL.dll;." --add-data "./klite.embd;." --add-data "./kcpp_docs.embd;." --add-data "./koboldcpp_default.dll;." --add-data "./koboldcpp_openblas.dll;." --add-data "./koboldcpp_failsafe.dll;." --add-data "./koboldcpp_noavx2.dll;." --add-data "./libopenblas.dll;." --add-data "./koboldcpp_clblast.dll;." --add-data "./koboldcpp_clblast_noavx2.dll;." --add-data "./koboldcpp_vulkan_noavx2.dll;." --add-data "./clblast.dll;." --add-data "./koboldcpp_vulkan.dll;." --add-data "./vulkan-1.dll;." --add-data "./rwkv_vocab.embd;." --add-data "./rwkv_world_vocab.embd;." "./koboldcpp.py" -n "koboldcpp.exe"
start "" "koboldcpp.exe"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed koboldcpp%reset%
pause
goto :app_installer_text_completion

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
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
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
    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA
    goto :install_tabbyapi_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_tabbyapi_pre
) else if "%gpu_choice%"=="0" (
    goto :app_installer_text_completion
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_tabbyapi
)

:install_tabbyapi_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing TabbyAPI...

REM Check if the folder exists
if not exist "%~dp0text-completion" (
    mkdir "%~dp0text-completion"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)
cd /d "%~dp0text-completion"

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

cd /d "tabbyAPI"
REM Use the GPU choice made earlier to install requirements for tabbyapi
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[tabbyapi]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%tabbyapi%reset%
    echo cu121 > "gpu_lib.txt" 
    pip install torch==2.1.1+cu121 torchaudio==2.1.1+cu121 --index-url https://download.pytorch.org/whl/cu121
    goto :install_tabbyapi_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[tabbyapi]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch in conda enviroment: %cyan_fg_strong%tabbyapi%reset%
    echo amd > "gpu_lib.txt" 
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
    goto :install_tabbyapi_final
)

:install_tabbyapi_final
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%TabbyAPI has been installed successfully.%reset%
pause
goto :app_installer_text_completion


REM ############################################################
REM ######## APP INSTALLER IMAGE GENERATION - FRONTEND #########
REM ############################################################
:app_installer_image_generation
title STL [APP INSTALLER IMAGE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Stable Diffusion web UI [Install options]
echo 2. Stable Diffusion web UI Forge [Install options]
echo 3. Install ComfyUI
echo 4. Install Fooocus
echo 0. Back

set /p app_installer_img_gen_choice=Choose Your Destiny: 

REM ######## APP INSTALLER IMAGE GENERATION - BACKEND #########
if "%app_installer_img_gen_choice%"=="1" (
    call :install_sdwebui_menu
) else if "%app_installer_img_gen_choice%"=="2" (
    goto :install_sdwebuiforge_menu
) else if "%app_installer_img_gen_choice%"=="3" (
    goto :install_comfyui
) else if "%app_installer_img_gen_choice%"=="4" (
    goto :install_fooocus
) else if "%app_installer_img_gen_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_image_generation
)


REM ############################################################
REM ##### APP INSTALLER STABLE DIFUSSION WEBUI - FRONTEND ######
REM ############################################################
:install_sdwebui_menu
title STL [APP INSTALLER STABLE DIFUSSION WEBUI]

REM Check if the folder exists
if exist "%~dp0image-generation\stable-diffusion-webui" (
    REM Activate the sdwebui environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Deactivating Conda environment: %cyan_fg_strong%sdwebui%reset%
    call conda deactivate
)

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Stable Diffusion web UI %reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install Stable Diffusion web UI
echo 2. Install Extensions
echo 3. Models [Install Options]
echo 0. Back

set /p app_installer_sdwebui_choice=Choose Your Destiny: 

REM ##### APP INSTALLER STABLE DIFUSSION WEBUI - BACKEND ######
if "%app_installer_sdwebui_choice%"=="1" (
    call :install_sdwebui
) else if "%app_installer_sdwebui_choice%"=="2" (
    goto :install_sdwebui_extensions
) else if "%app_installer_sdwebui_choice%"=="3" (
    goto :install_sdwebui_model_menu
) else if "%app_installer_sdwebui_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_menu
)


:install_sdwebui
title STL [INSTALL STABLE DIFFUSION WEBUI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install Stable Diffusion web UI%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Stable Diffusion web UI...

REM Check if the folder exists
if not exist "%~dp0image-generation" (
    mkdir "%~dp0image-generation"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "image-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "image-generation" folder already exists.%reset%
)
cd /d "%~dp0image-generation"


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
cd /d "stable-diffusion-webui"

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


:install_sdwebui_extensions
REM Check if the folder exists
if not exist "%~dp0image-generation\stable-diffusion-webui" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion Webui is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebui_menu
)

REM Clone extensions for stable-diffusion-webui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning extensions for stable-diffusion-webui...
cd /d "%~dp0image-generation\stable-diffusion-webui\extensions"
git clone https://github.com/alemelis/sd-webui-ar.git
git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper.git
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
git clone https://github.com/EnsignMK/danbooru-prompt.git
git clone https://github.com/fkunn1326/openpose-editor.git
git clone https://github.com/Mikubill/sd-webui-controlnet.git
git clone https://github.com/ashen-sensored/sd_webui_SAG.git
git clone https://github.com/NoCrypt/sd-fast-pnginfo.git
git clone https://github.com/Bing-su/adetailer.git
git clone https://github.com/hako-mikan/sd-webui-supermerger.git
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git
git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
git clone https://github.com/Gourieff/sd-webui-reactor.git
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Better Upscaler models...
cd /d "%~dp0image-generation\stable-diffusion-webui\models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extensions for Stable Diffusion web UI installed Successfully.%reset%
goto :install_sdwebui_menu


REM ############################################################
REM ##### APP INSTALLER SDWEBUI Models - FRONTEND ##############
REM ############################################################
:install_sdwebui_model_menu
title STL [APP INSTALLER SDWEBUI MODELS]

REM Check if the folder exists
if not exist "%~dp0image-generation\stable-diffusion-webui" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion Webui is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebui_menu
)

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebui%reset%
call conda activate sdwebui

cd /d "%~dp0image-generation\stable-diffusion-webui"

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / SDWEBUI Models%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install Hassaku [ANIME MODEL]
echo 2. Install YiffyMix [FURRY MODEL]
echo 3. Install Perfect World [REALISM MODEL]
echo 4. Install a custom model
echo 5. Add API Key from civitai
echo 0. Back

set /p app_installer_sdwebui_model_choice=Choose Your Destiny: 

REM ######## APP INSTALLER IMAGE GENERATION - BACKEND #########
if "%app_installer_sdwebui_model_choice%"=="1" (
    call :install_sdwebui_model_hassaku
) else if "%app_installer_sdwebui_model_choice%"=="2" (
    goto :install_sdwebui_model_yiffymix
) else if "%app_installer_sdwebui_model_choice%"=="3" (
    goto :install_sdwebui_model_perfectworld
) else if "%app_installer_sdwebui_model_choice%"=="4" (
    goto :install_sdwebui_model_custom
) else if "%app_installer_sdwebui_model_choice%"=="5" (
    goto :install_sdwebui_model_apikey
) else if "%app_installer_sdwebui_model_choice%"=="0" (
    goto :install_sdwebui_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_model_menu
)

:install_sdwebui_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku Model in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Model in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Config in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix VAE in: "%~dp0image-generation\stable-diffusion-webui\models\VAE"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Perfect World Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_custom
cls
set /p civitaimodelid="(0 to cancel)Insert Model ID: "

if "%civitaimodelid%"=="0" goto :install_sdwebui_model_menu

REM Check if the input is a valid number
echo %civitaimodelid%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_model_custom
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Downloading...
civitdl %civitaimodelid% -s basic "models\Stable-diffusion"
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_apikey
cls
set /p civitaiapikey="(0 to cancel)Insert API key: "

if "%civitaiapikey%"=="0" goto :install_sdwebui_model_menu

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Adding API key...
civitconfig default --api-key %civitaiapikey%
pause
goto :install_sdwebui_model_menu

REM ############################################################
REM ## APP INSTALLER STABLE DIFUSSION WEBUI FORGE - FRONTEND ###
REM ############################################################
:install_sdwebuiforge_menu
title STL [APP INSTALLER STABLE DIFUSSION WEBUI FORGE]

REM Check if the folder exists
if exist "%~dp0image-generation\stable-diffusion-webui-forge" (
    REM Activate the sdwebuiforge environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Deactivating Conda environment: %cyan_fg_strong%sdwebui%reset%
    call conda deactivate
)

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Stable Diffusion web UI Forge %reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install Stable Diffusion web UI Forge
echo 2. Install Extensions
echo 3. Models [Install Options]
echo 0. Back

set /p app_installer_sdwebuiforge_choice=Choose Your Destiny: 

REM ## APP INSTALLER STABLE DIFUSSION WEBUI FORGE - BACKEND ###
if "%app_installer_sdwebuiforge_choice%"=="1" (
    call :install_sdwebuiforge
) else if "%app_installer_sdwebuiforge_choice%"=="2" (
    goto :install_sdwebuiforge_extensions
) else if "%app_installer_sdwebuiforge_choice%"=="3" (
    goto :install_sdwebuiforge_model_menu
) else if "%app_installer_sdwebuiforge_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_menu
)


:install_sdwebuiforge
title STL [INSTALL STABLE DIFFUSION WEBUI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install Stable Diffusion web UI Forge%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Stable Diffusion web UI Forge...

REM Check if the folder exists
if not exist "%~dp0image-generation" (
    mkdir "%~dp0image-generation"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "image-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "image-generation" folder already exists.%reset%
)
cd /d "%~dp0image-generation"


set max_retries=3
set retry_count=0
:retry_install_sdwebuiforge
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the stable-diffusion-webui-forge repository...
git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_sdwebuiforge
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_image_generation
)
cd /d "stable-diffusion-webui-forge"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named sdwebuiforge
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%sdwebuiforge%reset%
call conda create -n sdwebuiforge python=3.11 -y

REM Activate the sdwebuiforge environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebuiforge%reset%
call conda activate sdwebuiforge

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements
pip install civitdl

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Stable Diffusion WebUI Forge installed Successfully.%reset%
pause
goto :install_sdwebuiforge_menu


:install_sdwebuiforge_extensions
REM Check if the folder exists
if not exist "%~dp0image-generation\stable-diffusion-webui-forge" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion WebUI Forge is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebuiforge_menu
)

REM Clone extensions for stable-diffusion-webui-forge
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning extensions for stable-diffusion-webui-forge...
cd /d "%~dp0image-generation\stable-diffusion-webui-forge\extensions"
git clone https://github.com/alemelis/sd-webui-ar.git
git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper.git
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
git clone https://github.com/EnsignMK/danbooru-prompt.git
git clone https://github.com/fkunn1326/openpose-editor.git
git clone https://github.com/Mikubill/sd-webui-controlnet.git
git clone https://github.com/ashen-sensored/sd_webui_SAG.git
git clone https://github.com/NoCrypt/sd-fast-pnginfo.git
git clone https://github.com/Bing-su/adetailer.git
git clone https://github.com/hako-mikan/sd-webui-supermerger.git
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git
git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
git clone https://github.com/Gourieff/sd-webui-reactor.git
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Better Upscaler models...
cd /d "%~dp0image-generation\stable-diffusion-webui-forge\models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extensions for Stable Diffusion WebUI Forge installed Successfully.%reset%
goto :install_sdwebuiforge_menu


REM ############################################################
REM ##### APP INSTALLER SDWEBUI Models - FRONTEND ##############
REM ############################################################
:install_sdwebuiforge_model_menu
title STL [APP INSTALLER SDWEBUIFORGE MODELS]

REM Check if the folder exists
if not exist "%~dp0image-generation\stable-diffusion-webui-forge" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion WebUI Forge is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebuiforge_menu
)

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebuiforge environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebuiforge%reset%
call conda activate sdwebuiforge

cd /d "%~dp0image-generation\stable-diffusion-webui-forge"

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / SDWEBUIFORGE Models%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install Hassaku [ANIME MODEL]
echo 2. Install YiffyMix [FURRY MODEL]
echo 3. Install Perfect World [REALISM MODEL]
echo 4. Install a custom model
echo 0. Back

set /p app_installer_sdwebuiforge_model_choice=Choose Your Destiny: 

REM ######## APP INSTALLER IMAGE GENERATION - BACKEND #########
if "%app_installer_sdwebuiforge_model_choice%"=="1" (
    call :install_sdwebuiforge_model_hassaku
) else if "%app_installer_sdwebuiforge_model_choice%"=="2" (
    goto :install_sdwebuiforge_model_yiffymix
) else if "%app_installer_sdwebuiforge_model_choice%"=="3" (
    goto :install_sdwebuiforge_model_perfectworld
) else if "%app_installer_sdwebuiforge_model_choice%"=="4" (
    goto :install_sdwebuiforge_model_custom
) else if "%app_installer_sdwebuiforge_model_choice%"=="0" (
    goto :install_sdwebuiforge_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_model_menu
)

:install_sdwebuiforge_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku Model in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Model in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Config in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix VAE in: "%~dp0image-generation\stable-diffusion-webui\models\VAE"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Perfect World Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%~dp0image-generation\stable-diffusion-webui\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_custom
cls
set /p civitaimodelid="(0 to cancel)Insert Model ID: "

if "%civitaimodelid%"=="0" goto :install_sdwebuiforge_model_menu

REM Check if the input is a valid number
echo %civitaimodelid%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_model_custom
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Downloading...
civitdl %civitaimodelid% -s basic "models\Stable-diffusion"

pause
goto :install_sdwebuiforge_model_menu


:install_comfyui
title STL [INSTALL COMFYUI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install ComfyUI%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing ComfyUI...

REM Check if the folder exists
if not exist "%~dp0image-generation" (
    mkdir "%~dp0image-generation"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "image-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "image-generation" folder already exists.%reset%
)
cd /d "%~dp0image-generation"


set max_retries=3
set retry_count=0
:retry_install_comfyui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the ComfyUI repository...
git clone https://github.com/comfyanonymous/ComfyUI.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_comfyui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_image_generation
)
cd /d "ComfyUI"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named comfyui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%comfyui%reset%
call conda create -n comfyui python=3.11 -y

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment %cyan_fg_strong%comfyui%reset
call conda activate comfyui

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements...
pip install -r requirements.txt
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121

REM Clone extensions for ComfyUI
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning extensions for ComfyUI...
cd /d "%~dp0image-generation/ComfyUI/custom_nodes"
git clone https://github.com/ltdrdata/ComfyUI-Manager.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Better Upscaler models...
cd /d "%~dp0image-generation/ComfyUI/models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/konohashinobi4/4xAnimesharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ComfyUI successfully installed.%reset%
pause
goto :app_installer_image_generation


:install_fooocus
title STL [INSTALL FOOOCUS]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install Fooocus%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Fooocus...

REM Check if the folder exists
if not exist "%~dp0image-generation" (
    mkdir "%~dp0image-generation"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "image-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "image-generation" folder already exists.%reset%
)
cd /d "%~dp0image-generation"

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
cd /d "Fooocus"

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


REM ############################################################
REM ######## APP INSTALLER CORE UTILITIES - FRONTEND ###########
REM ############################################################
:app_installer_core_utilities
title STL [APP INSTALLER CORE UTILITIES]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Core Utilities%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install 7-Zip
echo 2. Install FFmpeg
echo 3. Install Node.js
echo 4. Install yq
echo 5. Install Visual Studio BuildTools
echo 6. Install CUDA Toolkit
echo 0. Back

set /p app_installer_core_util_choice=Choose Your Destiny: 

REM ######## APP INSTALLER CORE UTILITIES - BACKEND ###########
if "%app_installer_core_util_choice%"=="1" (
    call :install_7zip
) else if "%app_installer_core_util_choice%"=="2" (
    call :install_ffmpeg
) else if "%app_installer_core_util_choice%"=="3" (
    call :install_nodejs
) else if "%app_installer_core_util_choice%"=="4" (
    call :install_yq
) else if "%app_installer_core_util_choice%"=="5" (
    call :install_vsbuildtools
) else if "%app_installer_core_util_choice%"=="6" (
    call :install_cudatoolkit
) else if "%app_installer_core_util_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_core_utilities
)


:install_7zip
title STL [INSTALL-7Z]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing 7-Zip...
winget install -e --id 7zip.7zip

rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Check if the paths are already in the current PATH
echo %current_path% | find /i "%zip7_install_path%" > nul
set "zip7_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %zip7_path_exists% neq 0 (
    set "new_path=%current_path%;%zip7_install_path%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "zip7_install_path is:%cyan_fg_strong% %zip7_install_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%7-zip added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] 7-Zip already exists in PATH.%reset%
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%7-Zip installed successfully. Please restart the Launcher.%reset%
pause
exit


:install_ffmpeg
title STL [INSTALL-FFMPEG]
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] 7z command not found in PATH.%reset%
    echo %red_fg_strong%7-Zip is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install 7-Zip%reset%
    pause
    goto :app_installer_core_utilities
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading FFmpeg archive...
curl -L -o "%ffdownload_path%" "%ffmpeg_url%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating ffmpeg directory if it doesn't exist...
if not exist "%ffextract_path%" (
    mkdir "%ffextract_path%"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Extracting FFmpeg archive...
7z x "%ffdownload_path%" -o"%ffextract_path%"


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Moving FFmpeg contents to C:\ffmpeg...
for /d %%i in ("%ffextract_path%\ffmpeg-*-full_build") do (
    xcopy "%%i\bin" "%ffextract_path%\bin" /E /I /Y
    xcopy "%%i\doc" "%ffextract_path%\doc" /E /I /Y
    xcopy "%%i\presets" "%ffextract_path%\presets" /E /I /Y
    rd "%%i" /S /Q
)

rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Check if the paths are already in the current PATH
echo %current_path% | find /i "%ffmpeg_path_bin%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%ffmpeg_path_bin%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "ffmpeg_path_bin is:%cyan_fg_strong% %ffmpeg_path_bin%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ffmpeg added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] ffmpeg already exists in PATH.%reset%
)
del "%ffdownload_path%"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ffmpeg installed successfully. Please restart the Launcher.%reset%
pause
exit


:install_nodejs
title STL [INSTALL-NODEJS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Node.js...
winget install -e --id OpenJS.NodeJS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Node.js is installed. Please restart the Launcher.%reset%
pause
exit

:install_yq
title STL [INSTALL-YQ]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing yq...
winget install -e --id MikeFarah.yq
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%yq is installed. Please restart the Launcher.%reset%
pause
exit

:install_vsbuildtools
REM Check if file exists
if not exist "%~dp0bin\vs_buildtools.exe" (
    REM Check if the folder exists
    if not exist "%~dp0bin" (
        mkdir "%~dp0bin"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "bin"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "bin" folder already exists.%reset%
    )
    curl -L -o "%~dp0bin\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "vs_buildtools.exe" file already exists. Downloading latest version...%reset%
    del "%~dp0bin\vs_buildtools.exe"
    curl -L -o "%~dp0bin\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Visual Studio BuildTools 2022...
start "" "%~dp0bin\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%When install is finished please restart the Launcher.%reset%
pause
exit


:install_cudatoolkit
REM Check if file exists
if not exist "%temp%\cuda_12.4.0_windows_network.exe" (
    curl -L -o "%temp%\cuda_12.4.0_windows_network.exe" "https://developer.download.nvidia.com/compute/cuda/12.4.0/network_installers/cuda_12.4.0_windows_network.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "cuda_12.4.0_windows_network.exe" file already exists.%reset%
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing CUDA Toolkit...
start "" "%temp%\cuda_12.4.0_windows_network.exe" visual_studio_integration_12.4
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%When install is finished please restart the Launcher.%reset%

REM If CUDA Toolkit fails to install then copy all files from MSBuildExtensions into BuildCustomizations
REM xcopy /s /i /y "%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v12.4\extras\visual_studio_integration\MSBuildExtensions\*" "%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Microsoft\VC\v170\BuildCustomizations"
pause
exit


REM ############################################################
REM ############## APP UNINSTALLER - FRONTEND ##################
REM ############################################################
:app_uninstaller
title STL [APP UNINSTALLER]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Uninstaller%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Text Completion
echo 2. Image Generation 
echo 3. Core Utilities
echo 0. Back

set /p app_uninstaller_choice=Choose Your Destiny: 

REM ############## APP UNINSTALLER - BACKEND ####################
if "%app_uninstaller_choice%"=="1" (
    call :app_uninstaller_text_completion
) else if "%app_uninstaller_choice%"=="2" (
    call :app_uninstaller_image_generation
) else if "%app_uninstaller_choice%"=="3" (
    call :app_uninstaller_core_utilities
) else if "%app_uninstaller_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller
)


REM ############################################################
REM ######## APP UNINSTALLER TEXT COMPLETION - FRONTEND ########
REM ############################################################
:app_uninstaller_text_completion
title STL [APP UNINSTALLER TEXT COMPLETION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Uninstaller / Text Completion%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. UNINSTALL Text generation web UI oobabooga
echo 2. UNINSTALL koboldcpp
echo 3. UNINSTALL TabbyAPI
echo 0. Back

set /p app_uninstaller_txt_comp_choice=Choose Your Destiny: 

REM ####### APP UNINSTALLER TEXT COMPLETION - BACKEND ##########
if "%app_uninstaller_txt_comp_choice%"=="1" (
    call :uninstall_ooba
) else if "%app_uninstaller_txt_comp_choice%"=="2" (
    call :uninstall_koboldcpp
) else if "%app_uninstaller_txt_comp_choice%"=="3" (
    call :uninstall_tabbyapi
) else if "%app_uninstaller_txt_comp_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_text_completion
)


:uninstall_ooba
title STL [UNINSTALL OOBABOOGA]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of Text generation web UI oobabooga                        ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the folder text-generation-webui
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the text-generation-webui directory...
    cd /d "%~dp0text-completion"
    rmdir /s /q "text-generation-webui"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Text generation web UI oobabooga has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_text_completion
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_text_completion
)


:uninstall_koboldcpp
title STL [UNINSTALL KOBOLDCPP]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of koboldcpp                                               ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%koboldcpp%reset%
    call conda remove --name koboldcpp --all -y
    call conda clean -a -y

    REM Remove the folder koboldcpp
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the koboldcpp directory...
    cd /d "%~dp0text-completion"
    rmdir /s /q "dev-koboldcpp"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the w64devkit directory...
    rmdir /s /q "%w64devkit_path%" 
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%koboldcpp has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_text_completion
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_text_completion
)


:uninstall_tabbyapi
title STL [UNINSTALL TABBYAPI]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of TabbyAPI                                                ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%tabbyapi%reset%
    call conda remove --name tabbyapi --all -y
    call conda clean -a -y

    REM Remove the folder tabbyAPI
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the tabbyAPI directory...
    cd /d "%~dp0text-completion"
    rmdir /s /q "tabbyAPI"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%TabbyAPI has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_text_completion
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_text_completion
)


REM ############################################################
REM ######## APP UNINSTALLER IMAGE GENERATION - FRONTEND #######
REM ############################################################
:app_uninstaller_image_generation
title STL [APP UNINSTALLER IMAGE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Uninstaller / Image Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. UNINSTALL Stable Diffusion web UI
echo 2. UNINSTALL Stable Diffusion web UI Forge
echo 3. UNINSTALL ComfyUI
echo 4. UNINSTALL Fooocus
echo 0. Back

set /p app_uninstaller_img_gen_choice=Choose Your Destiny: 

REM ######## APP UNINSTALLER IMAGE GENERATION - BACKEND #########
if "%app_uninstaller_img_gen_choice%"=="1" (
    call :uninstall_sdwebui
) else if "%app_uninstaller_img_gen_choice%"=="2" (
    goto :uninstall_sdwebuiforge
) else if "%app_uninstaller_img_gen_choice%"=="3" (
    goto :uninstall_comfyui
) else if "%app_uninstaller_img_gen_choice%"=="4" (
    goto :uninstall_fooocus
) else if "%app_uninstaller_img_gen_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_image_generation
)


:uninstall_sdwebui
title STL [UNINSTALL STABLE DIFUSSION WEBUI]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of Stable Diffusion web UI                                 ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%sdwebui%reset%
    call conda remove --name sdwebui --all -y
    call conda clean -a -y

    REM Remove the folder stable-diffusion-webui
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the stable-diffusion-webui directory...
    cd /d "%~dp0image-generation"
    rmdir /s /q "stable-diffusion-webui"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Stable Diffusion web UI has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_image_generation
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_image_generation
)


:uninstall_sdwebuiforge
title STL [UNINSTALL STABLE DIFUSSION WEBUI FORGE]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of Stable Diffusion web UI Forge                           ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%sdwebuiforge%reset%
    call conda remove --name sdwebuiforge --all -y
    call conda clean -a -y

    REM Remove the folder stable-diffusion-webui
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the stable-diffusion-webui-forge directory...
    cd /d "%~dp0image-generation"
    rmdir /s /q "stable-diffusion-webui-forge"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Stable Diffusion web UI Forge has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_image_generation
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_image_generation
)


:uninstall_comfyui
title STL [UNINSTALL COMFYUI]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of ComfyUI                                                 ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%comfyui%reset%
    call conda remove --name comfyui --all -y
    call conda clean -a -y

    REM Remove the folder ComfyUI
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the ComfyUI directory...
    cd /d "%~dp0image-generation"
    rmdir /s /q "ComfyUI"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ComfyUI has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_image_generation
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_image_generation
)


:uninstall_fooocus
title STL [UNINSTALL FOOOCUS]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of Fooocus                                                 ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%fooocus%reset%
    call conda remove --name fooocus --all -y
    call conda clean -a -y

    REM Remove the folder Fooocus
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Fooocus directory...
    cd /d "%~dp0image-generation"
    rmdir /s /q "Fooocus"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Fooocus has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_image_generation
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_image_generation
)


REM ############################################################
REM ######## APP UNINSTALLER CORE UTILITIES - FRONTEND #########
REM ############################################################
:app_uninstaller_core_utilities
title STL [APP UNINSTALLER CORE UTILITIES]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Uninstaller / Core Utilities%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. UNINSTALL Extras
echo 2. UNINSTALL XTTS
echo 3. UNINSTALL SillyTavern
echo 4. UNINSTALL 7-Zip
echo 5. UNINSTALL FFmpeg
echo 6. UNINSTALL Node.js
echo 7. UNINSTALL yq
echo 8. UNINSTALL CUDA Toolkit
echo 9. UNINSTALL Visual Studio BuildTools
echo 0. Back

set /p app_uninstaller_core_util_choice=Choose Your Destiny: 

REM ######## APP UNINSTALLER CORE UTILITIES - BACKEND #########
if "%app_uninstaller_core_util_choice%"=="1" (
    call :uninstall_extras
) else if "%app_uninstaller_core_util_choice%"=="2" (
    call :uninstall_xtts
) else if "%app_uninstaller_core_util_choice%"=="3" (
    call :uninstall_st
) else if "%app_uninstaller_core_util_choice%"=="4" (
    call :uninstall_7zip
) else if "%app_uninstaller_core_util_choice%"=="5" (
    call :uninstall_ffmpeg
) else if "%app_uninstaller_core_util_choice%"=="6" (
    call :uninstall_nodejs
) else if "%app_uninstaller_core_util_choice%"=="7" (
    call :uninstall_yq
) else if "%app_uninstaller_core_util_choice%"=="8" (
    call :uninstall_cudatoolkit
) else if "%app_uninstaller_core_util_choice%"=="9" (
    call :uninstall_vsbuildtools
) else if "%app_uninstaller_core_util_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_core_utilities
)


:uninstall_extras
title STL [UNINSTALL EXTRAS]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of Extras                                                  ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%extras%reset%
    call conda remove --name extras --all -y
    call conda clean -a -y

    REM Remove the folder SillyTavern-extras
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the SillyTavern-extras directory...
    cd /d "%~dp0"
    rmdir /s /q "%~dp0SillyTavern-extras"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extras has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_core_utilities
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_core_utilities
)


:uninstall_xtts
title STL [UNINSTALL XTTS]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of XTTS                                                    ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%xtts%reset%
    call conda remove --name xtts --all -y
    call conda clean -a -y

    REM Remove the folder SillyTavern
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts directory...
    cd /d "%~dp0"
    rmdir /s /q "%~dp0xtts"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_core_utilities
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_core_utilities
)


:uninstall_st
title STL [UNINSTALL ST]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of SillyTavern                                             ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the folder SillyTavern
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the SillyTavern directory...
    cd /d "%~dp0"
    rmdir /s /q "%~dp0SillyTavern"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_core_utilities
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_core_utilities
)

:uninstall_7zip
title STL [UNINSTALL-7ZIP]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling 7-Zip...
winget uninstall --id 7zip.7zip
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%7-Zip has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities

:uninstall_ffmpeg
title STL [UNINSTALL-FFMPEG]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling ffmpeg...
rmdir /s /q "%ffextract_path%"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ffmpeg has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities

:uninstall_nodejs
title STL [UNINSTALL-NODEJS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling Node.js...
winget uninstall --id OpenJS.NodeJS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Node.js has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities


:uninstall_yq
title STL [UNINSTALL-YQ]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling yq...
winget uninstall --id MikeFarah.yq
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%yq has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities


:uninstall_cudatoolkit
title STL [UNINSTALL-CUDATOOLKIT]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling CUDA Toolkit...
winget uninstall --id Nvidia.CUDA
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%CUDA Toolkit has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities

:uninstall_vsbuildtools
title STL [UNINSTALL-VSBUILDTOOLS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling Visual Studio BuildTools 2022...
winget uninstall --id Microsoft.VisualStudio.2022.BuildTools
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Visual Studio BuildTools 2022 has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities


REM ############################################################
REM ################# EDITOR - FRONTEND ########################
REM ############################################################
:editor
title STL [EDITOR]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Text Completion
echo 2. Image Generation 
echo 3. Core Utilities
echo 0. Back

set /p editor_choice=Choose Your Destiny: 

REM ################# EDITOR - BACKEND ########################
if "%editor_choice%"=="1" (
    call :editor_text_completion
) else if "%editor_choice%"=="2" (
    call :editor_image_generation
) else if "%editor_choice%"=="3" (
    call :editor_core_utilities
) else if "%editor_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor
)


REM ############################################################
REM ######## EDITOR TEXT COMPLETION - FRONTEND #################
REM ############################################################
:editor_text_completion
title STL [EDITOR TEXT COMPLETION]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Edit Text generation web UI oobabooga
echo 2. Edit koboldcpp
echo 3. Edit TabbyAPI
echo 0. Back

set /p editor_txt_comp_choice=Choose Your Destiny: 

REM ####### EDITOR TEXT COMPLETION - BACKEND ##########
if "%editor_txt_comp_choice%"=="1" (
    call :edit_ooba_modules
) else if "%editor_txt_comp_choice%"=="2" (
    call :edit_koboldcpp
) else if "%editor_txt_comp_choice%"=="3" (
    call :edit_tabbyapi
) else if "%editor_txt_comp_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_text_completion
)

REM ##################################################################################################################################################
REM ##################################################################################################################################################
REM ##################################################################################################################################################


REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b

REM ############################################################
REM ############## EDIT OOBA MODULES - FRONTEND ################
REM ############################################################
:edit_ooba_modules
title STL [EDIT OOBA MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit OOBA Modules%reset%
echo -------------------------------------------------------------
echo Choose OOBA modules to enable or disable (e.g., "1 2 4" to enable extensions openai, listen, and api-port)

REM Display module options with colors based on their status
call :printModule "1. extensions openai (--extensions openai)" %ooba_extopenai_trigger%
call :printModule "2. listen (--listen)" %ooba_listen_trigger%
call :printModule "3. listen-port (--listen-port 7910)" %ooba_listenport_trigger%
call :printModule "4. api-port (--api-port 7911)" %ooba_apiport_trigger%
call :printModule "5. autolaunch (--autolaunch)" %ooba_autolaunch_trigger%
call :printModule "6. verbose (--verbose)" %ooba_verbose_trigger%

echo 00. Quick Start Text generation web UI oobabooga
echo 0. Back

set "python_command="

set /p ooba_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%ooba_module_choices%) do (
    if "%%i"=="1" (
        if "%ooba_extopenai_trigger%"=="true" (
            set "ooba_extopenai_trigger=false"
        ) else (
            set "ooba_extopenai_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%ooba_listen_trigger%"=="true" (
            set "ooba_listen_trigger=false"
        ) else (
            set "ooba_listen_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%ooba_listenport_trigger%"=="true" (
            set "ooba_listenport_trigger=false"
        ) else (
            set "ooba_listenport_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%ooba_apiport_trigger%"=="true" (
            set "ooba_apiport_trigger=false"
        ) else (
            set "ooba_apiport_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%ooba_autolaunch_trigger%"=="true" (
            set "ooba_autolaunch_trigger=false"
        ) else (
            set "ooba_autolaunch_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%ooba_verbose_trigger%"=="true" (
            set "ooba_verbose_trigger=false"
        ) else (
            set "ooba_verbose_trigger=true"
        )

    ) else if "%%i"=="00" (
        goto :start_ooba

    ) else if "%%i"=="0" (
        goto :editor_text_completion
    )
)

REM Save the module flags to modules-ooba
echo ooba_extopenai_trigger=%ooba_extopenai_trigger%>%ooba_modules_path%
echo ooba_listen_trigger=%ooba_listen_trigger%>>%ooba_modules_path%
echo ooba_listenport_trigger=%ooba_listenport_trigger%>>%ooba_modules_path%
echo ooba_apiport_trigger=%ooba_apiport_trigger%>>%ooba_modules_path%
echo ooba_autolaunch_trigger=%ooba_autolaunch_trigger%>>%ooba_modules_path%
echo ooba_verbose_trigger=%ooba_verbose_trigger%>>%ooba_modules_path%


REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=start start_windows.bat"
if "%ooba_extopenai_trigger%"=="true" (
    set "python_command=%python_command% --extensions openai"
)
if "%ooba_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%ooba_listenport_trigger%"=="true" (
    set "python_command=%python_command% --listen-port 7910"
)
if "%ooba_apiport_trigger%"=="true" (
    set "python_command=%python_command% --api-port 7911"
)
if "%ooba_autolaunch_trigger%"=="true" (
    set "python_command=%python_command% --auto-launch"
)
if "%ooba_verbose_trigger%"=="true" (
    set "python_command=%python_command% --verbose"
)


REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-ooba for testing
echo ooba_start_command=%python_command%>>%ooba_modules_path%
goto :edit_ooba_modules


:edit_koboldcpp
echo COMMING SOON
pause
goto :editor_text_completion


:edit_tabbyapi
echo COMMING SOON
pause
goto :editor_text_completion


REM ############################################################
REM ######## EDITOR IMAGE GENERATION - FRONTEND ################
REM ############################################################
:editor_image_generation
title STL [EDITOR IMAGE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Image Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Edit Stable Diffusion web UI
echo 2. Edit Stable Diffusion web UI Forge
echo 3. Edit ComfyUI
echo 4. Edit Fooocus
echo 0. Back

set /p editor_img_gen_choice=Choose Your Destiny: 

REM ######## EDITOR IMAGE GENERATION - BACKEND #########
if "%editor_img_gen_choice%"=="1" (
    call :edit_sdwebui_modules
) else if "%editor_img_gen_choice%"=="2" (
    goto :edit_sdwebuiforge
) else if "%editor_img_gen_choice%"=="3" (
    goto :edit_comfyui
) else if "%editor_img_gen_choice%"=="4" (
    goto :edit_fooocus
) else if "%editor_img_gen_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_image_generation
)


REM ##################################################################################################################################################
REM ##################################################################################################################################################
REM ##################################################################################################################################################

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b

REM ############################################################
REM ############## EDIT SDWEBUI MODULES - FRONTEND #############
REM ############################################################
:edit_sdwebui_modules
title STL [EDIT SDWEBUI MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Image Generation / Edit SDWEBUI Modules%reset%
echo -------------------------------------------------------------
echo Choose SDWEBUI modules to enable or disable (e.g., "1 2 4" to enable autolaunch, api, and opt-sdp-attention)

REM Display module options with colors based on their status
call :printModule "1. autolaunch (--autolaunch)" %sdwebui_autolaunch_trigger%
call :printModule "2. api (--api)" %sdwebui_api_trigger%
call :printModule "3. port (--port 7900)" %sdwebui_port_trigger%
call :printModule "4. opt-sdp-attention (--opt-sdp-attention)" %sdwebui_optsdpattention_trigger%
call :printModule "5. listen (--listen)" %sdwebui_listen_trigger%
call :printModule "6. theme dark (--theme dark)" %sdwebui_themedark_trigger%
call :printModule "7. skip torchcudatest (--skip-torch-cuda-test)" %sdwebui_skiptorchcudatest_trigger%
call :printModule "8. low vram (--lowvram)" %sdwebui_lowvram_trigger%
call :printModule "9. med vram (--medvram)" %sdwebui_medvram_trigger%
echo 00. Quick Start Stable Diffusion WebUI
echo 0. Back

set "python_command="

set /p xtts_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%xtts_module_choices%) do (
    if "%%i"=="1" (
        if "%sdwebui_autolaunch_trigger%"=="true" (
            set "sdwebui_autolaunch_trigger=false"
        ) else (
            set "sdwebui_autolaunch_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%sdwebui_api_trigger%"=="true" (
            set "sdwebui_api_trigger=false"
        ) else (
            set "sdwebui_api_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%sdwebui_port_trigger%"=="true" (
            set "sdwebui_port_trigger=false"
        ) else (
            set "sdwebui_port_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%sdwebui_optsdpattention_trigger%"=="true" (
            set "sdwebui_optsdpattention_trigger=false"
        ) else (
            set "sdwebui_optsdpattention_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%sdwebui_listen_trigger%"=="true" (
            set "sdwebui_listen_trigger=false"
        ) else (
            set "sdwebui_listen_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%sdwebui_themedark_trigger%"=="true" (
            set "sdwebui_themedark_trigger=false"
        ) else (
            set "sdwebui_themedark_trigger=true"
        )
    ) else if "%%i"=="7" (
        if "%sdwebui_skiptorchcudatest_trigger%"=="true" (
            set "sdwebui_skiptorchcudatest_trigger=false"
        ) else (
            set "sdwebui_skiptorchcudatest_trigger=true"
        )
    ) else if "%%i"=="8" (
        if "%sdwebui_lowvram_trigger%"=="true" (
            set "sdwebui_lowvram_trigger=false"
        ) else (
            set "sdwebui_lowvram_trigger=true"
        )
    ) else if "%%i"=="9" (
        if "%sdwebui_medvram_trigger%"=="true" (
            set "sdwebui_medvram_trigger=false"
        ) else (
            set "sdwebui_medvram_trigger=true"
        )

    ) else if "%%i"=="00" (
        goto :start_sdwebui

    ) else if "%%i"=="0" (
        goto :editor_image_generation
    )
)

REM Save the module flags to modules-sdwebui
echo sdwebui_autolaunch_trigger=%sdwebui_autolaunch_trigger%>%sdwebui_modules_path%
echo sdwebui_api_trigger=%sdwebui_api_trigger%>>%sdwebui_modules_path%
echo sdwebui_port_trigger=%sdwebui_port_trigger%>>%sdwebui_modules_path%
echo sdwebui_optsdpattention_trigger=%sdwebui_optsdpattention_trigger%>>%sdwebui_modules_path%
echo sdwebui_listen_trigger=%sdwebui_listen_trigger%>>%sdwebui_modules_path%
echo sdwebui_themedark_trigger=%sdwebui_themedark_trigger%>>%sdwebui_modules_path%
echo sdwebui_skiptorchcudatest_trigger=%sdwebui_skiptorchcudatest_trigger%>>%sdwebui_modules_path%
echo sdwebui_lowvram_trigger=%sdwebui_lowvram_trigger%>>%sdwebui_modules_path%
echo sdwebui_medvram_trigger=%sdwebui_medvram_trigger%>>%sdwebui_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python launch.py"
if "%sdwebui_autolaunch_trigger%"=="true" (
    set "python_command=%python_command% --autolaunch"
)
if "%sdwebui_api_trigger%"=="true" (
    set "python_command=%python_command% --api"
)
if "%sdwebui_port_trigger%"=="true" (
    set "python_command=%python_command% --port 7900"
)
if "%sdwebui_optsdpattention_trigger%"=="true" (
    set "python_command=%python_command% --opt-sdp-attention"
)
if "%sdwebui_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%sdwebui_themedark_trigger%"=="true" (
    set "python_command=%python_command% --theme dark"
)
if "%sdwebui_skiptorchcudatest_trigger%"=="true" (
    set "python_command=%python_command% --skip-torch-cuda-test"
)
if "%sdwebui_lowvram_trigger%"=="true" (
    set "python_command=%python_command% --lowvram"
)
if "%sdwebui_medvram_trigger%"=="true" (
    set "python_command=%python_command% --medvram"
)

REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-sdwebui for testing
echo sdwebui_start_command=%python_command%>>%sdwebui_modules_path%
goto :edit_sdwebui_modules

REM ##################################################################################################################################################
REM ##################################################################################################################################################
REM ##################################################################################################################################################


:edit_sdwebuiforge
echo COMMING SOON
pause
goto :editor_image_generation


:edit_comfyui
echo COMMING SOON
pause
goto :editor_image_generation


:edit_fooocus
echo COMMING SOON
pause
goto :editor_image_generation


REM ############################################################
REM ######## EDITOR CORE UTILITIES - FRONTEND ##################
REM ############################################################
:editor_core_utilities
title STL [EDITOR CORE UTILITIES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Core Utilities%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Edit SillyTavern config.yaml
echo 2. Edit Extras
echo 3. Edit XTTS
echo 4. Edit Environment Variables
echo 0. Back

set /p editor_core_util_choice=Choose Your Destiny: 

REM ######## EDITOR CORE UTILITIES - FRONTEND ##################
if "%editor_core_util_choice%"=="1" (
    call :edit_st_config
) else if "%editor_core_util_choice%"=="2" (
    call :edit_extras_modules
) else if "%editor_core_util_choice%"=="3" (
    call :edit_xtts_modules
) else if "%editor_core_util_choice%"=="4" (
    call :edit_env_var
) else if "%editor_core_util_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_core_utilities
)

:edit_st_config
start "" "%~dp0SillyTavern\config.yaml"
goto :editor_core_utilities



REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b

REM ############################################################
REM ############## EDIT EXTRAS MODULES - FRONTEND ##############
REM ############################################################
:edit_extras_modules
title STL [EDIT EXTRAS MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Edit Extras Modules%reset%
echo -------------------------------------------------------------
echo Choose extras modules to enable or disable (e.g., "1 2 4" to enable Cuda, RVC, and Caption)

REM Display module options with colors based on their status
call :printModule "1. Cuda (--cuda)" %cuda_trigger%
call :printModule "2. RVC (--enable-modules=rvc --rvc-save-file --max-content-length=1000)" %rvc_trigger%
call :printModule "3. talkinghead (--enable-modules=talkinghead --talkinghead-gpu)" %talkinghead_trigger%
call :printModule "4. caption (--enable-modules=caption)" %caption_trigger%
call :printModule "5. summarize (--enable-modules=summarize)" %summarize_trigger%
call :printModule "6. listen (--listen)" %listen_trigger%
call :printModule "7. whisper (--enable-modules=whisper-stt)" %whisper_trigger%
call :printModule "8. Edge-tts (--enable-modules=edge-tts)" %edge_tts_trigger%
echo 00. Quick Start Extras
echo 0. Back

set "python_command="

set /p module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%module_choices%) do (
    if "%%i"=="1" (
        if "%cuda_trigger%"=="true" (
            set "cuda_trigger=false"
        ) else (
            set "cuda_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%rvc_trigger%"=="true" (
            set "rvc_trigger=false"
        ) else (
            set "rvc_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%talkinghead_trigger%"=="true" (
            set "talkinghead_trigger=false"
        ) else (
            set "talkinghead_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%caption_trigger%"=="true" (
            set "caption_trigger=false"
        ) else (
            set "caption_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%summarize_trigger%"=="true" (
            set "summarize_trigger=false"
        ) else (
            set "summarize_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%listen_trigger%"=="true" (
            set "listen_trigger=false"
        ) else (
            set "listen_trigger=true"
        )

    ) else if "%%i"=="7" (
        if "%whisper_trigger%"=="true" (
            set "whisper_trigger=false"
        ) else (
            set "whisper_trigger=true"
        )

    ) else if "%%i"=="8" (
        if "%edge_tts_trigger%"=="true" (
            set "edge_tts_trigger=false"
        ) else (
            set "edge_tts_trigger=true"
        )

    ) else if "%%i"=="00" (
        goto :start_extras

    ) else if "%%i"=="0" (
        goto :editor_core_utilities
    )
)

REM Save the module flags
echo cuda_trigger=%cuda_trigger%>%extras_modules_path%
echo rvc_trigger=%rvc_trigger%>>%extras_modules_path%
echo talkinghead_trigger=%talkinghead_trigger%>>%extras_modules_path%
echo caption_trigger=%caption_trigger%>>%extras_modules_path%
echo summarize_trigger=%summarize_trigger%>>%extras_modules_path%
echo listen_trigger=%listen_trigger%>>%extras_modules_path%
echo whisper_trigger=%whisper_trigger%>>%extras_modules_path%
echo edge_tts_trigger=%edge_tts_trigger%>>%extras_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python server.py"
if "%listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%cuda_trigger%"=="true" (
    set "python_command=%python_command% --cuda"
)
if "%rvc_trigger%"=="true" (
    set "python_command=%python_command% --rvc-save-file --max-content-length=1000"
    set "modules_enable=%modules_enable%rvc,"
)
if "%talkinghead_trigger%"=="true" (
    set "python_command=%python_command% --talkinghead-gpu"
    set "modules_enable=%modules_enable%talkinghead,"
)
if "%caption_trigger%"=="true" (
    set "modules_enable=%modules_enable%caption,"
)
if "%summarize_trigger%"=="true" (
    set "modules_enable=%modules_enable%summarize,"
)
if "%whisper_trigger%"=="true" (
    set "modules_enable=%modules_enable%whisper-stt,"
)
if "%edge_tts_trigger%"=="true" (
    set "modules_enable=%modules_enable%edge-tts,"
)

REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-extras for testing
echo extras_start_command=%python_command%>>%extras_modules_path%
goto :edit_extras_modules

REM ##################################################################################################################################################
REM ##################################################################################################################################################
REM ##################################################################################################################################################

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b


REM ############################################################
REM ############## EDIT XTTS MODULES - FRONTEND ################
REM ############################################################
:edit_xtts_modules
title STL [EDIT XTTS MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Edit XTTS Modules%reset%
echo -------------------------------------------------------------
echo Choose XTTS modules to enable or disable (e.g., "1 2 4" to enable Cuda, hs, and cache)

REM Display module options with colors based on their status
call :printModule "1. cuda (--device cuda)" %xtts_cuda_trigger%
call :printModule "2. hs (-hs 0.0.0.0)" %xtts_hs_trigger%
call :printModule "3. deepspeed (--deepspeed)" %xtts_deepspeed_trigger%
call :printModule "4. cache (--use-cache)" %xtts_cache_trigger%
call :printModule "5. listen (--listen)" %xtts_listen_trigger%
call :printModule "6. model (--model-source local)" %xtts_model_trigger%
echo 00. Quick Start XTTS
echo 0. Back

set "python_command="

set /p xtts_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%xtts_module_choices%) do (
    if "%%i"=="1" (
        if "%xtts_cuda_trigger%"=="true" (
            set "xtts_cuda_trigger=false"
        ) else (
            set "xtts_cuda_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%xtts_hs_trigger%"=="true" (
            set "xtts_hs_trigger=false"
        ) else (
            set "xtts_hs_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%xtts_deepspeed_trigger%"=="true" (
            set "xtts_deepspeed_trigger=false"
        ) else (
            set "xtts_deepspeed_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%xtts_cache_trigger%"=="true" (
            set "xtts_cache_trigger=false"
        ) else (
            set "xtts_cache_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%xtts_listen_trigger%"=="true" (
            set "xtts_listen_trigger=false"
        ) else (
            set "xtts_listen_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%xtts_model_trigger%"=="true" (
            set "xtts_model_trigger=false"
        ) else (
            set "xtts_model_trigger=true"
        )

    ) else if "%%i"=="00" (
        goto :start_xtts

    ) else if "%%i"=="0" (
        goto :editor_core_utilities
    )
)

REM Save the module flags to modules-xtts
echo xtts_cuda_trigger=%xtts_cuda_trigger%>%xtts_modules_path%
echo xtts_hs_trigger=%xtts_hs_trigger%>>%xtts_modules_path%
echo xtts_deepspeed_trigger=%xtts_deepspeed_trigger%>>%xtts_modules_path%
echo xtts_cache_trigger=%xtts_cache_trigger%>>%xtts_modules_path%
echo xtts_listen_trigger=%xtts_listen_trigger%>>%xtts_modules_path%
echo xtts_model_trigger=%xtts_model_trigger%>>%xtts_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python -m xtts_api_server"
if "%xtts_cuda_trigger%"=="true" (
    set "python_command=%python_command% --device cuda"
)
if "%xtts_hs_trigger%"=="true" (
    set "python_command=%python_command% -hs 0.0.0.0"
)
if "%xtts_deepspeed_trigger%"=="true" (
    set "python_command=%python_command% --deepspeed"
)
if "%xtts_cache_trigger%"=="true" (
    set "python_command=%python_command% --use-cache"
)
if "%xtts_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%xtts_model_trigger%"=="true" (
    set "python_command=%python_command% --model-source local"
)

REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-xtts for testing
echo xtts_start_command=%python_command%>>%xtts_modules_path%
goto :edit_xtts_modules

REM ##################################################################################################################################################
REM ##################################################################################################################################################
REM ##################################################################################################################################################


:edit_env_var
rundll32.exe sysdm.cpl,EditEnvironmentVariables
goto :editor_core_utilities


REM ############################################################
REM ############## TROUBLESHOOTING - FRONTEND ##################
REM ############################################################
:troubleshooting
title STL [TROUBLESHOOTING]
cls
echo %blue_fg_strong%/ Home / Toolbox / Troubleshooting%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Remove node_modules folder
echo 2. Fix unresolved conflicts or unmerged files [SillyTavern]
echo 3. Export dxdiag info
echo 4. Find what app is using port
echo 5. Set Onboarding Flow
echo 0. Back

set /p troubleshooting_choice=Choose Your Destiny: 

REM ############## TROUBLESHOOTING - BACKEND ##################
if "%troubleshooting_choice%"=="1" (
    call :remove_node_modules
) else if "%troubleshooting_choice%"=="2" (
    call :unresolved_unmerged
) else if "%troubleshooting_choice%"=="3" (
    call :export_dxdiag
) else if "%troubleshooting_choice%"=="4" (
    call :find_app_port
) else if "%troubleshooting_choice%"=="5" (
    call :onboarding_flow
) else if "%troubleshooting_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :troubleshooting
)


:remove_node_modules
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing node_modules folder...
cd /d "%~dp0SillyTavern"
rmdir /s /q "node_modules"
del package-lock.json
call npm cache clean --force
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% node_modules successfully removed.
pause
goto :troubleshooting


:unresolved_unmerged
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Trying to resolve unresolved conflicts in the working directory or unmerged files...
cd /d "%~dp0SillyTavern"
git merge --abort
git reset --hard
git pull --rebase --autostash
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Done.
pause
goto :troubleshooting


:export_dxdiag
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Exporting DirectX Diagnostic Tool information...
dxdiag /t "%~dp0dxdiag_info.txt"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%You can find the dxdiag_info.txt at: "%~dp0dxdiag_info.txt"%reset%
pause
goto :troubleshooting


REM Function to find and display the application using the specified port
:find_app_port
cls
setlocal EnableDelayedExpansion
set /p port_choice="(0 to cancel)Insert port number: "

if "%port_choice%"=="0" goto :troubleshooting

REM Check if the input is a number
set "valid=true"
for /f "delims=0123456789" %%i in ("!port_choice!") do set "valid=false"
if "!valid!"=="false" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input: Not a number.%reset%
    pause
    goto :troubleshooting
)

REM Check if the port is within range
if !port_choice! gtr 65535 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Port out of range. There are only 65,535 possible port numbers.%reset%
    echo [0-1023]: These ports are reserved for system services or commonly used protocols.
    echo [1024-49151]: These ports can be used by user processes or applications.
    echo [49152-65535]: These ports are available for use by any application or service on the system.
    pause
    goto :troubleshooting
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Searching for application using port: !port_choice!...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r "\<!port_choice!\>"') do (
    set pid=%%a
)

if defined pid (
    for /f "tokens=2*" %%b in ('tasklist /fi "PID eq !pid!" /fo list ^| find "Image Name"') do (
        echo Application Name: %cyan_fg_strong%%%c%reset%
        echo PID of Port !port_choice!: %cyan_fg_strong%!pid!%reset%
    )
) else (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN]%reset% Port: !port_choice! not found.
)
endlocal
pause
goto :troubleshooting


:onboarding_flow
set ONBOARDING_FLOW_VALUE=
set /p ONBOARDING_FLOW_VALUE="Enter new value for Onboarding Flow (true/false): "
yq eval -i ".firstRun = %ONBOARDING_FLOW_VALUE%" "%~dp0SillyTavern\public\settings.json"
goto :troubleshooting





REM ############################################################
REM ############## SWITCH BRANCE - FRONTEND ####################
REM ############################################################
:switch_brance
title STL [SWITCH-BRANCE]
cls
echo %blue_fg_strong%/ Home / Toolbox / Switch Branch%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Switch to Release - SillyTavern
echo 2. Switch to Staging - SillyTavern
echo 0. Back

REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo ======== VERSION STATUS =========
echo SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo =================================
set /p brance_choice=Choose Your Destiny: 

REM ################# SWITCH BRANCE - BACKEND ########################
if "%brance_choice%"=="1" (
    call :switch_brance_release_st
) else if "%brance_choice%"=="2" (
    call :switch_brance_staging_st
) else if "%brance_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :switch_brance
)


:switch_brance_release_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Switching to release branch...
cd /d "%~dp0SillyTavern"
git switch release
pause
goto :switch_brance


:switch_brance_staging_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Switching to staging branch...
cd /d "%~dp0SillyTavern"
git switch staging
pause
goto :switch_brance


REM ############################################################
REM ################# BACKUP - FRONTEND ########################
REM ############################################################
:backup
title STL [BACKUP]
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] 7z command not found in PATH.%reset%
    echo %red_fg_strong%7-Zip is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install 7-Zip%reset%
    pause
    goto :home
)
cls
echo %blue_fg_strong%/ Home / Toolbox / Backup%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Create Backup
echo 2. Restore Backup
echo 0. Back

set /p backup_choice=Choose Your Destiny: 

REM ################# BACKUP - BACKEND ########################
if "%backup_choice%"=="1" (
    call :create_backup
) else if "%backup_choice%"=="2" (
    call :restore_backup
) else if "%backup_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :backup
)

:create_backup
title STL [CREATE-BACKUP]
REM Create a backup using 7zip
7z a "%~dp0SillyTavern-backups\backup_.7z" ^
    "public\assets\*" ^
    "public\Backgrounds\*" ^
    "public\Characters\*" ^
    "public\Chats\*" ^
    "public\context\*" ^
    "public\Group chats\*" ^
    "public\Groups\*" ^
    "public\instruct\*" ^
    "public\KoboldAI Settings\*" ^
    "public\movingUI\*" ^
    "public\NovelAI Settings\*" ^
    "public\OpenAI Settings\*" ^
    "public\QuickReplies\*" ^
    "public\TextGen Settings\*" ^
    "public\themes\*" ^
    "public\User Avatars\*" ^
    "public\user\*" ^
    "public\worlds\*" ^
    "public\settings.json"

REM Get current date and time components
for /f "tokens=1-3 delims=/- " %%d in ("%date%") do (
    set "day=%%d"
    set "month=%%e"
    set "year=%%f"
)

for /f "tokens=1-2 delims=:." %%h in ("%time%") do (
    set "hour=%%h"
    set "minute=%%i"
)

REM Pad single digits with leading zeros
setlocal enabledelayedexpansion
set "day=0!day!"
set "month=0!month!"
set "hour=0!hour!"
set "minute=0!minute!"

set "formatted_date=%month:~-2%-%day:~-2%-%year%_%hour:~-2%%minute:~-2%"

REM Rename the backup file with the formatted date and time
rename "%~dp0SillyTavern-backups\backup_.7z" "backup_%formatted_date%.7z"

endlocal


echo %green_fg_strong%Backup created at %~dp0SillyTavern-backups%reset%
pause
endlocal
goto :backup


:restore_backup
title STL [RESTORE-BACKUP]

echo List of available backups:
echo =========================

setlocal enabledelayedexpansion
set "backup_count=0"

for %%F in ("%~dp0SillyTavern-backups\backup_*.7z") do (
    set /a "backup_count+=1"
    set "backup_files[!backup_count!]=%%~nF"
    echo !backup_count!. %cyan_fg_strong%%%~nF%reset%
)

echo =========================
set /p "restore_choice=(0 to cancel)Enter number of backup to restore: "

if "%restore_choice%"=="0" goto :backup

if "%restore_choice%" geq "1" (
    if "%restore_choice%" leq "%backup_count%" (
        set "selected_backup=!backup_files[%restore_choice%]!"
        echo Restoring backup !selected_backup!...
        REM Extract the contents of the "public" folder directly into the existing "public" folder
        7z x "%~dp0SillyTavern-backups\!selected_backup!.7z" -o"temp" -aoa
        xcopy /y /e "temp\public\*" "public\"
        rmdir /s /q "temp"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%!selected_backup! restored successfully.%reset%
    ) else (
        echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
        echo %red_bg%[%time%]%reset% %echo_invalidinput%
    )
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
)

pause
goto :backup


REM ############################################################
REM ############## SUPPORT - FRONTEND ##########################
REM ############################################################
:support
title STL [SUPPORT]
cls
echo %blue_fg_strong%/ Home / Support%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. I want to report a issue
echo 2. Documentation
echo 3. Discord
echo 0. Back

set /p support_choice=Choose Your Destiny: 

REM ############## SUPPORT - BACKEND ##########################
if "%support_choice%"=="1" (
    call :issue_report
) else if "%support_choice%"=="2" (
    call :documentation
) else if "%support_choice%"=="3" (
    call :discord
) else if "%support_choice%"=="0" (
    goto :home
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :support
)

:issue_report
start "" "https://github.com/SillyTavern/SillyTavern-Launcher/issues/new/choose"
goto :support

:documentation
start "" "https://docs.sillytavern.app/"
goto :support

:discord
start "" "https://discord.gg/sillytavern"
goto :support