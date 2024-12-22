@echo off

REM Check if the folder exists
if not exist "%invokeai_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Directory:%reset% %red_bg% %invokeai_install_path% %reset% %red_fg_strong%not found.%reset%
    pause
    exit /b 1
)

:start_invokeai
REM Activate the invokeai environment
call conda activate invokeai

REM Start InvokeAI
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% InvokeAI launched in a new window.

start cmd /k "title InvokeAI && cd /d %invokeai_install_path% && invokeai-web"
goto :home