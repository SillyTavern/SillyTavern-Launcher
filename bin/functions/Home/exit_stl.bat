@echo off

set /p "exit_choice=Are you sure you wanna exit SillyTavern-Launcher? [Y/N]: "
if /i "%exit_choice%"=="" set exit_choice=Y
if /i "%exit_choice%"=="Y" (
    exit
) else (
    goto :home
)