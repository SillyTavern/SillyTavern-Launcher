@echo off
chcp 437 > nul
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

REM Define variables for the core directories
set "bin_dir=%~dp0bin"
set "log_dir=%bin_dir%\logs"

REM Environment Variables (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM Environment Variables (miniconda3)
set "miniconda_path=%userprofile%\miniconda3"
set "miniconda_path_mingw=%userprofile%\miniconda3\Library\mingw-w64\bin"
set "miniconda_path_usrbin=%userprofile%\miniconda3\Library\usr\bin"
set "miniconda_path_bin=%userprofile%\miniconda3\Library\bin"
set "miniconda_path_scripts=%userprofile%\miniconda3\Scripts"

REM Define the paths and filenames for the shortcut creation (launcher.bat)
set "stl_shortcutTarget=%~dp0launcher.bat"
set "stl_iconFile=%~dp0st-launcher.ico"
set "stl_desktopPath=%userprofile%\Desktop"
set "stl_shortcutName=ST-Launcher.lnk"
set "stl_startIn=%~dp0"
set "stl_comment=SillyTavern Launcher"

REM Define the paths and filenames for the shortcut creation (start.bat)
set "st_shortcutTarget=%~dp0SillyTavern\start.bat"
set "st_iconFile=%~dp0st.ico"
set "st_desktopPath=%userprofile%\Desktop"
set "st_shortcutName=SillyTavern.lnk"
set "st_startIn=%~dp0"
set "st_comment=SillyTavern"

REM Check if the script is being run from a cloud storage folder (OneDrive, Google Drive, or Dropbox)
echo "%CD%" | findstr /I "OneDrive" > nul
if %errorlevel% equ 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Installation in OneDrive folders is not supported!%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] Installing the SillyTavern Launcher and SillyTavern in OneDrive can cause issues with dependency installs.
    echo Not to mention it's bad for privacy and speed because of cloud syncing.%reset%
    echo Please move the installer to a different directory and try again.
    pause
    exit /b 1
)

echo "%CD%" | findstr /I "Google Drive" > nul
if %errorlevel% equ 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Installation in Google Drive folders is not supported!%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] Installing the SillyTavern Launcher and SillyTavern in Google Drive can cause issues with dependency installs.
    echo Not to mention it's bad for privacy and speed because of cloud syncing.%reset%
    echo Please move the installer to a different directory and try again.
    pause
    exit /b 1
)

echo "%CD%" | findstr /I "Dropbox" > nul
if %errorlevel% equ 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Installation in Dropbox folders is not supported!%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] Installing the SillyTavern Launcher and SillyTavern in Dropbox can cause issues with dependency installs.
    echo Not to mention it's bad for privacy and speed because of cloud syncing..%reset%
    echo Please move the installer to a different directory and try again.
    pause
    exit /b 1
)



REM Create the logs folder if it doesn't exist
if not exist "%log_dir%" (
    mkdir "%log_dir%"
)

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


REM Check if Winget is installed; if not, then prompt the user to install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Winget is not installed on this system.%reset%
    set /p install_winget_choice="Install Winget? [Y/n]: "
    if /i "%install_winget_choice%"=="" set install_winget_choice=Y
    if /i "%install_winget_choice%"=="Y" (

        REM Ensure the bin directory exists
        if not exist "%bin_dir%" (
            mkdir "%bin_dir%"
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "bin"
        )

        REM Download the Winget installer into the bin directory
        powershell -Command "Invoke-RestMethod -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile '%bin_dir%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'"

        REM Install Winget
        start /wait "%bin_dir%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

        REM Clean up the installer
        del "%bin_dir%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

        REM Get the current PATH value from the registry
        for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

        REM Check if the winget path is already in the current PATH
        echo %current_path% | find /i "%winget_path%" > nul
        if %errorlevel% neq 0 (
            set "new_path=%current_path%;%winget_path%"
            echo.
            echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
            echo.
            echo [DEBUG] "winget_path is:%cyan_fg_strong% %winget_path%%reset%"
            echo.
            echo [DEBUG] "new_path is:%cyan_fg_strong% %new_path%%reset%"

            REM Update the PATH value in the registry
            reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%new_path%" /f

            REM Update the PATH value for the current session
            setx PATH "%new_path%" > nul
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Winget added to PATH.%reset%
        ) else (
            echo [ %green_fg_strong%OK%reset% ] Found PATH: winget%reset%
        )

        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Winget installed successfully. Please restart the Installer.%reset%
        pause
        exit
    ) else (
        echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Winget installation skipped by user.%reset%
    )
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app command: %cyan_fg_strong%winget%reset% from app: App Installer
)

