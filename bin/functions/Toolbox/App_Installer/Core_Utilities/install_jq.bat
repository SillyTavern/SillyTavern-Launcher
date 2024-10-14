@echo off

:install_jq
title STL [INSTALL-JQ]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing jq...
winget install -e --id jqlang.jq
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%jq is installed.%reset%

REM Prompt user to restart
echo Restarting launcher...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit