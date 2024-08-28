@echo off

:start_sdwebuiforge
cd /d "%sdwebuiforge_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Miniconda environment...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebuiforge environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Activating Conda environment: %cyan_fg_strong%sdwebuiforge%reset%
call conda activate sdwebuiforge

REM Read modules-sdwebuiforge and find the sdwebuiforge_start_command line
set "sdwebuiforge_start_command="

for /F "tokens=*" %%a in ('findstr /I "sdwebuiforge_start_command=" "%sdwebuiforge_modules_path%"') do (
    set "%%a"
)

if not defined sdwebuiforge_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit SDWEBUI FORGE Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit SDWEBUI FORGE Modules menu.%reset%
    pause
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_sdwebuiforge_modules.bat" (
        call %editor_image_generation_dir%\edit_sdwebuiforge_modules.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_sdwebuiforge_modules.bat not found in: editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_sdwebuiforge_modules.bat not found in: %editor_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
)

set "sdwebuiforge_start_command=%sdwebuiforge_start_command:sdwebuiforge_start_command=%"

REM Start Stable Diffusion WebUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Stable Diffusion WebUI launched in a new window.
start cmd /k "title SDWEBUI FORGE && cd /d %sdwebuiforge_install_path% && %sdwebuiforge_start_command%"
goto :home