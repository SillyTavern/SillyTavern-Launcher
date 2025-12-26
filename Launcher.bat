@echo off
chcp 437 > nul
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

set "stl_version=25.12.1.0"
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
set "green_bg=[42m"

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
if exist "%extras_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%extras_modules_path%"') do (
        set "%%A=%%B"
    )
)

REM Define variables to track module status (XTTS)
set "xtts_modules_path=%~dp0bin\settings\modules-xtts.txt"
set "xtts_cuda_trigger=false"
set "xtts_hs_trigger=false"
set "xtts_deepspeed_trigger=false"
set "xtts_cache_trigger=false"
set "xtts_listen_trigger=false"
set "xtts_model_trigger=false"
if exist "%xtts_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%xtts_modules_path%"') do (
        set "%%A=%%B"
    )
)

REM Define variables to track module status (RVC-PYTHON)
set "rvc_python_modules_path=%~dp0bin\settings\modules-rvc-python.txt"
set "rvc_python_cuda_trigger=false"
set "rvc_python_harvest_trigger=false"
set "rvc_python_listen_trigger=false"
set "rvc_python_preload_trigger=false"
if exist "%rvc_python_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%rvc_python_modules_path%"') do (
        set "%%A=%%B"
    )
)




REM Define variables to track module status (STABLE DIFFUSION WEBUI)
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
if exist "%sdwebui_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%sdwebui_modules_path%"') do (
        set "%%A=%%B"
    )
)

REM Define variables to track module status (COMFYUI)
set "comfyui_modules_path=%~dp0bin\settings\modules-comfyui.txt"
set "comfyui_disableautolaunch_trigger=false"
set "comfyui_listen_trigger=false"
set "comfyui_port_trigger=false"
set "comfyui_lowvram_trigger=false"
set "comfyui_medvram_trigger=false"
if exist "%comfyui_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%comfyui_modules_path%"') do (
        set "%%A=%%B"
    )
)

REM Define variables to track module status (STABLE DIFFUSION WEBUI FORGE)
set "sdwebuiforge_modules_path=%~dp0bin\settings\modules-sdwebuiforge.txt"
set "sdwebuiforge_autolaunch_trigger=false"
set "sdwebuiforge_api_trigger=false"
set "sdwebuiforge_listen_trigger=false"
set "sdwebuiforge_port_trigger=false"
set "sdwebuiforge_optsdpattention_trigger=false"
set "sdwebuiforge_themedark_trigger=false"
set "sdwebuiforge_skiptorchcudatest_trigger=false"
set "sdwebuiforge_lowvram_trigger=false"
set "sdwebuiforge_medvram_trigger=false"
if exist "%sdwebuiforge_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%sdwebuiforge_modules_path%"') do (
        set "%%A=%%B"
    )
)

REM Define variables to track module status (STABLE DIFFUSION WEBUI FORGE NEO)
set "sdwebuiforgeneo_modules_path=%~dp0bin\settings\modules-sdwebuiforgeneo.txt"
REM Performance
set "sdwfn_uv_trigger=true"
set "sdwfn_xformers_trigger=false"
set "sdwfn_sage_trigger=true"
set "sdwfn_flash_trigger=false"
set "sdwfn_cudamalloc_trigger=true"
set "sdwfn_cudastream_trigger=false"
set "sdwfn_fastfp16_trigger=false"
REM Memory
set "sdwfn_highvram_trigger=false"
set "sdwfn_lowvram_trigger=false"
set "sdwfn_bnb_trigger=false"
REM Networking/UI
set "sdwfn_autolaunch_trigger=false"
set "sdwfn_api_trigger=false"
set "sdwfn_listen_trigger=false"
set "sdwfn_port_trigger=false"
set "sdwfn_themedark_trigger=true"

if exist "%sdwebuiforgeneo_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%sdwebuiforgeneo_modules_path%"') do (
        set "%%A=%%B"
    )
)



REM Define variables to track module status (TEXT GENERATION WEBUI OOBABOOGA)
set "ooba_modules_path=%~dp0bin\settings\modules-ooba.txt"
set "ooba_autolaunch_trigger=false"
set "ooba_extopenai_trigger=false"
set "ooba_listen_trigger=false"
set "ooba_listenport_trigger=false"
set "ooba_apiport_trigger=false"
set "ooba_verbose_trigger=false"
if exist "%ooba_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%ooba_modules_path%"') do (
        set "%%A=%%B"
    )
)

REM Define variables to track module status (TABBYAPI)
set "tabbyapi_modules_path=%~dp0bin\settings\modules-tabbyapi.txt"
set "tabbyapi_selectedmodelname_trigger=false"
set "selected_tabbyapi_model_folder="

set "tabbyapi_ignoreupdate_trigger=false"
set "tabbyapi_port_trigger=false"
set "tabbyapi_port="
set "tabbyapi_host_trigger=false"
set "tabbyapi_maxseqlen_trigger=false"
set "tabbyapi_maxseqlen="
set "tabbyapi_ropealpha_trigger="
set "tabbyapi_ropealpha="
set "ttabbyapi_cachemode_trigger="
set "tabbyapi_cachemode="
set "ttabbyapi_updatedeps_trigger="
if exist "%tabbyapi_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%tabbyapi_modules_path%"') do (
        set "%%A=%%B"
    )
)


REM Define variables for install locations (Core Utilities)
set "stl_root=%~dp0"
set "st_install_path=%~dp0SillyTavern"
set "st_package_json_path=%st_install_path%\package.json"
set "extras_install_path=%~dp0SillyTavern-extras"
set "st_backup_path=%~dp0SillyTavern-backups"
set "NODE_ENV=production"

REM Define variables for install locations (Image Generation)
set "image_generation_dir=%~dp0image-generation"
set "sdwebui_install_path=%image_generation_dir%\stable-diffusion-webui"
set "sdwebuiforge_install_path=%image_generation_dir%\stable-diffusion-webui-forge"
set "sdwebuiforgeneo_install_path=%image_generation_dir%\stable-diffusion-webui-forge-neo"
set "comfyui_install_path=%image_generation_dir%\ComfyUI"
set "swarmui_install_path=%image_generation_dir%\SwarmUI"
set "fooocus_install_path=%image_generation_dir%\Fooocus"
set "invokeai_install_path=%image_generation_dir%\InvokeAI"
set "ostrisaitoolkit_install_path=%image_generation_dir%\ai-toolkit"


REM Define variables for install locations (Text Completion)
set "text_completion_dir=%~dp0text-completion"
set "ooba_install_path=%text_completion_dir%\text-generation-webui"
set "koboldcpp_install_path=%text_completion_dir%\dev-koboldcpp"
set "llamacpp_install_path=%text_completion_dir%\dev-llamacpp"
set "tabbyapi_install_path=%text_completion_dir%\tabbyAPI"

REM Define variables for install locations (Voice Generation)
set "voice_generation_dir=%~dp0voice-generation"
set "alltalk_install_path=%voice_generation_dir%\alltalk_tts"
set "alltalk_v2_install_path=%voice_generation_dir%\alltalk_tts"
set "xtts_install_path=%voice_generation_dir%\xtts"
set "rvc_install_path=%voice_generation_dir%\Retrieval-based-Voice-Conversion-WebUI"
set "rvc_python_install_path=%voice_generation_dir%\rvc-python"

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

REM Define variables for the directories for App Launcher
set "app_launcher_image_generation_dir=%functions_dir%\Toolbox\App_Launcher\Image_Generation"
set "app_launcher_text_completion_dir=%functions_dir%\Toolbox\App_Launcher\Text_Completion"
set "app_launcher_voice_generation_dir=%functions_dir%\Toolbox\App_Launcher\Voice_Generation"
set "app_launcher_core_utilities_dir=%functions_dir%\Toolbox\App_Launcher\Core_Utilities"

REM Define variables for the directories for Editor
set "editor_image_generation_dir=%functions_dir%\Toolbox\Editor\Image_Generation"
set "editor_text_completion_dir=%functions_dir%\Toolbox\Editor\Text_Completion"
set "editor_voice_generation_dir=%functions_dir%\Toolbox\Editor\Voice_Generation"
set "editor_core_utilities_dir=%functions_dir%\Toolbox\Editor\Core_Utilities"

REM Define variables for logging
set "st_auto_repair=%log_dir%\autorepair-setting.txt"
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


REM Check if Git is installed; if not, then install Git with fallback of powershell
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] App command: "git" from app: "Git" NOT FOUND. Git is not installed or added to PATH%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Git using winget...
    winget install -e --id Git.Git

    if %errorlevel% neq 0 (
        echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget failed to install Git or is not installed.%reset%

        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Git using powershell...
        curl -L -o "$bin_dir\git.exe" https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe

        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing git...
        start /wait %bin_dir%\git.exe /VERYSILENT /NORESTART
        
        del %bin_dir%\git.exe
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Git installed successfully.%reset%
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Git installed successfully.%reset%
    )
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app command: %cyan_fg_strong%"git"%reset% from app: "Git"
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
    del "%log_dir%\gpu_info_output.txt"
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


REM Create modules-rvc-python if it doesn't exist
if not exist %rvc_python_modules_path% (
    type nul > %rvc_python_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-rvc-python.txt"  
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%rvc_python_modules_path%) do set "%%a"


REM Create modules-sdwebui if it doesn't exist
if not exist %sdwebui_modules_path% (
    type nul > %sdwebui_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-sdwebui.txt"  
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%sdwebui_modules_path%) do set "%%a"

REM Create modules-comfyui if it doesn't exist
if not exist %comfyui_modules_path% (
    type nul > %comfyui_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-comfyui.txt"  
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%comfyui_modules_path%) do set "%%a"


REM Create modules-ooba if it doesn't exist
if not exist %ooba_modules_path% (
    type nul > %ooba_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-ooba.txt"  
)
REM Load modules-ooba flags from modules-ooba
for /f "tokens=*" %%a in (%ooba_modules_path%) do set "%%a"


REM Create modules-tabbyapi if it doesn't exist
if not exist %tabbyapi_modules_path% (
    type nul > %tabbyapi_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created text file: "modules-tabbyapi.txt"  
)
REM Load modules-tabbyapi flags from modules-tabbyapi
for /f "tokens=*" %%a in (%tabbyapi_modules_path%) do set "%%a"


REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%winget_path%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Check for Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] App command: "node" from app: "Node.js" NOT FOUND. The app is not installed or added to PATH.
    set "node_version=%red_bg%[ERROR] Node.js not installed or not found in system PATH.%reset%"
) else (
    for /f "tokens=*" %%i in ('node --version') do set node_version=%%i
    set version=!node_version:v=!
    for /f "tokens=1,2 delims=." %%a in ("!version!") do (
        if %%a lss 18 (
            set "node_version=!node_version! %red_bg%[ERROR] Node.js version is OUTDATED. Please update to Node.js v18 or higher.%reset%"
        )
    )
)

REM Check if winget exists in PATH
if %ff_path_exists% neq 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%winget NOT FOUND in PATH: %cyan_fg_strong%%winget_path%%reset%
) else (
    echo [ %green_fg_strong%OK%reset% ] Found PATH: winget%reset%
)

REM Check if winget is installed; if not, then install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] App command: "winget" from app: "App Installer" NOT FOUND. The app is not installed or added to PATH.
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app command: %cyan_fg_strong%"winget"%reset% from app: "App Installer"
)

