@echo off
REM --------------------------------------------
REM This script was created by: Deffcolony
REM --------------------------------------------
title SillyTavern Launcher
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

REM Environment Variables (TOOLBOX 7-Zip)
set "zip7version=7z2301-x64"
set "zip7_install_path=%ProgramFiles%\7-Zip"
set "zip7_download_path=%TEMP%\%zip7version%.exe"

REM Environment Variables (TOOLBOX FFmpeg)
set "ffmpeg_url=https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z"
set "ffdownload_path=%TEMP%\ffmpeg.7z"
set "ffextract_path=C:\ffmpeg"
set "bin_path=%ffextract_path%\bin"

REM Environment Variables (TOOLBOX Node.js)
set "node_installer_path=%temp%\NodejsInstaller.msi"

REM Environment Variables (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM Environment Variables (TOOLBOX Install Extras)
set "miniconda_path=%userprofile%\miniconda3"

REM Define variables to track module status
set "modules_path=%~dp0modules.txt"
set "coqui_trigger=false"
set "rvc_trigger=false"
set "talkinghead_trigger=false"
set "caption_trigger=false"
set "summarize_trigger=false"


REM Create modules.txt if it doesn't exist
if not exist modules.txt (
    type nul > modules.txt
)

REM Load module flags from modules.txt
for /f "tokens=*" %%a in (modules.txt) do set "%%a"


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


REM Home - frontend
:home
title SillyTavern [HOME]
cls
echo %blue_fg_strong%/ Home%reset%
echo -------------------------------------
echo What would you like to do?
echo 1. Start SillyTavern
echo 2. Start SillyTavern + Extras
echo 3. Update
echo 4. Backup
echo 5. Switch branch
echo 6. Toolbox
echo 7. Exit

REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo ======== VERSION STATUS =========
echo SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo Update Status: %update_status%
echo =================================

set "choice="
set /p "choice=Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM Home - backend
if "%choice%"=="1" (
    call :start
) else if "%choice%"=="2" (
    call :start_stextras
) else if "%choice%"=="3" (
    call :update
) else if "%choice%"=="4" (
    call :backup_menu
) else if "%choice%"=="5" (
    call :switchbrance_menu
) else if "%choice%"=="6" (
    call :toolbox
) else if "%choice%"=="7" (
    exit
) else (
    color 6
    echo WARNING: Invalid number. Please insert a valid number.
    pause
    goto :home
)


:start
REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_fg_strong%[ERROR] node command not found in PATH%reset%
    echo %red_bg%Please make sure Node.js is installed and added to your PATH.%reset%
    echo %blue_bg%To install Node.js go to Toolbox%reset%
    pause
    goto :home
)
echo %blue_fg_strong%[INFO]%reset% SillyTavern has been launched.
cd /d "%~dp0SillyTavern"
start cmd /k start.bat
goto :home


:start_stextras
REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_fg_strong%[ERROR] node command not found in PATH%reset%
    echo %red_bg%Please make sure Node.js is installed and added to your PATH.%reset%
    echo %blue_bg%To install Node.js go to Toolbox%reset%
    pause
    goto :home
)
echo %blue_fg_strong%[INFO]%reset% SillyTavern has been launched.
cd /d "%~dp0SillyTavern"
start cmd /k start.bat

REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sillytavernextras environment
call conda activate sillytavernextras


REM Start SillyTavern Extras with desired configurations
echo %blue_fg_strong%[INFO]%reset% Extras has been launched.
cd /d "%~dp0SillyTavern-extras"
start cmd /k python server.py --coqui-gpu --rvc-save-file --cuda-device=0 --max-content-length=1000 --enable-modules=talkinghead,chromadb,caption,summarize,rvc,coqui-tts
goto :home


:update
title SillyTavern [UPDATE]
echo %blue_fg_strong%[INFO]%reset% Updating SillyTavern...
cd /d "%~dp0SillyTavern"
REM Check if git is installed
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_fg_strong%[ERROR] git command not found in PATH. Skipping update.%reset%
    echo %red_bg%Please make sure Git is installed and added to your PATH.%reset%
    echo %blue_bg%To install Git go to Toolbox%reset%
) else (
    call git pull --rebase --autostash
    if %errorlevel% neq 0 (
        REM incase there is still something wrong
        echo There were errors while updating. Please download the latest version manually.
    )
)

