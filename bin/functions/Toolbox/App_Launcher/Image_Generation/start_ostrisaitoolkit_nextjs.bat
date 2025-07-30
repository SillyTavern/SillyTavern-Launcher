@echo off

:start_ostrisaitoolkit
cd /d "%ostrisaitoolkit_install_path%"

REM Start ostrisaitoolkit
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% ostrisaitoolkit launched in a new window.

start cmd /k "title Ostris AI Toolkit && cd /d %ostrisaitoolkit_install_path%/ui && npm run build_and_start"
goto :home