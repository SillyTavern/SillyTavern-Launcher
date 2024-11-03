@echo off
setlocal EnableDelayedExpansion
REM ############################################################
REM ############## EDIT TABBYAPI MODULES - FRONTEND ############
REM ############################################################
:edit_tabbyapi_modules
title STL [EDIT TABBYAPI MODULES]
if !exitflag!==1 (
 goto :save_tabbyapi_modules_exit
) 
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules%reset%
echo -------------------------------------------------------------
echo Choose tabbyapi modules (e.g., "1 2 4" to enable Load Model, Ignore Auto Upgrade, and host)

REM Read modules-audio and find the tabbyapi_start_command line
set "tabbyapi_start_command="
for /F "tokens=*" %%a in ('findstr /I "tabbyapi_start_command=" "%tabbyapi_modules_path%"') do (
    set "%%a"
)
set "tabbyapi_start_command=!tabbyapi_start_command:tabbyapi_start_command=!"
echo Preview: %cyan_fg_strong%!tabbyapi_start_command!%reset%
echo.

REM Display module options with colors based on their status
call :printModule "1. Load Model (--model-name !selected_tabbyapi_model_folder!)" !selected_tabbyapi_model_folder_trigger!
call :printModule "2. Ignore Auto Upgrade (--ignore-upgrade)" !tabbyapi_ignoreupdate_trigger!
call :printModule "3. Port (--port !tabbyapi_port!)" !tabbyapi_port_trigger!
call :printModule "4. Host (--host 0.0.0.0)" !tabbyapi_host_trigger!
call :printModule "5. Max Seq Len (--max-seq-len !tabbyapi_maxseqlen!)" !tabbyapi_maxseqlen_trigger!
call :printModule "6. Rope Alpha (--rope-alpha !tabbyapi_ropealpha!)" !tabbyapi_ropealpha_trigger!
call :printModule "7. Cache Mode (--cache-mode !tabbyapi_cachemode!)" !tabbyapi_cachemode_trigger!
call :printModule "8. Update Dependencies (--update-deps)" !tabbyapi_updatedeps_trigger!

echo.
echo 99. Open Models Folder
echo 00. Start TabbyAPI
echo 0. Back

set /p tabbyapi_module_choices="Choose modules to enable/disable: "

REM Handle the user's module choices and construct the Python command

for %%i in (!tabbyapi_module_choices!) do (
    if "%%i"=="1" (
        call :edit_tabbyapi_modules_loadmodel_menu
    ) else if "%%i"=="2" (
        if "!tabbyapi_ignoreupdate_trigger!"=="true" (
            set "tabbyapi_ignoreupdate_trigger=false"
            call :save_tabbyapi_modules
        ) else (
            set "tabbyapi_ignoreupdate_trigger=true"
            call :save_tabbyapi_modules
        )
    ) else if "%%i"=="3" (
        call :edit_tabbyapi_modules_port_menu
    ) else if "%%i"=="4" (
        if "!tabbyapi_host_trigger!"=="true" (
            set "tabbyapi_host_trigger=false"
            call :save_tabbyapi_modules
        ) else (
            set "tabbyapi_host_trigger=true"
            call :save_tabbyapi_modules
        )
    ) else if "%%i"=="5" (
        call :edit_tabbyapi_modules_maxseqlen_menu
    ) else if "%%i"=="6" (
        call :edit_tabbyapi_modules_ropealpha_menu
    ) else if "%%i"=="7" (
        call :edit_tabbyapi_modules_cachemode_menu
    ) else if "%%i"=="8" (
        if "!tabbyapi_updatedeps_trigger!"=="true" (
            set "tabbyapi_updatedeps_trigger=false"
            call :save_tabbyapi_modules
        ) else (
            set "tabbyapi_updatedeps_trigger=true"
            call :save_tabbyapi_modules
        )
    )  else if "%%i"=="00" (
        set "caller=app_launcher_text_completion"
        if exist "%app_launcher_text_completion_dir%\start_tabbyapi.bat" (
            call %app_launcher_text_completion_dir%\start_tabbyapi.bat
            goto :edit_tabbyapi_modules
        ) else (
            echo [%DATE% %TIME%] ERROR: start_tabbyapi.bat not found in: %app_launcher_text_completion_dir% >> %logs_stl_console_path%
            echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_tabbyapi.bat not found in: %app_launcher_text_completion_dir%%reset%
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
            git pull
            pause
            goto :edit_tabbyapi_modules
    )
    ) else if "%%i"=="0" (
        set exitflag=1
        goto :save_tabbyapi_modules_exit
        exit /b 1
    )else if "%%i"=="99" (
        start "" "%tabbyapi_install_path%\models"
        goto :edit_tabbyapi_modules
    )
)
goto :save_tabbyapi_modules_exit