REM Check if SillyTavern-extras directory exists
if not exist "%~dp0SillyTavern-extras" (
    echo %red_fg_strong%[ERROR] SillyTavern-extras directory not found. Skipping extras update.%reset%
    pause
    goto :home
)

cd /d "%~dp0SillyTavern-extras"
echo %blue_fg_strong%[INFO]%reset% Updating SillyTavern-extras...

REM Check if git is installed
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_fg_strong%[ERROR] git command not found in PATH. Skipping update.%reset%
    echo %red_bg%Please make sure Git is installed and added to your PATH.%reset%
    echo %blue_bg%To install Git go to Toolbox%reset%
) else (
    call git pull --rebase --autostash
    if %errorlevel% neq 0 (
        REM in case there are errors while updating
        echo There were errors while updating. Please download the latest version manually.
    )
)
pause
goto :home

REM Switch Brance - frontend
:switchbrance_menu
title SillyTavern [SWITCH-BRANCE]
cls
echo %blue_fg_strong%/ Home / Switch Branch%reset%
echo -------------------------------------
echo What would you like to do?
echo 1. Switch to Release - SillyTavern
echo 2. Switch to Staging - SillyTavern
echo 3. Back to Home

REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo ======== VERSION STATUS =========
echo SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo =================================
set /p brance_choice=Choose Your Destiny: 

REM Switch Brance - backend
if "%brance_choice%"=="1" (
    call :switch_release_st
) else if "%brance_choice%"=="2" (
    call :switch_staging_st
) else if "%brance_choice%"=="3" (
    goto :home
) else (
    color 6
    echo WARNING: Invalid number. Please insert a valid number.
    pause
    goto :switchbrance_menu
)


:switch_release_st
echo %blue_fg_strong%[INFO]%reset% Switching to release branch...
cd /d "%~dp0SillyTavern"
git switch release
pause
goto :switchbrance_menu


:switch_staging_st
echo %blue_fg_strong%[INFO]%reset% Switching to staging branch...
cd /d "%~dp0SillyTavern"
git switch staging
pause
goto :switchbrance_menu



REM Backup - Frontend
:backup_menu
title SillyTavern [BACKUP]
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_fg_strong%[ERROR] 7z command not found in PATH%reset%
    echo %red_bg%Please make sure 7-Zip is installed and added to your PATH.%reset%
    echo %blue_bg%To install 7-Zip go to Toolbox%reset%
    pause
    goto :home
)
cls
echo %blue_fg_strong%/ Home / Backup%reset%
echo -------------------------------------
echo What would you like to do?
REM color 7
echo 1. Create Backup
echo 2. Restore Backup
echo 3. Back to Home

set /p backup_choice=Choose Your Destiny: 

REM Backup - Backend
if "%backup_choice%"=="1" (
    call :create_backup
) else if "%backup_choice%"=="2" (
    call :restore_backup
) else if "%backup_choice%"=="3" (
    goto :home
) else (
    color 6
    echo WARNING: Invalid number. Please insert a valid number.
    pause
    goto :backup_menu
)

:create_backup
title SillyTavern [CREATE-BACKUP]
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
    "public\settings.json" ^
    "secrets.json"

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
goto :backup_menu


:restore_backup
title SillyTavern [RESTORE-BACKUP]

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
set /p "restore_choice=Enter number of backup to restore: "

if "%restore_choice%" geq "1" (
    if "%restore_choice%" leq "%backup_count%" (
        set "selected_backup=!backup_files[%restore_choice%]!"
        echo Restoring backup !selected_backup!...
        REM Extract the contents of the "public" folder directly into the existing "public" folder
        7z x "%~dp0SillyTavern-backups\!selected_backup!.7z" -o"temp" -aoa
        xcopy /y /e "temp\public\*" "public\"
        rmdir /s /q "temp"
        echo %green_fg_strong%!selected_backup! restored successfully.%reset%
    ) else (
        color 6
        echo WARNING: Invalid backup number. Please insert a valid number.
    )
) else (
    color 6
    echo WARNING: Invalid number. Please insert a valid number.
)
pause
goto :backup_menu