REM Check if Tailscale is installed; if not, then install it
tailscale version > nul 2>&1
if %errorlevel% neq 0 (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Tailscale not found, this is optional.
) else (
    echo [ %green_fg_strong%OK%reset% ] Found install: %cyan_fg_strong%"Tailscale"%reset%
            powershell -command ^
        "$json = tailscale status --json | ConvertFrom-Json; " ^
        "$self = $json.Self; " ^
        "$ip4 = $self.TailscaleIPs[0]; " ^
        "$hostName = $self.HostName; " ^
        "$dnsName = $self.DNSName; " ^
        "$logPath = '%~dp0\bin\logs\tailscale_status.txt'; " ^
        "Out-File -FilePath $logPath -InputObject $ip4 -Encoding ascii; " ^
        "Out-File -FilePath $logPath -InputObject $hostName -Append -Encoding ascii; " ^
        "Out-File -FilePath $logPath -InputObject $dnsName -Append -Encoding ascii"
)



REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%miniconda_path%" > nul
set "ff_path_exists=%errorlevel%"

REM Check if miniconda3 exists in PATH
if %ff_path_exists% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] miniconda3 NOT FOUND in PATH:%reset% %cyan_fg_strong%%miniconda_path%;%miniconda_path_mingw%;%miniconda_path_usrbin%;%miniconda_path_bin%;%miniconda_path_scripts%%reset%
) else (
    echo [ %green_fg_strong%OK%reset% ] Found PATH: miniconda3%reset%
)

REM Check if Miniconda3 is installed if not then install Miniconda3
call conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] App command: "conda" from app: "Miniconda3" NOT FOUND. Miniconda3 is not installed or added to PATH.%reset%
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app command: %cyan_fg_strong%conda%reset% from app: Miniconda3
)



REM Check if the SillyTavern folder exists
if not exist "%st_install_path%" (
    set "update_status_st=%red_bg%[ERROR] SillyTavern not found in: "%~dp0"%reset%"
    goto :no_st_install_path
)

REM Initialize variables for VRAM detection
set /a iteration=0
set /a last_UVRAM=0
set "GPU_name=Unknown"
set "last_GPU=Unknown"

REM Detect GPU and store name, excluding integrated GPUs if discrete GPUs are found
for /f "tokens=*" %%f in ('powershell -Command "Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name"') do (
    REM Update GPU name and store previous name
    if "!GPU_name!"=="" (
        set "GPU_name=%%f"
    ) else if "!GPU_name!" neq "%%f" (
        set "last_GPU=!GPU_name!"
        set "GPU_name=%%f"
    )

    REM Run PowerShell command to retrieve VRAM size and divide by 1GB
    for /f "usebackq tokens=*" %%i in (`powershell -Command "$qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'; if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) { $qwMemorySize = [double]$qwMemorySize[!iteration!] } else { $qwMemorySize = [double]$qwMemorySize }; if ($null -ne $qwMemorySize) { [math]::Round($qwMemorySize/1GB) } else { 'Property not found' }"`) do (
        set "UVRAM=%%i"
    )

    REM Increment iteration for array indexing
    set /a iteration=!iteration!+1

    REM Update UVRAM and GPU name only if current UVRAM is greater than last_UVRAM
    if /i !UVRAM! gtr !last_UVRAM! (
        set /a last_UVRAM=!UVRAM!
        set "last_GPU=!GPU_name!"
    )
)

REM Restore the GPU name and UVRAM to the one with the highest VRAM
set "UVRAM=!last_UVRAM!"
set "GPU_name=!last_GPU!"

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
 
echo %blue_fg_strong%^| ^> / Home                                                     ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%
echo     %red_bg%If you paid for this launcher, you have been scammed...%reset%
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%
echo    1. Update ^& Start SillyTavern%sslOptionSuffix%
echo    2. Start SillyTavern%sslOptionSuffix%
echo    3. Start SillyTavern With Remote Link%sslOptionSuffix%
REM Check if the custom shortcut file exists and is not empty
set "custom_name=Create Custom App Shortcut to Launch with SillyTavern"  ; Initialize to default
if exist "%~dp0bin\settings\custom-shortcut.txt" (
    set /p custom_name=<"%~dp0bin\settings\custom-shortcut.txt"
    if "!custom_name!"=="" set "custom_name=Create Custom Shortcut"
)
echo    4. %custom_name%
echo    5. Update Manager
echo    6. Toolbox
echo    7. Troubleshooting ^& Support
echo    8. More info about LLM models your GPU can run.
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Exit

REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i

REM Set the counter file
set counter_file=%log_dir%\gpu_counter.txt

REM Initialize or increment the counter
if exist %counter_file% (
    for /f "delims=" %%x in (%counter_file%) do set /a counter=%%x + 1
) else (
    set counter=1
)

REM If counter reaches 10, reset and delete the GPU info file
if !counter! geq 10 (
    set counter=0
    del "%log_dir%\gpu_info_output.txt"
)
REM Save the counter back to the file
echo !counter! > %counter_file%

REM Check if gpu_info_output.txt exists and call GPU detection script if not
if not exist "%log_dir%\gpu_info_output.txt" (
    call "%troubleshooting_dir%\gpu_info.bat" > "%log_dir%\gpu_info_output.txt"
)

REM Read the content of gpu_info_output.txt into gpuInfo
if exist "%log_dir%\gpu_info_output.txt" (
    for /f "delims=" %%x in (%log_dir%\gpu_info_output.txt) do (
        set "gpuInfo=%%x"
    )
) else (
    set "gpuInfo=GPU Info not found"
)

if exist "%log_dir%\tailscale_status.txt" (
rem Read the the content of tailscale log into vars 
set count=0
for /f "tokens=* delims=" %%i in (%log_dir%\tailscale_status.txt) do (
    set /a count+=1
    if !count! equ 1 set ip4=%%i
    if !count! equ 2 set hostName=%%i
    if !count! equ 3 set dnsName=%%i
)
)
rem Remove trailing period from dnsName if it exists
if "!dnsName:~-1!"=="." set "dnsName=!dnsName:~0,-1!"


REM Read the package.json from SillyTavern and extract the version key value
for /f "tokens=2 delims=:" %%a in ('findstr /c:"\"version\"" "%st_package_json_path%"') do (
    set "st-version=%%a"
)

REM Remove leading and trailing whitespace and surrounding quotes
for /f "tokens=* delims= " %%a in ("!st-version!") do (
    set "st-version=%%a"
)

set st-version=%st-version:"=%
set st-version=%st-version:,=%

REM Check if the package.json file exists
if not exist "%st_package_json_path%" (
set "st-version=%red_bg%[ERROR] Cannot get ST version because package.json file not found in %st_install_path%%reset%"
)

echo %yellow_fg_strong% ______________________________________________________________%reset%
echo %yellow_fg_strong%^| Version ^& Compatibility Status:                              ^|%reset%
echo    SillyTavern - Branch: %cyan_fg_strong%!current_branch! %reset%^| Status: %cyan_fg_strong%!update_status_st!%reset%
echo    SillyTavern: %cyan_fg_strong%!st-version!%reset%
echo    STL: %cyan_fg_strong%!stl_version!%reset%
REM echo    !gpuInfo!
echo    Node.js: %cyan_fg_strong%!node_version!%reset%
rem Conditionally echo Tailscale URLs only if they exist
if defined ip4 (
    echo    Tailscale URL - IP4: %cyan_fg_strong% http://!ip4!:8000%reset%
)
if defined hostName (
    echo    Tailscale URL - Machine Name: %cyan_fg_strong% http://!hostName!:8000%reset%
)
if defined dnsName (
    echo    Tailscale URL - MagicDNS Name: %cyan_fg_strong% http://!dnsName!:8000%reset%
)

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "choice=%BS%   Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM ################## HOME - BACKEND #########################
if "%choice%"=="1" (
    set "caller=home"
    if exist "%app_launcher_core_utilities_dir%\update_start_st.bat" (
        call %app_launcher_core_utilities_dir%\update_start_st.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: update_start_st.bat not found in: %app_launcher_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] update_start_st.bat not found in: %app_launcher_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%choice%"=="2" (
    set "caller=home"
    if exist "%app_launcher_core_utilities_dir%\start_st.bat" (
        call %app_launcher_core_utilities_dir%\start_st.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_st.bat not found in: %app_launcher_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_st.bat not found in: %app_launcher_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%choice%"=="3" (
    start "" "%~dp0SillyTavern\Remote-Link.cmd"
    echo "SillyTavern Remote Link Cloudflare Tunnel Launched"
    call %app_launcher_core_utilities_dir%\start_st.bat
    if %errorlevel% equ 1 goto :home
) else if "%choice%"=="4" (
    if exist "%~dp0bin\settings\custom-shortcut.txt" (
        call :launch_custom_shortcut
    ) else (
        call :create_custom_shortcut
    )
) else if "%choice%"=="5" (
    call :update_manager
) else if "%choice%"=="6" (
    call :toolbox
) else if "%choice%"=="7" (
    call :troubleshooting
) else if "%choice%"=="8" (
    set "caller=home"
    if exist "%functions_dir%\Home\info_vram.bat" (
        call "%functions_dir%\Home\info_vram.bat" "%UVRAM%"
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: info_vram.bat not found in: %functions_dir%\Home >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] info_vram.bat not found in: %functions_dir%\Home%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%choice%"=="0" (
    set "caller=home"
    if exist "%functions_dir%\Home\exit_stl.bat" (
        call %functions_dir%\Home\exit_stl.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: exit_stl.bat not found in: %functions_dir%\Home >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] exit_stl.bat not found in: %functions_dir%\Home%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%choice%"=="000" (
        call %troubleshooting_dir%\restart_stl.bat
        goto :home

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
echo %blue_fg_strong%^| ^> / Home / Update Manager                                    ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Text Completion
echo    2. Voice Generation
echo    3. Image Generation
echo    4. Core Utilities
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "update_manager_choice=%BS%   Choose Your Destiny: "


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

echo %blue_fg_strong%^| ^> / Home / Update Manager / Text Completion                  ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Update Text generation web UI (oobabooga)
echo    2. Update koboldcpp
echo    3. Update TabbyAPI
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "update_manager_txt_comp_choice=%BS%   Choose Your Destiny: "


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
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating tabbyAPI repository...
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
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating TabbyAPI Dependencies...
echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] This process could take a while, typically around 10 minutes or less. Please be patient and do not close this window until the update is complete.%reset%

REM Run the update process and log the output
python start.py --update-deps > %log_dir%\tabby_update_log.txt 2>&1

REM Scan the log file for the specific success message
findstr /c:"Dependencies updated. Please run TabbyAPI" %log_dir%\tabby_update_log.txt >nul
if %errorlevel% == 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% TabbyAPI Updated
) else (
    echo %red_bg%[ERROR] TabbyAPI Update Failed%reset%
)

REM Delete the log file
del %log_dir%\tabby_update_log.txt

REM Continue with the rest of the script
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%TabbyAPI installed successfully.%reset%
pause
goto :update_manager_text_completion


REM ############################################################
REM ########## UPDATE MANAGER VOICE GENERATION - FRONTEND ######
REM ############################################################
:update_manager_voice_generation
title STL [UPDATE MANAGER VOICE GENERATION]
cls
echo %blue_fg_strong%^| ^> / Home / Update Manager / Voice Generation                 ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%
echo    1. Update AllTalk
echo    2. Update XTTS
echo    3. Update RVC
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "update_manager_voice_gen_choice=%BS%   Choose Your Destiny: "


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

