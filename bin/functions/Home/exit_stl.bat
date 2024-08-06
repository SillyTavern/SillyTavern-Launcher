@echo off

set /p "exit_choice=Are you sure you wanna exit SillyTavern-Launcher? [Y/N]: "
if /i "%exit_choice%"=="" set exit_choice=Y
if /i "%exit_choice%"=="Y" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%Terminating all PID processes...%reset%
    for /f %%a in ('type "%log_dir%\pids.txt"') do (
        taskkill /F /PID %%a
    )
    del "%log_dir%\pids.txt"
    exit
) else (
    goto :home
)