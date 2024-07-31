@echo off

:start_extras
REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the extras environment
call conda activate extras

REM Start SillyTavern Extras with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Extras launched in a new window.

REM Read modules-extras and find the extras_start_command line
set "extras_start_command="

for /F "tokens=*" %%a in ('findstr /I "extras_start_command=" "%extras_modules_path%"') do (
    set "%%a"
)

set "extras_start_command=%extras_start_command:extras_start_command=%"
start cmd /k "title SillyTavern Extras && cd /d %extras_install_path% && %extras_start_command%"
goto :home