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

REM Environment Variables (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM Environment Variables (TOOLBOX Install Extras)
set "miniconda_path=%userprofile%\miniconda3"

REM Define the paths and filenames for the shortcut creation
set "shortcutTarget=%~dp0st-launcher.bat"
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
    bitsadmin /transfer "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" /download /priority FOREGROUND "https://github.com/microsoft/winget-cli/releases/download/v1.6.2771/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" "%temp%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
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
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern + Extras...
echo .
echo %cyan_fg_strong%This may take a while. Please be patient.%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern...

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern repository...
git clone https://github.com/SillyTavern/SillyTavern.git
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%SillyTavern installed successfully.%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Extras...

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Miniconda...
winget install -e --id Anaconda.Miniconda3

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"

if %errorlevel% neq 0 (
  echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Download failed. Please restart the installer%reset%
  pause
  goto :installer
) else (
  start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
)


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named sillytavernextras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment sillytavernextras...
call conda create -n sillytavernextras -y

REM Activate the sillytavernextras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment sillytavernextras...
call conda activate sillytavernextras

REM Install Python 3.11 and Git in the sillytavernextras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Python and Git in the Conda environment...
call conda install python=3.11 git -y

REM Clone the SillyTavern Extras repository
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern-extras repository...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Navigate to the SillyTavern-extras directory
cd SillyTavern-extras

REM Install Python dependencies from requirements files
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements-complete...
pip install -r requirements-complete.txt

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements-rvc...
pip install -r requirements-rvc.txt


echo %cyan_fg_strong%Yes, If you are seeing errors about Numpy and Librosa then that is completely normal. If facebook updates their fairseq library to python 3.11 then this error will not appear anymore.%reset%
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
        "$Shortcut.WorkingDirectory = '%startIn%'; " ^
        "$Shortcut.Description = '%comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Shortcut created on the desktop.%reset%
    pause
)
endlocal
goto :installer


:install_sillytavern
title SillyTavern [INSTALL ST]
cls
echo %blue_fg_strong%/ Installer / SillyTavern%reset%
echo ---------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SillyTavern...
echo .
echo %cyan_fg_strong%This may take a while. Please be patient.%reset%

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
    pause
)
endlocal
goto :installer


:install_extras
title SillyTavern [INSTALL EXTRAS]
cls
echo %blue_fg_strong%/ Installer / Extras%reset%
echo ---------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Extras...
echo .
echo %cyan_fg_strong%This may take a while. Please be patient.%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Miniconda...
winget install -e --id Anaconda.Miniconda3

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"

if %errorlevel% neq 0 (
  echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Download failed. Please restart the installer%reset%
  pause
  goto :installer
) else (
  start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named sillytavernextras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment sillytavernextras...
call conda create -n sillytavernextras -y

REM Activate the sillytavernextras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment sillytavernextras...
call conda activate sillytavernextras

REM Install Python 3.11 and Git in the sillytavernextras environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Python and Git in the Conda environment...
call conda install python=3.11 git -y

REM Clone the SillyTavern Extras repository
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SillyTavern-extras repository...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Navigate to the SillyTavern-extras directory
cd SillyTavern-extras

REM Install Python dependencies from requirements files
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements-complete...
pip install -r requirements-complete.txt

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements-rvc...
pip install -r requirements-rvc.txt


echo %cyan_fg_strong%Yes, If you are seeing errors about Numpy and Librosa then that is completely normal. If facebook updates their fairseq library to python 3.11 then this error will not appear anymore.%reset%
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
    pause
)
endlocal
goto :installer
