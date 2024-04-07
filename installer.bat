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
title STL Installer [STARTUP CHECK]
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

REM Environment Variables (get)
set "git_path=%userprofile%\AppData\Local"

REM Environment Variables (miniconda3)
set "miniconda_path=%userprofile%\miniconda3"
set "miniconda_path_mingw=%userprofile%\miniconda3\Library\mingw-w64\bin"
set "miniconda_path_usrbin=%userprofile%\miniconda3\Library\usr\bin"
set "miniconda_path_bin=%userprofile%\miniconda3\Library\bin"
set "miniconda_path_scripts=%userprofile%\miniconda3\Scripts"

REM Define the paths and filenames for the shortcut creation
set "shortcutTarget=%~dp0launcher.bat"
set "iconFile=%~dp0SillyTavern\public\st-launcher.ico"
set "desktopPath=%userprofile%\Desktop"
set "shortcutName=ST-Launcher.lnk"
set "startIn=%~dp0"
set "comment=SillyTavern Launcher"


REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"


setlocal enabledelayedexpansion




endlocal

REM Check if Git is installed if not then install git
if "%startIn%\PortableGit" neq 0 (
curl -LJO https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/PortableGit-2.44.0-32-bit.7z.exe
PortableGit-2.44.0-32-bit.7z.exe -o  "%startIn%\PortableGit" -y 
)


REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%miniconda_path%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

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
    echo %blue_fg_strong%[INFO] miniconda3 already exists in PATH.%reset%
)

REM Check if Miniconda3 is installed if not then install Miniconda3
call conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Miniconda3 is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Miniconda3 using curl...
    curl -L -o "%temp%\vs_buildtools.exe" "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" 
	Miniconda3-latest-Windows-x86_64.exe" /InstallationType=JustMe /RegisterPython=0 /S /D="%userprofile%\miniconda3" 
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


REM Installer menu - Frontend
:installer
title STL [INSTALLER]
cls
echo %blue_fg_strong%/ Installer%reset%
echo ---------------------------------------------------------------
echo What would you like to do?
echo 1. Install SillyTavern + Extras + XTTS
echo 2. Install SillyTavern
echo 3. Install Extras
echo 4. Install XTTS
echo 5. Support
echo 0. Exit

set "choice="
set /p "choice=Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM Installer menu - Backend
if "%choice%"=="1" (
    call :install_all
) else if "%choice%"=="2" (
    call :install_sillytavern
) else if "%choice%"=="3" (
    call :install_extras
) else if "%choice%"=="4" (
    call :install_xtts
) else if "%choice%"=="5" (
    call :support
) else if "%choice%"=="0" (
    exit
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :installer
)


:install_all
title STL [INSTALL SILLYTAVERN + EXTRAS + XTTS]
cls
echo %blue_fg_strong%/ Installer / Install SillyTavern + Extras + XTTS%reset%
echo ---------------------------------------------------------------

REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only mode)
echo 0. Cancel install

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
    goto :install_all_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_all_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Using CPU-only mode
    goto :install_all_pre
) else if "%gpu_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_all
)

:install_all_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern + Extras + XTTS...
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern...

set max_retries=3
set retry_count=0

:retry_st_extras_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern repository...
git clone https://github.com/SillyTavern/SillyTavern.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_st_extras_pre
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :installer
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern installed successfully.%reset%