REM Check if Git is installed; if not, then install Git with fallback of powershell
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Git is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Git using winget...
    winget install -e --id Git.Git

    if %errorlevel% neq 0 (
        echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget failed to install Git or is not installed.%reset%

        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Git using powershell...
        powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe', '%bin_dir%\git.exe')"

        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing git...
        start /wait %bin_dir%\git.exe /VERYSILENT /NORESTART
        
        del %bin_dir%\git.exe
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Git installed successfully.%reset%
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Git installed successfully.%reset%
    )
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app command: %cyan_fg_strong%git%reset% from app: Git
)


REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Node.js is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Node.js using winget...
    
    winget install -e --id OpenJS.NodeJS.LTS
    
REM    if %errorlevel% neq 0 (
REM        echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget failed to install Node.js or is not installed.%reset%

REM        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Node.js using PowerShell...
REM        powershell -Command "$webClient = New-Object System.Net.WebClient; $latestPage = $webClient.DownloadString('https://nodejs.org/dist/latest/'); $msiFile = ($latestPage -split '`n' | Select-String -Pattern 'node-v.+?-x64\.msi' -AllMatches | ForEach-Object { $_.Matches } | Select-Object -First 1).Value; $webClient.DownloadFile(('https://nodejs.org/dist/latest/' + $msiFile), '%bin_dir%\nodejs.msi')"

REM        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Node.js...
REM        start /wait msiexec /i "%bin_dir%\nodejs.msi" /passive
        
REM        del "%bin_dir%\nodejs.msi"
REM        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Node.js installed successfully.%reset%
REM        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Please restart installer.bat in order to activate node command%reset%
REM        pause
REM        exit
REM    ) else (
REM        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Node.js installed successfully.%reset%
REM    )
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app command: %cyan_fg_strong%node%reset% from app: Node.js
)



REM Check if Miniconda3 is installed; if not, then install Miniconda3 with fallback of PowerShell
call conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Miniconda3 is not installed on this system.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Miniconda3 using PowerShell...

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading Miniconda3...
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe', '%bin_dir%\Miniconda3-latest-Windows-x86_64.exe')"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Miniconda3...
    start /wait %bin_dir%\Miniconda3-latest-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /AddToPath=1 /S


    del %bin_dir%\Miniconda3-latest-Windows-x86_64.exe
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Miniconda3 installed successfully.%reset%

) else (
    echo [ %green_fg_strong%OK%reset% ] Found app command: %cyan_fg_strong%conda%reset% from app: Miniconda3
)

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are in the current PATH
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
    echo [ %green_fg_strong%OK%reset% ] Found PATH: miniconda3%reset%
)

REM Check if Python App Execution Aliases exist
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" (
    REM Disable App Execution Aliases for python.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" -Force
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Removed Execution Alias for python.exe%reset%
) else (
    echo [ %green_fg_strong%OK%reset% ] Nothing to remove for Execution Alias of python.exe %reset%
)

REM Check if python3.exe App Execution Alias exists
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" (
    REM Disable App Execution Aliases for python3.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" -Force
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Removed Execution Alias for python3.exe%reset%
) else (
    echo [ %green_fg_strong%OK%reset% ] Nothing to remove for Execution Alias of python3.exe %reset%
)

REM Installer menu - Frontend
:installer
title STL [INSTALLER]
cls
echo %blue_fg_strong%/ Installer%reset%
echo ---------------------------------------------------------------
echo What would you like to do?
echo 1. Install SillyTavern
REM echo 2. Install Extras
REM echo 3. Install XTTS
REM echo 4. Install All Options From Above
echo 5. Support
echo 0. Exit

