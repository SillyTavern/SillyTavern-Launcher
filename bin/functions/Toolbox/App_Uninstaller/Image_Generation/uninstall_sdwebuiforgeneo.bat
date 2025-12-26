@echo off
:uninstall_sdwebuiforgeneo
title STL [UNINSTALL SDWEBUI FORGE-NEO]
setlocal enabledelayedexpansion
chcp 65001 > nul

echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all Forge-NEO data and its Pixi environment.                        ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing directory: %sdwebuiforgeneo_install_path%
    if exist "%sdwebuiforgeneo_install_path%" rmdir /s /q "%sdwebuiforgeneo_install_path%"
    
    echo %blue_bg%[%time%]%reset% %green_fg_strong%Forge-NEO has been uninstalled.%reset%
    pause
    goto :home
) else (
    echo Uninstall canceled.
    pause
    goto :home
)