REM Clone the SillyTavern Extras repository
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Extras...
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern-extras repository...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Install script for XTTS 
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing XTTS...

    REM Activate the Miniconda installation
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
    call "%miniconda_path%\Scripts\activate.bat"

    REM Create a Conda environment named xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%xtts%reset%
    call conda create -n xtts python=3.10 git -y

    REM Activate the conda environment named xtts 
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%xtts%reset%
    call conda activate xtts

    REM Use the GPU choice made earlier to install requirements for XTTS
    if "%GPU_CHOICE%"=="1" (
        echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
        pip install torch==2.1.1+cu118 torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
        goto :install_st_xtts
    ) else if "%GPU_CHOICE%"=="2" (
        echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
        goto :install_st_xtts
    ) else if "%GPU_CHOICE%"=="3" (
        echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing CPU-only version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
        pip install torch torchvision torchaudio
        goto :install_st_xtts
    )

    :install_st_xtts
    REM Clone the xtts-api-server repository for voice examples
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning xtts-api-server repository...
    git clone https://github.com/daswer123/xtts-api-server.git
    cd /d "%~dp0xtts-api-server"

    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install -r requirements.txt
    pip install xtts-api-server
    pip install pydub
    pip install stream2sentence

    REM Create folders for xtts
    cd /d "%~dp0"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating xtts folders...
    mkdir "%~dp0xtts"
    mkdir "%~dp0xtts\speakers"
    mkdir "%~dp0xtts\output"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding voice examples to speakers directory...
    xcopy "%~dp0xtts-api-server\example\*" "%~dp0xtts\speakers\" /y /e

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts-api-server directory...
    rmdir /s /q "%~dp0xtts-api-server"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS installed successfully%reset%
REM End of install script for XTTS


REM Create a Conda environment named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%extras%reset%
call conda create -n extras python=3.11 git -y

REM Activate the conda environment named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%extras%reset%
call conda activate extras

REM Navigate to the SillyTavern-extras directory
cd "%~dp0SillyTavern-extras"

REM Use the GPU choice made earlier to install requirements for extras
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for NVIDIA from requirements.txt in conda enviroment: %cyan_fg_strong%extras%reset% 
    call conda install -c conda-forge faiss-gpu -y
    pip install -r requirements.txt
    goto :install_all_post
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for AMD from requirements-rocm.txt in conda enviroment: %cyan_fg_strong%extras%reset% 
    pip install -r requirements-rocm.txt
    goto :install_all_post
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for CPU from requirements-silicon.txt in conda enviroment: %cyan_fg_strong%extras%reset% 
    pip install -r requirements-silicon.txt
    goto :install_all_post
)

:install_all_post
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements from requirements-rvc.txt in conda enviroment: %cyan_fg_strong%extras%reset% 
pip install -r requirements-rvc.txt
pip install tensorboardX

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/c7707d68-d6ce-4479-973e-e2a3dc4341fe/1AD7988C17663CC742B01BEF1A6DF2ED1741173009579AD50A94434E54F56073/VC_redist.x64.exe', 'VC_redist.x64.exe')"
VC_redist.x64.exe /install /quiet /norestart

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/71c6392f-8df5-4b61-8d50-dba6a525fb9d/510FC8C2112E2BC544FB29A72191EABCC68D3A5A7468D35D7694493BC8593A79/VC_redist.x86.exe', 'VC_redist.x86.exe')"
VC_redist.x86.exe /install /quiet /norestart

REM Check if file exists
if not exist "%temp%\vs_buildtools.exe" (
    curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "vs_buildtools.exe" file already exists.%reset%
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools


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
title STL [INSTALL SILLYTAVERN]
cls
echo %blue_fg_strong%/ Installer / Install SillyTavern%reset%
echo ---------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern...

set max_retries=3
set retry_count=0

:retry_install_sillytavern
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern repository...
git clone https://github.com/SillyTavern/SillyTavern.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_sillytavern
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :installer
)

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
title STL [INSTALL EXTRAS]
cls
echo %blue_fg_strong%/ Installer / Install Extras%reset%
echo ---------------------------------------------------------------

REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only mode)
echo 0. Cancel install

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
    goto :install_extras_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_extras_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Using CPU-only mode
    goto :install_extras_pre
) else if "%gpu_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_extras
)

:install_extras_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Extras...

set max_retries=3
set retry_count=0

:retry_extras_pre
REM Clone the SillyTavern Extras repository
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern-extras repository...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_extras_pre
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :installer
)


REM Create a Conda environment named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%extras%reset%
call conda create -n extras python=3.11 git -y

REM Activate the conda environment named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%extras%reset%
call conda activate extras