set "choice="
set /p "choice=Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM Installer menu - Backend
if "%choice%"=="1" (
    call :install_sillytavern
REM ) else if "%choice%"=="2" (
REM     call :install_extras
REM ) else if "%choice%"=="3" (
REM     call :install_xtts
REM ) else if "%choice%"=="4" (
REM     call :install_all
) else if "%choice%"=="5" (
    call :support
) else if "%choice%"=="0" (
    exit
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :installer
)

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
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating shortcut for ST-Launcher...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%stl_desktopPath%\%stl_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%stl_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%stl_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%stl_startIn%'; " ^
        "$Shortcut.Description = '%stl_comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Shortcut created on the desktop.%reset%

    REM Create the shortcut (start.bat)
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating shortcut for SillyTavern...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%st_desktopPath%\%st_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%st_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%st_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%st_startIn%'; " ^
        "$Shortcut.Description = '%st_comment%'; " ^
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
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ INSTALL SUMMARY ══════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ Extras has been DISCONTINUED since April 2024 and WON'T receive any new updates or modules.   ║%reset%
echo %red_bg%║ The vast majority of modules are available natively in the main SillyTavern application.      ║%reset%
echo %red_bg%║ You may still install and use it but DON'T expect to get support if you face any issues.      ║%reset%
echo %red_bg%║ Below is a list of package requirements that will get installed:                              ║%reset%
echo %red_bg%║ * SillyTavern-extras [Size: 65 MB]                                                            ║%reset%
echo %red_bg%║ * Visual Studio BuildTools 2022 [Size: 3,10 GB]                                               ║%reset%
echo %red_bg%║ * Miniconda3 [INSTALLED] [Size: 630 MB]                                                       ║%reset%
echo %red_bg%║ * Miniconda3 env - extras [Size: 9,98 GB]                                                     ║%reset%
echo %red_bg%║ * Git [INSTALLED] [Size: 338 MB]                                                              ║%reset%
echo %red_bg%║ * Microsoft Visual C++ 2015-2022 Redistributable (x64) [Size: 20,6 MB]                        ║%reset%
echo %red_bg%║ * Microsoft Visual C++ 2015-2022 Redistributable (x86) [Size: 18 MB]                          ║%reset%
echo %red_bg%║ TOTAL INSTALL SIZE: 13,67 GB                                                                  ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (
    goto :install_extras_y
) else (
    goto :installer
)


:install_extras_y
REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only mode)
echo 0. Cancel install

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
    goto :install_extras_y
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
call conda create -n extras python=3.11 -y

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

REM Install Microsoft.VCRedist.2015+.x64 using winget with fallback of powershell
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget is not installed or failed to install Microsoft.VCRedist.2015+.x64%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Attempting to install Microsoft.VCRedist.2015+.x64 using powershell...

    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/c7707d68-d6ce-4479-973e-e2a3dc4341fe/1AD7988C17663CC742B01BEF1A6DF2ED1741173009579AD50A94434E54F56073/VC_redist.x64.exe', '%bin_dir%\VC_redist.x64.exe')"
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to download VC_redist.x64.exe.%reset%
    )

    start /wait %bin_dir%\VC_redist.x64.exe /install /quiet /norestart
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to install VC_redist.x64.exe.%reset%
    )
    del %bin_dir%\VC_redist.x64.exe
)

REM Install Microsoft.VCRedist.2015+.x86 using winget fallback of powershell
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget is not installed or failed to install Microsoft.VCRedist.2015+.x86%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Attempting to install Microsoft.VCRedist.2015+.x86 using powershell...

    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/71c6392f-8df5-4b61-8d50-dba6a525fb9d/510FC8C2112E2BC544FB29A72191EABCC68D3A5A7468D35D7694493BC8593A79/VC_redist.x86.exe', '%bin_dir%\VC_redist.x86.exe')"
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to download VC_redist.x86.exe.%reset%
    )

    start /wait %bin_dir%\VC_redist.x86.exe /install /quiet /norestart
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to install VC_redist.x86.exe.%reset%
    )
    del %bin_dir%\VC_redist.x86.exe
)


