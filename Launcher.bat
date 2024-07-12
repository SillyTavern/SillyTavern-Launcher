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

set "stl_version=1.2.1"
set "stl_title_pid=STL [TROUBLESHOOTING]"

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

REM Environment Variables (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM Environment Variables (miniconda3)
set "miniconda_path=%userprofile%\miniconda3"
set "miniconda_path_mingw=%userprofile%\miniconda3\Library\mingw-w64\bin"
set "miniconda_path_usrbin=%userprofile%\miniconda3\Library\usr\bin"
set "miniconda_path_bin=%userprofile%\miniconda3\Library\bin"
set "miniconda_path_scripts=%userprofile%\miniconda3\Scripts"

REM Environment Variables (7-Zip)
set "zip7_version=7z2301-x64"
set "zip7_install_path=%ProgramFiles%\7-Zip"
set "zip7_download_path=%TEMP%\%zip7_version%.exe"

REM Environment Variables (FFmpeg)
set "ffmpeg_download_url=https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z"
set "ffmpeg_download_path=%~dp0bin\ffmpeg.7z"
set "ffmpeg_install_path=C:\ffmpeg"
set "ffmpeg_path_bin=%ffmpeg_install_path%\bin"

REM Environment Variables (w64devkit)
set "w64devkit_download_url=https://github.com/skeeto/w64devkit/releases/download/v1.22.0/w64devkit-1.22.0.zip"
set "w64devkit_download_path=%~dp0bin\w64devkit-1.22.0.zip"
set "w64devkit_install_path=C:\w64devkit"
set "w64devkit_path_bin=%w64devkit_install_path%\bin"

REM Environment Variables (Node.js)
set "node_installer_path=%temp%\NodejsInstaller.msi"

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
set "websearch_trigger=false"

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

REM Define variables for install locations (Core Utilities)
set "stl_root=%~dp0"
set "st_install_path=%~dp0SillyTavern"
set "extras_install_path=%~dp0SillyTavern-extras"
set "st_backup_path=%~dp0SillyTavern-backups"

REM Define variables for install locations (Image Generation)
set "image_generation_dir=%~dp0image-generation"
set "sdwebui_install_path=%image_generation_dir%\stable-diffusion-webui"
set "sdwebuiforge_install_path=%image_generation_dir%\stable-diffusion-webui-forge"
set "comfyui_install_path=%image_generation_dir%\ComfyUI"
set "fooocus_install_path=%image_generation_dir%\Fooocus"

REM Define variables for install locations (Text Completion)
set "text_completion_dir=%~dp0text-completion"
set "ooba_install_path=%text_completion_dir%\text-generation-webui"
set "koboldcpp_install_path=%text_completion_dir%\dev-koboldcpp"
set "llamacpp_install_path=%text_completion_dir%\dev-llamacpp"
set "tabbyapi_install_path=%text_completion_dir%\tabbyAPI"

REM Define variables for install locations (Voice Generation)
set "voice_generation_dir=%~dp0voice-generation"
set "alltalk_install_path=%voice_generation_dir%\alltalk_tts"
set "xtts_install_path=%voice_generation_dir%\xtts"
set "rvc_install_path=%voice_generation_dir%\Retrieval-based-Voice-Conversion-WebUI"

REM Define variables for the core directories
set "bin_dir=%~dp0bin"
set "log_dir=%bin_dir%\logs"
set "functions_dir=%bin_dir%\functions"

REM Define variables for the directories for Toolbox
set "toolbox_dir=%functions_dir%\Toolbox"
set "troubleshooting_dir=%toolbox_dir%\Troubleshooting"
set "backup_dir=%toolbox_dir%\Backup"

REM Define variables for the directories for App Installer
set "app_installer_image_generation_dir=%functions_dir%\Toolbox\App_Installer\Image_Generation"
set "app_installer_text_completion_dir=%functions_dir%\Toolbox\App_Installer\Text_Completion"
set "app_installer_voice_generation_dir=%functions_dir%\Toolbox\App_Installer\Voice_Generation"
set "app_installer_core_utilities_dir=%functions_dir%\Toolbox\App_Installer\Core_Utilities"

REM Define variables for the directories for App Uninstaller
set "app_uninstaller_image_generation_dir=%functions_dir%\Toolbox\App_Uninstaller\Image_Generation"
set "app_uninstaller_text_completion_dir=%functions_dir%\Toolbox\App_Uninstaller\Text_Completion"
set "app_uninstaller_voice_generation_dir=%functions_dir%\Toolbox\App_Uninstaller\Voice_Generation"
set "app_uninstaller_core_utilities_dir=%functions_dir%\Toolbox\App_Uninstaller\Core_Utilities"

REM Define variables for the directories for Editor
set "editor_image_generation_dir=%functions_dir%\Toolbox\Editor\Image_Generation"
set "editor_text_completion_dir=%functions_dir%\Toolbox\Editor\Text_Completion"
set "editor_voice_generation_dir=%functions_dir%\Toolbox\Editor\Voice_Generation"
set "editor_core_utilities_dir=%functions_dir%\Toolbox\Editor\Core_Utilities"

REM Define variables for logging
set "logs_stl_console_path=%log_dir%\stl.log"
set "logs_st_console_path=%log_dir%\st_console_output.log"


REM Create the logs folder if it doesn't exist
if not exist "%log_dir%" (
    mkdir "%log_dir%"
)

set "log_invalidinput=[ERROR] Invalid input. Please enter a valid number."
set "echo_invalidinput=%red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%"

cd /d "%~dp0"

REM Check if folder path has no spaces
echo "%CD%"| findstr /C:" " >nul && (
    echo %red_fg_strong%[ERROR] Path cannot have spaces! Please remove them or replace with: - %reset%
    echo Folders containing spaces makes the launcher unstable
    echo path: %red_bg%%~dp0%reset%
    pause
    exit /b 1
)

REM Check if folder path has no special characters
echo "%CD%"| findstr /R /C:"[!#\$%&()\*+,;<=>?@\[\]\^`{|}~]" >nul && (
    echo %red_fg_strong%[ERROR] Path cannot have special characters! Please remove them.%reset%
    echo Folders containing special characters makes the launcher unstable for the following: "[!#\$%&()\*+,;<=>?@\[\]\^`{|}~]" 
    echo path: %red_bg%%~dp0%reset%
    pause
    exit /b 1
)

REM Check if launcher has updates
title STL [UPDATE ST-LAUNCHER]
git fetch origin
for /f %%i in ('git branch --show-current') do set stl_current_branch=%%i
REM Get the list of commits between local and remote branch
for /f %%i in ('git rev-list HEAD..%stl_current_branch%@{upstream}') do (
    goto :startupcheck_found_update
)

REM If no updates are available, skip the update process
echo [ %green_fg_strong%OK%reset% ] SillyTavern-Launcher is up to date.%reset%
goto :startupcheck_no_update

:startupcheck_found_update
cls
echo %blue_fg_strong%[INFO]%reset% %cyan_fg_strong%New update for SillyTavern-Launcher is available!%reset%
set /p "update_choice=Update now? [Y/n]: "
if /i "%update_choice%"=="" set update_choice=Y
if /i "%update_choice%"=="Y" (
    REM Update the repository
    git pull
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern-Launcher updated successfully. Restarting launcher...%reset%
    timeout /t 10
    start launcher.bat
    exit
) else (
    goto :startupcheck_no_update
)



:startupcheck_no_update
title STL [STARTUP CHECK]
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
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-extras.txt"  
)
REM Load modules-extras flags from modules
for /f "tokens=*" %%a in (%extras_modules_path%) do set "%%a"


REM Create modules-xtts if it doesn't exist
if not exist %xtts_modules_path% (
    type nul > %xtts_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-xtts.txt"  
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%xtts_modules_path%) do set "%%a"


REM Create modules-sdwebui if it doesn't exist
if not exist %sdwebui_modules_path% (
    type nul > %sdwebui_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-sdwebui.txt"  
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%sdwebui_modules_path%) do set "%%a"


REM Create modules-ooba if it doesn't exist
if not exist %ooba_modules_path% (
    type nul > %ooba_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-ooba.txt"  
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
    echo [ %green_fg_strong%OK%reset% ] Found PATH: winget%reset%
)

REM Check if winget is installed; if not, then install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget is not installed on this system.%reset%
    REM Check if the folder exists
    if not exist "%~dp0bin" (
        mkdir "%~dp0bin"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created directory: "bin"  
    ) else (
        echo [ %green_fg_strong%OK%reset% ] Found directory: "bin"%reset%
    )
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing winget...
    curl -L -o "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    start "" "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%winget installed successfully. Please restart the Launcher.%reset%
    pause
    exit
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app: %cyan_fg_strong%winget%reset%
)

