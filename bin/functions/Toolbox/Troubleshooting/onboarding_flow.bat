@echo off

:onboarding_flow
title STL [ONBOARDING FLOW]
cls
echo %blue_fg_strong%/ Home / Toolbox / Troubleshooting / Set Onboarding Flow%reset%
echo ---------------------------------------------------------------

REM Scan for user folders
set "user_folders="
for /d %%d in ("%st_install_path%\data\*") do (
    if /i not "%%~nxd"=="_storage" if /i not "%%~nxd"=="_uploads" (
        set "user_folders=!user_folders!%%~nxd|"
    )
)

REM Remove the trailing pipe character
set "user_folders=%user_folders:~0,-1%"

REM Split user_folders into an array
setlocal enabledelayedexpansion
set i=1
set "user_count=0"
for %%a in (%user_folders:|= %) do (
    echo !i!. %%a
    set "user_folder_!i!=%%a"
    set /a i+=1
    set /a user_count+=1
)

REM If only one user folder is found, skip the selection
if %user_count%==1 (
    set "selected_user_folder=!user_folder_1!"
    goto skip_user_selection
)

:select_user_folder
REM Prompt user to select a folder
echo 0. Cancel
set "selected_user_folder="
set /p user_choice="Select a folder to apply the setting: "

REM Check if the user wants to exit
if "%user_choice%"=="0" (
    if "%caller%"=="home" (
        exit /b 1
    ) else (
        exit /b 0
    )
)

REM Get the selected folder name
for /l %%i in (1,1,%user_count%) do (
    if "%user_choice%"=="%%i" set "selected_user_folder=!user_folder_%%i!"
)

if "%selected_user_folder%"=="" (
    echo %red_fg_strong%[ERROR] Invalid selection. Please enter a number between 1 and %user_count%, or press 0 to cancel.%reset%
    pause
    goto :onboarding_flow
)

:skip_user_selection
REM Replace backslashes with double backslashes in st_install_path
set "escaped_st_install_path=%st_install_path:\=\\%"

REM Get the current value of the Onboarding Flow setting using Node.js
for /f "tokens=*" %%i in ('node -e "const fs = require(`fs`); const path = require(`path`); const settingsPath = path.join(`%escaped_st_install_path%`, `data`, `%selected_user_folder%`, `settings.json`); const settings = JSON.parse(fs.readFileSync(settingsPath, `utf-8`)); console.log(settings.firstRun);"') do (
    set "current_onboarding_value=%%i"
)

echo %blue_fg_strong%[INFO]%reset% Current Onboarding Flow value is: %yellow_fg_strong% %current_onboarding_value% %reset%

REM Toggle the value
if /i "%current_onboarding_value%"=="true" (
    set "new_onboarding_value=false"
) else (
    set "new_onboarding_value=true"
)

echo %blue_fg_strong%[INFO]%reset% New Onboarding Flow value will be: %green_fg_strong% %new_onboarding_value% %reset%

REM Prompt for confirmation to toggle the value
set /p confirm="Do you want to toggle the Onboarding Flow value to %new_onboarding_value%? (Y/N): "
if /i "%confirm%"=="Y" (
    REM Update settings.json in the selected user folder using Node.js
    node -e "const fs = require(`fs`); const path = require(`path`); const settingsPath = path.join(`%escaped_st_install_path%`, `data`, `%selected_user_folder%`, `settings.json`); const settings = JSON.parse(fs.readFileSync(settingsPath, `utf-8`)); settings.firstRun = %new_onboarding_value%; fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2)); console.log('Saving...');"
    echo %green_fg_strong%[INFO]%reset% Onboarding flow updated for user: %selected_user_folder% to: %green_fg_strong%%new_onboarding_value%%reset%.
) else (
    echo %blue_fg_strong%[INFO]%reset% No changes made.
)

pause
if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)