REM Toolbox - Frontend
:toolbox
title SillyTavern [TOOLBOX]
cls
echo %blue_fg_strong%/ Home / Toolbox%reset%
echo -------------------------------------
echo What would you like to do?
REM color 7
echo 1. Install 7-Zip
echo 2. Install FFmpeg
echo 3. Install Node.js
echo 4. Edit Environment
echo 5. Edit Extras Modules
echo 6. Reinstall SillyTavern
echo 7. Reinstall Extras
echo 8. Back to Home

set /p toolbox_choice=Choose Your Destiny: 

REM Toolbox - Backend
if "%toolbox_choice%"=="1" (
    call :install7zip
) else if "%toolbox_choice%"=="2" (
    call :installffmpeg
) else if "%toolbox_choice%"=="3" (
    call :installnodejs
) else if "%toolbox_choice%"=="4" (
    call :editenvironment
) else if "%toolbox_choice%"=="5" (
    call :editextrasmodules
) else if "%toolbox_choice%"=="6" (
    call :reinstallsillytavern
) else if "%toolbox_choice%"=="7" (
    call :reinstallextras
) else if "%toolbox_choice%"=="8" (
    goto :home
) else (
    color 6
    echo WARNING: Invalid number. Please insert a valid number.
    pause
    goto :toolbox
)


:install7zip
title SillyTavern [INSTALL-7Z]
echo %blue_fg_strong%[INFO]%reset% Installing 7-Zip...
winget install -e --id 7zip.7zip

rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Check if the paths are already in the current PATH
echo %current_path% | find /i "%zip7_install_path%" > nul
set "zip7_path_exists=%errorlevel%"

rem Append the new paths to the current PATH only if they don't exist
if %zip7_path_exists% neq 0 (
    set "new_path=%current_path%;%zip7_install_path%"
    echo %green_fg_strong%7-Zip added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] 7-Zip already exists in PATH.%reset%
)

rem Update the PATH value in the registry
reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%new_path%" /f

rem Update the PATH value for the current session
setx PATH "%new_path%"

echo %green_fg_strong%7-Zip is installed. Please restart the Launcher.%reset%
pause
exit


:installffmpeg
title SillyTavern [INSTALL-FFMPEG]
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_fg_strong%[ERROR] 7z command not found in PATH%reset%
    echo %red_bg%Please make sure 7-Zip is installed and added to your PATH.%reset%
    echo %blue_bg%To install 7-Zip go to Toolbox%reset%
    pause
    goto :toolbox
)

echo %blue_fg_strong%[INFO]%reset% Downloading FFmpeg archive...
rem bitsadmin /transfer "ffmpeg" /download /priority FOREGROUND "%ffmpeg_url%" "%ffdownload_path%"
curl -o "%ffdownload_path%" "%ffmpeg_url%"

echo %blue_fg_strong%[INFO]%reset% Creating ffmpeg directory if it doesn't exist...
if not exist "%ffextract_path%" (
    mkdir "%ffextract_path%"
)

echo %blue_fg_strong%[INFO]%reset% Extracting FFmpeg archive...
7z x "%ffdownload_path%" -o"%ffextract_path%"


echo %blue_fg_strong%[INFO]%reset% Moving FFmpeg contents to C:\ffmpeg...
for /d %%i in ("%ffextract_path%\ffmpeg-*-full_build") do (
    xcopy "%%i\bin" "%ffextract_path%\bin" /E /I /Y
    xcopy "%%i\doc" "%ffextract_path%\doc" /E /I /Y
    xcopy "%%i\presets" "%ffextract_path%\presets" /E /I /Y
    rd "%%i" /S /Q
)

rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Check if the paths are already in the current PATH
echo %current_path% | find /i "%bin_path%" > nul
set "ff_path_exists=%errorlevel%"

rem Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%bin_path%"
    echo %green_fg_strong%ffmpeg added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] ffmpeg already exists in PATH.%reset%
)