REM Check if Git is installed if not then install git
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Git is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Git using winget...
    winget install -e --id Git.Git
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Git is installed. Please restart the Launcher.%reset%
    pause
    exit
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app: %cyan_fg_strong%Git%reset%
)

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%miniconda_path%" > nul
set "ff_path_exists=%errorlevel%"

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%miniconda_path%;%miniconda_path_mingw%;%miniconda_path_usrbin%;%miniconda_path_bin%;%miniconda_path_scripts%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "miniconda_path is:%cyan_fg_strong% %miniconda_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%miniconda3 added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo [ %green_fg_strong%OK%reset% ] Found PATH: miniconda3%reset%
)

REM Check if Miniconda3 is installed if not then install Miniconda3
call conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Miniconda3 is not installed on this system. Could not find command: conda%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Checking if Miniconda3 exists in app list...
    winget uninstall --id Anaconda.Miniconda3
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Miniconda3 using winget...
    winget install -e --id Anaconda.Miniconda3
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Miniconda3 installed successfully. Please restart the Installer.%reset%
    pause
    exit
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app: %cyan_fg_strong%Miniconda3%reset%
)

REM Run PowerShell command to retrieve VRAM size and divide by 1GB
for /f "usebackq tokens=*" %%i in (`powershell -Command "$qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'; if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) { $qwMemorySize = [double]$qwMemorySize[0] } else { $qwMemorySize = [double]$qwMemorySize }; if ($null -ne $qwMemorySize) { [math]::Round($qwMemorySize/1GB) } else { 'Property not found' }"`) do (
    set "VRAM=%%i"
)

REM Check if the SillyTavern folder exists
if not exist "%st_install_path%" (
    set "update_status_st=%red_bg%[ERROR] SillyTavern not found in: "%~dp0"%reset%"
    goto :no_st_install_path
)


REM Change the current directory to 'sillytavern' folder
cd /d "%st_install_path%"

REM Check for updates
git fetch origin

REM Get the list of commits between local and remote branch
for /f %%i in ('git rev-list HEAD..%current_branch%@{upstream}') do (
    set "update_status_st=%yellow_fg_strong%Update Available%reset%"
    goto :found_update
)

set "update_status_st=%green_fg_strong%Up to Date%reset%"
:found_update

REM ############################################################
REM ################## HOME - FRONTEND #########################
REM ############################################################
:home
:no_st_install_path
cd /d "%st_install_path%"
title STL [HOME]
cls

set "SSL_INFO_FILE=%~dp0\SillyTavern\certs\SillyTavernSSLInfo.txt"
set "sslOptionSuffix="

REM Check if the SSL info file exists and set the suffix
if exist "%SSL_INFO_FILE%" (
    set "sslOptionSuffix= (With SSL)"
)

echo %blue_fg_strong%/ Home%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Start SillyTavern%sslOptionSuffix%
echo 2. Start SillyTavern With Remote Link%sslOptionSuffix%
REM Check if the custom shortcut file exists and is not empty
set "custom_name=Create Custom App Shortcut to Launch with SillyTavern"  ; Initialize to default
if exist "%~dp0bin\settings\custom-shortcut.txt" (
    set /p custom_name=<"%~dp0bin\settings\custom-shortcut.txt"
    if "!custom_name!"=="" set "custom_name=Create Custom Shortcut"
)
echo 3. %custom_name%
echo 4. Update Manager
echo 5. Toolbox
echo 6. Support
echo 7. More info about LLM models your GPU can run.
echo 0. Exit

echo ======== VERSION STATUS =========
REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo SillyTavern: %update_status_st%
echo STL Version: %stl_version%
echo GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
echo =================================

set "choice="
set /p "choice=Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM ################## HOME - BACKEND #########################
if "%choice%"=="1" (
    call %functions_dir%\launch\start_st.bat
    if %errorlevel% equ 1 goto :home
) else if "%choice%"=="2" (
    start "" "%~dp0SillyTavern\Remote-Link.cmd"
    echo "SillyTavern Remote Link Cloudflare Tunnel Launched"
    call %functions_dir%\launch\start_st.bat
    if %errorlevel% equ 1 goto :home
) else if "%choice%"=="3" (
    if exist "%~dp0bin\settings\custom-shortcut.txt" (
        call :launch_custom_shortcut
    ) else (
        call :create_custom_shortcut
    )
) else if "%choice%"=="4" (
    call :update_manager
) else if "%choice%"=="5" (
    call :toolbox
) else if "%choice%"=="6" (
    call :support
) else if "%choice%"=="7" (
    set "caller=home"
    if exist "%functions_dir%\launch\info_vram.bat" (
        call %functions_dir%\launch\info_vram.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: info_vram.bat not found in: %functions_dir%\launch >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] info_vram.bat not found in: %functions_dir%\launch%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%choice%"=="0" (
    set "caller=home"
    if exist "%functions_dir%\launch\exit_stl.bat" (
        call %functions_dir%\launch\exit_stl.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: exit_stl.bat not found in: %functions_dir%\launch >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] exit_stl.bat not found in: %functions_dir%\launch%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :home
)
goto :home

REM ############################################################
REM ############## UPDATE MANAGER - FRONTEND ###################
REM ############################################################
:update_manager
title STL [UPDATE MANAGER]
cls
echo %blue_fg_strong%/ Home / Update Manager%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Text Completion
echo 2. Voice Generation
echo 3. Image Generation
echo 4. Core Utilities
echo 0. Back

set /p update_manager_choice=Choose Your Destiny: 

REM ############## UPDATE MANAGER - BACKEND ####################
if "%update_manager_choice%"=="1" (
    call :update_manager_text_completion
) else if "%update_manager_choice%"=="2" (
    call :update_manager_voice_generation
) else if "%update_manager_choice%"=="3" (
    call :update_manager_image_generation
) else if "%update_manager_choice%"=="4" (
    call :update_manager_core_utilities
) else if "%update_manager_choice%"=="0" (
    goto :home
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager
)


REM ############################################################
REM ########## UPDATE MANAGER TEXT COMPLETION - FRONTEND #######
REM ############################################################
:update_manager_text_completion
title STL [UPDATE MANAGER TEXT COMPLETION]
cls
echo %blue_fg_strong%/ Home / Update Manager / Text Completion%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Update Text generation web UI (oobabooga)
echo 2. Update koboldcpp
echo 3. Update TabbyAPI
echo 0. Back

set /p update_manager_txt_comp_choice=Choose Your Destiny: 

REM ########## UPDATE MANAGER TEXT COMPLETION - BACKEND #########
if "%update_manager_txt_comp_choice%"=="1" (
    call :update_ooba
) else if "%update_manager_txt_comp_choice%"=="2" (
    call :update_koboldcpp
) else if "%update_manager_txt_comp_choice%"=="3" (
    call :update_tabbyapi
) else if "%update_manager_txt_comp_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_text_completion
)

:update_ooba
REM Check if text-generation-webui directory exists
if not exist "%ooba_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] text-generation-webui directory not found. Skipping update.%reset%
    pause
    goto :update_manager_text_completion
)

REM Update text-generation-webui
set max_retries=3
set retry_count=0

:retry_update_ooba
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating text-generation-webui...
cd /d "%ooba_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_ooba
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update text-generation-webui repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_text_completion
)

start "" "update_wizard_windows.bat"
echo When the update is finished:
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%text-generation-webui updated successfully.%reset%
pause
goto :update_manager_text_completion

:update_koboldcpp
REM Check if dev-koboldcpp directory exists
if not exist "%koboldcpp_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] dev-koboldcpp directory not found. Skipping update.%reset%
    pause
    goto :update_manager_text_completion
)

REM Check if koboldcpp file exists [koboldcpp NVIDIA]
if exist "%koboldcpp_install_path%\koboldcpp.exe" (
    REM Remove koboldcpp
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing koboldcpp.exe
    del "%koboldcpp_install_path%\koboldcpp.exe"
    curl -L -o "%koboldcpp_install_path%\koboldcpp.exe" "https://github.com/LostRuins/koboldcpp/releases/latest/download/koboldcpp.exe"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%koboldcpp updated successfully.%reset%
    pause
    goto :update_manager_text_completion
)
REM Check if koboldcpp file exists [koboldcpp AMD]
if exist "%koboldcpp_install_path%\koboldcpp_rocm.exe" (
    REM Remove koboldcpp_rocm
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing koboldcpp_rocm.exe
    del "%koboldcpp_install_path%\koboldcpp_rocm.exe"
    curl -L -o "%koboldcpp_install_path%\koboldcpp_rocm.exe" "https://github.com/YellowRoseCx/koboldcpp-rocm/releases/latest/download/koboldcpp_rocm.exe"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%koboldcpp_rocm updated successfully.%reset%
    pause
    goto :update_manager_text_completion
)


:update_tabbyapi
REM Check if tabbyAPI directory exists
if not exist "%tabbyapi_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] tabbyAPI directory not found. Skipping update.%reset%
    pause
    goto :update_manager_text_completion
)