REM Check if file exists
if exist "%bin_dir%\vs_buildtools.exe" (
    REM Remove file if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing file...
    del "%bin_dir%\vs_buildtools.exe"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/vs_BuildTools.exe', '%bin_dir%\vs_buildtools.exe')"
start "" "%bin_dir%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extras installed successfully.%reset%

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
echo 3. None CPU-only mode
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
REM Check if the folder exists
if not exist "%voice_generation_dir%" (
    mkdir "%voice_generation_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "voice-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "voice-generation" folder already exists.%reset%
)
cd /d "%voice_generation_dir%"

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
    pip install torch==2.1.1+cu118 torchvision==0.16.1+cu118  torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
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
cd /d "xtts-api-server"

REM Create requirements-custom.txt to install pip requirements
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Creating file: requirements-custom.txt%reset%
echo xtts-api-server > requirements-custom.txt
echo pydub >> requirements-custom.txt
echo stream2sentence >> requirements-custom.txt
echo spacy==3.7.4 >> requirements-custom.txt

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements in conda enviroment: %cyan_fg_strong%xtts%reset%
pip install -r requirements-custom.txt

REM Create folders for xtts
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating xtts folders...
mkdir "%xtts_install_path%"
mkdir "%xtts_install_path%\speakers"
mkdir "%xtts_install_path%\output"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding voice examples to speakers directory...
xcopy "%voice_generation_dir%\xtts-api-server\example\*" "%xtts_install_path%\speakers\" /y /e

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts-api-server directory...
rmdir /s /q "%voice_generation_dir%\xtts-api-server"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS installed successfully%reset%
pause
goto :installer


:install_all
title STL [INSTALL EVERYTHING]
cls
echo %blue_fg_strong%/ Installer / Install Everything%reset%
echo ---------------------------------------------------------------
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %blue_bg%╔════ INSTALL SUMMARY ══════════════════════════════════════════════════════════════════════════╗%reset%
echo %blue_bg%║ You are about to install all options from the installer.                                      ║%reset%
echo %blue_bg%║ This will include the following options: SillyTavern, SillyTavern-Extras and XTTS             ║%reset%
echo %blue_bg%║ Below is a list of package requirements that will get installed:                              ║%reset%
echo %blue_bg%║ * SillyTavern [Size: 478 MB]                                                                  ║%reset%
echo %blue_bg%║ * SillyTavern-extras [Size: 65 MB]                                                            ║%reset%
echo %blue_bg%║ * xtts [Size: 1.74 GB]                                                                        ║%reset%
echo %blue_bg%║ * Visual Studio BuildTools 2022 [Size: 3.10 GB]                                               ║%reset%
echo %blue_bg%║ * Miniconda3 [INSTALLED] [Size: 630 MB]                                                       ║%reset%
echo %blue_bg%║ * Miniconda3 env - xtts [Size: 6.98 GB]                                                       ║%reset%
echo %blue_bg%║ * Miniconda3 env - extras [Size: 9.98 GB]                                                     ║%reset%
echo %blue_bg%║ * Git [INSTALLED] [Size: 338 MB]                                                              ║%reset%
echo %blue_bg%║ * Node.js [Size: 87.5 MB]                                                                     ║%reset%
echo %blue_bg%║ * Microsoft Visual C++ 2015-2022 Redistributable (x64) [Size: 20.6 MB]                        ║%reset%
echo %blue_bg%║ * Microsoft Visual C++ 2015-2022 Redistributable (x86) [Size: 18 MB]                          ║%reset%
echo %blue_bg%║ TOTAL INSTALL SIZE: 22.56 GB                                                                  ║%reset%
echo %blue_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (
    goto :install_all_y
) else (
    goto :installer
)


:install_all_y
REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only mode)
echo 0. Cancel install

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
    REM Check if the folder exists
    if not exist "%~dp0voice-generation" (
        mkdir "%~dp0voice-generation"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "voice-generation"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "voice-generation" folder already exists.%reset%
    )
    cd /d "%~dp0voice-generation"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing XTTS...

    REM Activate the Miniconda installation
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
    call "%miniconda_path%\Scripts\activate.bat"

    REM Create a Conda environment named xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%xtts%reset%
    call conda create -n xtts python=3.10 -y

    REM Activate the conda environment named xtts 
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%xtts%reset%
    call conda activate xtts

    REM Use the GPU choice made earlier to install requirements for XTTS
    if "%GPU_CHOICE%"=="1" (
        echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
        pip install torch==2.1.1+cu118 torchvision==0.16.1+cu118  torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
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
    cd /d "xtts-api-server"

    REM Create requirements-custom.txt to install pip requirements
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Creating file: requirements-custom.txt%reset%
    echo xtts-api-server > requirements-custom.txt
    echo pydub >> requirements-custom.txt
    echo stream2sentence >> requirements-custom.txt
    echo spacy==3.7.4 >> requirements-custom.txt

    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install -r requirements-custom.txt

    REM Create folders for xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating xtts folders...
    mkdir "%~dp0voice-generation\xtts"
    mkdir "%~dp0voice-generation\xtts\speakers"
    mkdir "%~dp0voice-generation\xtts\output"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding voice examples to speakers directory...
    xcopy "%~dp0voice-generation\xtts-api-server\example\*" "%~dp0voice-generation\xtts\speakers\" /y /e

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the xtts-api-server directory...
    cd /d "%~dp0"
    rmdir /s /q "%~dp0voice-generation\xtts-api-server"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%XTTS installed successfully%reset%
REM End of install script for XTTS


REM Create a Conda environment named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%extras%reset%
call conda create -n extras python=3.11 -y

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

REM Install Microsoft.VCRedist.2015+.x64 using winget
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget is not installed or failed to install Microsoft.VCRedist.2015+.x64%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Attempting to install Microsoft.VCRedist.2015+.x64 using powershell...

    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/c7707d68-d6ce-4479-973e-e2a3dc4341fe/1AD7988C17663CC742B01BEF1A6DF2ED1741173009579AD50A94434E54F56073/VC_redist.x64.exe', '%bin_dir%\VC_redist.x64.exe')"
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to download VC_redist.x64.exe.%reset%
    )

    start /wait %bin_dir%\VC_redist.x64.exe /install /quiet /norestart
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to install VC_redist.x64.exe.%reset%
    )
    del %bin_dir%\VC_redist.x64.exe
)

