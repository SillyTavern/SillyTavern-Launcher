@echo off

:start_alltalk
REM Activate the alltalk environment
call conda activate alltalk

REM Start AllTalk
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% AllTalk launched in a new window.
start cmd /k "title AllTalk && cd /d %alltalk_install_path% && python script.py"
goto :home