echo %blue_fg_strong%^| ^> / Home / Update Manager / Image Generation                 ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%
echo    1. Update Stable Diffusion WebUI
echo    2. Update Stable Diffusion WebUI Forge
echo    3. Update Stable Diffusion WebUI Forge NEO
echo    4. Update ComfyUI
echo    5. Update SwarmUI
echo    6. Update Fooocus
echo    7. Update InvokeAI
echo    8. Update Ostris AI Toolkit
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "update_manager_img_gen_choice=%BS%   Choose Your Destiny: "

REM ######## UPDATE MANAGER IMAGE GENERATION - BACKEND #########
if "%update_manager_img_gen_choice%"=="1" (
    call :update_sdwebui
) else if "%update_manager_img_gen_choice%"=="2" (
    goto :update_sdwebuiforge
) else if "%update_manager_img_gen_choice%"=="3" (
    goto :update_sdwebuiforgeneo
) else if "%update_manager_img_gen_choice%"=="4" (
    goto :update_comfyui
) else if "%update_manager_img_gen_choice%"=="5" (
    goto :update_swarmui
) else if "%update_manager_img_gen_choice%"=="6" (
    goto :update_fooocus
) else if "%update_manager_img_gen_choice%"=="7" (
    goto :update_invokeai
) else if "%update_manager_img_gen_choice%"=="8" (
    goto :update_ostrisaitoolkit
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


:update_sdwebuiforgeneo
if not exist "%sdwebuiforgeneo_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Forge-NEO directory not found.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating Forge-NEO via Git and Pixi...
cd /d "%sdwebuiforgeneo_install_path%"
call git pull
call pixi update
echo %green_fg_strong%Update Complete.%reset%
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

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%comfyui%reset%
call conda activate comfyui

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements...
pip install -r requirements.txt

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Deactivating Conda environment: %cyan_fg_strong%comfyui%reset%
call conda deactivate

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


:update_swarmui
REM Check if the folder exists
if not exist "%swarmui_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] SwarmUI directory not found. Skipping update.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update SwarmUI
set max_retries=3
set retry_count=0

:retry_update_swarmui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating SwarmUI...
cd /d "%swarmui_install_path%"
call git pull

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_swarmui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update SwarmUI repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SwarmUI updated successfully.%reset%
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


:update_invokeai
REM Check if InvokeAI directory exists
if not exist "%invokeai_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] InvokeAI directory not found. Skipping update.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating invokeai...
call conda activate invokeai
pip install --upgrade InvokeAI
call conda deactivate
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%InvokeAI updated successfully.%reset%
pause
goto :update_manager_image_generation


:update_ostrisaitoolkit
REM Check if ai-toolkit directory exists
if not exist "%ostrisaitoolkit_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] ai-toolkit directory not found. Skipping update.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update Ostris AI Toolkit
set max_retries=3
set retry_count=0

:retry_update_ostrisaitoolkit
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Updating Ostris AI Toolkit...
cd /d "%ostrisaitoolkit_install_path%"
call git pull
git submodule update --init --recursive
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_ostrisaitoolkit
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to update Ostris AI Toolkit repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Ostris AI Toolkit updated successfully.%reset%
pause
goto :update_manager_image_generation


REM ############################################################
REM ######## UPDATE MANAGER CORE UTILITIES - FRONTEND #########
REM ############################################################
:update_manager_core_utilities
title STL [UPDATE MANAGER CORE UTILITIES]
cls
echo %blue_fg_strong%^| ^> / Home / Update Manager / Core Utilities                   ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Update SillyTavern
echo    2. Update Extras
echo    3. Update 7-Zip
echo    4. Update FFmpeg
echo    5. Update Node.js
echo    6. Update yq
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "update_manager_core_util_choice=%BS%   Choose Your Destiny: "

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
winget upgrade OpenJS.NodeJS.LTS
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
echo %blue_fg_strong%^| ^> / Home / Toolbox                                           ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%
echo    1. App Launcher
echo    2. App Installer
echo    3. App Uninstaller
echo    4. Editor
echo    5. Backup
echo    6. Switch Branch
echo    7. Reset Custom Shortcut
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "toolbox_choice=%BS%   Choose Your Destiny: "

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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Launcher                            ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Text Completion
echo    2. Voice Generation
echo    3. Image Generation
echo    4. Core Utilities
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_launcher_choice=%BS%   Choose Your Destiny: "
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Launcher / Text Completion          ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Start Text generation web UI (oobabooga)
echo    2. Start koboldcpp
echo    3. Start TabbyAPI
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_launcher_txt_comp_choice=%BS%   Choose Your Destiny: "

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
    set "caller=app_launcher_text_completion"
    if exist "%app_launcher_text_completion_dir%\start_koboldcpp.bat" (
        call %app_launcher_text_completion_dir%\start_koboldcpp.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_koboldcpp.bat not found in: %app_launcher_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_koboldcpp.bat not found in: %app_launcher_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
)


:start_tabbyapi
    set "caller=app_launcher_text_completion"
    if exist "%app_launcher_text_completion_dir%\start_tabbyapi.bat" (
        call %app_launcher_text_completion_dir%\start_tabbyapi.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_tabbyapi.bat not found in: %app_launcher_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_tabbyapi.bat not found in: %app_launcher_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
)


REM ############################################################
REM ########## APP LAUNCHER VOICE GENERATION - FRONTEND ########
REM ############################################################
:app_launcher_voice_generation
title STL [APP LAUNCHER VOICE GENERATION]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Launcher / Voice Generation         ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. AllTalk [Launch Options]
echo    2. Start XTTS
echo    3. RVC [Launch Options]
echo    4. Start RVC-Python
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_launcher_voice_generation_choice=%BS%   Choose Your Destiny: "

REM ########## APP LAUNCHER TEXT COMPLETION - BACKEND #########
if "%app_launcher_voice_generation_choice%"=="1" (
    call :app_launcher_voice_generation_alltalk
) else if "%app_launcher_voice_generation_choice%"=="2" (
    set "caller=app_launcher_voice_generation"
    if exist "%app_launcher_voice_generation_dir%\start_xtts.bat" (
        call %app_launcher_voice_generation_dir%\start_xtts.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_xtts.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_xtts.bat not found in: %app_launcher_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_voice_generation_choice%"=="3" (
    call :app_launcher_voice_generation_rvc
) else if "%app_launcher_voice_generation_choice%"=="4" (
    set "caller=app_launcher_voice_generation"
    if exist "%app_launcher_voice_generation_dir%\start_rvc_python.bat" (
        call %app_launcher_voice_generation_dir%\start_rvc_python.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_rvc_python.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_rvc_python.bat not found in: %app_launcher_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_voice_generation_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_voice_generation
)

REM ############################################################
REM ####### APP LAUNCHER VOICE GENERATION ALLTALK - FRONTEND ###
REM ############################################################
:app_launcher_voice_generation_alltalk
title STL [APP LAUNCHER VOICE GENERATION ALLTALK]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Launcher / Voice Generation / AllTalk^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| AllTalk V2                                                  ^|%reset%
echo    1. Start AllTalk V2
echo    2. Start Finetune
echo    3. Start Diagnostics
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| AllTalk V1                                                   ^|%reset%
echo    4. Start AllTalk V1
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_launcher_voice_generation_alltalk_choice=%BS%   Choose Your Destiny: "

REM ########## APP LAUNCHER TEXT COMPLETION - BACKEND #########
if "%app_launcher_voice_generation_alltalk_choice%"=="1" (
    set "caller=app_launcher_voice_generation"
    if exist "%app_launcher_voice_generation_dir%\start_alltalk_v2.bat" (
        call %app_launcher_voice_generation_dir%\start_alltalk_v2.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_alltalk_v2.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_alltalk_v2.bat not found in: %app_launcher_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_voice_generation_alltalk_choice%"=="2" (
    set "caller=app_launcher_voice_generation"
    if exist "%app_launcher_voice_generation_dir%\start_alltalk_v2_finetune.bat" (
        call %app_launcher_voice_generation_dir%\start_alltalk_v2_finetune.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_alltalk_v2_finetune.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_alltalk_v2_finetune.bat not found in: %app_launcher_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_voice_generation_alltalk_choice%"=="3" (
    set "caller=app_launcher_voice_generation"
    if exist "%app_launcher_voice_generation_dir%\start_alltalk_v2_diag.bat" (
        call %app_launcher_voice_generation_dir%\start_alltalk_v2_diag.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_alltalk_v2_diag.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_alltalk_v2_diag.bat not found in: %app_launcher_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_voice_generation_alltalk_choice%"=="0" (
    goto :app_launcher_voice_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_voice_generation_alltalk
)


REM ############################################################
REM ####### APP LAUNCHER VOICE GENERATION RVC - FRONTEND #######
REM ############################################################
:app_launcher_voice_generation_rvc
title STL [APP LAUNCHER VOICE GENERATION RVC]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Launcher / Voice Generation / RVC   ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Retrieval based Voice Conversion                             ^|%reset%
echo    1. Start RVC
echo    2. Start RVC REALTIME [Used with Discord, Steam, etc...]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_launcher_voice_generation_rvc_choice=%BS%   Choose Your Destiny: "

REM ########## APP LAUNCHER TEXT COMPLETION - BACKEND #########
if "%app_launcher_voice_generation_rvc_choice%"=="1" (
    set "caller=app_launcher_voice_generation"
    if exist "%app_launcher_voice_generation_dir%\start_rvc.bat" (
        call %app_launcher_voice_generation_dir%\start_rvc.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_rvc.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_rvc.bat not found in: %app_launcher_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_voice_generation_rvc_choice%"=="2" (
    set "caller=app_launcher_voice_generation"
    if exist "%app_launcher_voice_generation_dir%\start_rvc_realtime.bat" (
        call %app_launcher_voice_generation_dir%\start_rvc_realtime.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_rvc_realtime.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_rvc_realtime.bat not found in: %app_launcher_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_voice_generation_rvc_choice%"=="0" (
    goto :app_launcher_voice_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_voice_generation_rvc
)


REM ############################################################
REM ######## APP LAUNCHER IMAGE GENERATION - FRONTEND ##########
REM ############################################################
:app_launcher_image_generation
title STL [APP LAUNCHER IMAGE GENERATION]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Launcher / Image Generation         ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Start Stable Diffusion WebUI
echo    2. Start Stable Diffusion WebUI Forge
echo    3. Start Stable Diffusion WebUI Forge NEO
echo    4. Start ComfyUI
echo    5. Start SwarmUI
echo    6. Start Fooocus
echo    7. Start InvokeAI
echo    8. Start Ostris AI Toolkit
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_launcher_image_generation_choice=%BS%   Choose Your Destiny: "

REM ######## APP LAUNCHER IMAGE GENERATION - BACKEND #########
if "%app_launcher_image_generation_choice%"=="1" (
    set "caller=app_launcher_image_generation"
    if exist "%app_launcher_image_generation_dir%\start_sdwebui.bat" (
        call %app_launcher_image_generation_dir%\start_sdwebui.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_sdwebui.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_sdwebui.bat not found in: %app_launcher_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_image_generation_choice%"=="2" (
    set "caller=app_launcher_image_generation"
    if exist "%app_launcher_image_generation_dir%\start_sdwebuiforge.bat" (
        call %app_launcher_image_generation_dir%\start_sdwebuiforge.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_sdwebuiforge.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_sdwebuiforge.bat not found in: %app_launcher_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_image_generation_choice%"=="3" (
    set "caller=app_launcher_image_generation"
    if exist "%app_launcher_image_generation_dir%\start_sdwebuiforgeneo.bat" (
        call %app_launcher_image_generation_dir%\start_sdwebuiforgeneo.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_sdwebuiforgeneo.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_sdwebuiforgeneo.bat not found in: %app_launcher_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_image_generation_choice%"=="4" (
    set "caller=app_launcher_image_generation"
    if exist "%app_launcher_image_generation_dir%\start_comfyui.bat" (
        call %app_launcher_image_generation_dir%\start_comfyui.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_comfyui.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_comfyui.bat not found in: %app_launcher_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_image_generation_choice%"=="5" (
    set "caller=app_launcher_image_generation"
    if exist "%app_launcher_image_generation_dir%\start_swarmui.bat" (
        call %app_launcher_image_generation_dir%\start_swarmui.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_swarmui.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_swarmui.bat not found in: %app_launcher_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_image_generation_choice%"=="6" (
    goto :start_fooocus
) else if "%app_launcher_image_generation_choice%"=="7" (
    set "caller=app_launcher_image_generation"
    if exist "%app_launcher_image_generation_dir%\start_invokeai.bat" (
        call %app_launcher_image_generation_dir%\start_invokeai.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_invokeai.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_invokeai.bat not found in: %app_launcher_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_image_generation_choice%"=="8" (
    set "caller=app_launcher_image_generation"
    if exist "%app_launcher_image_generation_dir%\start_ostrisaitoolkit_nextjs.bat" (
        call %app_launcher_image_generation_dir%\start_ostrisaitoolkit_nextjs.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: start_ostrisaitoolkit_nextjs.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_ostrisaitoolkit_nextjs.bat not found in: %app_launcher_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
) else if "%app_launcher_image_generation_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_image_generation
)


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
REM ######## APP LAUNCHER CORE UTILITIES - FRONTEND ##########
REM ############################################################
:app_launcher_core_utilities
title STL [APP LAUNCHER CORE UTILITIES]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Launcher / Core Utilities           ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%
echo    1. Start Extras
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_launcher_core_utilities_choice=%BS%   Choose Your Destiny: "


REM ######## APP LAUNCHER CORE UTILITIES - BACKEND #########
if "%app_launcher_core_utilities_choice%"=="1" (
    set "caller=app_launcher_core_utilities"

    REM Read modules-extras and find the extras_start_command line
    set "extras_start_command="

    for /F "tokens=*" %%a in ('findstr /I "extras_start_command=" "%extras_modules_path%"') do (
        set "%%a"
    )

    set "extras_start_command=%extras_start_command:extras_start_command=%"
    if not defined extras_start_command (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled!%reset%
        echo %red_bg%Please make sure at least one of the modules are enabled from Edit Extras Modules.%reset%
        echo.
        echo %blue_bg%We will redirect you to the Edit Extras Modules menu.%reset%
        pause
        set "caller=editor_core_utilities"
        if exist "%editor_core_utilities_dir%\edit_extras_modules.bat" (
            call %editor_core_utilities_dir%\edit_extras_modules.bat
            goto :app_launcher_core_utilities
        ) else (
            echo [%DATE% %TIME%] ERROR: edit_extras_modules.bat not found in: %editor_core_utilities_dir% >> %logs_stl_console_path%
            echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_extras_modules.bat not found in: %editor_core_utilities_dir%%reset%
            pause
            goto :app_launcher_core_utilities
        )
    )
    if exist "%app_launcher_core_utilities_dir%\start_extras.bat" (
        call %app_launcher_core_utilities_dir%\start_extras.bat
        goto :app_launcher_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: start_extras.bat not found in: %app_launcher_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_extras.bat not found in: %app_launcher_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_launcher_core_utilities
)
) else if "%app_launcher_core_utilities_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_core_utilities
)


REM ############################################################
REM ############## APP INSTALLER - FRONTEND ####################
REM ############################################################
:app_installer
title STL [APP INSTALLER]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer                           ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Text Completion
echo    2. Voice Generation
echo    3. Image Generation
echo    4. Core Utilities

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_choice=%BS%   Choose Your Destiny: "


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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Text Completion         ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install Text generation web UI oobabooga
echo    2. koboldcpp [Install options]
echo    3. TabbyAPI [Install options]
echo    4. Install llamacpp
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_txt_comp_choice=%BS%   Choose Your Destiny: "

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

echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Text Completion / koboldcpp ^|%reset%
echo %blue_fg_strong% ==================================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install koboldcpp from prebuild .exe [Recommended]
echo    2. Build dll files and compile the .exe installer [Advanced]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_koboldcpp_choice=%BS%   Choose Your Destiny: "

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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Text Completion / TabbyAPI ^|%reset%
echo %blue_fg_strong% =================================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install TabbyAPI
echo    2. Install ST-tabbyAPI-loader Extension
echo    3. Models [Install Options]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_tabbyapi_choice=%BS%   Choose Your Destiny: "

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
    set "caller=app_installer_text_completion_tabbyapi"
    if exist "%app_installer_text_completion_dir%\install_tabbyapi_st_ext.bat" (
        call %app_installer_text_completion_dir%\install_tabbyapi_st_ext.bat
        goto :install_tabbyapi_menu
    ) else (
        echo [%DATE% %TIME%] ERROR: install_tabbyapi_st_ext.bat not found in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_tabbyapi_st_ext.bat not found in: %app_installer_text_completion_dir%%reset%
        pause
        goto :install_tabbyapi_menu
    )
) else if "%app_installer_tabbyapi_choice%"=="3" (
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Text Completion / TabbyAPI / Models ^|%reset%
echo %blue_fg_strong% ===========================================================================%reset%   
echo %cyan_fg_strong% ____________________________________________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                                                 ^|%reset%

echo    1. Install Captain-Eris_Violet-V0.420-12B-4bpw-exl2 [RP, General, UNCENSORED]
echo    2. Install Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2 [RP, General, UNCENSORED]
echo    3. Install L3-8B-Stheno-v3.2-exl2 [RP, UNCENSORED]
echo    4. Install Replete-Coder-Instruct-8b-Merged-exl2 [Programming, Cybersecurity, UNCENSORED]
echo    5. Install a custom model
echo %cyan_fg_strong% ____________________________________________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                                              ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ____________________________________________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                                                            ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_tabbyapi_model_choice=%BS%   Choose Your Destiny: "


REM ######## APP INSTALLER TABBYAPI Models - BACKEND #########
if "%app_installer_tabbyapi_model_choice%"=="1" (
    call :install_tabbyapi_model_captainiris
) else if "%app_installer_tabbyapi_model_choice%"=="2" (
    goto :install_tabbyapi_model_hathor
) else if "%app_installer_tabbyapi_model_choice%"=="3" (
    goto :install_tabbyapi_model_stheno
) else if "%app_installer_tabbyapi_model_choice%"=="4" (
    goto :install_tabbyapi_model_repletecoder
) else if "%app_installer_tabbyapi_model_choice%"=="5" (
    goto :install_tabbyapi_model_custom
) else if "%app_installer_tabbyapi_model_choice%"=="0" (
    goto :install_tabbyapi_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_tabbyapi_model_menu
)

:install_tabbyapi_model_captainiris
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %UVRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Sorry... You need atleast 8GB VRAM or more to run a local LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %UVRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Captain-Eris_Violet-V0.420-12B-4bpw-exl2" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Captain-Eris_Violet-V0.420-12B-4bpw-exl2"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 4.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone https://huggingface.co/Nitrals-Quants/Captain-Eris_Violet-V0.420-12B-4bpw-exl2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Captain-Eris_Violet-V0.420-12B-4bpw-exl2%reset%
goto :install_tabbyapi_model_captainiris_presets

) else if %UVRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Captain-Eris_Violet-V0.420-12B-4bpw-exl2" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Captain-Eris_Violet-V0.420-12B-4bpw-exl2"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 4.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone https://huggingface.co/Nitrals-Quants/Captain-Eris_Violet-V0.420-12B-4bpw-exl2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Captain-Eris_Violet-V0.420-12B-4bpw-exl2%reset%
goto :install_tabbyapi_model_captainiris_presets

) else if %UVRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Captain-Eris_Violet-V0.420-12B-4bpw-exl2" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Captain-Eris_Violet-V0.420-12B-4bpw-exl2"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 4.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone https://huggingface.co/Nitrals-Quants/Captain-Eris_Violet-V0.420-12B-4bpw-exl2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Captain-Eris_Violet-V0.420-12B-4bpw-exl2%reset%
goto :install_tabbyapi_model_captainiris_presets

) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.%reset%
    pause
    goto :install_tabbyapi_model_menu
)



:install_tabbyapi_model_hathor
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %UVRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Sorry... You need atleast 8GB VRAM or more to run a local LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %UVRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset%Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone https://huggingface.co/Nitral-AI/Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2%reset%
goto :install_tabbyapi_model_hathor_presets

) else if %UVRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone https://huggingface.co/Nitral-AI/Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2%reset%
goto :install_tabbyapi_model_hathor_presets

) else if %UVRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone https://huggingface.co/Nitral-AI/Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Hathor_Tahsin-L3-8B-v0.85-5bpw-exl2%reset%
goto :install_tabbyapi_model_hathor_presets

) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.%reset%
    pause
    goto :install_tabbyapi_model_menu
)


:install_tabbyapi_model_stheno
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %UVRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Sorry... You need atleast 8GB VRAM or more to run a local LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %UVRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "L3-8B-Stheno-v3.2-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "L3-8B-Stheno-v3.2-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/L3-8B-Stheno-v3.2-exl2 L3-8B-Stheno-v3.2-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: L3-8B-Stheno-v3.2-exl2-5_0%reset%
pause
goto :install_tabbyapi_model_menu

) else if %UVRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "L3-8B-Stheno-v3.2-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "L3-8B-Stheno-v3.2-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/L3-8B-Stheno-v3.2-exl2 L3-8B-Stheno-v3.2-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: L3-8B-Stheno-v3.2-exl2-6_5%reset%
pause
goto :install_tabbyapi_model_menu

) else if %UVRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "L3-8B-Stheno-v3.2-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "L3-8B-Stheno-v3.2-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/L3-8B-Stheno-v3.2-exl2 L3-8B-Stheno-v3.2-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: L3-8B-Stheno-v3.2-exl2-6_5%reset%
pause
goto :install_tabbyapi_model_menu

) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.%reset%
    pause
    goto :install_tabbyapi_model_menu
)

https://huggingface.co/bartowski/Replete-Coder-Instruct-8b-Merged-exl2
:install_tabbyapi_model_repletecoder
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %UVRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Sorry... You need atleast 8GB VRAM or more to run a local LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %UVRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Replete-Coder-Instruct-8b-Merged-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Replete-Coder-Instruct-8b-Merged-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/Replete-Coder-Instruct-8b-Merged-exl2 Replete-Coder-Instruct-8b-Merged-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Replete-Coder-Instruct-8b-Merged-exl2%reset%
pause
goto :install_tabbyapi_model_menu

) else if %UVRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Replete-Coder-Instruct-8b-Merged-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Replete-Coder-Instruct-8b-Merged-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
REM set GIT_CURL_VERBOSE=1
REM set GIT_TRACE=1
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Replete-Coder-Instruct-8b-Merged-exl2 Replete-Coder-Instruct-8b-Merged-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Replete-Coder-Instruct-8b-Merged-exl2%reset%
pause
goto :install_tabbyapi_model_menu

) else if %UVRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Detected GPU VRAM: %cyan_fg_strong%%UVRAM% GB%reset%
REM Check if model exists
if exist "Replete-Coder-Instruct-8b-Merged-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing model...
    rmdir /s /q "Replete-Coder-Instruct-8b-Merged-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading model size bits: 6.0
