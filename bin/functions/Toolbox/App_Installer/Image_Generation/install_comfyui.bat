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
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128

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


set TRITON_URL=https://github.com/woct0rdho/triton-windows/releases/download/v3.2.0-windows.post10/triton-3.2.0-cp312-cp312-win_amd64.whl
set INCLUDE_LIBS_URL=https://github.com/woct0rdho/triton-windows/releases/download/v3.0.0-windows.post1/python_3.12.7_include_libs.zip
set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8



echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Checking Visual Studio Build Tools...
winget list --id Microsoft.VisualStudio.2022.BuildTools --source winget >nul 2>&1
if %errorlevel% neq 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Visual Studio Build Tools...
    winget install --id Microsoft.VisualStudio.2022.BuildTools -e --source winget --override "--quiet --wait --norestart --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.20348"
    if %errorlevel% neq 0 (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to install Visual Studio Build Tools.%reset%
        pause
        exit /b
    )
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Visual Studio Build Tools already installed.
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment %cyan_fg_strong%comfyui%reset%
call conda activate comfyui
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to activate comfyui environment.%reset%
    pause
    exit /b
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Using python from: %cyan_fg_strong%%CONDA_PREFIX%\python.exe%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing PyTorch with CUDA aaaa support...
pip install torch==2.7.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to install PyTorch.%reset%
    pause
    exit /b
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Triton...
pip install "%TRITON_URL%"
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to install Triton.%reset%
    pause
    exit /b
)

for %%F in ("%INCLUDE_LIBS_URL%") do set FILE_NAME=%%~nxF
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading and extracting Python include/libs for Triton...
curl -L -o "%FILE_NAME%" "%INCLUDE_LIBS_URL%" && tar -xf "%FILE_NAME%" -C "%CONDA_PREFIX%"
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to setup Python headers/libs for Triton.%reset%
    del "%FILE_NAME%" >nul 2>&1
    pause
    exit /b
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning SageAttention repository...
git clone https://github.com/thu-ml/SageAttention.git
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone SageAttention repository.%reset%
    pause
    exit /b
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing SageAttention...
pushd SageAttention
pip install --no-build-isolation .
set SAGE_INSTALL_ERROR=%errorlevel%
popd

if %SAGE_INSTALL_ERROR% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to install SageAttention.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cleaning up temporary files...
    del "%FILE_NAME%" >nul 2>&1
    rmdir /s /q "SageAttention" >nul 2>&1
    pause
    exit /b
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cleaning up temporary files...
del "%FILE_NAME%"
rmdir /s /q "SageAttention"

echo.
echo %blue_bg%[%time%]%reset% %green_fg_strong%Triton and SageAttention successfully installed for ComfyUI.%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ComfyUI successfully installed.%reset%
pause
goto :app_installer_image_generation