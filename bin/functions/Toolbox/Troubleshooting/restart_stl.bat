echo Restarting launcher...
timeout /t 3
cd /d %stl_root%
start %stl_root%Launcher.bat
exit