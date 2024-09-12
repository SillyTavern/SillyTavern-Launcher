@echo off

:start_rvc
REM Activate the alltalk environment
call conda activate rvc

REM Start RVC with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% RVC launched in a new window.
start cmd /k "title RVC REALTIME && cd /d %rvc_install_path% && python gui_v1.py"
goto :home