REM Update tabbyAPI
set max_retries=3
set retry_count=0

:retry_update_tabbyapi
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating tabbyAPI...
cd /d "%tabbyapi_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_tabbyapi
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update tabbyAPI repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_text_completion
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%tabbyAPI updated successfully.%reset%
pause
goto :update_manager_text_completion


REM ############################################################
REM ########## UPDATE MANAGER VOICE GENERATION - FRONTEND ######
REM ############################################################
:update_manager_voice_generation
title STL [UPDATE MANAGER VOICE GENERATION]
cls
echo %blue_fg_strong%/ Home / Update Manager / Voice Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Update AllTalk
echo 2. Update XTTS
echo 3. Update RVC
echo 0. Back

set /p update_manager_voice_gen_choice=Choose Your Destiny: 

REM ########## UPDATE MANAGER TEXT COMPLETION - BACKEND ########
if "%update_manager_voice_gen_choice%"=="1" (
    call :update_alltalk
) else if "%update_manager_voice_gen_choice%"=="2" (
    call :update_xtts
) else if "%update_manager_voice_gen_choice%"=="3" (
    call :update_rvc
) else if "%update_manager_voice_gen_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_voice_generation
)

:update_alltalk
REM Check if alltalk_tts directory exists
if not exist "%alltalk_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] alltalk_tts directory not found. Skipping update.%reset%
    pause
    goto :update_manager_voice_generation
)

REM Update alltalk_tts
set max_retries=3
set retry_count=0

:retry_update_alltalk
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating alltalk_tts...
cd /d "%alltalk_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_alltalk
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update alltalk_tts repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_voice_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%alltalk_tts updated successfully.%reset%
pause
goto :update_manager_voice_generation


:update_xtts
REM Check if XTTS directory exists
if not exist "%xtts_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] xtts directory not found. Skipping update.%reset%
    pause
    goto :update_manager_voice_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating XTTS...
call conda activate xtts
pip install --upgrade xtts-api-server
call conda deactivate
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS updated successfully.%reset%
pause
goto :update_manager_voice_generation


:update_rvc
REM Check if the folder exists
if not exist "%rvc_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retrieval-based-Voice-Conversion-WebUI directory not found. Skipping update.%reset%
    pause
    goto :update_manager_voice_generation
)

REM Update Retrieval-based-Voice-Conversion-WebUI
set max_retries=3
set retry_count=0

:retry_update_rvc
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating Retrieval-based-Voice-Conversion-WebUI...
cd /d "%rvc_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_rvc
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update Retrieval-based-Voice-Conversion-WebUI repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_voice_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Retrieval-based-Voice-Conversion-WebUI updated successfully.%reset%
pause
goto :update_manager_voice_generation


REM ############################################################
REM ######## UPDATE MANAGER IMAGE GENERATION - FRONTEND ########
REM ############################################################
:update_manager_image_generation
title STL [UPDATE MANAGER IMAGE GENERATION]
cls
echo %blue_fg_strong%/ Home / Update Manager / Image Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Update Stable Diffusion web UI
echo 2. Update Stable Diffusion web UI Forge
echo 3. Update ComfyUI
echo 4. Update Fooocus
echo 0. Back

set /p update_manager_img_gen_choice=Choose Your Destiny: 

REM ######## UPDATE MANAGER IMAGE GENERATION - BACKEND #########
if "%update_manager_img_gen_choice%"=="1" (
    call :update_sdwebui
) else if "%update_manager_img_gen_choice%"=="2" (
    goto :update_sdwebuiforge
) else if "%update_manager_img_gen_choice%"=="3" (
    goto :update_comfyui
) else if "%update_manager_img_gen_choice%"=="4" (
    goto :update_fooocus
) else if "%update_manager_img_gen_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_image_generation
)

:update_sdwebui
REM Check if the folder exists
if not exist "%sdwebui_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] stable-diffusion-webui directory not found. Skipping update.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update stable-diffusion-webui
set max_retries=3
set retry_count=0

:retry_update_sdwebui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating stable-diffusion-webui...
cd /d "%sdwebui_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_sdwebui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update stable-diffusion-webui repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%stable-diffusion-webui updated successfully.%reset%
pause
goto :update_manager_image_generation


:update_sdwebuiforge
REM Check if the folder exists
if not exist "%sdwebuiforge_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] stable-diffusion-webui-forge directory not found. Skipping update.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update stable-diffusion-webui-forge
set max_retries=3
set retry_count=0

:retry_update_sdwebuiforge
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating stable-diffusion-webui-forge...
cd /d "%sdwebuiforge_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_sdwebuiforge
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update stable-diffusion-webui-forge repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%stable-diffusion-webui-forge updated successfully.%reset%
pause
goto :update_manager_image_generation


:update_comfyui
REM Check if the folder exists
if not exist "%comfyui_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] ComfyUI directory not found. Skipping update.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update ComfyUI
set max_retries=3
set retry_count=0

:retry_update_comfyui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating ComfyUI...
cd /d "%comfyui_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_comfyui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update ComfyUI repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ComfyUI updated successfully.%reset%
pause
goto :update_manager_image_generation


:update_fooocus
REM Check if the folder exists
if not exist "%fooocus_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Fooocus directory not found. Skipping update.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update Fooocus
set max_retries=3
set retry_count=0

:retry_update_fooocus
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating Fooocus...
cd /d "%fooocus_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_fooocus
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update Fooocus repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Fooocus updated successfully.%reset%
pause
goto :update_manager_image_generation


REM ############################################################
REM ######## UPDATE MANAGER CORE UTILITIES - FRONTEND #########
REM ############################################################
:update_manager_core_utilities
title STL [UPDATE MANAGER CORE UTILITIES]
cls
echo %blue_fg_strong%/ Home / Update Manager / Core Utilities%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Update SillyTavern
echo 2. Update Extras
echo 3. Update 7-Zip
echo 4. Update FFmpeg
echo 5. Update Node.js
echo 6. Update yq
echo 0. Back

set /p update_manager_core_util_choice=Choose Your Destiny: 

REM ######## UPDATE MANAGER CORE UTILITIES - BACKEND #########
if "%update_manager_core_util_choice%"=="1" (
    call :update_st
) else if "%update_manager_core_util_choice%"=="2" (
    call :update_extras
) else if "%update_manager_core_util_choice%"=="3" (
    call :update_7zip
) else if "%update_manager_core_util_choice%"=="4" (
    call :update_ffmpeg
) else if "%update_manager_core_util_choice%"=="5" (
    call :update_nodejs
) else if "%update_manager_core_util_choice%"=="6" (
    call :update_yq
) else if "%update_manager_core_util_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_core_utilities
)

:update_st
REM Check if SillyTavern directory exists
if not exist "%st_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] SillyTavern directory not found. Skipping update.%reset%
    pause
    goto :update_manager_core_utilities
)

REM Update SillyTavern
set max_retries=3
set retry_count=0

:retry_update_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating SillyTavern...
cd /d "%st_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_st
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update SillyTavern repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_core_utilities
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern updated successfully.%reset%
pause
goto :update_manager_core_utilities


:update_extras
REM Check if SillyTavern-extras directory exists
if not exist "%extras_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] SillyTavern-extras directory not found. Skipping update.%reset%
    pause
    goto :update_manager_core_utilities
)

REM Update SillyTavern-extras
set max_retries=3
set retry_count=0

:retry_update_extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating SillyTavern-extras...
cd /d "%extras_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_extras
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update SillyTavern-extras repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_core_utilities
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern-extras updated successfully.%reset%
pause
goto :update_manager_core_utilities


:update_7zip
winget upgrade 7zip.7zip
pause
goto :update_manager_core_utilities


:update_ffmpeg
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] 7z command not found in PATH.%reset%
    echo %red_fg_strong%7-Zip is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install 7-Zip%reset%
    pause
    goto :app_installer_core_utilities
)