:edit_tabbyapi_modules_loadmodel_menu
title STL [EDIT TABBYAPI LOAD MODEL]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules / Load Model%reset%
echo -------------------------------------------------------------

REM Scan for model folders in TabbyAPI
set "tabbyapi_model_folders="
for /d %%d in ("%tabbyapi_install_path%\models\*") do (
    if /i not "%%~nxd"=="place_your_models_here.txt" if /i not "%%~nxd"=="_uploads" (
        set "tabbyapi_model_folders=!tabbyapi_model_folders!%%~nxd|"
    )
)

echo === DETECTED MODELS ============================
REM Remove the trailing pipe character
set "tabbyapi_model_folders=%tabbyapi_model_folders:~0,-1%"

REM Split tabbyapi_model_folders into an array
set i=1
set "model_count=0"
for %%a in (%tabbyapi_model_folders:|= %) do (
    echo !i!. %cyan_fg_strong%%%a%reset%
    set "tabbyapi_model_folder_!i!=%%a"
    set /a i+=1
    set /a model_count+=1
)
echo ================================================

:select_tabbyapi_model_folder
REM Prompt user to select a folder
echo %red_fg_strong%00. Disable this module%reset%
echo 0. Cancel
echo.
set /p tabbyapi_model_choice="Choose a model: "

REM Check if the user wants to exit
if "%tabbyapi_model_choice%"=="0" (
    goto :edit_tabbyapi_modules
)

REM Handle 'Disable' selection
if "!tabbyapi_model_choice!"=="00" (
    set "selected_tabbyapi_model_folder_trigger=false"
    goto :save_tabbyapi_modules
)

REM Get the selected folder name
for /l %%i in (1,1,%model_count%) do (
    if "%tabbyapi_model_choice%"=="%%i" (
        set "selected_tabbyapi_model_folder=!tabbyapi_model_folder_%%i!"
        set "selected_tabbyapi_model_folder_trigger=true"
        goto :save_tabbyapi_modules
    )
)
REM Validate the selection
if "%selected_tabbyapi_model_folder%"=="" (
    echo %red_fg_strong%[ERROR] Invalid selection. Please enter a number between 1 and %model_count%, or press 0 to cancel.%reset%
    pause
    goto :select_tabbyapi_model_folder
)

:skip_user_selection
REM Replace backslashes with double backslashes in tabbyapi_install_path
set "escaped_tabbyapi_install_path=%tabbyapi_install_path:\=\\%"

REM save selected model in variable
REM echo "%tabbyapi_install_path%\models\%selected_tabbyapi_model_folder%"
goto :edit_tabbyapi_modules


:edit_tabbyapi_modules_port_menu
title STL [EDIT TABBYAPI PORT]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules / Port%reset%
echo -------------------------------------------------------------

echo %red_fg_strong%00. Disable this module%reset%
echo 0. Cancel
echo. 
set /p port_choice="Insert port number: "

if "%port_choice%"=="0" goto :edit_tabbyapi_modules

REM Check if the input is a number
set "valid=true"
for /f "delims=0123456789" %%i in ("!port_choice!") do set "valid=false"
if "!valid!"=="false" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input: Not a number.%reset%
    pause
    goto :edit_tabbyapi_modules_port_menu
)

REM Check if the port is within range
if !port_choice! gtr 65535 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Port out of range. There are only 65,535 possible port numbers.%reset%
    echo [0-1023]: These ports are reserved for system services or commonly used protocols.
    echo [1024-49151]: These ports can be used by user processes or applications.
    echo [49152-65535]: These ports are available for use by any application or service on the system.
    pause
    goto :edit_tabbyapi_modules_port_menu
)

