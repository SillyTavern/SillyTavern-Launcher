@echo off

:uninstall_koboldcpp
title STL [UNINSTALL KOBOLDCPP]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of koboldcpp                                               ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the Conda enviroment: %cyan_fg_strong%koboldcpp%reset%
    call conda deactivate
    call conda remove --name koboldcpp --all -y
    call conda clean -a -y

    REM Remove the folder koboldcpp
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the koboldcpp directory...
    cd /d "%~dp0"
    rmdir /s /q "%koboldcpp_install_path%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing the w64devkit directory...
    rmdir /s /q "%w64devkit_install_path%" 

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%koboldcpp has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_text_completion
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_text_completion
)
