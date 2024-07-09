@echo off

:install_w64devkit
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] 7z command not found in PATH.%reset%
    echo %red_fg_strong%7-Zip is not installed or not found in the system PATH.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ Toolbox / App Installer / Core Utilities / Install 7-Zip%reset%
    pause
    goto :app_installer_core_utilities
)

REM Check if the folder exists
if exist "%w64devkit_install_path%" (
    REM Remove w64devkit folder if it already exist
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Removing existing w64devkit installation...
    rmdir /s /q "%w64devkit_install_path%"
)

REM Download w64devkit zip archive
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Downloading w64devkit...
curl -L -o "%w64devkit_download_path%" "%w64devkit_download_url%"

REM Extract w64devkit zip archive
7z x "%w64devkit_download_path%" -o"C:\"

REM Remove leftovers
del "%w64devkit_download_path%"

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%w64devkit_path_bin%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%w64devkit_path_bin%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "w64devkit_path_bin is:%cyan_fg_strong% %w64devkit_path_bin%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%w64devkit added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[INFO] w64devkit already exists in PATH.%reset%
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%w64devkit is installed.%reset%

REM Prompt user to restart
echo Restarting launcher...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit