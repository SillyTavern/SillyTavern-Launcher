@echo off


:install_koboldcpp
title STL [INSTALL AND UNPACK KOBOLDCPP]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install and Unpack koboldcpp%reset%
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

REM Check if tmp folder exists
if not exist "%koboldcpp_temp_path%" (
    mkdir "%koboldcpp_temp_path%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created temporary folder  
) else (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Temporary folder already exists. Please check %koboldcpp_temp_path% for contents before proceeding%reset%
	set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
	if /i "%confirmation%"=="Y" (
	echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Proceeding%reset%
	del /q "%koboldcpp_temp_path%"
	)
)
cd /d "%koboldcpp_temp_path%"

REM Use the GPU choice made earlier to install koboldcpp, unpack koboldcpp, and remove the tmp directory
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading koboldcpp.exe for: %cyan_fg_strong%NVIDIA%reset% 
    curl -L -o "%koboldcpp_temp_path%\koboldcpp.exe" "https://github.com/LostRuins/koboldcpp/releases/latest/download/koboldcpp.exe"
	echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Clearing koboldcpp install folder
	rmdir /s /q "%koboldcpp_install_path%"
	mkdir "%koboldcpp_install_path%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Unpacking koboldcpp.exe for: %cyan_fg_strong%NVIDIA%reset% 
    start /w "" "koboldcpp.exe" --unpack "%koboldcpp_install_path%"
	echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Moving koboldcpp executable to install folder
	move /Y "%koboldcpp_temp_path%\koboldcpp.exe" "%koboldcpp_install_path%"
	cd /d "%koboldcpp_install_path%"
	rmdir /s /q "%koboldcpp_temp_path%"
	pause
	echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cleaned up temporary folder
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading koboldcpp_rocm.exe for: %cyan_fg_strong%AMD%reset% 
    curl -L -o "%koboldcpp_temp_path%\koboldcpp_rocm.exe" "https://github.com/YellowRoseCx/koboldcpp-rocm/releases/latest/download/koboldcpp_rocm.exe"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Unpacking koboldcpp_rocm.exe for: %cyan_fg_strong%AMD%reset% 
	rmdir /s /q "%koboldcpp_install_path%"
	mkdir "%koboldcpp_install_path%"
    start /w "" "koboldcpp_rocm.exe" --unpack "%koboldcpp_install_path%"
	echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Moving koboldcpp executable to install folder
	move /Y "%koboldcpp_temp_path%\koboldcpp_rocm.exe" "%koboldcpp_install_path%"
	cd /d "%koboldcpp_install_path%"
	rmdir /s /q "%koboldcpp_temp_path%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cleaned up temporary folder
)

start "" "koboldcpp-launcher.exe"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed and unpacked koboldcpp%reset%
pause

goto :app_installer_text_completion

