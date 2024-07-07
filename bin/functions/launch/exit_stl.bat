@echo off
REM Set base directory
set "base_dir=%~dp0\..\.."

:exit
echo %red_bg%[%time%]%reset% %red_fg_strong%Terminating all started processes...%reset%
for /f %%a in ('type "%base_dir%\logs\pids.txt"') do (
    taskkill /F /PID %%a
)
del "%base_dir%\logs\pids.txt"
exit

