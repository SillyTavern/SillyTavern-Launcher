@echo off
REM --------------------------------------------
REM This script was created by: Deffcolony
REM --------------------------------------------
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
set "miniconda_path=%userprofile%\miniconda"

REM Define the paths and filenames for the shortcut creation
set "shortcutTarget=SillyTavern\st-launcher.bat"
set "iconFile=SillyTavern\public\st-launcher.ico"
set "desktopPath=%userprofile%\Desktop"
set "shortcutName=ST Launcher.lnk"
set "startIn=SillyTavern"
set "comment=SillyTavern Launcher"


REM Check if Winget is installed; if not, then install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_fg_strong%[WARN] Winget is not installed on this system.
    echo %blue_fg_strong%[INFO]%reset% Installing Winget...
    bitsadmin /transfer "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" /download /priority FOREGROUND "https://github.com/microsoft/winget-cli/releases/download/v1.5.2201/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" "%temp%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    start "" "%temp%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    echo %green_fg_strong%Winget is now installed.%reset%
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
    echo %green_fg_strong%winget added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] winget already exists in PATH.%reset%
)


REM Check if Git is installed if not then install git
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_fg_strong%[WARN] Git is not installed on this system.%reset%
    echo %blue_fg_strong%[INFO]%reset% Installing Git using Winget...
    winget install -e --id Git.Git
    echo %green_fg_strong%Git is installed. Please restart the Launcher.%reset%
    pause
    exit
) else (
    echo %blue_fg_strong%[INFO] Git is already installed.%reset%
)

REM Check if Python App Execution Aliases exist
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" (
    REM Disable App Execution Aliases for python.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" -Force
    echo %green_fg_strong%Execution Alias for python.exe has been removed.%reset%
) else (
    echo %blue_fg_strong%[INFO] Execution Alias for python.exe is already removed.%reset%
)

REM Check if python3.exe App Execution Alias exists
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" (
    REM Disable App Execution Aliases for python3.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" -Force
    echo %green_fg_strong%Execution Alias for python3.exe has been removed.%reset%
) else (
    echo %blue_fg_strong%[INFO] Execution Alias for python3.exe is already removed.%reset%
)


REM Installer - Frontend
:installer
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
    call :installstextras
) else if "%choice%"=="2" (
    call :installsillytavern 
) else if "%choice%"=="3" (
    call :installextras
) else if "%choice%"=="4" (
    exit
) else (
    color 6
    echo WARNING: Invalid number. Please insert a valid number.
    pause
    goto :installer
)


:installstextras
cls
echo %blue_fg_strong%/ Installer / SillyTavern + Extras%reset%
echo ---------------------------------------------------------------
echo %blue_fg_strong%[INFO]%reset% Installing SillyTavern + Extras...
echo %cyan_fg_strong%This may take a while. Please be patient.%reset%

echo %blue_fg_strong%[INFO]%reset% Installing SillyTavern...

git clone https://github.com/SillyTavern/SillyTavern.git
echo %green_fg_strong%SillyTavern installed successfully.%reset%

echo %blue_fg_strong%[INFO]%reset% Installing Extras...

winget install -e --id Anaconda.Miniconda3

rem winget install -e --id Microsoft.VisualStudio.2022.BuildTools

echo %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
bitsadmin /transfer "vs_buildtools" /download /priority FOREGROUND "https://aka.ms/vs/17/release/vs_BuildTools.exe" "%temp%\vs_buildtools.exe"
start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
echo %green_fg_strong%vs_BuildTools is now installed. Please continue%reset%
pause
winget install -e --id Microsoft.VCRedist.2015+.x64
winget install -e --id Microsoft.VCRedist.2015+.x86

REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named sillytavernextras
call conda create -n sillytavernextras -y

REM Activate the sillytavernextras environment
call conda activate sillytavernextras

REM Install Python 3.11 and Git in the sillytavernextras environment
call conda install python=3.11 git -y

REM Clone the SillyTavern Extras repository
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Navigate to the SillyTavern-extras directory
cd SillyTavern-extras

REM Install Python dependencies from requirements files
pip install -r requirements-complete.txt
pip install -r requirements-rvc.txt
echo %cyan_fg_strong%Yes, If you are seeing errors about Numpy and Librosa then that is completely normal. If facebook updates their fairseq library to python 3.11 then this error will not appear anymore.%reset%
echo %green_fg_strong%SillyTavern + Extras has been successfully installed.%reset%

