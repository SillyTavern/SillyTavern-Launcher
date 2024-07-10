@echo off

:install_koboldcpp_raw
title STL [INSTALL KOBOLDCPP RAW]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install koboldcpp RAW%reset%
echo -------------------------------------------------------------

REM Check if the folder exists
if not exist "%w64devkit_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] w64devkit not found.%reset%
    echo %red_fg_strong%w64devkit is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install w64devkit go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install w64devkit%reset%
    pause
    goto :app_installer_core_utilities
)

REM Check if the folder exists
if not exist "%text_completion_dir%" (
    mkdir "%text_completion_dir%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "text-completion"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "text-completion" folder already exists.%reset%
)

REM Check if the folder exists
if not exist "%koboldcpp_install_path%" (
    mkdir "%koboldcpp_install_path%"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "dev-koboldcpp"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "dev-koboldcpp" folder already exists.%reset%
)
cd /d "%koboldcpp_install_path%"

REM Check if file exists
if not exist "make.sh" (
    echo make -C "${1}" > "make.sh"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created new file: "make.sh"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "make.sh" already exists.%reset%
)

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda environment named koboldcpp
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Conda environment: %cyan_fg_strong%koboldcpp%reset%
call conda create -n koboldcpp python=3.11 -y

REM Activate the conda environment named koboldcpp 
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%koboldcpp%reset%
call conda activate koboldcpp

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing pip requirements
pip install pyinstaller

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing koboldcpp...

set max_retries=3
set retry_count=0

:retry_install_koboldcpp
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning the koboldcpp repository...
git clone https://github.com/LostRuins/koboldcpp.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_koboldcpp
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Failed to clone repository after %max_retries% retries.%reset%
    pause
    goto :app_installer_text_completion
)

REM Add new lines to CMakeLists.txt
cd /d "koboldcpp"
echo add_compile_options("$<$<C_COMPILER_ID:MSVC>:-utf-8>")>> CMakeLists.txt
echo add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:-utf-8>")>> CMakeLists.txt
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% successfully added new lines to: CMakeLists.txt

make
PyInstaller --noconfirm --onefile --clean --console --collect-all customtkinter --icon "./niko.ico" --add-data "./winclinfo.exe;." --add-data "./OpenCL.dll;." --add-data "./klite.embd;." --add-data "./kcpp_docs.embd;." --add-data "./koboldcpp_default.dll;." --add-data "./koboldcpp_openblas.dll;." --add-data "./koboldcpp_failsafe.dll;." --add-data "./koboldcpp_noavx2.dll;." --add-data "./libopenblas.dll;." --add-data "./koboldcpp_clblast.dll;." --add-data "./koboldcpp_clblast_noavx2.dll;." --add-data "./koboldcpp_vulkan_noavx2.dll;." --add-data "./clblast.dll;." --add-data "./koboldcpp_vulkan.dll;." --add-data "./vulkan-1.dll;." --add-data "./rwkv_vocab.embd;." --add-data "./rwkv_world_vocab.embd;." "./koboldcpp.py" -n "koboldcpp.exe"
start "" "koboldcpp.exe"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Successfully installed koboldcpp%reset%
pause
goto :app_installer_text_completion