REM Navigate to the SillyTavern-extras directory
cd "%~dp0SillyTavern-extras"

REM Use the GPU choice made earlier to install requirements for extras
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for NVIDIA from requirements.txt in conda enviroment: %cyan_fg_strong%extras%reset%
    call conda install -c conda-forge faiss-gpu -y
    pip install -r requirements.txt
    goto :install_extras_post
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for AMD from requirements-rocm.txt in conda enviroment: %cyan_fg_strong%extras%reset%
    pip install -r requirements-rocm.txt
    goto :install_extras_post
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing modules for CPU from requirements-silicon.txt in conda enviroment: %cyan_fg_strong%extras%reset%
    pip install -r requirements-silicon.txt
    goto :install_extras_post
)

:install_extras_post
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements from requirements-rvc.txt in conda enviroment: %cyan_fg_strong%extras%reset%
pip install -r requirements-rvc.txt
pip install tensorboardX

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/c7707d68-d6ce-4479-973e-e2a3dc4341fe/1AD7988C17663CC742B01BEF1A6DF2ED1741173009579AD50A94434E54F56073/VC_redist.x64.exe', 'VC_redist.x64.exe')"
VC_redist.x64.exe /install /quiet /norestart

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/71c6392f-8df5-4b61-8d50-dba6a525fb9d/510FC8C2112E2BC544FB29A72191EABCC68D3A5A7468D35D7694493BC8593A79/VC_redist.x86.exe', 'VC_redist.x86.exe')"
VC_redist.x86.exe /install /quiet /norestart

REM Check if file exists
if not exist "%temp%\vs_buildtools.exe" (
    curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "vs_buildtools.exe" file already exists.%reset%
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools


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


:install_xtts
title STL [INSTALL XTTS]
cls
echo %blue_fg_strong%/ Installer / Install XTTS%reset%
echo ---------------------------------------------------------------

REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only mode)
echo 0. Cancel install

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
    goto :install_xtts_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_xtts_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Using CPU-only mode
    goto :install_xtts_pre
) else if "%gpu_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_xtts
)

:install_xtts_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing XTTS...

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named xtts
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%xtts%reset%
call conda create -n xtts python=3.10 -y

REM Activate the xtts environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%xtts%reset%
call conda activate xtts

REM Use the GPU choice made earlier to install requirements for XTTS
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch==2.1.1+cu118 torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
    goto :install_xtts_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
    goto :install_xtts_final
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing CPU-only version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch torchvision torchaudio
    goto :install_xtts_final
)


:install_xtts_final
REM Clone the xtts-api-server repository for voice examples
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning xtts-api-server repository...
git clone https://github.com/daswer123/xtts-api-server.git
cd /d "%~dp0xtts-api-server"

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements in conda enviroment: %cyan_fg_strong%xtts%reset%
pip install -r requirements.txt
pip install xtts-api-server
pip install pydub
pip install stream2sentence

REM Create folders for xtts
cd /d "%~dp0"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating xtts folders...
mkdir "%~dp0xtts"
mkdir "%~dp0xtts\speakers"
mkdir "%~dp0xtts\output"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding voice examples to speakers directory...
xcopy "%~dp0xtts-api-server\example\*" "%~dp0xtts\speakers\" /y /e

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts-api-server directory...
rmdir /s /q "%~dp0xtts-api-server"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS installed successfully%reset%
pause
goto :installer


REM Support menu - Frontend
:support
title STL [SUPPORT]
cls
echo %blue_fg_strong%/ Installer / Support%reset%
echo ---------------------------------------------------------------
echo What would you like to do?
echo 1. I want to report a issue
echo 2. Documentation
echo 3. Discord
echo 0. Back to Installer

set /p support_choice=Choose Your Destiny: 

REM Support menu - Backend
if "%support_choice%"=="1" (
    call :issue_report
) else if "%support_choice%"=="2" (
    call :documentation
) else if "%support_choice%"=="3" (
    call :discord
) else if "%support_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
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