REM set GIT_CURL_VERBOSE=1
REM set GIT_TRACE=1
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%When you see: Unpacking objects: 100, please wait until you see Successfully installed model in green text.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Replete-Coder-Instruct-8b-Merged-exl2 Replete-Coder-Instruct-8b-Merged-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed model: Replete-Coder-Instruct-8b-Merged-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.%reset%
    pause
    goto :install_tabbyapi_model_menu
)

:install_tabbyapi_model_captainiris_presets


:install_tabbyapi_model_hathor_presets
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hathor presets...
cd /d "%tabbyapi_install_path%\models"
git clone https://huggingface.co/Nitral-AI/Hathor_Presets


REM Scan for user folders
set "user_folders="
for /d %%d in ("%st_install_path%\data\*") do (
    if /i not "%%~nxd"=="_storage" if /i not "%%~nxd"=="_uploads" (
        set "user_folders=!user_folders!%%~nxd|"
    )
)

echo Detected accounts:
echo ================================
REM Remove the trailing pipe character
set "user_folders=%user_folders:~0,-1%"

REM Split user_folders into an array
set i=1
set "user_count=0"
for %%a in (%user_folders:|= %) do (
    echo !i!. %cyan_fg_strong%%%a%reset%
    set "user_folder_!i!=%%a"
    set /a i+=1
    set /a user_count+=1
)
echo ================================