REM Handle 'Cancel' selection
if "!port_choice!"=="0" (
    goto :edit_tabbyapi_modules
)

REM Handle 'Disable' selection
if "!port_choice!"=="00" (
    set "tabbyapi_port_trigger=false"
    call :save_tabbyapi_modules
    goto :edit_tabbyapi_modules
)

REM Set the port and enable the trigger
set "tabbyapi_port=!port_choice!"
set "tabbyapi_port_trigger=true"
call :save_tabbyapi_modules
goto :edit_tabbyapi_modules


:edit_tabbyapi_modules_maxseqlen_menu
title STL [EDIT TABBYAPI MAX SEQ LEN]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules / Max Seq Len%reset%
echo -------------------------------------------------------------

        set "maxseqlen=32768 24576 16384 8192 4096"
        set /a count=1

        for %%r in (%maxseqlen%) do (
            if "%%r"=="32768" (
                echo !count!. %%r - 32K
            ) else if "%%r"=="24576" (
                echo !count!. %%r - 24K
            ) else if "%%r"=="16384" (
                echo !count!. %%r - 16K
            ) else if "%%r"=="8192" (
                echo !count!. %%r - 8K
            ) else if "%%r"=="4096" (
                echo !count!. %%r - 4K
            ) else (
                echo !count!. %%r
            )
            set /a count+=1
        )
        echo 6. Insert custom value
        echo %red_fg_strong%00. Disable this module%reset%
        echo 0. Cancel
        echo.
        set /p maxseqlen_choice="Choose a Max Seq Len: "

        if "!maxseqlen_choice!"=="0" (
            goto :edit_tabbyapi_modules
        ) else if "!maxseqlen_choice!"=="00" (
            set "tabbyapi_maxseqlen_trigger=false"
            call :save_tabbyapi_modules
            goto :edit_tabbyapi_modules
        ) else if "!maxseqlen_choice!"=="6" (
            goto :edit_tabbyapi_modules_maxseqlen_custom
        ) else (
            set /a idx=maxseqlen_choice 
            set /a count=1
            for %%r in (%maxseqlen%) do (
                if "!count!"=="!idx!" (
                    set "tabbyapi_maxseqlen_trigger=true"
                    set "tabbyapi_maxseqlen=%%r"
                    call :save_tabbyapi_modules
                    goto :edit_tabbyapi_modules
                )
                set /a count+=1
            )
        )

        echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
        echo %red_bg%[%time%]%reset% %echo_invalidinput%
        pause
        goto :edit_tabbyapi_modules_maxseqlen_menu


:edit_tabbyapi_modules_maxseqlen_custom
title STL [EDIT TABBYAPI MAX SEQ LEN]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules / Max Seq Len / Custom%reset%
echo -------------------------------------------------------------
echo 0. Cancel
echo. 
set /p tabbyapi_maxseqlen_custom="Insert Custom Max Seq Len Value: "

if "%tabbyapi_maxseqlen_custom%"=="0" goto :edit_tabbyapi_modules_maxseqlen_menu

REM Set the maxseqlen and enable the trigger
set "tabbyapi_maxseqlen=!tabbyapi_maxseqlen_custom!"
set "tabbyapi_maxseqlen_trigger=true"
call :save_tabbyapi_modules
goto :edit_tabbyapi_modules



:edit_tabbyapi_modules_ropealpha_menu
title STL [EDIT TABBYAPI ROPE ALPHA]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules / Rope Alpha%reset%
echo -------------------------------------------------------------

echo %red_fg_strong%00. Disable this module%reset%
echo 0. Cancel
echo. 
set /p ropealpha_choice="Insert Rope Alpha number: "

REM Check if input is empty
if "%ropealpha_choice%"=="" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Input cannot be empty.%reset%
    pause
    goto :edit_tabbyapi_modules_ropealpha_menu
)

REM Check if the input is a number
set "valid=true"
for /f "delims=0123456789" %%i in ("!ropealpha_choice!") do set "valid=false"
if "!valid!"=="false" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input: Not a number.%reset%
    pause
    goto :edit_tabbyapi_modules_ropealpha_menu
)

