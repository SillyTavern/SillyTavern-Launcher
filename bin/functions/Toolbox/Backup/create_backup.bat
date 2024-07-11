@echo off
setlocal

:create_backup
title STL [CREATE BACKUP]
cls
echo %blue_fg_strong%/ Home / Toolbox / Backup / Create Backup%reset%
echo ---------------------------------------------------------------

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
set /p user_choice="Select a folder to backup: "

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

REM Prompt user for custom name
set "use_custom_name=N"
set "custom_name="
set /p rename_choice="Give backup file a custom name? (Default is st_backup_DATE_TIME.7z) [Y/N]: "
if /i "%rename_choice%"=="Y" (
    set "use_custom_name=Y"
    set /p custom_name="Enter custom name for backup file (without extension): "
) else if "%rename_choice%"=="" (
    set "use_custom_name=N"
)

REM Get current date and time components
for /f "tokens=2-4 delims=/ " %%a in ('echo %date%') do (
    set "day=%%a"
    set "month=%%b"
    set "year=%%c"
)

for /f "tokens=1-2 delims=:. " %%a in ('echo %time%') do (
    set "hour=%%a"
    set "minute=%%b"
)

REM Format the date and time
set "formatted_date=%year%-%month%-%day%_%hour%-%minute%"

REM Determine the backup file name
if "%use_custom_name%"=="Y" (
    set "backup_filename=st_backup_%custom_name%.7z"
) else (
    set "backup_filename=st_backup_%formatted_date%.7z"
)

REM Create a backup using 7zip
7z a "%st_backup_path%\%backup_filename%" "%st_install_path%\data\%selected_user_folder%\*"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Backup created at %st_backup_path%\%backup_filename%%reset%

pause
endlocal

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)