REM If only one user folder is found, skip the selection
if %user_count%==1 (
    set "selected_user_folder=!user_folder_1!"
    goto skip_user_selection
)

:select_user_folder
REM Prompt user to select a folder
echo 0. Cancel
echo.
set "selected_user_folder="
set /p user_choice="Select a folder to import presets: "

REM Check if the user wants to exit
if "%user_choice%"=="0" (
    exit /b 0
)

REM Get the selected folder name
for /l %%i in (1,1,%user_count%) do (
    if "%user_choice%"=="%%i" set "selected_user_folder=!user_folder_%%i!"
)

if "%selected_user_folder%"=="" (
    echo %red_fg_strong%[ERROR] Invalid selection. Please enter a number between 1 and %user_count%, or press 0 to cancel.%reset%
    pause
    goto :create_backup
)

:skip_user_selection
REM Replace backslashes with double backslashes in st_install_path
set "escaped_st_install_path=%st_install_path:\=\\%"

REM move presets into user folder
move /Y "%tabbyapi_install_path%\models\Hathor_Presets\Hathor-Llama-3_Theme.json" "%st_install_path%\data\%selected_user_folder%\themes"
move /Y "%tabbyapi_install_path%\models\Hathor_Presets\Hathor_Llama-3_Context.json" "%st_install_path%\data\%selected_user_folder%\context"
move /Y "%tabbyapi_install_path%\models\Hathor_Presets\Hathor_Llama-3_Instruct.json" "%st_install_path%\data\%selected_user_folder%\instruct"
move /Y "%tabbyapi_install_path%\models\Hathor_Presets\Hathor_Llama-3_Text-Completion-Preset.json" "%st_install_path%\data\%selected_user_folder%\TextGen Settings"

REM Remove leftovers
rd /S /Q "%tabbyapi_install_path%\models\Hathor_Presets"


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hathor presets at %st_install_path%\data\%selected_user_folder%\%reset%
pause
goto :install_tabbyapi_model_menu


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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Voice Generation        ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install AllTalk V2
echo    2. Install AllTalk
echo    3. Install XTTS
echo    4. Install RVC
echo    5. Install RVC-Python
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_voice_gen_choice=%BS%   Choose Your Destiny: "


REM ######## APP INSTALLER VOICE GENERATION - BACKEND #########
if "%app_installer_voice_gen_choice%"=="1" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_alltalk_v2.bat" (
        call %app_installer_voice_generation_dir%\install_alltalk_v2.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_alltalk_v2.bat not found in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_alltalk_v2.bat not found in: %app_installer_voice_generation_dir%%reset%
        pause
        goto :app_installer_voice_generation
    )
) else if "%app_installer_voice_gen_choice%"=="2" (
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
) else if "%app_installer_voice_gen_choice%"=="3" (
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
) else if "%app_installer_voice_gen_choice%"=="4" (
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
) else if "%app_installer_voice_gen_choice%"=="5" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_rvc_python.bat" (
        call %app_installer_voice_generation_dir%\install_rvc_python.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_rvc_python.bat not found in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_rvc_python.bat not found in: %app_installer_voice_generation_dir%%reset%
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Image Generation        ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Stable Diffusion WebUI [Install options]
echo    2. Stable Diffusion WebUI Forge [Install options]
echo    3. Stable Diffusion WebUI Forge NEO [Install options]
echo    4. Install ComfyUI
echo    5. Install SwarmUI
echo    6. Install Fooocus
echo    7. Install InvokeAI
echo    8. Install Ostris AI Toolkit
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_image_generation_choice=%BS%   Choose Your Destiny: "