REM Check if the folder exists
if exist "%ffmpeg_install_path%" (
    REM Remove ffmpeg folder if it already exist
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing ffmpeg installation...
    rmdir /s /q "%ffmpeg_install_path%
)


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading FFmpeg archive...
curl -L -o "%ffmpeg_download_path%" "%ffmpeg_download_url%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating ffmpeg directory if it doesn't exist...
if not exist "%ffmpeg_install_path%" (
    mkdir "%ffmpeg_install_path%"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Extracting FFmpeg archive...
7z x "%ffmpeg_download_path%" -o"%ffmpeg_install_path%"


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Moving FFmpeg contents to C:\ffmpeg...
for /d %%i in ("%ffmpeg_install_path%\ffmpeg-*-full_build") do (
    xcopy "%%i\bin" "%ffmpeg_install_path%\bin" /E /I /Y
    xcopy "%%i\doc" "%ffmpeg_install_path%\doc" /E /I /Y
    xcopy "%%i\presets" "%ffmpeg_install_path%\presets" /E /I /Y
    rd "%%i" /S /Q
)

del "%ffmpeg_download_path%"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ffmpeg updated successfully.%reset%
pause
goto :update_manager_core_utilities


:update_nodejs
winget upgrade OpenJS.NodeJS
pause
goto :update_manager_core_utilities


:update_yq
winget upgrade MikeFarah.yq
pause
goto :update_manager_core_utilities



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
echo 6. Switch Branch
echo 7. Troubleshooting
echo 8. Reset Custom Shortcut
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
    call :switch_branch
) else if "%toolbox_choice%"=="7" (
    call :troubleshooting
) else if "%toolbox_choice%"=="8" (
    call :reset_custom_shortcut
) else if "%toolbox_choice%"=="0" (
    goto :home
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
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
echo 2. Voice Generation
echo 3. Image Generation
echo 4. Core Utilities
echo 0. Back

set /p app_launcher_choice=Choose Your Destiny: 

REM ############## APP INSTALLER - BACKEND ####################
if "%app_launcher_choice%"=="1" (
    call :app_launcher_text_completion
) else if "%app_launcher_choice%"=="2" (
    call :app_launcher_voice_generation
) else if "%app_launcher_choice%"=="3" (
    call :app_launcher_image_generation
) else if "%app_launcher_choice%"=="4" (
    call :app_launcher_core_utilities
) else if "%app_launcher_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
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
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_text_completion
)

:start_ooba
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
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_ooba_modules.bat" (
        call %editor_text_completion_dir%\edit_ooba_modules.bat
        goto :app_launcher_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_ooba_modules.bat not found in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_ooba_modules.bat not found in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_launcher_text_completion
    )
)

set "ooba_start_command=%ooba_start_command:ooba_start_command=%"

REM Start Text generation web UI oobabooga with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Text generation web UI oobabooga launched in a new window.
cd /d "%ooba_install_path%" && %ooba_start_command%
goto :home


:start_koboldcpp
REM Start koboldcpp with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% koboldcpp launched in a new window.

cd /d "%koboldcpp_install_path%"
start "" "koboldcpp.exe"
goto :home


:start_tabbyapi
REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the extras environment
call conda activate tabbyapi

REM Start TabbyAPI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% TabbyAPI launched in a new window.

start cmd /k "title TabbyAPI && cd /d %tabbyapi_install_path% && python start.py"
goto :home


REM ############################################################
REM ########## APP LAUNCHER VOICE GENERATION - FRONTEND ########
REM ############################################################
:app_launcher_voice_generation
title STL [APP LAUNCHER VOICE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Launcher / Voice Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Start AllTalk
echo 2. Start XTTS
echo 3. Start RVC
echo 0. Back

set /p app_launcher_voice_gen_choice=Choose Your Destiny: 

REM ########## APP LAUNCHER TEXT COMPLETION - BACKEND #########
if "%app_launcher_voice_gen_choice%"=="1" (
    call :start_alltalk
) else if "%app_launcher_voice_gen_choice%"=="2" (
    call :start_xtts
) else if "%app_launcher_voice_gen_choice%"=="3" (
    call :start_rvc
) else if "%app_launcher_voice_gen_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_voice_generation
)


:start_alltalk
REM Activate the alltalk environment
call conda activate alltalk

REM Start AllTalk
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% AllTalk launched in a new window.
start cmd /k "title AllTalk && cd /d %alltalk_install_path% && python script.py"
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
start cmd /k "title XTTSv2 API Server && cd /d %xtts_install_path% && %xtts_start_command%"
goto :home


:start_rvc
REM Activate the alltalk environment
call conda activate rvc

REM Start RVC with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% RVC launched in a new window.
start cmd /k "title RVC && cd /d %rvc_install_path% && python infer-web.py --port 7897"
goto :home


REM ############################################################
REM ######## APP LAUNCHER IMAGE GENERATION - FRONTEND ##########
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
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_image_generation
)


:start_sdwebui
cd /d "%sdwebui_install_path%"

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
start cmd /k "title SDWEBUI && cd /d %sdwebui_install_path% && %sdwebui_start_command%"
goto :home

:start_sdwebuiforge
cd /d "%sdwebuiforge_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebuiforge%reset%
call conda activate sdwebuiforge

REM Start Stable Diffusion WebUI Forge with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Stable Diffusion WebUI Forge launched in a new window.
REM start cmd /k "title SDWEBUIFORGE && cd /d %sdwebuiforge_install_path% && %sdwebuiforge_start_command%"
start cmd /k "title SDWEBUIFORGE && cd /d %sdwebuiforge_install_path% && python launch.py"
goto :home

:start_comfyui
REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%comfyui%reset%
call conda activate comfyui

REM Start ComfyUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% ComfyUI launched in a new window.
start cmd /k "title ComfyUI && cd /d %comfyui_install_path% && python main.py --auto-launch --listen --port 7901"
goto :home


:start_fooocus
REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the fooocus environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%fooocus%reset%
call conda activate fooocus

REM Start Fooocus with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Fooocus launched in a new window.
start cmd /k "title Fooocus && cd /d %fooocus_install_path% && python entry_with_update.py"
goto :home


REM ############################################################
REM ######## APP LAUNCHER IMAGE GENERATION - FRONTEND ##########
REM ############################################################
:app_launcher_core_utilities
title STL [APP LAUNCHER IMAGE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Launcher / Core Utilities%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Start Extras
echo 0. Back

set /p app_launcher_core_util_choice=Choose Your Destiny: 

REM ######## APP LAUNCHER IMAGE GENERATION - BACKEND #########
if "%app_launcher_core_util_choice%"=="1" (
    call :start_extras
) else if "%app_launcher_core_util_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_core_utilities
)


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
start cmd /k "title SillyTavern Extras && cd /d %extras_install_path% && %extras_start_command%"
goto :home


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
echo 2. Voice Generation
echo 3. Image Generation
echo 4. Core Utilities
echo 0. Back

set /p app_installer_choice=Choose Your Destiny: 

REM ############## APP INSTALLER - BACKEND ####################
if "%app_installer_choice%"=="1" (
    call :app_installer_text_completion
) else if "%app_installer_choice%"=="2" (
    call :app_installer_voice_generation
) else if "%app_installer_choice%"=="3" (
    call :app_installer_image_generation
) else if "%app_installer_choice%"=="4" (
    call :app_installer_core_utilities
) else if "%app_installer_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
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
echo 3. TabbyAPI [Install options]
echo 4. Install llamacpp
echo 0. Back

set /p app_installer_txt_comp_choice=Choose Your Destiny: 

REM ######## APP INSTALLER TEXT COMPLETION - BACKEND ##########
if "%app_installer_txt_comp_choice%"=="1" (
    set "caller=app_installer_text_completion"
    if exist "%app_installer_text_completion_dir%\install_ooba.bat" (
        call %app_installer_text_completion_dir%\install_ooba.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: install_ooba.bat not found in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_ooba.bat not found in: %app_installer_text_completion_dir%%reset%
        pause
        goto :app_installer_text_completion
    )
) else if "%app_installer_txt_comp_choice%"=="2" (
    call :install_koboldcpp_menu
) else if "%app_installer_txt_comp_choice%"=="3" (
    call :install_tabbyapi_menu
) else if "%app_installer_txt_comp_choice%"=="4" (
    set "caller=app_installer_text_completion"
    if exist "%app_installer_text_completion_dir%\install_llamacpp.bat" (
        call %app_installer_text_completion_dir%\install_llamacpp.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: install_llamacpp.bat not found in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_llamacpp.bat not found in: %app_installer_text_completion_dir%%reset%
        pause
        goto :app_installer_text_completion
    )
) else if "%app_installer_txt_comp_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_text_completion
)


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
    set "caller=app_installer_text_completion_koboldcpp"
    if exist "%app_installer_text_completion_dir%\install_koboldcpp.bat" (
        call %app_installer_text_completion_dir%\install_koboldcpp.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: install_koboldcpp.bat not found in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_koboldcpp.bat not found in: %app_installer_text_completion_dir%%reset%
        pause
        goto :install_koboldcpp_menu
    )
) else if "%app_installer_koboldcpp_choice%"=="2" (
    set "caller=app_installer_text_completion_koboldcpp"
    if exist "%app_installer_text_completion_dir%\install_koboldcpp_raw.bat" (
        call %app_installer_text_completion_dir%\install_koboldcpp_raw.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: install_koboldcpp_raw.bat not found in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_koboldcpp_raw.bat not found in: %app_installer_text_completion_dir%%reset%
        pause
        goto :install_koboldcpp_menu
    )
) else if "%app_installer_koboldcpp_choice%"=="0" (
    goto :app_installer_text_completion
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_koboldcpp_menu
)


REM ############################################################
REM ######## APP INSTALLER TABBYAPI - FRONTEND #################
REM ############################################################
:install_tabbyapi_menu
title STL [APP INSTALLER TABBYAPI]

