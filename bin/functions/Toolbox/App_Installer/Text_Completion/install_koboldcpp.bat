@echo off

:install_koboldcpp
title STL [INSTALL KOBOLDCPP]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install koboldcpp%reset%
echo -------------------------------------------------------------
REM GPU menu - Frontend
echo What is your GPU?
echo 1. NVIDIA (CUDA12)
echo 2. NVIDIA
echo 3. NVIDIA (NO CUDA)
echo 4. NVIDIA (OLD CPU)
echo 5. AMD
echo 0. Cancel

REM                               1/5     2/5    3/5       4/5
REM koboldcpp_cu12.exe     CUDA12 ✔  CUDA ✔  CPU ✔  NVIDIA ✔
REM koboldcpp.exe          CUDA12 ✖  CUDA ✔  CPU ✔  NVIDIA ✔
REM koboldcpp_nocuda.exe   CUDA12 ✖  CUDA ✖  CPU ✔  NVIDIA ✔
REM koboldcpp_oldcpu.exe   CUDA12 ✖  CUDA ✖  CPU ✖  NVIDIA ✔
REM koboldcpp_rocm.exe     CUDA12 ✖  CUDA ✖  CPU ✖  NVIDIA ✖

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
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
cd /d "%koboldcpp_install_path%"
if "%gpu_choice%"=="1" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA (CUDA12)
    echo koboldcpp_cu12.exe > ".preferred_exe.txt"
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA
    echo koboldcpp.exe > ".preferred_exe.txt"
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA (NO CUDA)
    echo koboldcpp_nocuda.exe > ".preferred_exe.txt"
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="4" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to NVIDIA (OLD CPU)
    echo koboldcpp_oldcpu.exe > ".preferred_exe.txt"
    goto :install_koboldcpp_pre
) else if "%gpu_choice%"=="5" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    echo koboldcpp_rocm.exe > ".preferred_exe.txt"
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
for /f "tokens=*" %%a in ('type "%koboldcpp_install_path%\.preferred_exe.txt"') do set hotdog=%%a

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %hotdog%
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% !hotdog!
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %GPU_CHOICE%
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% !GPU_CHOICE!
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %gpu_choice%
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% !gpu_choice!
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %NVIDIA_KCPP%
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% !NVIDIA_KCPP!
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %koboldcpp_preferred_exe%
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% !koboldcpp_preferred_exe!
pause


set koboldcpp_preferred_exe=%koboldcpp_preferred_exe%
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
if not "%GPU_CHOICE%"=="5" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading !koboldcpp_preferred_exe! for: %cyan_fg_strong%NVIDIA%reset%
    curl -L -o "%koboldcpp_install_path%\!koboldcpp_preferred_exe!" "https://github.com/LostRuins/koboldcpp/releases/latest/download/!koboldcpp_preferred_exe!"
    start "" "!koboldcpp_preferred_exe!"
    goto :install_koboldcpp_final
) else if "%GPU_CHOICE%"=="5" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading %koboldcpp_preferred_exe% for: %cyan_fg_strong%AMD%reset%
    curl -L -o "%koboldcpp_install_path%\%koboldcpp_preferred_exe%" "https://github.com/YellowRoseCx/koboldcpp-rocm/releases/latest/download/!koboldcpp_preferred_exe!"
    start "" "!koboldcpp_preferred_exe!"
    goto :install_koboldcpp_final
)

:install_koboldcpp_final
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed koboldcpp%reset%
for /f %%i in ('curl -L -s "https://api.github.com/repos/LostRuins/koboldcpp/releases/latest"  ^| jq ".tag_name"') do set koboldcpp_release_tag=%%i
echo %koboldcpp_release_tag%>"%koboldcpp_install_path%\.version.txt"
pause
goto :app_installer_text_completion