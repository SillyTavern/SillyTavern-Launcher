@echo off

:create_backup
title STL [CREATE-BACKUP]
REM Create a backup using 7zip
7z a "%st_backup_path%\backup_.7z" ^
    "data\default-user\*" ^


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