rem Update the PATH value in the registry
reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "%new_path%" /f

rem Update the PATH value for the current session
setx PATH "%new_path%" > nul

del "%ffdownload_path%"
echo %green_fg_strong%FFmpeg is installed. Please restart the Launcher.%reset%
pause
exit


:installnodejs
title SillyTavern [INSTALL-NODEJS]
echo %blue_fg_strong%[INFO]%reset% Installing Node.js...
winget install -e --id OpenJS.NodeJS
echo %green_fg_strong%Node.js is installed. Please restart the Launcher.%reset%
pause
exit

:editenvironment
rundll32.exe sysdm.cpl,EditEnvironmentVariables
goto :toolbox

:reinstallsillytavern
title SillyTavern [REINSTALL-ST]
setlocal enabledelayedexpansion
chcp 65001 > nul
REM Define the names of items to be excluded
set "script_name=%~nx0"
set "excluded_folders=backups"
set "excluded_files=!script_name!"

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data in the current branch except the Backups.                  ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
echo Are you sure you want to proceed? [Y/N] 
set /p "confirmation="
if /i "!confirmation!"=="Y" (
    cd /d "%~dp0SillyTavern"
    REM Remove non-excluded folders
    for /d %%D in (*) do (
        set "exclude_folder="
        for %%E in (!excluded_folders!) do (
            if "%%D"=="%%E" set "exclude_folder=true"
        )
        if not defined exclude_folder (
            rmdir /s /q "%%D" 2>nul
        )
    )

    REM Remove non-excluded files
    for %%F in (*) do (
        set "exclude_file="
        for %%E in (!excluded_files!) do (
            if "%%F"=="%%E" set "exclude_file=true"
        )
        if not defined exclude_file (
            del /f /q "%%F" 2>nul
        )
    )

    REM Clone repo into %temp% folder
    git clone https://github.com/SillyTavern/SillyTavern.git "%temp%\SillyTavern-TEMP"

    REM Move the contents of the temporary folder to the current directory
    xcopy /e /y "%temp%\SillyTavern-TEMP\*" .

    REM Clean up the temporary folder
    rmdir /s /q "%temp%\SillyTavern-TEMP"

    echo %green_fg_strong%SillyTavern reinstalled successfully!%reset%
) else (
    echo Reinstall canceled.
)
endlocal
pause
goto :toolbox


REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b

:editextrasmodules
title SillyTavern [EDIT-MODULES]
REM editextrasmodules - Frontend
cls
echo %blue_fg_strong%/ Home / Toolbox / Edit Extras Modules%reset%
echo -------------------------------------
echo Choose extras modules to enable or disable (e.g., "1 2 4" to enable Coqui, RVC, and Caption)
REM color 7

REM Display module options with colors based on their status
call :printModule "1. Coqui (--enable-modules=coqui-tts --coqui-gpu --cuda-device=0)" %coqui_trigger%
call :printModule "2. RVC (--enable-modules=rvc --rvc-save-file --max-content-length=1000)" %rvc_trigger%
call :printModule "3. talkinghead (--enable-modules=talkinghead)" %talkinghead_trigger%
call :printModule "4. caption (--enable-modules=caption)" %caption_trigger%
call :printModule "5. summarize (--enable-modules=summarize)" %summarize_trigger%
echo 6. Back to Toolbox

set "python_command="

set /p module_choices=Choose modules to enable/disable (1-5): 

REM Handle the user's module choices and construct the Python command
for %%i in (%module_choices%) do (
    if "%%i"=="1" (
        if "%coqui_trigger%"=="true" (
            set "coqui_trigger=false"
        ) else (
            set "coqui_trigger=true"
        )
        set "python_command= --enable-modules=coqui-tts --coqui-gpu --cuda-device=0"
    ) else if "%%i"=="2" (
        if "%rvc_trigger%"=="true" (
            set "rvc_trigger=false"
        ) else (
            set "rvc_trigger=true"
        )
        set "python_command= --enable-modules=rvc --rvc-save-file --max-content-length=1000"
    ) else if "%%i"=="3" (
        if "%talkinghead_trigger%"=="true" (
            set "talkinghead_trigger=false"
        ) else (
            set "talkinghead_trigger=true"
        )
        set "python_command= --enable-modules=talkinghead"
    ) else if "%%i"=="4" (
        if "%caption_trigger%"=="true" (
            set "caption_trigger=false"
        ) else (
            set "caption_trigger=true"
        )
        set "python_command= --enable-modules=caption"
    ) else if "%%i"=="5" (
        if "%summarize_trigger%"=="true" (
            set "summarize_trigger=false"
        ) else (
            set "summarize_trigger=true"
        )
        set "python_command= --enable-modules=summarize"
    ) else if "%%i"=="6" (
        goto :toolbox
    )
)