set /p create_shortcut=Do you want to create a shortcut on the desktop? [Y/n] 
setlocal enabledelayedexpansion
if "%create_shortcut%"=="" set "create_shortcut=Y"
if /i "%create_shortcut%"=="Y" (

    REM Create the PowerShell command to create the shortcut
    powershell.exe -Command "New-Object -ComObject WScript.Shell | ForEach-Object { $shortcut = $_.CreateShortcut('!desktopPath!\!shortcutName!'); $shortcut.TargetPath = '!cd!\!shortcutTarget!'; $shortcut.IconLocation = '!cd!\!iconFile!'; $shortcut.WorkingDirectory = '!cd!\!startIn!'; $shortcut.Description = '!comment!'; $shortcut.Save() }"

    echo %green_fg_strong%Desktop shortcut created.%reset%
) else if /i "%create_shortcut%"=="N" (
    echo You chose not to create a desktop shortcut.
    REM Add code here for the installation without a shortcut.
) else (
    echo Invalid choice. Please enter Y or N.
)
endlocal
goto :installer


:installsillytavern
cls
echo %blue_fg_strong%/ Installer / SillyTavern%reset%
echo ---------------------------------------------------------------
echo %blue_fg_strong%[INFO]%reset% Installing SillyTavern...
echo --------------------------------
echo %cyan_fg_strong%This may take a while. Please be patient.%reset%

git clone https://github.com/SillyTavern/SillyTavern.git
echo %green_fg_strong%SillyTavern installed successfully.%reset%

set /p create_shortcut=Do you want to create a shortcut on the desktop? [Y/n] 
setlocal enabledelayedexpansion
if "%create_shortcut%"=="" set "create_shortcut=Y"
if /i "%create_shortcut%"=="Y" (

    REM Create the PowerShell command to create the shortcut
    powershell.exe -Command "New-Object -ComObject WScript.Shell | ForEach-Object { $shortcut = $_.CreateShortcut('!desktopPath!\!shortcutName!'); $shortcut.TargetPath = '!cd!\!shortcutTarget!'; $shortcut.IconLocation = '!cd!\!iconFile!'; $shortcut.WorkingDirectory = '!cd!\!startIn!'; $shortcut.Description = '!comment!'; $shortcut.Save() }"

    echo %green_fg_strong%Desktop shortcut created.%reset%
) else if /i "%create_shortcut%"=="N" (
    echo You chose not to create a desktop shortcut.
    REM Add code here for the installation without a shortcut.
) else (
    echo Invalid choice. Please enter Y or N.
)
endlocal
goto :installer


:installextras
cls
echo %blue_fg_strong%/ Installer / Extras%reset%
echo ---------------------------------------------------------------
echo %blue_fg_strong%[INFO]%reset% Installing Extras...
echo .
echo %cyan_fg_strong%This may take a while. Please be patient.%reset%

winget install -e --id Anaconda.Miniconda3

rem winget install -e --id Microsoft.VisualStudio.2022.BuildTools

echo %blue_fg_strong%[INFO]%reset% Installing vs_BuildTools...
bitsadmin /transfer "vs_buildtools" /download /priority FOREGROUND "https://aka.ms/vs/17/release/vs_BuildTools.exe" "%temp%\vs_buildtools.exe"
start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
echo %green_fg_strong%vs_BuildTools is now installed. Please continue%reset%
pause
winget install -e --id Microsoft.VCRedist.2015+.x64
winget install -e --id Microsoft.VCRedist.2015+.x86

REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named sillytavernextras
call conda create -n sillytavernextras -y

REM Activate the sillytavernextras environment
call conda activate sillytavernextras

REM Install Python 3.11 and Git in the sillytavernextras environment
call conda install python=3.11 git -y

REM Clone the SillyTavern Extras repository
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Navigate to the SillyTavern-extras directory
cd SillyTavern-extras

REM Install Python dependencies from requirements files
pip install -r requirements-complete.txt
pip install -r requirements-rvc.txt
echo %cyan_fg_strong%Yes, If you are seeing errors about Numpy and Librosa then that is completely normal. If facebook updates their fairseq library to python 3.11 then this error will not appear anymore.%reset%
echo %green_fg_strong%Extras has been successfully installed.%reset%

set /p create_shortcut=Do you want to create a shortcut on the desktop? [Y/n] 
setlocal enabledelayedexpansion
if "%create_shortcut%"=="" set "create_shortcut=Y"
if /i "%create_shortcut%"=="Y" (

    REM Create the PowerShell command to create the shortcut
    powershell.exe -Command "New-Object -ComObject WScript.Shell | ForEach-Object { $shortcut = $_.CreateShortcut('!desktopPath!\!shortcutName!'); $shortcut.TargetPath = '!cd!\!shortcutTarget!'; $shortcut.IconLocation = '!cd!\!iconFile!'; $shortcut.WorkingDirectory = '!cd!\!startIn!'; $shortcut.Description = '!comment!'; $shortcut.Save() }"

    echo %green_fg_strong%Desktop shortcut created.%reset%
) else if /i "%create_shortcut%"=="N" (
    echo You chose not to create a desktop shortcut.
    REM Add code here for the installation without a shortcut.
) else (
    echo Invalid choice. Please enter Y or N.
)
endlocal
goto :installer
