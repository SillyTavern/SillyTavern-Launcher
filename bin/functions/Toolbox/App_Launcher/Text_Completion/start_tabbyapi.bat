@echo off

:start_tabbyapi
REM Read modules-tabbyapi and find the tabyapi_start_command line
set "tabbyapi_start_command="

for /F "tokens=*" %%a in ('findstr /I "tabbyapi_start_command=" "%tabbyapi_modules_path%"') do (
    set "%%a"
)

if not defined tabbyapi_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit tabbyapi Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit tabbyapi Modules menu.%reset%
    pause
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_tabbyapi_modules.bat" (
        call %editor_text_completion_dir%\edit_tabbyapi_modules.bat
        goto :app_launcher_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_tabbyapi_modules.bat not found in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_tabbyapi_modules.bat not found in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_launcher_text_completion
    )
)

set "tabbyapi_start_command=%tabbyapi_start_command:tabbyapi_start_command=%"


REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the extras environment
call conda activate tabbyapi

REM Start TabbyAPI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% TabbyAPI launched in a new window.
start cmd /k "title TabbyAPI && cd /d %tabbyapi_install_path% && %tabbyapi_start_command%"