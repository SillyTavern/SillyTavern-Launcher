@echo off

:start_sdwebui
cd /d "%sdwebui_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebui%reset%
call conda activate sdwebui

REM Read modules-sdwebui and find the sdwebui_start_command line
set "sdwebui_start_command="

for /F "tokens=*" %%a in ('findstr /I "sdwebui_start_command=" "%sdwebui_modules_path%"') do (
    set "%%a"
)

if not defined sdwebui_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit SDWEBUI Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit SDWEBUI Modules menu.%reset%
    pause
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_sdwebui_modules.bat" (
        call %editor_image_generation_dir%\edit_sdwebui_modules.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_sdwebui_modules.bat not found in: editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_sdwebui_modules.bat not found in: %editor_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
)

set "sdwebui_start_command=%sdwebui_start_command:sdwebui_start_command=%"

REM Start Stable Diffusion WebUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Stable Diffusion WebUI launched in a new window.
start cmd /k "title SDWEBUI && cd /d %sdwebui_install_path% && %sdwebui_start_command%"
goto :home