REM Handle 'Cancel' selection
if "!ropealpha_choice!"=="0" (
    goto :edit_tabbyapi_modules
)

REM Handle 'Disable' selection
if "!ropealpha_choice!"=="00" (
    set "tabbyapi_ropealpha_trigger=false"
    call :save_tabbyapi_modules
    goto :edit_tabbyapi_modules
)

REM Set the ropealpha and enable the trigger
set "tabbyapi_ropealpha=!ropealpha_choice!"
set "tabbyapi_ropealpha_trigger=true"
call :save_tabbyapi_modules
goto :edit_tabbyapi_modules



:edit_tabbyapi_modules_cachemode_menu
title STL [EDIT TABBYAPI CACHE MODE]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules / Cache Mode%reset%
echo -------------------------------------------------------------

        set "cachemode=FP16 FP8 Q4"
        set /a count=1

        for %%r in (%cachemode%) do (
            if "%%r"=="FP16" (
                echo !count!. %%r
            ) else if "%%r"=="FP8" (
                echo !count!. %%r
            ) else if "%%r"=="Q4" (
                echo !count!. %%r
            ) else (
                echo !count!. %%r
            )
            set /a count+=1
        )
        echo %red_fg_strong%00. Disable this module%reset%
        echo 0. Cancel
        echo.
        set /p cachemode_choice="Choose a Cache Mode: "

        if "!cachemode_choice!"=="0" (
            goto :edit_tabbyapi_modules
        ) else if "!cachemode_choice!"=="00" (
            set "tabbyapi_cachemode_trigger=false"
            call :save_tabbyapi_modules
            goto :edit_tabbyapi_modules
        ) else (
            set /a idx=cachemode_choice 
            set /a count=1
            for %%r in (%cachemode%) do (
                if "!count!"=="!idx!" (
                    set "tabbyapi_cachemode_trigger=true"
                    set "tabbyapi_cachemode=%%r"
                    call :save_tabbyapi_modules
                    goto :edit_tabbyapi_modules
                )
                set /a count+=1
            )
        )

        echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
        echo %red_bg%[%time%]%reset% %echo_invalidinput%
        pause
        goto :edit_tabbyapi_modules_cachemode_menu



REM ##################################################################################################################################################
REM ##################################################   SAVE MODULES SETTINGS TO FILE   #############################################################
REM ##################################################################################################################################################

:save_tabbyapi_modules
REM Compile the Python command
set "python_command=python start.py"
if "!selected_tabbyapi_model_folder_trigger!"=="true" (
    set "python_command=!python_command! --model-name !selected_tabbyapi_model_folder!"
)
if "!tabbyapi_ignoreupdate_trigger!"=="true" (
    set "python_command=!python_command! --ignore-upgrade"
)
if "!tabbyapi_port_trigger!"=="true" (
    set "python_command=!python_command! --port !tabbyapi_port!"
)
if "!tabbyapi_host_trigger!"=="true" (
    set "python_command=!python_command! --host 0.0.0.0"
)
if "!tabbyapi_maxseqlen_trigger!"=="true" (
    set "python_command=!python_command! --max-seq-len !tabbyapi_maxseqlen!"
)
if "!tabbyapi_ropealpha_trigger!"=="true" (
    set "python_command=!python_command! --rope-alpha !tabbyapi_ropealpha!"
)
if "!tabbyapi_cachemode_trigger!"=="true" (
    set "python_command=!python_command! --cache-mode !tabbyapi_cachemode!"
)
if "!tabbyapi_updatedeps_trigger!"=="true" (
    set "python_command=!python_command! --update-deps"
)

