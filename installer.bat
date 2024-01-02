@echo off
REM SillyTavern Installer
REM Created by: Deffcolony
REM
REM Description:
REM This script can install sillytavern and/or extras with shortcut to open the launcher.bat
REM
REM This script is intended for use on Windows systems.
REM report any issues or bugs on the GitHub repository.
REM
REM GitHub: https://github.com/SillyTavern/SillyTavern-Launcher
REM Issues: https://github.com/SillyTavern/SillyTavern-Launcher/issues
title SillyTavern Installer
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

REM Environment Variables (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM Environment Variables (TOOLBOX Install Extras)
set "miniconda_path=%userprofile%\miniconda3"

REM Define the paths and filenames for the shortcut creation
set "shortcutTarget=%~dp0launcher.bat"
set "iconFile=%~dp0SillyTavern\public\st-launcher.ico"
set "desktopPath=%userprofile%\Desktop"
set "shortcutName=ST-Launcher.lnk"
set "startIn=%~dp0"
set "comment=SillyTavern Launcher"


REM Check if Winget is installed; if not, then install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Winget is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Winget...
    curl -L -o "%temp%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" "https://github.com/microsoft/winget-cli/releases/download/v1.6.2771/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    start "" "%temp%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Winget installed successfully.%reset%
) else (
    echo %blue_fg_strong%[INFO] Winget is already installed.%reset%
)


rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Check if the paths are already in the current PATH
echo %current_path% | find /i "%winget_path%" > nul
set "ff_path_exists=%errorlevel%"

rem Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%winget_path%"

    rem Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%new_path%" /f

    rem Update the PATH value for the current session
    setx PATH "%new_path%" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%winget added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] winget already exists in PATH.%reset%
)


REM Check if Git is installed if not then install git
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Git is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Git using Winget...
    winget install -e --id Git.Git
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Git installed successfully. Please restart the Installer.%reset%
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

REM Check if Python App Execution Aliases exist
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" (
    REM Disable App Execution Aliases for python.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" -Force
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Removed Execution Alias for python.exe%reset%
) else (
    echo %blue_fg_strong%[INFO] Execution Alias for python.exe was already removed.%reset%
)

REM Check if python3.exe App Execution Alias exists
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" (
    REM Disable App Execution Aliases for python3.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" -Force
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Removed Execution Alias for python3.exe%reset%
) else (
    echo %blue_fg_strong%[INFO] Execution Alias for python3.exe was already removed.%reset%
)


REM Installer - Frontend
:installer
title SillyTavern [INSTALLER]
cls
echo %blue_fg_strong%/ Installer%reset%
echo -------------------------------------
echo What would you like to do?
echo 1. Install SillyTavern + Extras
echo 2. Install SillyTavern
echo 3. Install Extras
echo 4. Exit

set "choice="
set /p "choice=Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM Installer - Backend
if "%choice%"=="1" (
    call :install_st_extras
) else if "%choice%"=="2" (
    call :install_sillytavern 
) else if "%choice%"=="3" (
    call :install_extras
) else if "%choice%"=="4" (
    exit
) else (
    color 6
    echo WARNING: Invalid number. Please insert a valid number.
    pause
    goto :installer
)


:install_st_extras
title SillyTavern [INSTALL ST + EXTRAS]
cls
echo %blue_fg_strong%/ Installer / SillyTavern + Extras%reset%
echo ---------------------------------------------------------------

:what_gpu
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only mode)

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

REM Set the GPU choice in an environment variable for choise callback
set "GPU_CHOICE=%gpu_choice%"

REM Check the user's response
if "%gpu_choice%"=="1" (
    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA
    goto :install_st_extras_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_st_extras_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Using CPU-only mode
    goto :install_st_extras_pre
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Invalid GPU choice. Please enter a valid number.
    pause
    goto what_gpu
)

:install_st_extras_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern + Extras...

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern...

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern repository...
git clone https://github.com/SillyTavern/SillyTavern.git
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern installed successfully.%reset%

REM Clone the SillyTavern Extras repository
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Extras...
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern-extras repository...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Provide a link to the XTTS
echo %blue_fg_strong%[INFO] Feeling excited to give your robotic waifu/husbando a new shiny voice modulator?%reset%
echo %blue_fg_strong%To learn more about XTTS, visit:%reset% https://coqui.ai/blog/tts/open_xtts

REM Ask the user if they want to install XTTS
set /p install_xtts_requirements=Install XTTS? [Y/N] 