REM Check if the folder exists
if exist "%tabbyapi_install_path%" (
    REM Activate the tabbyapi environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Deactivating Conda environment: %cyan_fg_strong%tabbyapi%reset%
    call conda deactivate
)

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / TabbyAPI %reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install TabbyAPI
echo 2. Models [Install Options]
echo 0. Back

set /p app_installer_tabbyapi_choice=Choose Your Destiny: 

REM ##### APP INSTALLER TABBYAPI - BACKEND ######
if "%app_installer_tabbyapi_choice%"=="1" (
    set "caller=app_installer_text_completion_tabbyapi"
    if exist "%app_installer_text_completion_dir%\install_tabbyapi.bat" (
        call %app_installer_text_completion_dir%\install_tabbyapi.bat
        goto :install_tabbyapi_menu
    ) else (
        echo [%DATE% %TIME%] ERROR: install_tabbyapi.bat not found in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_tabbyapi.bat not found in: %app_installer_text_completion_dir%%reset%
        pause
        goto :install_tabbyapi_menu
    )
) else if "%app_installer_tabbyapi_choice%"=="2" (
    goto :install_tabbyapi_model_menu
) else if "%app_installer_tabbyapi_choice%"=="0" (
    goto :app_installer_text_completion
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_tabbyapi_menu
)


REM ############################################################
REM ##### APP INSTALLER TABBYAPI Models - FRONTEND #############
REM ############################################################
:install_tabbyapi_model_menu
title STL [APP INSTALLER TABBYAPI MODELS]

REM Check if the folder exists
if not exist "%tabbyapi_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] TabbyAPI is not installed. Please install it first.%reset%
    pause
    goto :install_tabbyapi_menu
)

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the tabbyapi environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%tabbyapi%reset%
call conda activate tabbyapi

cd /d "%tabbyapi_install_path%"

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / TabbyAPI / Models%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install Hathor_Aleph-L3-8B-v0.72-exl2 [V0.72 RP, Cybersecurity, Programming, Biology/Anatomy UNCENSORED]
echo 2. Install Hathor_Stable-L3-8B-v0.5-exl2 [V0.5 RP, Cybersecurity, Programming, Biology/Anatomy UNCENSORED]
echo 3. Install Hathor-L3-8B-v.01-exl2 [V0.1 RP UNCENSORED]
echo 4. Install a custom model
echo 0. Back

set /p app_installer_tabbyapi_model_choice=Choose Your Destiny: 

REM ######## APP INSTALLER TABBYAPI Models - BACKEND #########
if "%app_installer_tabbyapi_model_choice%"=="1" (
    call :install_tabbyapi_model_hathorv07
) else if "%app_installer_tabbyapi_model_choice%"=="2" (
    goto :install_tabbyapi_model_hathorv05
) else if "%app_installer_tabbyapi_model_choice%"=="3" (
    goto :install_tabbyapi_model_hathorv01
) else if "%app_installer_tabbyapi_model_choice%"=="4" (
    goto :install_tabbyapi_model_custom
) else if "%app_installer_tabbyapi_model_choice%"=="0" (
    goto :install_tabbyapi_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_tabbyapi_model_menu
)


:install_tabbyapi_model_hathorv07
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %VRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Sorry... You need atleast 8GB VRAM or more to run a local LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Aleph-L3-8B-v0.72-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Aleph-L3-8B-v0.72-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/Hathor_Aleph-L3-8B-v0.72-exl2 Hathor_Aleph-L3-8B-v0.72-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Aleph-L3-8B-v0.72-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Aleph-L3-8B-v0.72-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Aleph-L3-8B-v0.72-exl2 Hathor_Aleph-L3-8B-v0.72-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Aleph-L3-8B-v0.72-exl2-6_5%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Aleph-L3-8B-v0.72-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Aleph-L3-8B-v0.72-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Aleph-L3-8B-v0.72-exl2 Hathor_Aleph-L3-8B-v0.72-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Aleph-L3-8B-v0.72-exl2-6_5%reset%
pause
goto :install_tabbyapi_model_menu
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.%reset%
    pause
    goto :install_tabbyapi_model_menu
)

:install_tabbyapi_model_hathorv05
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %VRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Sorry... You need atleast 8GB VRAM or more to run a local LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Stable-L3-8B-v0.5-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Stable-L3-8B-v0.5-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/Hathor_Stable-L3-8B-v0.5-exl2 Hathor_Stable-L3-8B-v0.5-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Stable-L3-8B-v0.5-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Stable-L3-8B-v0.5-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
REM set GIT_CURL_VERBOSE=1
REM set GIT_TRACE=1
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Stable-L3-8B-v0.5-exl2 Hathor_Stable-L3-8B-v0.5-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Stable-L3-8B-v0.5-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Stable-L3-8B-v0.5-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
REM set GIT_CURL_VERBOSE=1
REM set GIT_TRACE=1
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Stable-L3-8B-v0.5-exl2 Hathor_Stable-L3-8B-v0.5-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.%reset%
    pause
    goto :install_tabbyapi_model_menu
)


:install_tabbyapi_model_hathorv01
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %VRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Sorry... You need atleast 8GB VRAM or more to run a local LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor-L3-8B-v.01-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor-L3-8B-v.01-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Downloading model size bits: 5.0
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/Hathor-L3-8B-v.01-exl2 Hathor-L3-8B-v.01-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor-L3-8B-v.01-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor-L3-8B-v.01-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor-L3-8B-v.01-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Downloading model size bits: 6.0
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor-L3-8B-v.01-exl2 Hathor-L3-8B-v.01-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor-L3-8B-v.01-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Detected GPU VRAM: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor-L3-8B-v.01-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor-L3-8B-v.01-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Downloading model size bits: 6.0
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor-L3-8B-v.01-exl2 Hathor-L3-8B-v.01-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor-L3-8B-v.01-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.%reset%
    pause
    goto :install_tabbyapi_model_menu
)

:install_tabbyapi_model_custom
cls
set /p tabbyapimodelurl="(0 to cancel)Insert Model URL: "
if "%tabbyapimodelurl%"=="0" goto :install_tabbyapi_model_menu


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading...
cd /d "%tabbyapi_install_path%\models"
git clone %tabbyapimodelurl%
pause
goto :install_tabbyapi_model_menu


REM ############################################################
REM ######## APP INSTALLER VOICE GENERATION - FRONTEND #########
REM ############################################################
:app_installer_voice_generation
title STL [APP INSTALLER VOICE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Voice Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install AllTalk
echo 2. Install XTTS
echo 3. Install RVC
echo 0. Back

set /p app_installer_voice_gen_choice=Choose Your Destiny: 

REM ######## APP INSTALLER VOICE GENERATION - BACKEND #########
if "%app_installer_voice_gen_choice%"=="1" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_alltalk.bat" (
        call %app_installer_voice_generation_dir%\install_alltalk.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_alltalk.bat not found in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_alltalk.bat not found in: %app_installer_voice_generation_dir%%reset%
        pause
        goto :app_installer_voice_generation
    )
) else if "%app_installer_voice_gen_choice%"=="2" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_xtts.bat" (
        call %app_installer_voice_generation_dir%\install_xtts.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_xtts.bat not found in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_xtts.bat not found in: %app_installer_voice_generation_dir%%reset%
        pause
        goto :app_installer_voice_generation
    )
) else if "%app_installer_voice_gen_choice%"=="3" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_rvc.bat" (
        call %app_installer_voice_generation_dir%\install_rvc.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_rvc.bat not found in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_rvc.bat not found in: %app_installer_voice_generation_dir%%reset%
        pause
        goto :app_installer_voice_generation
    )
) else if "%app_installer_voice_gen_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_voice_generation
)



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
    set "caller=app_installer_image_generation"
    if exist "%app_installer_image_generation_dir%\install_comfyui.bat" (
        call %app_installer_image_generation_dir%\install_comfyui.bat
        goto :app_installer_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_comfyui.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_comfyui.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :app_installer_image_generation
    )
) else if "%app_installer_img_gen_choice%"=="4" (
    set "caller=app_installer_image_generation"
    if exist "%app_installer_image_generation_dir%\install_fooocus.bat" (
        call %app_installer_image_generation_dir%\install_fooocus.bat
        goto :app_installer_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_fooocus.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_fooocus.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :app_installer_image_generation
    )
) else if "%app_installer_img_gen_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
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
if exist "%sdwebui_install_path%" (
    REM Activate the sdwebui environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Deactivating Conda environment: %cyan_fg_strong%sdwebui%reset%
    call conda deactivate
)

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Stable Diffusion web UI %reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Install Stable Diffusion web UI
echo 2. Install Extensions
echo 3. Models [Install Options]
echo 0. Back

set /p app_installer_sdwebui_choice=Choose Your Destiny: 

