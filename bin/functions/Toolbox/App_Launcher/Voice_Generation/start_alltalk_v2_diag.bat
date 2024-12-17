@echo off

:start_alltalk_v2_diag
REM Activate the alltalk environment
call conda activate alltalkv2

REM Start AllTalkV2
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% AllTalkV2 Diagnostics launched in a new window.
start cmd /k "title AllTalkV2 && cd /d %alltalk_v2_install_path% && python diagnostics.py"
goto :home