REM Check the user's response
if /i "%install_xtts_requirements%"=="Y" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing XTTS...

    REM Activate the Miniconda installation
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
    call "%miniconda_path%\Scripts\activate.bat"

    REM Create a Conda environment named xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment xtts...
    call conda create -n xtts -y

    REM Activate the xtts environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment xtts...
    call conda activate xtts

    REM Check if activation was successful
    if %errorlevel% equ 0 (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Conda environment xtts activated successfully.
    ) else (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to activate Conda environment xtts.%reset%
        echo %blue_bg%[%time%]%reset% %red_fg_strong%[INFO] Press any key to try again otherwise close the installer and restart%reset%
        goto :install_st_extras_pre
    )

    REM Install Python 3.10 in the xtts environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Python in the Conda environment...
    call conda install python=3.10 -y

    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements for xtts...
    pip install xtts-api-server
    pip install pydub
    pip install stream2sentence==0.2.2

    REM Use the GPU choice made earlier to set the correct PyTorch index-url
    if "%GPU_CHOICE%"=="1" (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
        goto :install_xtts
    ) else if "%GPU_CHOICE%"=="2" (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
        goto :install_xtts
    ) else if "%GPU_CHOICE%"=="3" (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing CPU-only version of PyTorch
        pip install torch torchvision torchaudio
        goto :install_xtts
    )

    :install_xtts
    REM Create folders for xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating xtts folders...
    mkdir "%~dp0xtts"
    mkdir "%~dp0xtts\speakers"
    mkdir "%~dp0xtts\output"

    REM Clone the xtts-api-server repository for voice examples
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning xtts-api-server repository...
    git clone https://github.com/daswer123/xtts-api-server.git

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding voice examples to speakers directory...
    xcopy "%~dp0xtts-api-server\example\*" "%~dp0xtts\speakers\" /y /e

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts-api-server directory...
    rmdir /s /q "%~dp0xtts-api-server"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] XTTS installation skipped.%reset% 
)

REM Create a Conda environment named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment extras...
call conda create -n extras -y

REM Activate the extras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment extras...
call conda activate extras

REM Navigate to the SillyTavern-extras directory
cd "%~dp0SillyTavern-extras"


REM Use the GPU choice made earlier to install requirements for extras
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for NVIDIA from requirements.txt in extras
    pip install -r requirements.txt
    call conda install -c conda-forge faiss-gpu -y
    goto :install_st_extras_post
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for AMD from requirements-rocm.txt in extras
    pip install -r requirements-rocm.txt
    goto :install_st_extras_post
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for CPU from requirements-silicon.txt in extras
    pip install -r requirements-silicon.txt
    goto :install_st_extras_post
)

:install_st_extras_post
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"

if %errorlevel% neq 0 (
  echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Download failed. Please restart the installer%reset%
  pause
  goto :installer
) else (
  start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
)

REM Activate the extras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment extras...
call conda activate extras

REM Check if activation was successful
if %errorlevel% equ 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Conda environment extras activated successfully.
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to activate Conda environment extras.%reset%
)

REM Install Python 3.11 and Git in the extras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Python and Git in the Conda environment...
call conda install python=3.11 git -y

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements-rvc in extras environment...
pip install -r requirements-rvc.txt
pip install tensorboardX

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extras installed successfully.%reset%


REM Ask if the user wants to create a shortcut
set /p create_shortcut=Do you want to create a shortcut on the desktop? [Y/n] 
if /i "%create_shortcut%"=="Y" (

    REM Create the shortcut
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating shortcut...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%desktopPath%\%shortcutName%'); " ^
        "$Shortcut.TargetPath = '%shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%startIn%'; " ^
        "$Shortcut.Description = '%comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Shortcut created on the desktop.%reset%
)


REM Ask if the user wants to start the launcher.bat
set /p start_launcher=Start the launcher now? [Y/n] 
if /i "%start_launcher%"=="Y" (
    REM Run the launcher
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running launcher in a new window...
    cd /d "%~dp0"
    start cmd /k launcher.bat
    exit
)
goto :installer


:install_sillytavern
title SillyTavern [INSTALL ST]
cls
echo %blue_fg_strong%/ Installer / SillyTavern%reset%
echo ---------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern...

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern repository...
git clone https://github.com/SillyTavern/SillyTavern.git
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern installed successfully.%reset%

REM Ask if the user wants to create a shortcut
set /p create_shortcut=Do you want to create a shortcut on the desktop? [Y/n] 
if /i "%create_shortcut%"=="Y" (

    REM Create the shortcut
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating shortcut...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%desktopPath%\%shortcutName%'); " ^
        "$Shortcut.TargetPath = '%shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%startIn%'; " ^
        "$Shortcut.Description = '%comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Shortcut created on the desktop.%reset%
)


REM Ask if the user wants to start the launcher.bat
set /p start_launcher=Start the launcher now? [Y/n] 
if /i "%start_launcher%"=="Y" (
    REM Run the launcher
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running launcher in a new window...
    cd /d "%~dp0"
    start cmd /k launcher.bat
    exit
)
goto :installer


:install_extras
title SillyTavern [INSTALL EXTRAS]
cls
echo %blue_fg_strong%/ Installer / Extras%reset%
echo ---------------------------------------------------------------