REM ##### APP INSTALLER STABLE DIFUSSION WEBUI - BACKEND ######
if "%app_installer_sdwebui_choice%"=="1" (
    set "caller=app_installer_image_generation_sdwebui"
    if exist "%app_installer_image_generation_dir%\install_sdwebui.bat" (
        call %app_installer_image_generation_dir%\install_sdwebui.bat
        goto :install_sdwebui_menu
    ) else (
        echo [%DATE% %TIME%] ERROR: install_sdwebui.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_sdwebui.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :install_sdwebui_menu
    )
) else if "%app_installer_sdwebui_choice%"=="2" (
    goto :install_sdwebui_extensions
) else if "%app_installer_sdwebui_choice%"=="3" (
    goto :install_sdwebui_model_menu
) else if "%app_installer_sdwebui_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_menu
)


:install_sdwebui_extensions
REM Check if the folder exists
if not exist "%sdwebui_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion Webui is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebui_menu
)

REM Clone extensions for stable-diffusion-webui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning extensions for stable-diffusion-webui...
cd /d "%sdwebui_install_path%\extensions"
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
cd /d "%sdwebui_install_path%\models"
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
if not exist "%sdwebui_install_path%" (
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

cd /d "%sdwebui_install_path%"

cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Stable Diffusion web UI / Models%reset%
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
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_model_menu
)

:install_sdwebui_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Config in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix VAE in: "%sdwebui_install_path%\models\VAE"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Perfect World Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_custom
cls
set /p civitaimodelid="(0 to cancel)Insert Model ID: "

if "%civitaimodelid%"=="0" goto :install_sdwebui_model_menu

REM Check if the input is a valid number
echo %civitaimodelid%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_model_custom
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading...
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
if exist "%sdwebuiforge_install_path%" (
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
    set "caller=app_installer_image_generation_sdwebuiforge"
    if exist "%app_installer_image_generation_dir%\install_sdwebuiforge.bat" (
        call %app_installer_image_generation_dir%\install_sdwebuiforge.bat
        goto :install_sdwebuiforge_menu
    ) else (
        echo [%DATE% %TIME%] ERROR: install_sdwebuiforge.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_sdwebuiforge.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :install_sdwebuiforge_menu
    )
) else if "%app_installer_sdwebuiforge_choice%"=="2" (
    goto :install_sdwebuiforge_extensions
) else if "%app_installer_sdwebuiforge_choice%"=="3" (
    goto :install_sdwebuiforge_model_menu
) else if "%app_installer_sdwebuiforge_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_menu
)


:install_sdwebuiforge_extensions
REM Check if the folder exists
if not exist "%sdwebuiforge_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion WebUI Forge is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebuiforge_menu
)

REM Clone extensions for stable-diffusion-webui-forge
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning extensions for stable-diffusion-webui-forge...
cd /d "%sdwebuiforge_install_path%\extensions"
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
cd /d "%sdwebuiforge_install_path%\models"
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
if not exist "%sdwebuiforge_install_path%" (
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

cd /d "%sdwebuiforge_install_path%"

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
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_model_menu
)

:install_sdwebuiforge_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Config in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix VAE in: "%sdwebui_install_path%\models\VAE"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Perfect World Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_custom
cls
set /p civitaimodelid="(0 to cancel)Insert Model ID: "

if "%civitaimodelid%"=="0" goto :install_sdwebuiforge_model_menu

REM Check if the input is a valid number
echo %civitaimodelid%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_model_custom
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Downloading...
civitdl %civitaimodelid% -s basic "models\Stable-diffusion"

pause
goto :install_sdwebuiforge_model_menu



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
echo 7. Install w64devkit
echo 0. Back

set /p app_installer_core_util_choice=Choose Your Destiny: 

REM ######## APP INSTALLER CORE UTILITIES - BACKEND ###########
if "%app_installer_core_util_choice%"=="1" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_7zip.bat" (
        call %app_installer_core_utilities_dir%\install_7zip.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_7zip.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_7zip.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="2" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_ffmpeg.bat" (
        call %app_installer_core_utilities_dir%\install_ffmpeg.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_ffmpeg.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_ffmpeg.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="3" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_nodejs.bat" (
        call %app_installer_core_utilities_dir%\install_nodejs.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_nodejs.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_nodejs.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="4" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_yq.bat" (
        call %app_installer_core_utilities_dir%\install_yq.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_yq.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_yq.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="5" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_vsbuildtools.bat" (
        call %app_installer_core_utilities_dir%\install_vsbuildtools.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_vsbuildtools.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_vsbuildtools.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="6" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_cudatoolkit.bat" (
        call %app_installer_core_utilities_dir%\install_cudatoolkit.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_cudatoolkit.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_cudatoolkit.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="7" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_w64devkit.bat" (
        call %app_installer_core_utilities_dir%\install_w64devkit.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_w64devkit.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_w64devkit.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_core_utilities
)



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
echo 2. Voice Generation
echo 3. Image Generation 
echo 4. Core Utilities
echo 0. Back

set /p app_uninstaller_choice=Choose Your Destiny: 

REM ############## APP UNINSTALLER - BACKEND ####################
if "%app_uninstaller_choice%"=="1" (
    call :app_uninstaller_text_completion
) else if "%app_uninstaller_choice%"=="2" (
    call :app_uninstaller_voice_generation
) else if "%app_uninstaller_choice%"=="3" (
    call :app_uninstaller_image_generation
) else if "%app_uninstaller_choice%"=="4" (
    call :app_uninstaller_core_utilities
) else if "%app_uninstaller_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
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
echo 4. UNINSTALL llamacpp
echo 0. Back

set /p app_uninstaller_text_completion_choice=Choose Your Destiny: 

REM ####### APP UNINSTALLER TEXT COMPLETION - BACKEND ##########
if "%app_uninstaller_text_completion_choice%"=="1" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_ooba.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_ooba.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_ooba.bat not found in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_ooba.bat not found in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="2" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_koboldcpp.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_koboldcpp.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_koboldcpp.bat not found in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_koboldcpp.bat not found in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="3" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_tabbyapi.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_tabbyapi.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_tabbyapi.bat not found in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_tabbyapi.bat not found in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="4" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_llamacpp.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_llamacpp.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_llamacpp.bat not found in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_llamacpp.bat not found in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_text_completion
)



REM ############################################################
REM ######## APP UNINSTALLER VOICE GENERATION - FRONTEND #######
REM ############################################################
:app_uninstaller_voice_generation
title STL [APP UNINSTALLER VOICE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Uninstaller / Voice Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. UNINSTALL AllTalk
echo 2. UNINSTALL XTTS
echo 3. UNINSTALL rvc
echo 0. Back

set /p app_uninstaller_voice_gen_choice=Choose Your Destiny: 

REM ######## APP UNINSTALLER VOICE GENERATION - BACKEND #########
if "%app_uninstaller_voice_gen_choice%"=="1" (
    set "caller=app_uninstaller_voice_generation"
    if exist "%app_uninstaller_voice_generation_dir%\uninstall_alltalk.bat" (
        call %app_uninstaller_voice_generation_dir%\uninstall_alltalk.bat
        goto :app_uninstaller_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_alltalk.bat not found in: %app_uninstaller_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_alltalk.bat not found in: %app_uninstaller_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_voice_generation
    )
) else if "%app_uninstaller_voice_gen_choice%"=="2" (
    set "caller=app_uninstaller_voice_generation"
    if exist "%app_uninstaller_voice_generation_dir%\uninstall_xtts.bat" (
        call %app_uninstaller_voice_generation_dir%\uninstall_xtts.bat
        goto :app_uninstaller_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_xtts.bat not found in: %app_uninstaller_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_xtts.bat not found in: %app_uninstaller_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_voice_generation
    )
) else if "%app_uninstaller_voice_gen_choice%"=="3" (
    set "caller=app_uninstaller_voice_generation"
    if exist "%app_uninstaller_voice_generation_dir%\uninstall_rvc.bat" (
        call %app_uninstaller_voice_generation_dir%\uninstall_rvc.bat
        goto :app_uninstaller_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_rvc.bat not found in: %app_uninstaller_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_rvc.bat not found in: %app_uninstaller_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_voice_generation
    )
) else if "%app_uninstaller_voice_gen_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_voice_generation
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
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_sdwebui.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_sdwebui.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_sdwebui.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_sdwebui.bat not found in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="2" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_sdwebuiforge.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_sdwebuiforge.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_sdwebuiforge.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_sdwebuiforge.bat not found in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="3" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_comfyui.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_comfyui.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_comfyui.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_comfyui.bat not found in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="4" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_fooocus.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_fooocus.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_fooocus.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_fooocus.bat not found in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
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
echo 2. UNINSTALL SillyTavern
echo 3. UNINSTALL 7-Zip
echo 4. UNINSTALL FFmpeg
echo 5. UNINSTALL Node.js
echo 6. UNINSTALL yq
echo 7. UNINSTALL CUDA Toolkit
echo 8. UNINSTALL Visual Studio BuildTools
echo 9. UNINSTALL w64devkit
echo 0. Back

set /p app_uninstaller_core_utilities_choice=Choose Your Destiny: 

REM ######## APP UNINSTALLER CORE UTILITIES - BACKEND #########
if "%app_uninstaller_core_utilities_choice%"=="1" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_extras.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_extras.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_extras.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_extras.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="2" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_st.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_st.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_st.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_st.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="3" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_7zip.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_7zip.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_7zip.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_7zip.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="4" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_ffmpeg.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_ffmpeg.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_ffmpeg.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_ffmpeg.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="5" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_nodejs.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_nodejs.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_nodejs.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_nodejs.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="6" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_yq.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_yq.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_yq.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_yq.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="7" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_cudatoolkit.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_cudatoolkit.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_cudatoolkit.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_cudatoolkit.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="8" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_vsbuildtools.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_vsbuildtools.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_vsbuildtools.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_vsbuildtools.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="9" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_w64devkit.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_w64devkit.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_w64devkit.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_w64devkit.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_util_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_core_utilities
)


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
echo 2. Voice Generation 
echo 3. Image Generation 
echo 4. Core Utilities
echo 0. Back

