@echo off
REM Set base directory

:exit
echo %red_bg%[%time%]%reset% %red_fg_strong%Terminating all started processes...%reset%
for /f %%a in ('type "%log_dir%pids.txt"') do (
    taskkill /F /PID %%a
)
del "%log_dir%pids.txt"
exit