REM Save the module flags to modules.txt
echo coqui_trigger=%coqui_trigger%>"%~dp0modules.txt"
echo rvc_trigger=%rvc_trigger%>>"%~dp0modules.txt"
echo talkinghead_trigger=%talkinghead_trigger%>>"%~dp0modules.txt"
echo caption_trigger=%caption_trigger%>>"%~dp0modules.txt"
echo summarize_trigger=%summarize_trigger%>>"%~dp0modules.txt"

REM Save the constructed Python command to modules.txt for testing
echo start cmd /k python server.py %python_command%>>"%~dp0modules.txt"

REM Construct and execute the Python command
REM start cmd /k python server.py %python_command%

goto :editextrasmodules

:reinstallextras
title SillyTavern [REINSTALL-EXTRAS]
setlocal enabledelayedexpansion
chcp 65001 > nul
REM Define the names of items to be excluded
set "script_name=%~nx0"
set "excluded_folders=backups"
set "excluded_files=!script_name!"

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data in Sillytavern-extras                                      ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
echo Are you sure you want to proceed? [Y/N] 
set /p "confirmation="
if /i "!confirmation!"=="Y" (
    cd /d "%~dp0SillyTavern-extras"
    REM Remove non-excluded folders
    for /d %%D in (*) do (
        set "exclude_folder="
        for %%E in (!excluded_folders!) do (
            if "%%D"=="%%E" set "exclude_folder=true"
        )
        if not defined exclude_folder (
            rmdir /s /q "%%D" 2>nul
        )
    )

    REM Remove non-excluded files
    for %%F in (*) do (
        set "exclude_file="
        for %%E in (!excluded_files!) do (
            if "%%F"=="%%E" set "exclude_file=true"
        )
        if not defined exclude_file (
            del /f /q "%%F" 2>nul
        )
    )

    REM Clone repo into %temp% folder
    git clone https://github.com/SillyTavern/SillyTavern-extras.git "%temp%\SillyTavern-extras-TEMP"

    REM Move the contents of the temporary folder to the current directory
    xcopy /e /y "%temp%\SillyTavern-extras-TEMP\*" .

    REM Clean up the temporary folder
    rmdir /s /q "%temp%\SillyTavern-extras-TEMP"

    endlocal    
    cls
    echo %blue_fg_strong%SillyTavern Extras%reset%
    echo ---------------------------------------------------------------
    echo %blue_fg_strong%[INFO]%reset% Installing SillyTavern Extras...
    echo --------------------------------
    echo %cyan_fg_strong%This may take a while. Please be patient.%reset%

    winget install -e --id Anaconda.Miniconda3

    REM Run conda activate from the Miniconda installation
    call "%miniconda_path%\Scripts\activate.bat"

    REM Create a Conda environment named sillytavernextras
    call conda create -n sillytavernextras -y

    REM Activate the sillytavernextras environment
    call conda activate sillytavernextras

    REM Install Python 3.11 and Git in the sillytavernextras environment
    call conda install python=3.11 git -y

    REM Clone the SillyTavern Extras repository
    git clone https://github.com/SillyTavern/SillyTavern-extras

    REM Navigate to the SillyTavern-extras directory
    cd SillyTavern-extras

    REM Install Python dependencies from requirements files
    pip install -r requirements-complete.txt
    pip install -r requirements-rvc.txt
    echo %green_fg_strong%SillyTavern Extras have been successfully reinstalled.%reset%
) else (
    echo Reinstall canceled.
)
pause
goto :toolbox