REM Install Microsoft.VCRedist.2015+.x86 using winget
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] winget is not installed or failed to install Microsoft.VCRedist.2015+.x86%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Attempting to install Microsoft.VCRedist.2015+.x86 using powershell...

    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/71c6392f-8df5-4b61-8d50-dba6a525fb9d/510FC8C2112E2BC544FB29A72191EABCC68D3A5A7468D35D7694493BC8593A79/VC_redist.x86.exe', '%bin_dir%\VC_redist.x86.exe')"
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to download VC_redist.x86.exe.%reset%
    )

    start /wait %bin_dir%\VC_redist.x86.exe /install /quiet /norestart
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR]%reset% Failed to install VC_redist.x86.exe.%reset%
    )
    del %bin_dir%\VC_redist.x86.exe
)

REM Check if file exists
if exist "%bin_dir%\vs_buildtools.exe" (
    REM Remove file if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing file...
    del "%bin_dir%\vs_buildtools.exe"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/vs_BuildTools.exe', '%bin_dir%\vs_buildtools.exe')"
start "" "%bin_dir%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Extras installed successfully.%reset%


REM Ask if the user wants to create a shortcut
set /p create_shortcut=Do you want to create a shortcut on the desktop? [Y/n] 
if /i "%create_shortcut%"=="Y" (

    REM Create the shortcut (launcher.bat)
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating shortcut for ST-Launcher...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%stl_desktopPath%\%stl_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%stl_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%stl_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%stl_startIn%'; " ^
        "$Shortcut.Description = '%stl_comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Shortcut created on the desktop.%reset%

    REM Create the shortcut (start.bat)
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating shortcut for SillyTavern...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%st_desktopPath%\%st_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%st_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%st_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%st_startIn%'; " ^
        "$Shortcut.Description = '%st_comment%'; " ^
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

