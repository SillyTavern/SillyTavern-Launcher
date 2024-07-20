@echo off

:install_tabbyapi_st_ext
title STL [INSTALL TABBYAPI ST EXT]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Text Completion / Install ST-tabbyAPI-loader Extension%reset%
echo -------------------------------------------------------------

REM Scan for user folders
set "user_folders="
for /d %%d in ("%st_install_path%\data\*") do (
    if /i not "%%~nxd"=="_storage" if /i not "%%~nxd"=="_uploads" (
        set "user_folders=!user_folders!%%~nxd|"
    )
)

echo Detected accounts:
echo ================================
REM Remove the trailing pipe character
set "user_folders=%user_folders:~0,-1%"

REM Split user_folders into an array
set i=1
set "user_count=0"
for %%a in (%user_folders:|= %) do (
    echo !i!. %cyan_fg_strong%%%a%reset%
    set "user_folder_!i!=%%a"
    set /a i+=1
    set /a user_count+=1
)
echo ================================

REM If only one user folder is found, skip the selection
if %user_count%==1 (
    set "selected_user_folder=!user_folder_1!"
    goto skip_user_selection
)

:select_user_folder
REM Prompt user to select a folder
echo 0. Cancel
echo.
set "selected_user_folder="
set /p user_choice="Select a folder to install ST-tabbyAPI-loader: "

REM Check if the user wants to exit
if "%user_choice%"=="0" (
    exit /b 0
)

REM Get the selected folder name
for /l %%i in (1,1,%user_count%) do (
    if "%user_choice%"=="%%i" set "selected_user_folder=!user_folder_%%i!"
)

if "%selected_user_folder%"=="" (
    echo %red_fg_strong%[ERROR] Invalid selection. Please enter a number between 1 and %user_count%, or press 0 to cancel.%reset%
    pause
    goto :create_backup
)

:skip_user_selection
REM Replace backslashes with double backslashes in st_install_path
set "escaped_st_install_path=%st_install_path:\=\\%"

REM install the extension in selected user folder
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing ST-tabbyAPI-loader extension...
cd /d "%st_install_path%\data\%selected_user_folder%\extensions"
git clone https://github.com/theroyallab/ST-tabbyAPI-loader.git 

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ST-tabbyAPI-loader Extension for SillyTavern has been installed successfully.%reset%
pause
goto :install_tabbyapi_menu