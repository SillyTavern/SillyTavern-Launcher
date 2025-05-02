@echo off

:start_rvc_python
REM Activate the rvc-python environment
call conda activate rvc-python

REM Start rvc-python
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% rvc-python launched in a new window.

REM Read modules-rvc-python and find the rvc_python_start_command line
set "rvc_python_start_command="

for /F "tokens=*" %%a in ('findstr /I "rvc_python_start_command=" "%rvc_python_modules_path%"') do (
    set "%%a"
)


if not defined rvc_python_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] No modules enabled.%reset%
    echo %red_bg%Please make sure you enabled at least one of the modules from Edit rvc-python Modules.%reset%
    echo.
    echo %blue_bg%We will redirect you to the Edit rvc-python Modules menu.%reset%
    pause
    set "caller=editor_image_generation"
    if exist "%editor_voice_generation_dir%\edit_rvc_python_modules.bat" (
        call %editor_voice_generation_dir%\edit_rvc_python_modules.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] ERROR: edit_rvc_python_modules.bat not found in: editor_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] edit_rvc_python_modules.bat not found in: %editor_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
        git pull
        pause
        goto :home
    )
)


set "rvc_python_start_command=%rvc_python_start_command:rvc_python_start_command=%"
start cmd /k "title RVC-Python && cd /d %rvc_python_install_path% && %rvc_python_start_command%"
goto :home