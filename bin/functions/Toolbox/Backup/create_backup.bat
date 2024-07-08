@echo off

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

REM Remove the trailing pipe character
set "user_folders=%user_folders:~0,-1%"

REM Split user_folders into an array
set i=1
set "user_count=0"
for %%a in (%user_folders:|= %) do (
    echo !i!. %%a
    set "user_folder_!i!=%%a"
    set /a i+=1
    set /a user_count+=1
)

REM If only one user folder is found, skip the selection
if %user_count%==1 (
    set "selected_user_folder=!user_folder_1!"
    goto skip_user_selection
)

:select_user_folder
REM Prompt user to select a folder
echo 0. Cancel
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

REM Create a backup using 7zip
7z a "%st_backup_path%\backup_.7z" ^
    "%st_install_path%\data\%selected_user_folder%\*" ^

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
set "day=0!day!"
set "month=0!month!"
set "hour=0!hour!"
set "minute=0!minute!"

set "formatted_date=%month:~-2%-%day:~-2%-%year%_%hour:~-2%%minute:~-2%"

REM Rename the backup file with the formatted date and time
rename "%st_backup_path%\backup_.7z" "backup_%formatted_date%.7z"

endlocal


echo %green_fg_strong%Backup created at %st_backup_path%%reset%
pause
endlocal

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)