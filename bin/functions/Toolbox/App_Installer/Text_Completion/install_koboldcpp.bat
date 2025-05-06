@echo off

:install_koboldcpp
title STL [INSTALL KOBOLDCPP]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install koboldcpp%reset%
echo -------------------------------------------------------------
REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA
echo 2. AMD
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
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="0" (
    goto :install_koboldcpp_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_koboldcpp
)

:install_koboldcpp_pre
REM Check if text-completion folder exists
if not exist "%text_completion_dir%" (
    mkdir "%text_completion_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)

REM Check if dev-koboldcpp folder exists
if not exist "%koboldcpp_install_path%" (
    mkdir "%koboldcpp_install_path%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "dev-koboldcpp"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "dev-koboldcpp" folder already exists.%reset%
)
cd /d "%koboldcpp_install_path%"

REM Use the GPU choice made earlier to install koboldcpp
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading koboldcpp.exe for: %cyan_fg_strong%NVIDIA%reset% 
    curl -L -o "%koboldcpp_install_path%\koboldcpp.exe" "https://github.com/LostRuins/koboldcpp/releases/latest/download/koboldcpp.exe"
    start "" "koboldcpp.exe"
    goto :install_koboldcpp_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading koboldcpp_rocm.exe for: %cyan_fg_strong%AMD%reset% 
    curl -L -o "%koboldcpp_install_path%\koboldcpp_rocm.exe" "https://github.com/YellowRoseCx/koboldcpp-rocm/releases/latest/download/koboldcpp_rocm.exe"
    start "" "koboldcpp_rocm.exe"
    goto :install_koboldcpp_final
)

:install_koboldcpp_final
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed koboldcpp%reset%
pause
goto :app_installer_text_completion