REM Save all settings including the start command to modules-tabbyapi.txt
(
    echo selected_tabbyapi_model_folder_trigger=!selected_tabbyapi_model_folder_trigger!
    echo selected_tabbyapi_model_folder=!selected_tabbyapi_model_folder!
    echo tabbyapi_ignoreupdate_trigger=!tabbyapi_ignoreupdate_trigger!
    echo tabbyapi_port_trigger=!tabbyapi_port_trigger!
    echo tabbyapi_port=!tabbyapi_port!
    echo tabbyapi_host_trigger=!tabbyapi_host_trigger!
    echo tabbyapi_maxseqlen_trigger=!tabbyapi_maxseqlen_trigger!
    echo tabbyapi_maxseqlen=!tabbyapi_maxseqlen!
    echo tabbyapi_ropealpha_trigger=!tabbyapi_ropealpha_trigger!
    echo tabbyapi_ropealpha=!tabbyapi_ropealpha!
    echo tabbyapi_cachemode_trigger=!tabbyapi_cachemode_trigger!
    echo tabbyapi_cachemode=!tabbyapi_cachemode!
    echo tabbyapi_updatedeps_trigger=!tabbyapi_updatedeps_trigger!
) > "%tabbyapi_modules_path%"

REM remove modules_enable
set "modules_enable="

REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-tabbyapi.txt for testing
echo tabbyapi_start_command=%python_command% >> %tabbyapi_modules_path%

if exist "%tabbyapi_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%tabbyapi_modules_path%"') do (
        set "%%A=%%B"
    )
)

goto :edit_tabbyapi_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b

REM ##################################################################################################################################################
REM ###############################################   SAVE MODULES SETTINGS TO FILE THEN EXIT  #######################################################
REM ##################################################################################################################################################

:save_tabbyapi_modules_exit
REM Compile the Python command
set "python_command=python start.py"
if "!selected_tabbyapi_model_folder_trigger!"=="true" (
    set "python_command=!python_command! --model-name !selected_tabbyapi_model_folder!"
)
if "!tabbyapi_ignoreupdate_trigger!"=="true" (
    set "python_command=!python_command! --ignore-upgrade"
)
if "!tabbyapi_port_trigger!"=="true" (
    set "python_command=!python_command! --port !tabbyapi_port!"
)
if "!tabbyapi_host_trigger!"=="true" (
    set "python_command=!python_command! --host 0.0.0.0"
)
if "!tabbyapi_maxseqlen_trigger!"=="true" (
    set "python_command=!python_command! --max-seq-len !tabbyapi_maxseqlen!"
)
if "!tabbyapi_ropealpha_trigger!"=="true" (
    set "python_command=!python_command! --rope-alpha !tabbyapi_ropealpha!"
)
if "!tabbyapi_cachemode_trigger!"=="true" (
    set "python_command=!python_command! --cache-mode !tabbyapi_cachemode!"
)
if "!tabbyapi_updatedeps_trigger!"=="true" (
    set "python_command=!python_command! --update-deps"
)

REM Save all settings including the start command to modules-tabbyapi.txt
(
    echo selected_tabbyapi_model_folder_trigger=!selected_tabbyapi_model_folder_trigger!
    echo selected_tabbyapi_model_folder=!selected_tabbyapi_model_folder!
    echo tabbyapi_ignoreupdate_trigger=!tabbyapi_ignoreupdate_trigger!
    echo tabbyapi_port_trigger=!tabbyapi_port_trigger!
    echo tabbyapi_port=!tabbyapi_port!
    echo tabbyapi_host_trigger=!tabbyapi_host_trigger!
    echo tabbyapi_maxseqlen_trigger=!tabbyapi_maxseqlen_trigger!
    echo tabbyapi_maxseqlen=!tabbyapi_maxseqlen!
    echo tabbyapi_ropealpha_trigger=!tabbyapi_ropealpha_trigger!
    echo tabbyapi_ropealpha=!tabbyapi_ropealpha!
    echo tabbyapi_cachemode_trigger=!tabbyapi_cachemode_trigger!
    echo tabbyapi_cachemode=!tabbyapi_cachemode!
    echo tabbyapi_updatedeps_trigger=!tabbyapi_updatedeps_trigger!
) > "%tabbyapi_modules_path%"


REM Save the constructed Python command to modules-tabbyapi.txt for testing
echo tabbyapi_start_command=%python_command% >> %tabbyapi_modules_path%

if exist "%tabbyapi_modules_path%" (
    for /f "tokens=1,* delims==" %%A in ('type "%tabbyapi_modules_path%"') do (
        set "%%A=%%B"
    )
)

exit /b