set /p editor_choice=Choose Your Destiny: 

REM ################# EDITOR - BACKEND ########################
if "%editor_choice%"=="1" (
    call :editor_text_completion
) else if "%editor_choice%"=="2" (
    call :editor_voice_generation
) else if "%editor_choice%"=="3" (
    call :editor_image_generation
) else if "%editor_choice%"=="4" (
    call :editor_core_utilities
) else if "%editor_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
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

set /p editor_text_completion_choice=Choose Your Destiny: 

REM ####### EDITOR TEXT COMPLETION - BACKEND ##########
if "%editor_text_completion_choice%"=="1" (
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_ooba_modules.bat" (
        call %editor_text_completion_dir%\edit_ooba_modules.bat
        goto :editor_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_ooba_modules.bat not found in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_ooba_modules.bat not found in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :editor_text_completion
    )
) else if "%editor_text_completion_choice%"=="2" (
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_koboldcpp_modules.bat" (
        call %editor_text_completion_dir%\edit_koboldcpp_modules.bat
        goto :editor_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_koboldcpp_modules.bat not found in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_koboldcpp_modules.bat not found in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :editor_text_completion
    )
) else if "%editor_text_completion_choice%"=="3" (
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_tabbyapi_modules.bat" (
        call %editor_text_completion_dir%\edit_tabbyapi_modules.bat
        goto :editor_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_tabbyapi_modules.bat.bat not found in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_tabbyapi_modules.bat not found in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :editor_text_completion
    )
) else if "%editor_text_completion_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_text_completion
)

REM ############################################################
REM ######## EDITOR VOICE GENERATION - FRONTEND ################
REM ############################################################
:editor_voice_generation
title STL [EDITOR VOICE GENERATION]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Voice Generation%reset%
echo -------------------------------------------------------------
echo What would you like to do?

echo 1. Edit XTTS Modules
echo 0. Back

set /p editor_voice_generation_choice=Choose Your Destiny: 

REM ######## EDITOR VOICE GENERATION - BACKEND #########
if "%editor_voice_generation_choice%"=="1" (
    set "caller=editor_voice_generation"
    if exist "%editor_voice_generation_dir%\edit_xtts_modules.bat" (
        call %editor_voice_generation_dir%\edit_xtts_modules.bat
        goto :editor_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_xtts_modules.bat not found in: %editor_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_xtts_modules.bat not found in: %editor_voice_generation_dir%%reset%
        pause
        goto :editor_voice_generation
    )
) else if "%editor_voice_generation_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_voice_generation
)


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

set /p editor_image_generation_choice=Choose Your Destiny: 

REM ######## EDITOR IMAGE GENERATION - BACKEND #########
if "%editor_image_generation_choice%"=="1" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_sdwebui_modules.bat" (
        call %editor_image_generation_dir%\edit_sdwebui_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_sdwebui_modules.bat not found in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_sdwebui_modules.bat not found in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="2" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_sdwebuiforge_modules.bat" (
        call %editor_image_generation_dir%\edit_sdwebuiforge_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_sdwebuiforge_modules.bat not found in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_sdwebuiforge_modules.bat not found in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="3" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_comfyui_modules.bat" (
        call %editor_image_generation_dir%\edit_comfyui_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_comfyui_modules.bat not found in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_comfyui_modules.bat not found in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="4" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_fooocus_modules.bat" (
        call %editor_image_generation_dir%\edit_fooocus_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_fooocus_modules.bat not found in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_fooocus_modules.bat not found in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_image_generation
)


REM ############################################################
REM ######## EDITOR CORE UTILITIES - FRONTEND ##################
REM ############################################################
:editor_core_utilities
title STL [EDITOR CORE UTILITIES]
cls
set "SSL_INFO_FILE=%~dp0SillyTavern\certs\SillyTavernSSLInfo.txt"
set "sslOption=2. Create and Use Self-Signed SSL Certificate with SillyTavern to encrypt your connection &echo       %blue_fg_strong%Read More: https://sillytavernai.com/launcher-ssl (press 9 to open)%reset%"

REM Check if the SSL info file exists and read the expiration date
if exist "%SSL_INFO_FILE%" (
    for /f "skip=2 tokens=*" %%i in ('type "%SSL_INFO_FILE%"') do (
        set "expDate=%%i"
        goto :infoFound
    )
    :infoFound
        set "sslOption=2. Regenerate SillyTavern SSL - %expDate% &echo     %blue_fg_strong%SSL NOTE 1: You%reset% %red_fg_strong%WILL%reset% %blue_fg_strong%need to add the Self-Signed Cert as trusted in your browser on first launch. How to here: https://sillytavernai.com/launcher-ssl (press 9 to open)%reset% &echo     %blue_fg_strong%SSL NOTE 2: To remove the SSL press 8%reset%"

)

echo %blue_fg_strong%/ Home / Toolbox / Editor / Core Utilities%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Edit SillyTavern config.yaml
echo %sslOption%
echo 3. Edit Extras
echo 4. Edit Environment Variables
echo 0. Back

set /p editor_core_utilities_choice=Choose Your Destiny: 

REM ######## EDITOR CORE UTILITIES - FRONTEND ##################
if "%editor_core_utilities_choice%"=="1" (
    set "caller=editor_core_utilities"
    if exist "%editor_core_utilities_dir%\edit_st_config.bat" (
        call %editor_core_utilities_dir%\edit_st_config.bat
        goto :editor_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_st_config.bat not found in: %editor_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_st_config.bat not found in: %editor_core_utilities_dir%%reset%
        pause
        goto :editor_core_utilities
    )
) else if "%editor_core_utilities_choice%"=="2" (
    call :create_st_ssl
) else if "%editor_core_utilities_choice%"=="3" (
    set "caller=editor_core_utilities"
    if exist "%editor_core_utilities_dir%\edit_extras_modules.bat" (
        call %editor_core_utilities_dir%\edit_extras_modules.bat
        goto :editor_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_extras_modules.bat not found in: %editor_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_extras_modules.bat not found in: %editor_core_utilities_dir%%reset%
        pause
        goto :editor_core_utilities
    )
) else if "%editor_core_utilities_choice%"=="4" (
    set "caller=editor_core_utilities"
    if exist "%editor_core_utilities_dir%\edit_env_var.bat" (
        call %editor_core_utilities_dir%\edit_env_var.bat
        goto :editor_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_env_var.bat not found in: %editor_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_env_var.bat not found in: %editor_core_utilities_dir%%reset%
        pause
        goto :editor_core_utilities
    )
) else if "%editor_core_utilities_choice%"=="8" (
    goto :delete_st_ssl
) else if "%editor_core_utilities_choice%"=="9" (
    echo Opening SillyTavernai.com SSL Info Page
    start "" "https://sillytavernai.com/launcher-ssl"
    goto :editor_core_utilities
) else if "%editor_core_utilities_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_core_utilities
)

:create_st_ssl
call "%functions_dir%\SSL\create_ssl.bat" no-pause
REM Check the error level returned by the main batch file
if %errorlevel% equ 0 (
    echo  %green_fg_strong%The SSL was created successfully.%reset%
) else (
    echo  %red_fg_strong%The SSL creation encountered an error. Please see \bin\SSL-Certs\ssl_error_log.txt for more info.%reset%
)
pause
goto :editor_core_utilities

:delete_st_ssl
REM Check if the SillyTavern\certs folder exists and delete it if it does
set "CERTS_DIR=%~dp0SillyTavern\certs"

