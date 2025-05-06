@echo off

:install_invokeai
title STL [INSTALL INVOKEAI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install invokeai%reset%
echo ---------------------------------------------------------------
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
    goto :install_invokeai_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% GPU choice set to AMD
    goto :install_invokeai_pre
) else if "%gpu_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%
    pause
    goto :install_invokeai
)
:install_invokeai_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing InvokeAI...

REM Check if the folder exists
if not exist "%image_generation_dir%" (
    mkdir "%image_generation_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "image-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "image-generation" folder already exists.%reset%
)
cd /d "%image_generation_dir%"

set max_retries=3
set retry_count=0

:retry_install_invokeai
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning InvokeAI repository...
git clone https://github.com/invoke-ai/InvokeAI.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_invokeai
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :home
)
cd /d "%invokeai_install_path%"

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named invokeai
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%invokeai%reset%
call conda create -n invokeai python=3.11 -y

REM Activate the invokeai environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%invokeai%reset%
call conda activate invokeai

REM Use the GPU choice made earlier to install requirements for invokeai
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[invokeai]%reset% %blue_fg_strong%[INFO]%reset% Installing NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%invokeai%reset%
    pip install InvokeAI --use-pep517 --extra-index-url https://download.pytorch.org/whl/cu121
    goto :install_invokeai_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[invokeai]%reset% %blue_fg_strong%[INFO]%reset% Installing AMD version of PyTorch in conda enviroment: %cyan_fg_strong%invokeai%reset%
    pip install InvokeAI --use-pep517 --extra-index-url https://download.pytorch.org/whl/rocm5.6
    goto :install_invokeai_final
)
:install_invokeai_final

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%InvokeAI installed successfully%reset%
pause
goto :app_installer_image_generation