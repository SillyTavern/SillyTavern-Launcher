@echo off

:install_comfyui
title STL [INSTALL COMFYUI]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install ComfyUI%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing ComfyUI...

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
:retry_install_comfyui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the ComfyUI repository...
git clone https://github.com/comfyanonymous/ComfyUI.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_comfyui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_image_generation
)
cd /d "%comfyui_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named comfyui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%comfyui%reset%
call conda create -n comfyui python=3.12 -y

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment %cyan_fg_strong%comfyui%reset%
call conda activate comfyui

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pytorch...
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements...
pip install -r requirements.txt

REM Clone extensions for ComfyUI
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning extensions for ComfyUI...
cd /d "%comfyui_install_path%\custom_nodes"
git clone https://github.com/ltdrdata/ComfyUI-Manager.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Better Upscaler models...
cd /d "%comfyui_install_path%\models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/konohashinobi4/4xAnimesharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ComfyUI successfully installed.%reset%
pause
goto :app_installer_image_generation