if exist "%CERTS_DIR%" (
    echo %blue_fg_strong%Deleting %CERTS_DIR% ...%reset%
    rmdir /s /q "%CERTS_DIR%"
    if errorlevel 0 (
        echo  %green_fg_strong%The SillyTavern\certs folder has been successfully deleted.%reset%
    ) else (
        echo  %red_fg_strong%Failed to delete the SillyTavern\certs folder. Please check if the folder is in use and try again.%reset%
    )
) else (
    echo  %red_fg_strong%The SillyTavern\certs folder does not exist.%reset%
)
pause
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
echo 2. Clear pip cache
echo 3. Fix unresolved conflicts or unmerged files [SillyTavern]
echo 4. Export dxdiag info
echo 5. Find what app is using port
echo 6. Set Onboarding Flow
echo 0. Back

REM Retrieve the PID of the current script using PowerShell TEMPORARY DISABLED UNTIL A BETTER WAY IS FOUND

REM for /f "delims=" %%G in ('powershell -NoProfile -Command "Get-Process | Where-Object { $_.MainWindowTitle -eq '%stl_title_pid%' } | Select-Object -ExpandProperty Id"') do (
REM     set "stl_PID=%%~G"
REM )
REM echo ======== INFO BOX ===============
REM echo STL PID: %cyan_fg_strong%%stl_PID%%reset%
REM echo =================================

set /p troubleshooting_choice=Choose Your Destiny: 


REM ############## TROUBLESHOOTING - BACKEND ##################
if "%troubleshooting_choice%"=="1" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\remove_node_modules.bat" (
        call %troubleshooting_dir%\remove_node_modules.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: remove_node_modules.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] remove_node_modules.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="2" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\remove_pip_cache.bat" (
        call %troubleshooting_dir%\remove_pip_cache.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: remove_pip_cache.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] remove_pip_cache.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="3" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\fix_github_conflicts.bat" (
        call %troubleshooting_dir%\fix_github_conflicts.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: fix_github_conflicts.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] fix_github_conflicts.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="4" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\export_dxdiag.bat" (
        call %troubleshooting_dir%\export_dxdiag.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: export_dxdiag.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] export_dxdiag.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="5" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\find_app_port.bat" (
        call %troubleshooting_dir%\find_app_port.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: find_app_port.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] find_app_port.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="6" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\onboarding_flow.bat" (
        call %troubleshooting_dir%\onboarding_flow.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: onboarding_flow.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] onboarding_flow.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :troubleshooting
)



REM ############################################################
REM ############## SWITCH BRANCH - FRONTEND ####################
REM ############################################################
:switch_branch
title STL [SWITCH-BRANCH]
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
set /p branch_choice=Choose Your Destiny: 

REM ################# SWITCH BRANCH - BACKEND ########################
if "%branch_choice%"=="1" (
    call :switch_branch_release_st
) else if "%branch_choice%"=="2" (
    call :switch_branch_staging_st
) else if "%branch_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :switch_branch
)


:switch_branch_release_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Switching to release branch...
cd /d "%st_install_path%"
git switch release
pause
goto :switch_branch


:switch_branch_staging_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Switching to staging branch...
cd /d "%st_install_path%"
git switch staging
pause
goto :switch_branch


REM ############################################################
REM ################# BACKUP - FRONTEND ########################
REM ############################################################
:backup
title STL [BACKUP]
cls

REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    goto :7zip_prompt
) else (
    goto :backup_options
)

:7zip_prompt
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] 7z command not found in PATH.%reset%
echo %red_fg_strong%7-Zip is not installed or not found in the system PATH. 7-Zip is required for making backups%reset%
REM Prompt user to install 7-Zip
echo 1. Install 7-Zip
echo 2. Cancel
set /p zip_choice="Would you like to install 7-Zip Now? (this will require a launcher restart after install): "
REM Check if the user wants to install 7-Zip
if "%zip_choice%"=="1" (
    set "caller=backup"
    if exist "%app_installer_core_utilities_dir%\install_7zip.bat" (
        call %app_installer_core_utilities_dir%\install_7zip.bat
    ) else (
        echo [%DATE% %TIME%] ERROR: install_7zip.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_7zip.bat not found in: %app_installer_core_utilities_dir%%reset%
        pause
        goto :toolbox
    )
) else (
    echo 7-Zip not installed, cannot create backups...
    pause
    goto :toolbox
)
cls

:backup_options
echo %blue_fg_strong%/ Home / Toolbox / Backup%reset%
echo -------------------------------------------------------------
echo What would you like to do?
echo 1. Create Backup
echo 2. Restore Backup
echo 0. Back

set /p backup_choice=Choose Your Destiny: 

REM ################# BACKUP - BACKEND ########################
if "%backup_choice%"=="1" (
    set "caller=backup"
    call %backup_dir%\create_backup.bat
    if %errorlevel% equ 1 (
        goto :home
    ) else (
        goto :backup
    )
) else if "%backup_choice%"=="2" (
    set "caller=backup"
    call %backup_dir%\restore_backup.bat
        if %errorlevel% equ 1 (
        goto :home
    ) else (
        goto :backup
    )
) else if "%backup_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :backup
)


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
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
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




REM ############################################################
REM ############ CREATE CUSTOM SHORTCUT - FRONTEND #############
REM ########### ADDED BY ROLYAT / BLUEPRINTCODING ##############
REM ############################################################
REM Allows users to create a home menu shortcut to launch any app from the toolbox with SillyTavern in one button push

REM This function sets up the shortcut on the homepage with the users selected option, it saves the users choice in a text file called "custom-shortcut.txt" in "\bin\settings"
:create_custom_shortcut
title STL [CUSTOM SHORTCUT]
cls
echo %blue_fg_strong%/ Home / Create Custom Shortcut%reset%
echo -------------------------------------------------------------
echo Create a custom shortcut to launch any app with SillyTavern. 
echo To reset the shortcut go to: %blue_bg%/ Home / Toolbox%reset%
echo ---------------------------------------------------------

REM Define options and corresponding commands in a structured format
set "option1=Oobabooga"
set "option2=Koboldcpp"
set "option3=TabbyAPI"
set "option4=AllTalk"
set "option5=XTTS"
set "option6=RVC"
set "option7=Stable Diffusion"
set "option8=Stable Diffusion Forge"
set "option9=ComfyUI"
set "option10=Fooocus"

REM Display each option using a loop
for /L %%i in (1,1,10) do (
    call echo %%i. %%option%%i%%
)

echo Type 0 to cancel
set /p user_apps="Enter your choice: "
if "%user_apps%"=="0" goto :home

REM Array-like structure for mapping names and commands
set "command1=call :start_ooba"
set "command2=call :start_koboldcpp"
set "command3=call :start_tabbyapi"
set "command4=call :start_alltalk"
set "command5=call :start_xtts"
set "command6=call :start_rvc"
set "command7=call :start_sdwebui"
set "command8=call :start_sdwebuiforge"
set "command9=call :start_comfyui"
set "command10=call :start_fooocus"

REM Retrieve the selected application name and command
call set "shortcut_name=Start SillyTavern With %%option%user_apps%%%"
call set "command=%%command%user_apps%%%"

REM Write the custom name and command to the settings file
echo %shortcut_name% > "%~dp0bin\settings\custom-shortcut.txt"
echo %command% >> "%~dp0bin\settings\custom-shortcut.txt"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Shortcut "%shortcut_name%" created successfully.%reset%
pause
goto :home

REM This command launches the custom shortcut if defined, it also launches SillyTavern, can't reuse the :start_st command as it goes to :home at the end, breaking the chaining
:launch_custom_shortcut
echo Executing custom shortcut...
echo Launching SillyTavern...
REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Node.js is not installed or not found in the PATH.%reset%
    echo %red_fg_strong%To install Node.js, go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install Node.js%reset%
    pause
    goto :home
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% SillyTavern launched in a new window.
start cmd /k "title SillyTavern && cd /d %st_install_path% && call npm install --no-audit && node server.js && pause && popd"

if exist "%~dp0bin\settings\custom-shortcut.txt" (
    setlocal EnableDelayedExpansion
    set "lineCount=0"
    for /f "delims=" %%a in ('type "%~dp0bin\settings\custom-shortcut.txt"') do (
        set /a lineCount+=1
        if !lineCount! equ 1 (
            set "appName=%%a"
            echo Launching !appName:Start SillyTavern With=!:...
        )
        if !lineCount! equ 2 (
            set "cmd=%%a"
            echo Now executing: !cmd!
            call !cmd!
            echo !appName:Start SillyTavern With=!: Launched in a new window.
        )
    )
    endlocal
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Custom shortcut executed.%reset%
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Shortcut file not found. Please create it first.%reset%
)
pause
goto :home

REM This command is called from the toolbox, it deletes the txt file that saves the users defined shortcut
:reset_custom_shortcut
if exist "%~dp0bin\settings\custom-shortcut.txt" (
    del "%~dp0bin\settings\custom-shortcut.txt"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Custom shortcut has been reset.%reset%
    pause
    goto :home
) else (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] No custom shortcut found to reset.%reset%
    pause
    goto :toolbox
)