:what_gpu
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only mode)

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

REM Set the GPU choice in an environment variable for choise callback
set "GPU_CHOICE=%gpu_choice%"

REM Check the user's response
if "%gpu_choice%"=="1" (
    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA
    goto :install_extras_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_extras_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Using CPU-only mode
    goto :install_extras_pre
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Invalid GPU choice. Please enter a valid number.
    pause
    goto what_gpu
)

:install_extras_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Extras...

REM Clone the SillyTavern Extras repository
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern-extras repository...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Provide a link to the XTTS
echo %blue_fg_strong%[INFO] Feeling excited to give your robotic waifu/husbando a new shiny voice modulator?%reset%
echo %blue_fg_strong%To learn more about XTTS, visit:%reset% https://coqui.ai/blog/tts/open_xtts

REM Ask the user if they want to install XTTS
set /p install_xtts_requirements=Install XTTS? [Y/N] 

REM Check the user's response
if /i "%install_xtts_requirements%"=="Y" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing XTTS...

    REM Activate the Miniconda installation
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
    call "%miniconda_path%\Scripts\activate.bat"

    REM Create a Conda environment named xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment xtts...
    call conda create -n xtts -y

    REM Activate the xtts environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment xtts...
    call conda activate xtts

    REM Check if activation was successful
    if %errorlevel% equ 0 (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Conda environment xtts activated successfully.
    ) else (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to activate Conda environment xtts.%reset%
    )

    REM Install Python 3.10 in the xtts environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Python in the Conda environment...
    call conda install python=3.10 -y

    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements for xtts...
    pip install xtts-api-server
    pip install pydub
    pip install stream2sentence==0.2.2
    
    REM Use the GPU choice made earlier to set the correct PyTorch index-url
    if "%GPU_CHOICE%"=="1" (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
        goto :install_xtts
    ) else if "%GPU_CHOICE%"=="2" (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
        goto :install_xtts
    ) else if "%GPU_CHOICE%"=="3" (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing CPU-only version of PyTorch
        pip install torch torchvision torchaudio
        goto :install_xtts
    )

    :install_xtts
    REM Create folders for xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating xtts folders...
    mkdir "%~dp0xtts"
    mkdir "%~dp0xtts\speakers"
    mkdir "%~dp0xtts\output"

    REM Clone the xtts-api-server repository for voice examples
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning xtts-api-server repository...
    git clone https://github.com/daswer123/xtts-api-server.git

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding voice examples to speakers directory...
    xcopy "%~dp0xtts-api-server\example\*" "%~dp0xtts\speakers\" /y /e

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts-api-server directory...
    rmdir /s /q "%~dp0xtts-api-server"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] XTTS installation skipped.%reset% 
)

REM Create a Conda environment named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment extras...
call conda create -n extras -y

REM Activate the extras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment extras...
call conda activate extras

REM Navigate to the SillyTavern-extras directory
cd "%~dp0SillyTavern-extras"

REM Use the GPU choice made earlier to install requirements for extras
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for NVIDIA from requirements.txt in extras
    pip install -r requirements.txt
    call conda install -c conda-forge faiss-gpu -y
    goto :install_extras_post
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for AMD from requirements-rocm.txt in extras
    pip install -r requirements-rocm.txt
    goto :install_extras_post
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for CPU from requirements-silicon.txt in extras
    pip install -r requirements-silicon.txt
    goto :install_extras_post
)

:install_extras_post
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"

if %errorlevel% neq 0 (
  echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Download failed. Please restart the installer%reset%
  pause
  goto :installer
) else (
  start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
)

REM Activate the extras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment extras...
call conda activate extras

REM Check if activation was successful
if %errorlevel% equ 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Conda environment extras activated successfully.
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to activate Conda environment extras.%reset%
)

REM Install Python 3.11 and Git in the extras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Python and Git in the Conda environment...
call conda install python=3.11 git -y

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements-rvc in extras environment...
pip install -r requirements-rvc.txt
pip install tensorboardX

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extras installed successfully.%reset%

REM Ask if the user wants to create a shortcut
set /p create_shortcut=Do you want to create a shortcut on the desktop? [Y/n] 
if /i "%create_shortcut%"=="Y" (

    REM Create the shortcut
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating shortcut...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%desktopPath%\%shortcutName%'); " ^
        "$Shortcut.TargetPath = '%shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%startIn%'; " ^
        "$Shortcut.Description = '%comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Shortcut created on the desktop.%reset%
)


REM Ask if the user wants to start the launcher.bat
set /p start_launcher=Start the launcher now? [Y/n] 
if /i "%start_launcher%"=="Y" (
    REM Run the launcher
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running launcher in a new window...
    cd /d "%~dp0"
    start cmd /k launcher.bat
    exit
)
goto :installer