REM ######## APP INSTALLER IMAGE GENERATION - BACKEND #########
if "%app_installer_image_generation_choice%"=="1" (
    call :install_sdwebui_menu
) else if "%app_installer_image_generation_choice%"=="2" (
    goto :install_sdwebuiforge_menu
) else if "%app_installer_image_generation_choice%"=="3" (
    goto :install_sdwebuiforgeneo_menu
) else if "%app_installer_image_generation_choice%"=="4" (
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
) else if "%app_installer_image_generation_choice%"=="5" (
    set "caller=app_installer_image_generation"
    if exist "%app_installer_image_generation_dir%\install_swarmui.bat" (
        call %app_installer_image_generation_dir%\install_swarmui.bat
        goto :app_installer_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_swarmui.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_swarmui.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :app_installer_image_generation
    )
) else if "%app_installer_image_generation_choice%"=="6" (
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
) else if "%app_installer_image_generation_choice%"=="7" (
    set "caller=app_installer_image_generation"
    if exist "%app_installer_image_generation_dir%\install_invokeai.bat" (
        call %app_installer_image_generation_dir%\install_invokeai.bat
        goto :app_installer_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_invokeai.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_invokeai.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :app_installer_image_generation
    )
) else if "%app_installer_image_generation_choice%"=="8" (
    set "caller=app_installer_image_generation"
    if exist "%app_installer_image_generation_dir%\install_ostris_aitoolkit.bat" (
        call %app_installer_image_generation_dir%\install_ostris_aitoolkit.bat
        goto :app_installer_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: install_ostris_aitoolkit.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_ostris_aitoolkit.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :app_installer_image_generation
    )
) else if "%app_installer_image_generation_choice%"=="0" (
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Image Generation / Stable Diffusion WebUI ^|%reset%
echo %blue_fg_strong% ================================================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install Stable Diffusion WebUI
echo    2. Install Extensions
echo    3. Models [Install Options]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_sdwebui_choice=%BS%   Choose Your Destiny: "


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
git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git
git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
git clone https://github.com/Gourieff/sd-webui-reactor-sfw.git
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Better Upscaler models...
cd /d "%sdwebui_install_path%\models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extensions for Stable Diffusion WebUI installed Successfully.%reset%
goto :install_sdwebui_menu


REM ############################################################
REM ##### APP INSTALLER SDWEBUI MODELS - FRONTEND ##############
REM ############################################################
:install_sdwebui_model_menu
title STL [APP INSTALLER SDWEBUI MODELS]

REM Check if the folder exists
if not exist "%sdwebui_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion WebUI Forge is not installed. Please install it first.%reset%
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Stable Diffusion WebUI / Models    ^|%reset%
echo %blue_fg_strong% =========================================================================%reset%
echo    1. Install a custom model
echo    2. Add Civit AI API Key
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SD 1.5 Models [SD 1.5]                                       ^|%reset%
echo    3. Install Hassaku [ANIME]
echo    4. Install YiffyMix [FURRY]
echo    5. Install Perfect World [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SDXL Models [PONY]                                           ^|%reset%
echo    6. Install Hassaku XL [ANIME] 
echo    7. Install AutismMix_confetti [ANIME/CARTOON/FURRY MIX] 
echo    8. Install Pony Realism [REALISM]
echo    9. Install CyberRealistic Pony [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SDXL Models [ILLUSTRIOUS]                                    ^|%reset%
echo    10. Install WAI-NSFW-illustrious-SDXL [ANIME]
echo    11. Install Hassaku XL Illustrious [ANIME]
echo    12. Install CyberIllustrious [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| FLUX Models                                                  ^|%reset%
echo    NOT SUPPORTED YET.
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_sdwebui_model_choice=%BS%   Choose Your Destiny: "

REM ######## APP INSTALLER IMAGE GENERATION - BACKEND #########
if "%app_installer_sdwebui_model_choice%"=="1" (
    call :install_sdwebui_model_custom
) else if "%app_installer_sdwebui_model_choice%"=="2" (
    goto :install_sdwebui_model_apikey
) else if "%app_installer_sdwebui_model_choice%"=="3" (
    goto :install_sdwebui_model_hassaku
) else if "%app_installer_sdwebui_model_choice%"=="4" (
    goto :install_sdwebui_model_yiffymix
) else if "%app_installer_sdwebui_model_choice%"=="5" (
    goto :install_sdwebui_model_perfectworld
) else if "%app_installer_sdwebui_model_choice%"=="6" (
    goto :install_sdwebui_model_hassakuxl
) else if "%app_installer_sdwebui_model_choice%"=="7" (
    goto :install_sdwebui_model_autismMixconfetti
) else if "%app_installer_sdwebui_model_choice%"=="8" (
    goto :install_sdwebui_model_ponyrealism
) else if "%app_installer_sdwebui_model_choice%"=="9" (
    goto :install_sdwebui_model_cyberrealistic_pony
 ) else if "%app_installer_sdwebui_model_choice%"=="10" (
    goto :install_sdwebui_model_wai_nsfw_illustrious_sdxl
 ) else if "%app_installer_sdwebui_model_choice%"=="11" (
    goto :install_sdwebui_model_hassaku_xl_illustrious
 ) else if "%app_installer_sdwebui_model_choice%"=="12" (
    goto :install_sdwebui_model_cyberillustrious
) else if "%app_installer_sdwebui_model_choice%"=="0" (
    goto :install_sdwebui_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_model_menu
)

:install_sdwebui_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku [SD 1.5] Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku [SD 1.5] Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Config in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix VAE in: "%sdwebui_install_path%\models\VAE"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Perfect World [SD 1.5] Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_hassakuxl
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku XL [PONY] Model...
civitdl 376031 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku XL [PONY] Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_autismMixconfetti
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading AutismMix SDXL [PONY] Model...
civitdl 288584 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed AutismMix SDXL [PONY] Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_ponyrealism
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Pony Realism [PONY] Model...
civitdl 372465 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Pony Realism [PONY] Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu

:install_sdwebui_model_cyberrealistic_pony
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading cyberrealistic-pony [PONY] Model...
civitdl 443821 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed cyberrealistic-pony [PONY] Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu

:install_sdwebui_model_wai_nsfw_illustrious_sdxl
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading WAI-NSFW-illustrious-SDXL [ILLUSTRIOUS] Model...
civitdl 827184 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed WAI-NSFW-illustrious-SDXL [ILLUSTRIOUS] Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu

:install_sdwebui_model_hassaku_xl_illustrious
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading hassaku-xl-illustrious [ILLUSTRIOUS] Model...
civitdl 140272 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed hassaku-xl-illustrious [ILLUSTRIOUS] Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu

REM :install_sdwebui_model_flux
REM echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Flux...
REM civitdl 638187 -s basic "models\Stable-diffusion"
REM echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
REM pause
REM goto :install_sdwebui_model_menu


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
echo To generate a Civit AI API key, follow these steps:
echo * %cyan_fg_strong%Go to%reset% %yellow_fg_strong%https://civitai.com/user/account%reset% %cyan_fg_strong%or click on your user picture then click on Account settings%reset%
echo * %cyan_fg_strong%Scroll down until you see "API Keys"%reset%
echo * %cyan_fg_strong%Click Add API key%reset%
echo * %cyan_fg_strong%Name it "civitdl" then click on Save%reset%
echo * %cyan_fg_strong%Copy the API Key and paste it here below%reset%
echo.

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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Image Generation / Stable Diffusion WebUI Forge ^|%reset%
echo %blue_fg_strong% ================================================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install Stable Diffusion WebUI Forge
echo    2. Install Extensions
echo    3. Models [Install Options]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_sdwebuiforge_choice=%BS%   Choose Your Destiny: "


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
git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git
git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
git clone https://github.com/Gourieff/sd-webui-reactor-sfw.git
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
REM ##### APP INSTALLER SDWEBUI FORGE Models - FRONTEND ########
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Stable Diffusion WebUI Forge / Models    ^|%reset%
echo %blue_fg_strong% ===============================================================================%reset%
echo    1. Install a custom model
echo    2. Add Civit AI API Key
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SD 1.5 Models [SD 1.5]                                       ^|%reset%
echo    3. Install Hassaku [ANIME]
echo    4. Install YiffyMix [FURRY]
echo    5. Install Perfect World [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SDXL Models [PONY]                                           ^|%reset%
echo    6. Install Hassaku XL [ANIME] 
echo    7. Install AutismMix_confetti [ANIME/CARTOON/FURRY MIX] 
echo    8. Install Pony Realism [REALISM]
echo    9. Install CyberRealistic Pony [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SDXL Models [ILLUSTRIOUS]                                    ^|%reset%
echo    10. Install WAI-NSFW-illustrious-SDXL [ANIME]
echo    11. Install Hassaku XL Illustrious [ANIME]
echo    12. Install CyberIllustrious [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| FLUX Models                                                  ^|%reset%
echo    13. Install Flux.1-Dev/Schnell BNB NF4 [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_sdwebuiforge_model_choice=%BS%   Choose Your Destiny: "

REM ######## APP INSTALLER IMAGE GENERATION - BACKEND #########
if "%app_installer_sdwebuiforge_model_choice%"=="1" (
    call :install_sdwebuiforge_model_custom
) else if "%app_installer_sdwebuiforge_model_choice%"=="2" (
    goto :install_sdwebuiforge_model_apikey
) else if "%app_installer_sdwebuiforge_model_choice%"=="3" (
    goto :install_sdwebuiforge_model_hassaku
) else if "%app_installer_sdwebuiforge_model_choice%"=="4" (
    goto :install_sdwebuiforge_model_yiffymix
) else if "%app_installer_sdwebuiforge_model_choice%"=="5" (
    goto :install_sdwebuiforge_model_perfectworld
) else if "%app_installer_sdwebuiforge_model_choice%"=="6" (
    goto :install_sdwebuiforge_model_hassakuxl
) else if "%app_installer_sdwebuiforge_model_choice%"=="7" (
    goto :install_sdwebuiforge_model_autismMixconfetti
) else if "%app_installer_sdwebuiforge_model_choice%"=="8" (
    goto :install_sdwebuiforge_model_ponyrealism
) else if "%app_installer_sdwebuiforge_model_choice%"=="9" (
    goto :install_sdwebuiforge_model_cyberrealistic_pony
) else if "%app_installer_sdwebuiforge_model_choice%"=="10" (
    goto :install_sdwebuiforge_model_wai_nsfw_illustrious_sdxl
) else if "%app_installer_sdwebuiforge_model_choice%"=="11" (
    goto :install_sdwebuiforge_model_hassaku_xl_illustrious
) else if "%app_installer_sdwebuiforge_model_choice%"=="12" (
    goto :install_sdwebuiforge_model_cyberillustrious
) else if "%app_installer_sdwebuiforge_model_choice%"=="13" (
    goto :install_sdwebuiforge_model_flux

) else if "%app_installer_sdwebuiforge_model_choice%"=="0" (
    goto :install_sdwebuiforge_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_model_menu
)

:install_sdwebuiforge_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku [SD 1.5] Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku [SD 1.5] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Config in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix VAE in: "%sdwebuiforge_install_path%\models\VAE"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Perfect World [SD 1.5] Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_hassakuxl
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku XL [PONY] Model...
civitdl 376031 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku XL [PONY] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_autismMixconfetti
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading AutismMix SDXL [PONY] Model...
civitdl 288584 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed AutismMix SDXL [PONY] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_ponyrealism
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Pony Realism [PONY] Model...
civitdl 372465 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Pony Realism [PONY] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu

:install_sdwebuiforge_model_cyberrealistic_pony
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading cyberrealistic-pony [PONY] Model...
civitdl 443821 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed cyberrealistic-pony [PONY] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu

:install_sdwebuiforge_model_wai_nsfw_illustrious_sdxl
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading WAI-NSFW-illustrious-SDXL [ILLUSTRIOUS] Model...
civitdl 827184 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed WAI-NSFW-illustrious-SDXL [ILLUSTRIOUS] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu

:install_sdwebuiforge_model_hassaku_xl_illustrious
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading hassaku-xl-illustrious [ILLUSTRIOUS] Model...
civitdl 140272 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed hassaku-xl-illustrious [ILLUSTRIOUS] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu

:install_sdwebuiforge_model_cyberillustrious
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading CyberIllustrious [ILLUSTRIOUS] Model...
civitdl 1125067 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed CyberIllustrious [ILLUSTRIOUS] Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu

:install_sdwebuiforge_model_flux
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Flux...
civitdl 638187 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebuiforge_install_path%\models\Stable-diffusion"%reset%
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

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading...
civitdl %civitaimodelid% -s basic "models\Stable-diffusion"
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_apikey
cls
echo To generate a Civit AI API key, follow these steps:
echo * %cyan_fg_strong%Go to%reset% %yellow_fg_strong%https://civitai.com/user/account%reset% %cyan_fg_strong%or click on your user picture then click on Account settings%reset%
echo * %cyan_fg_strong%Scroll down until you see "API Keys"%reset%
echo * %cyan_fg_strong%Click Add API key%reset%
echo * %cyan_fg_strong%Name it "civitdl" then click on Save%reset%
echo * %cyan_fg_strong%Copy the API Key and paste it here below%reset%
echo.

set /p civitaiapikey="(0 to cancel)Insert API key: "

if "%civitaiapikey%"=="0" goto :install_sdwebuiforge_model_menu

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding API key...
civitconfig default --api-key %civitaiapikey%
pause
goto :install_sdwebuiforge_model_menu


REM ##############################################################
REM ## APP INSTALLER STABLE DIFUSSION WEBUI FORGE NEO - FRONTEND ###
REM ##############################################################
:install_sdwebuiforgeneo_menu
title STL [APP INSTALLER STABLE DIFUSSION WEBUI FORGE NEO]

REM Check if Theme is installed to change menu text
set "theme_label=Install Theme (Lobe Theme)"
if exist "%sdwebuiforgeneo_install_path%\extensions\sd-webui-lobe-theme" (
    set "theme_label=%red_fg_strong%UNINSTALL Theme (Lobe Theme)%reset%"
)

cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Image Generation / Stable Diffusion WebUI Forge NEO ^|%reset%
echo %blue_fg_strong% ================================================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install Stable Diffusion WebUI Forge NEO
echo    2. Install Extensions (Bulk)
echo    3. %theme_label%
echo    4. Models [Install Options]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_sdwebuiforgeneo_choice=%BS%   Choose Your Destiny: "


REM ## APP INSTALLER STABLE DIFUSSION WEBUI FORGE NEO - BACKEND ###
if "%app_installer_sdwebuiforgeneo_choice%"=="1" (
    set "caller=app_installer_image_generation_sdwebuiforgeneo"
    if exist "%app_installer_image_generation_dir%\install_sdwebuiforgeneo.bat" (
        call %app_installer_image_generation_dir%\install_sdwebuiforgeneo.bat
        goto :install_sdwebuiforgeneo_menu
    ) else (
        echo [%DATE% %TIME%] ERROR: install_sdwebuiforgeneo.bat not found in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_sdwebuiforgeneo.bat not found in: %app_installer_image_generation_dir%%reset%
        pause
        goto :install_sdwebuiforgeneo_menu
    )
) else if "%app_installer_sdwebuiforgeneo_choice%"=="2" (
    goto :install_sdwebuiforgeneo_extensions
) else if "%app_installer_sdwebuiforgeneo_choice%"=="3" (
    goto :toggle_sdwebuiforgeneo_theme
) else if "%app_installer_sdwebuiforgeneo_choice%"=="4" (
    goto :install_sdwebuiforgeneo_model_menu
) else if "%app_installer_sdwebuiforgeneo_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforgeneo_menu
)

:toggle_sdwebuiforgeneo_theme
if exist "%sdwebuiforgeneo_install_path%\extensions\sd-webui-lobe-theme" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing Lobe Theme...
    rmdir /s /q "%sdwebuiforgeneo_install_path%\extensions\sd-webui-lobe-theme"
    echo %green_fg_strong%Theme removed successfully.%reset%
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Lobe Theme...
    if not exist "%sdwebuiforgeneo_install_path%\extensions" mkdir "%sdwebuiforgeneo_install_path%\extensions"
    cd /d "%sdwebuiforgeneo_install_path%\extensions"
    git clone https://github.com/PeterBai923/sd-webui-lobe-theme
    echo %green_fg_strong%Theme installed successfully.%reset%
)
pause
goto :install_sdwebuiforgeneo_menu


:install_sdwebuiforgeneo_extensions
REM Check if the folder exists
if not exist "%sdwebuiforgeneo_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion WebUI Forge NEO is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebuiforgeneo_menu
)

REM Clone extensions for stable-diffusion-webui-forge-neo
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning extensions for stable-diffusion-webui-forge-neo...
cd /d "%sdwebuiforgeneo_install_path%\extensions"
git clone https://github.com/ussoewwin/sd-webui-ar-gradio4.git
git clone https://github.com/SiliconeShojo/Stable-Diffusion-Webui-Civitai-Helper.git
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
git clone https://github.com/EnsignMK/danbooru-prompt.git
git clone https://github.com/xiaofeng-ling/sd-webui-openpose-editor.git
git clone https://github.com/Mikubill/sd-webui-controlnet.git
git clone https://github.com/ashen-sensored/sd_webui_SAG.git
git clone https://github.com/NoCrypt/sd-fast-pnginfo.git
git clone https://github.com/newtextdoc1111/adetailer.git
git clone https://github.com/hako-mikan/sd-webui-supermerger.git
git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git
git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
REM git clone https://github.com/Gourieff/sd-webui-reactor-sfw.git
git clone https://github.com/maksabuzyarov/stable-diffusion-webui-rembg.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Better Upscaler models...
cd /d "%sdwebuiforgeneo_install_path%\models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extensions for Stable Diffusion WebUI Forge NEO installed Successfully.%reset%
goto :install_sdwebuiforgeneo_menu


REM ############################################################
REM ##### APP INSTALLER SDWEBUI FORGE NEO Models - FRONTEND ########
REM ############################################################
:install_sdwebuiforgeneo_model_menu
title STL [APP INSTALLER SDWEBUIFORGE NEO MODELS]

REM Check if the folder exists
if not exist "%sdwebuiforgeneo_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Stable Diffusion WebUI Forge NEO is not installed. Please install it first.%reset%
    pause
    goto :install_sdwebuiforgeneo_menu
)

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebuiforgeneo environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebuiforgeneo%reset%
call conda activate sdwebuiforgeneo

cd /d "%sdwebuiforgeneo_install_path%"

cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Stable Diffusion WebUI Forge NEO / Models    ^|%reset%
echo %blue_fg_strong% ===============================================================================%reset%
echo    1. Install a custom model
echo    2. Add Civit AI API Key
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SD 1.5 Models [SD 1.5]                                       ^|%reset%
echo    3. Install Hassaku [ANIME]
echo    4. Install YiffyMix [FURRY]
echo    5. Install Perfect World [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SDXL Models [PONY]                                           ^|%reset%
echo    6. Install Hassaku XL [ANIME] 
echo    7. Install AutismMix_confetti [ANIME/CARTOON/FURRY MIX] 
echo    8. Install Pony Realism [REALISM]
echo    9. Install CyberRealistic Pony [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| SDXL Models [ILLUSTRIOUS]                                    ^|%reset%
echo    10. Install WAI-NSFW-illustrious-SDXL [ANIME]
echo    11. Install Hassaku XL Illustrious [ANIME]
echo    12. Install CyberIllustrious [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| FLUX Models                                                  ^|%reset%
echo    13. Install Flux.1-Dev/Schnell BNB NF4 [REALISM]
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_sdwebuiforgeneo_model_choice=%BS%   Choose Your Destiny: "

REM ######## APP INSTALLER IMAGE GENERATION - BACKEND #########
if "%app_installer_sdwebuiforgeneo_model_choice%"=="1" (
    call :install_sdwebuiforgeneo_model_custom
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="2" (
    goto :install_sdwebuiforgeneo_model_apikey
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="3" (
    goto :install_sdwebuiforgeneo_model_hassaku
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="4" (
    goto :install_sdwebuiforgeneo_model_yiffymix
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="5" (
    goto :install_sdwebuiforgeneo_model_perfectworld
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="6" (
    goto :install_sdwebuiforgeneo_model_hassakuxl
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="7" (
    goto :install_sdwebuiforgeneo_model_autismMixconfetti
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="8" (
    goto :install_sdwebuiforgeneo_model_ponyrealism
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="9" (
    goto :install_sdwebuiforgeneo_model_cyberrealistic_pony
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="10" (
    goto :install_sdwebuiforgeneo_model_wai_nsfw_illustrious_sdxl
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="11" (
    goto :install_sdwebuiforgeneo_model_hassaku_xl_illustrious
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="12" (
    goto :install_sdwebuiforgeneo_model_cyberillustrious
) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="13" (
    goto :install_sdwebuiforgeneo_model_flux

) else if "%app_installer_sdwebuiforgeneo_model_choice%"=="0" (
    goto :install_sdwebuiforgeneo_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforgeneo_model_menu
)

:install_sdwebuiforgeneo_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku [SD 1.5] Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku [SD 1.5] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu


:install_sdwebuiforgeneo_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix Config in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading YiffyMix [SD 1.5] VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed YiffyMix VAE in: "%sdwebuiforgeneo_install_path%\models\VAE"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu


:install_sdwebuiforgeneo_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Perfect World [SD 1.5] Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu


:install_sdwebuiforgeneo_model_hassakuxl
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Hassaku XL [PONY] Model...
civitdl 376031 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Hassaku XL [PONY] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu


:install_sdwebuiforgeneo_model_autismMixconfetti
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading AutismMix SDXL [PONY] Model...
civitdl 288584 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed AutismMix SDXL [PONY] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu


:install_sdwebuiforgeneo_model_ponyrealism
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Pony Realism [PONY] Model...
civitdl 372465 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Pony Realism [PONY] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu

:install_sdwebuiforgeneo_model_cyberrealistic_pony
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading cyberrealistic-pony [PONY] Model...
civitdl 443821 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed cyberrealistic-pony [PONY] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu

:install_sdwebuiforgeneo_model_wai_nsfw_illustrious_sdxl
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading WAI-NSFW-illustrious-SDXL [ILLUSTRIOUS] Model...
civitdl 827184 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed WAI-NSFW-illustrious-SDXL [ILLUSTRIOUS] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu

:install_sdwebuiforgeneo_model_hassaku_xl_illustrious
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading hassaku-xl-illustrious [ILLUSTRIOUS] Model...
civitdl 140272 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed hassaku-xl-illustrious [ILLUSTRIOUS] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu

:install_sdwebuiforgeneo_model_cyberillustrious
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading CyberIllustrious [ILLUSTRIOUS] Model...
civitdl 1125067 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed CyberIllustrious [ILLUSTRIOUS] Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu

:install_sdwebuiforgeneo_model_flux
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Flux...
civitdl 638187 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed Perfect World Model in: "%sdwebuiforgeneo_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforgeneo_model_menu


:install_sdwebuiforgeneo_model_custom
cls
set /p civitaimodelid="(0 to cancel)Insert Model ID: "

if "%civitaimodelid%"=="0" goto :install_sdwebuiforgeneo_model_menu

REM Check if the input is a valid number
echo %civitaimodelid%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforgeneo_model_custom
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading...
civitdl %civitaimodelid% -s basic "models\Stable-diffusion"
pause
goto :install_sdwebuiforgeneo_model_menu


:install_sdwebuiforgeneo_model_apikey
cls
echo To generate a Civit AI API key, follow these steps:
echo * %cyan_fg_strong%Go to%reset% %yellow_fg_strong%https://civitai.com/user/account%reset% %cyan_fg_strong%or click on your user picture then click on Account settings%reset%
echo * %cyan_fg_strong%Scroll down until you see "API Keys"%reset%
echo * %cyan_fg_strong%Click Add API key%reset%
echo * %cyan_fg_strong%Name it "civitdl" then click on Save%reset%
echo * %cyan_fg_strong%Copy the API Key and paste it here below%reset%
echo.

set /p civitaiapikey="(0 to cancel)Insert API key: "

if "%civitaiapikey%"=="0" goto :install_sdwebuiforgeneo_model_menu

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding API key...
civitconfig default --api-key %civitaiapikey%
pause
goto :install_sdwebuiforgeneo_model_menu




REM ############################################################
REM ######## APP INSTALLER CORE UTILITIES - FRONTEND ###########
REM ############################################################
:app_installer_core_utilities
title STL [APP INSTALLER CORE UTILITIES]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Installer / Core Utilities          ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Install 7-Zip
echo    2. Install FFmpeg
echo    3. Install Node.js
echo    4. Install yq
echo    5. Install Visual Studio BuildTools
echo    6. Install CUDA Toolkit
echo    7. Install w64devkit
echo    8. Install Tailscale (VPN to access SillyTavern remotely)
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_installer_core_util_choice=%BS%   Choose Your Destiny: "


REM ######## APP INSTALLER CORE UTILITIES - BACKEND ###########
if "%app_installer_core_util_choice%"=="1" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_7zip.bat" (
        call %app_installer_core_utilities_dir%\install_7zip.bat
        goto :app_installer_core_utilities
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
        goto :app_installer_core_utilities
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
        goto :app_installer_core_utilities
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
        goto :app_installer_core_utilities
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
        goto :app_installer_core_utilities
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
        goto :app_installer_core_utilities
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
        goto :app_installer_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: install_w64devkit.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_w64devkit.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="8" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_tailscale.bat" (
        call %app_installer_core_utilities_dir%\install_tailscale.bat
        goto :app_installer_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: install_tailscale.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] install_tailscale.bat not found in: %app_installer_core_utilities_dir%%reset%
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Uninstaller                         ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Text Completion
echo    2. Voice Generation
echo    3. Image Generation 
echo    4. Core Utilities
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_uninstaller_choice=%BS%   Choose Your Destiny: "

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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Uninstaller / Text Completion       ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%


echo    1. UNINSTALL Text generation web UI oobabooga
echo    2. UNINSTALL koboldcpp
echo    3. UNINSTALL TabbyAPI
echo    4. UNINSTALL llamacpp
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_uninstaller_text_completion_choice=%BS%   Choose Your Destiny: "

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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Uninstaller / Voice Generation      ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. UNINSTALL AllTalk V2
echo    2. UNINSTALL AllTalk
echo    3. UNINSTALL XTTS
echo    4. UNINSTALL rvc

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_uninstaller_voice_gen_choice=%BS%   Choose Your Destiny: "

REM ######## APP UNINSTALLER VOICE GENERATION - BACKEND #########
if "%app_uninstaller_voice_gen_choice%"=="1" (
    set "caller=app_uninstaller_voice_generation"
    if exist "%app_uninstaller_voice_generation_dir%\uninstall_alltalk_v2.bat" (
        call %app_uninstaller_voice_generation_dir%\uninstall_alltalk_v2.bat
        goto :app_uninstaller_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_alltalk_v2.bat not found in: %app_uninstaller_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_alltalk_v2.bat not found in: %app_uninstaller_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_voice_generation
    )
) else if "%app_uninstaller_voice_gen_choice%"=="2" (
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
) else if "%app_uninstaller_voice_gen_choice%"=="3" (
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
) else if "%app_uninstaller_voice_gen_choice%"=="4" (
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Uninstaller / Image Generation      ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. UNINSTALL Stable Diffusion WebUI
echo    2. UNINSTALL Stable Diffusion WebUI Forge
echo    3. UNINSTALL Stable Diffusion WebUI Forge NEO
echo    4. UNINSTALL ComfyUI
echo    5. UNINSTALL SwarmUI
echo    6. UNINSTALL Fooocus
echo    7. UNINSTALL InvokeAI
echo    8. UNINSTALL Ostris AI Toolkit
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_uninstaller_img_gen_choice=%BS%   Choose Your Destiny: "

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
    if exist "%app_uninstaller_image_generation_dir%\uninstall_sdwebuiforgeneo.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_sdwebuiforgeneo.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_sdwebuiforgeneo.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_sdwebuiforgeneo.bat not found in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="4" (
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
) else if "%app_uninstaller_img_gen_choice%"=="5" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_swarmui.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_swarmui.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_swarmui.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_swarmui.bat not found in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="6" (
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
) else if "%app_uninstaller_img_gen_choice%"=="7" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_invokeai.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_invokeai.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_invokeai.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_invokeai.bat not found in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="8" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_ostris_aitoolkit.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_ostris_aitoolkit.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_ostris_aitoolkit.bat not found in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_ostris_aitoolkit.bat not found in: %app_uninstaller_image_generation_dir%%reset%
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / App Uninstaller / Core Utilities        ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. UNINSTALL Extras
echo    2. UNINSTALL SillyTavern
echo    3. UNINSTALL 7-Zip
echo    4. UNINSTALL FFmpeg
echo    5. UNINSTALL Node.js
echo    6. UNINSTALL yq
echo    7. UNINSTALL CUDA Toolkit
echo    8. UNINSTALL Visual Studio BuildTools
echo    9. UNINSTALL w64devkit
echo    10. UNINSTALL Tailscale

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "app_uninstaller_core_utilities_choice=%BS%   Choose Your Destiny: "


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
) else if "%app_uninstaller_core_utilities_choice%"=="10" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_tailscale.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_tailscale.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: uninstall_tailscale.bat not found in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] uninstall_tailscale.bat not found in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="0" (
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / Editor                                  ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Text Completion
echo    2. Voice Generation 
echo    3. Image Generation 
echo    4. Core Utilities

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "editor_choice=%BS%   Choose Your Destiny: "

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
echo %blue_fg_strong%^| ^> / Home / Toolbox / Editor / Text Completion                ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Edit Text generation web UI oobabooga
echo    2. Edit koboldcpp
echo    3. Edit TabbyAPI

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "editor_text_completion_choice=%BS%   Choose Your Destiny: "


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
        if exist "%tabbyapi_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%tabbyapi_modules_path%"') do (
        set "%%A=%%B"
    )
)
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / Editor / Voice Generation               ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Edit XTTS Modules
echo    2. Edit RVC-PYTHON Modules

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "editor_voice_generation_choice=%BS%   Choose Your Destiny: "

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
) else if "%editor_voice_generation_choice%"=="2" (
    set "caller=editor_voice_generation"
    if exist "%editor_voice_generation_dir%\edit_rvc_python_modules.bat" (
        call %editor_voice_generation_dir%\edit_rvc_python_modules.bat
        goto :editor_voice_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_rvc_python_modules.bat not found in: %editor_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_rvc_python_modules.bat not found in: %editor_voice_generation_dir%%reset%
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
echo %blue_fg_strong%^| ^> / Home / Toolbox / Editor / Image Generation               ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Edit Stable Diffusion WebUI
echo    2. Edit Stable Diffusion WebUI Forge
echo    3. Edit Stable Diffusion WebUI Forge NEO
echo    4. Edit ComfyUI
echo    5. Edit Fooocus
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "editor_image_generation_choice=%BS%   Choose Your Destiny: "

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
    if exist "%editor_image_generation_dir%\edit_sdwebuiforgeneo_modules.bat" (
        call %editor_image_generation_dir%\edit_sdwebuiforgeneo_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_sdwebuiforgeneo_modules.bat not found in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_sdwebuiforgeneo_modules.bat not found in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="4" (
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
) else if "%editor_image_generation_choice%"=="5" (
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

echo %blue_fg_strong%^| ^> / Home / Toolbox / Editor / Core Utilities                                               ^|%reset%
echo %blue_fg_strong% ============================================================================================%reset%   
echo %cyan_fg_strong% ____________________________________________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                                                 ^|%reset%

echo    1. Edit SillyTavern config.yaml
echo    %sslOption%
echo    3. Edit Extras
echo    4. Edit Environment Variables
echo    5. View Tailscale configuration

echo %cyan_fg_strong% ____________________________________________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                                              ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ____________________________________________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                                                            ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "editor_core_utilities_choice=%BS%   Choose Your Destiny: "

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
) else if "%editor_core_utilities_choice%"=="5" (
    set "caller=editor_core_utilities"
    if exist "%app_installer_core_utilities_dir%\config_tailscale.bat" (
        call %app_installer_core_utilities_dir%\config_tailscale.bat
        goto :editor_core_utilities
    ) else (
        echo [%DATE% %TIME%] ERROR: config_tailscale.bat not found in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] config_tailscale.bat not found in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
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
    echo %blue_fg_strong%Del eting %CERTS_DIR% ...%reset%
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
REM ########## TROUBLESHOOTING & SUPPORT - FRONTEND ############
REM ############################################################
:troubleshooting
setlocal enabledelayedexpansion

REM Check auto-repair setting
if not exist "%log_dir%\autorepair-setting.txt" (
    echo NO > "%log_dir%\autorepair-setting.txt"
)
for /f "tokens=1 delims= " %%a in ('type "%log_dir%\autorepair-setting.txt"') do set "st_auto_repair=%%a"
if /i "%st_auto_repair%"=="YES" (
    set "autorepair_status=Enabled"
) else (
    set "autorepair_status=Disabled"
)

title STL [TROUBLE ^& SUPPORT]
@echo off
cls
echo %blue_fg_strong%^| ^> / Home / Troubleshooting ^& Support                         ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   

REM Call the VPN detection script
call "%troubleshooting_dir%\detect_vpn.bat" > "%log_dir%\vpn_status.txt"
set /p "vpnStatus="<"%log_dir%\vpn_status.txt"
del "%log_dir%\vpn_status.txt"

REM Call the home port check script
call "%troubleshooting_dir%\home_port_check.bat" > "%log_dir%\port_8000_status.txt"
set /p "portStatus="<"%log_dir%\port_8000_status.txt"
del "%log_dir%\port_8000_status.txt"

REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i

REM Get the current PowerShell version
for /f "tokens=*" %%i in ('powershell -command "[string]::Join('.', $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor, $PSVersionTable.PSVersion.Build, $PSVersionTable.PSVersion.Revision)"') do set ps_version=%%i

REM Read the package.json file and extract the version key value
for /f "tokens=2 delims=:" %%a in ('findstr /c:"\"version\"" "%st_package_json_path%"') do (
    set "st-version=%%a"
)

REM Remove leading and trailing whitespace and surrounding quotes
for /f "tokens=* delims= " %%a in ("!st-version!") do (
    set "st-version=%%a"
)

set st-version=%st-version:"=%
set st-version=%st-version:,=%

REM Check if the package.json file exists
if not exist "%st_package_json_path%" (
set "st-version=%red_bg%[ERROR] Cannot get ST version because package.json file not found in %st_install_path%%reset%"
)

echo %yellow_fg_strong% ______________________________________________________________%reset%
echo %yellow_fg_strong%^| Version ^& Compatibility Status:                              ^|%reset%
echo    SillyTavern Branch: %cyan_fg_strong%!current_branch! %reset%^| Status: %cyan_fg_strong%!update_status_st!%reset%
echo    SillyTavern: %cyan_fg_strong%!st-version!%reset%
echo    STL: %cyan_fg_strong%!stl_version!%reset%
echo    !gpuInfo!
echo    Node.js: %cyan_fg_strong%!node_version!%reset%
echo    PowerShell: %cyan_fg_strong%!ps_version!%reset%
echo    !vpnStatus!
echo    !portStatus!

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Troubleshooting ^& Repair Options:                            ^|%reset%

echo    1. Remove node_modules folder
echo    2. Clear npm cache
echo    3. Clear pip cache
echo    4. Fix unresolved conflicts or unmerged files [SillyTavern]
echo    5. Export dxdiag info
echo    6. Find what app is using port
echo    7. Set Onboarding Flow
echo    8. Toggle Logging/Auto-repair (Current: %cyan_fg_strong%!autorepair_status!%reset%)
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Support Options:                                             ^|%reset%
echo    9. Report an Issue
echo    10. SillyTavern Documentation
echo    11. Discord servers
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "troubleshooting_choice=%BS%   Choose Your Destiny: "


REM ############## TROUBLESHOOTING - BACKEND ##################
if "%troubleshooting_choice%"=="1" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\remove_node_modules.bat" (
        call %troubleshooting_dir%\remove_node_modules.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: remove_node_modules.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] remove_node_modules.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="2" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\remove_npm_cache.bat" (
        call %troubleshooting_dir%\remove_npm_cache.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: remove_npm_cache.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] remove_npm_cache.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="3" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\remove_pip_cache.bat" (
        call %troubleshooting_dir%\remove_pip_cache.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: remove_pip_cache.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] remove_pip_cache.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="4" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\fix_github_conflicts.bat" (
        call %troubleshooting_dir%\fix_github_conflicts.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: fix_github_conflicts.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] fix_github_conflicts.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="5" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\export_dxdiag.bat" (
        call %troubleshooting_dir%\export_dxdiag.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: export_dxdiag.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] export_dxdiag.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="6" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\find_app_port.bat" (
        call %troubleshooting_dir%\find_app_port.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: find_app_port.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] find_app_port.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="7" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\onboarding_flow.bat" (
        call %troubleshooting_dir%\onboarding_flow.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: onboarding_flow.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] onboarding_flow.bat not found in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="8" (
    for /f "tokens=1 delims= " %%a in ('type "%log_dir%\autorepair-setting.txt"') do set "st_auto_repair=%%a"
    if /i "%st_auto_repair%"=="YES" (
        echo NO > "%log_dir%\autorepair-setting.txt"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Auto-repair and logging disabled.
    ) else (
        echo YES > "%log_dir%\autorepair-setting.txt"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Auto-repair and logging enabled.
    )
    goto :troubleshooting
) else if "%troubleshooting_choice%"=="9" (
    call :issue_report
) else if "%troubleshooting_choice%"=="10" (
    call :documentation
) else if "%troubleshooting_choice%"=="11" (
    set "caller=troubleshooting"
    if exist "%troubleshooting_dir%\Support\discord.bat" (
        call %troubleshooting_dir%\Support\discord.bat
        goto :troubleshooting
    ) else (
        echo [%DATE% %TIME%] ERROR: discord.bat not found in: %troubleshooting_dir%\Support >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] discord.bat not found in: %troubleshooting_dir%\Support%reset%
        pause
    )
) else if "%troubleshooting_choice%"=="0" (
    goto :home
) else if "%troubleshooting_choice%"=="99" (
    set "caller=home"
    if exist "%troubleshooting_dir%\find_app_port.bat" (
        call %troubleshooting_dir%\find_app_port.bat 8000 
    ) else (
        echo [%DATE% %TIME%] ERROR: find_app_port.bat not found in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] find_app_port.bat not found in: %troubleshooting_dir%%reset%
        pause
    )
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :troubleshooting
)

:issue_report
start "" "https://github.com/SillyTavern/SillyTavern-Launcher/issues/new/choose"
goto :troubleshooting

:documentation
start "" "https://docs.sillytavern.app/"
goto :troubleshooting



REM ############################################################
REM ############## SWITCH BRANCH - FRONTEND ####################
REM ############################################################
:switch_branch
title STL [SWITCH-BRANCH]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / Switch Branch                           ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo %yellow_fg_strong% ______________________________________________________________%reset%
echo %yellow_fg_strong%^| Version Status:                                              ^|%reset%
echo    SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%
echo    1. Switch to Release - SillyTavern
echo    2. Switch to Staging - SillyTavern

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back


echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%
:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "branch_choice=%BS%   Choose Your Destiny: "


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
echo %blue_fg_strong%^| ^> / Home / Toolbox / Backup                                  ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| What would you like to do?                                   ^|%reset%

echo    1. Create Backup
echo    2. Restore Backup
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "backup_choice=%BS%   Choose Your Destiny: "

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
start cmd /k "title SillyTavern && cd /d %st_install_path% && call npm install --no-save --no-audit --no-fund --loglevel=error --no-progress --omit=dev && node server.js && pause && popd"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% SillyTavern launched in a new window.

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
