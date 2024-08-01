@echo off

:restore_backup
title STL [RESTORE BACKUP]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / Backup / Restore Backup                 ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%   
echo.
echo +==== Available backups ==================+
setlocal enabledelayedexpansion
set "backup_count=0"

for %%F in ("%st_backup_path%\st_backup_*.7z") do (
    set /a "backup_count+=1"
    set "backup_files[!backup_count!]=%%~nF"
    echo    !backup_count!. %cyan_fg_strong%%%~nF%reset%
)
echo +=========================================+
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Cancel
echo.
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%
set /p "restore_choice=%BS%   Select backup to restore: "

if "%restore_choice%"=="0" goto :backup

if "%restore_choice%" geq "1" (
    if "%restore_choice%" leq "%backup_count%" (
        set "selected_backup=!backup_files[%restore_choice%]!"
        echo Restoring backup !selected_backup!...
        REM Extract the contents of the "data" folder directly into the existing "data" folder
        7z x "%st_backup_path%\!selected_backup!.7z" -o"temp" -aoa
        xcopy /y /e "temp\data\*" "%st_install_path%\data\"
        rmdir /s /q "temp"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%!selected_backup! restored successfully.%reset%
    ) else (
        echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %echo_invalidinput%
    )
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
)

pause

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)