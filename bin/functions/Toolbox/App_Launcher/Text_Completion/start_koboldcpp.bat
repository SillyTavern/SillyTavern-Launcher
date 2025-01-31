@echo off

:start_koboldcpp
REM Read modules-koboldcpp and find the koboldcpp_start_command line
set "koboldcpp_start_command="

for /F "tokens=*" %%a in ('findstr /I "koboldcpp_start_command=" "%koboldcpp_modules_path%"') do (
    set "%%a"
)

if not defined koboldcpp_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit koboldcpp Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit koboldcpp Modules menu.%reset%
    pause
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_koboldcpp_modules.bat" (
        call %editor_text_completion_dir%\edit_koboldcpp_modules.bat
        goto :app_launcher_text_completion
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_koboldcpp_modules.bat not found in: editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_koboldcpp_modules.bat not found in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :app_launcher_text_completion
    )
)

set "koboldcpp_start_command=%koboldcpp_start_command:koboldcpp_start_command=%"

REM Start Stable Diffusion WebUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% koboldcpp launched in a new window.
start cmd /k "title KOBOLDCPP && cd /d %koboldcpp_install_path% && %koboldcpp_start_command%"
goto :home