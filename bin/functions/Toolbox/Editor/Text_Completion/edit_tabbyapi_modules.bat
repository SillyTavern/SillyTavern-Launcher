@echo off

REM ############################################################
REM ############## EDIT TABBYAPI MODULES - FRONTEND ############
REM ############################################################
:edit_tabbyapi_modules
title STL [EDIT TABBYAPI MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules%reset%
echo -------------------------------------------------------------
echo Choose tabbyapi modules (e.g., "1 2 4" to enable Load Model, Ignore Auto Upgrade, and host)

echo %red_bg%WORK IN PROGRESS. NOT FINAL. OPTION 2 AND 4 ARE WORKING ALREADY. OTHERS WILL BE SOON%reset%

REM Display module options with colors based on their status
call :printModule "1. Load Model (--model-name %selected_tabbyapi_model_folder%)" %selected_tabbyapi_model_folder_trigger%
call :printModule "2. Ignore Auto Upgrade (--ignore-upgrade)" %tabbyapi_ignoreupdate_trigger%
call :printModule "3. Port (--port %tabbyapi_port%)" %tabbyapi_port_trigger%
call :printModule "4. Host (--host 0.0.0.0)" %tabbyapi_host_trigger%
call :printModule "5. Max Seq Len (--max-seq-len %tabbyapi_maxseqlen%)" %tabbyapi_maxseqlen_trigger%
call :printModule "6. Rope Alpha (--rope-alpha %tabbyapi_ropealpha%)" %tabbyapi_ropealpha_trigger%
call :printModule "7. Cache Mode (--cache-mode %tabbyapi_cachemode%)" %tabbyapi_cachemode_trigger%

echo 00. Quick Start TabbyAPI
echo 0. Back

set "python_command="

set /p tabbyapi_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%tabbyapi_module_choices%) do (
    if "%%i"=="1" (
        if "%selected_tabbyapi_model_folder_trigger%"=="true" (
            set "selected_tabbyapi_model_folder_trigger=false"
        ) else (
            set "selected_tabbyapi_model_folder_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%tabbyapi_ignoreupdate_trigger%"=="true" (
            set "tabbyapi_ignoreupdate_trigger=false"
        ) else (
            set "tabbyapi_ignoreupdate_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%tabbyapi_port_trigger%"=="true" (
            set "tabbyapi_port_trigger=false"
        ) else (
            set "tabbyapi_port_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%tabbyapi_host_trigger%"=="true" (
            set "tabbyapi_host_trigger=false"
        ) else (
            set "tabbyapi_host_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%tabbyapi_maxseqlen_trigger%"=="true" (
            set "tabbyapi_maxseqlen_trigger=false"
        ) else (
            set "tabbyapi_maxseqlen_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%tabbyapi_ropealpha_trigger%"=="true" (
            set "tabbyapi_ropealpha_trigger=false"
        ) else (
            set "tabbyapi_ropealpha_trigger=true"
        )
    ) else if "%%i"=="7" (
        if "%tabbyapi_cachemode_trigger%"=="true" (
            set "tabbyapi_cachemode_trigger=false"
        ) else (
            set "tabbyapi_cachemode_trigger=true"
        )

    ) else if "%%i"=="00" (
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
        goto :editor_text_completion
    )
)

REM ##################################################################################################################################################
REM ##################################################   SAVE MODULES SETTINGS TO FILE   #############################################################
REM ##################################################################################################################################################

:save_tabbyapi_modules
REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python start.py"
if "%selected_tabbyapi_model_folder_trigger%"=="true" (
    set "python_command=%python_command% --model-name %selected_tabbyapi_model_folder%"
)
if "%tabbyapi_ignoreupdate_trigger%"=="true" (
    set "python_command=%python_command% --ignore-upgrade"
)
if "%tabbyapi_port_trigger%"=="true" (
    set "python_command=%python_command% --port %tabbyapi_port%"
)
if "%tabbyapi_host_trigger%"=="true" (
    set "python_command=%python_command% --host 0.0.0.0"
)
if "%tabbyapi_maxseqlen_trigger%"=="true" (
    set "python_command=%python_command% --max-seq-len %tabbyapi_maxseqlen%"
)
if "%tabbyapi_ropealpha_trigger%"=="true" (
    set "python_command=%python_command% --rope-alpha %tabbyapi_ropealpha%"
)
if "%tabbyapi_cachemode_trigger%"=="true" (
    set "python_command=%python_command% --cache-mode %tabbyapi_cachemode%"
)

REM Save all audio settings including the start command to modules-audio
(
    echo selected_tabbyapi_model_folder_trigger=%selected_tabbyapi_model_folder_trigger%
    echo tabbyapi_ignoreupdate_trigger=%tabbyapi_ignoreupdate_trigger%
    echo tabbyapi_port_trigger=%tabbyapi_port_trigger%
    echo tabbyapi_host_trigger=%tabbyapi_host_trigger%
    echo tabbyapi_maxseqlen_trigger=%tabbyapi_maxseqlen_trigger%
    echo tabbyapi_ropealpha_trigger=%tabbyapi_ropealpha_trigger%
) > "%tabbyapi_modules_path%"


REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-tabbyapi for testing
echo tabbyapi_start_command=%python_command%>>%tabbyapi_modules_path%
goto :edit_tabbyapi_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b




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
set "user_count=0"
for %%a in (%tabbyapi_model_folders:|= %) do (
    echo !i!. %cyan_fg_strong%%%a%reset%
    set "tabbyapi_model_folder_!i!=%%a"
    set /a i+=1
    set /a user_count+=1
)
echo ================================================

REM If only one user folder is found, skip the selection
if %user_count%==1 (
    set "selected_tabbyapi_model_folder=!tabbyapi_model_folder_1!"
    goto skip_user_selection
)

:select_tabbyapi_model_folder
REM Prompt user to select a folder
echo %red_fg_strong%00. Disable this module%reset%
echo 0. Cancel
echo.
set "selected_tabbyapi_model_folder="
set /p user_choice="Choose a model: "

REM Check if the user wants to exit
if "%user_choice%"=="0" (
    goto :edit_tabbyapi_modules
)

REM Get the selected folder name
for /l %%i in (1,1,%user_count%) do (
    if "%user_choice%"=="%%i" set "selected_tabbyapi_model_folder=!tabbyapi_model_folder_%%i!"
)

if "%selected_tabbyapi_model_folder%"=="" (
    echo %red_fg_strong%[ERROR] Invalid selection. Please enter a number between 1 and %user_count%, or press 0 to cancel.%reset%
    pause
    goto :create_backup
)

:skip_user_selection
REM Replace backslashes with double backslashes in tabbyapi_install_path
set "escaped_tabbyapi_install_path=%tabbyapi_install_path:\=\\%"


REM save selected model in variable
REM echo "%tabbyapi_install_path%\models\%selected_tabbyapi_model_folder%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Model selected at %tabbyapi_install_path%\models\%selected_tabbyapi_model_folder%%reset%

pause
goto :edit_tabbyapi_modules




:edit_tabbyapi_modules_port_menu
title STL [EDIT TABBYAPI PORT]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit TabbyAPI Modules / Port%reset%
echo -------------------------------------------------------------

set "port=5001 5002 5003"
set /a count=1

REM Display port options
for %%a in (%port%) do (
    echo !count!. %%a
    set /a count+=1
)
echo %red_fg_strong%00. Disable this module%reset%
echo 0. Cancel
set /p port_choice="Choose a Port: "

REM Handle 'Cancel' selection
if "!port_choice!"=="0" (
    goto :edit_tabbyapi_modules
)

REM Handle 'Disable' selection
if "!port_choice!"=="00" (
    set "tabbyapi_port_trigger=false"
    call :save_audio_settings
    goto :edit_tabbyapi_modules
)

REM Adjust index to map to format list
set /a idx=!port_choice! 
set /a validChoiceMax=count 

REM Set format based on selection and enable the trigger
if "!port_choice!" geq "1" if "!port_choice!" leq "!validChoiceMax!" (
    set /a fcount=1
    for %%a in (%port%) do (
        if "!fcount!"=="!idx!" (
            set "tabbyapi_port=%%a"
            set "tabbyapi_port_trigger=true"
            call :save_audio_settings
            goto :edit_tabbyapi_modules
        )
        set /a fcount+=1
    )
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %log_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :edit_tabbyapi_modules_port_menu
)




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
cls
set /p tabbyapi_maxseqlen_custom="(0 to cancel)Insert Custom Max Seq Len Value: "
if "%tabbyapi_maxseqlen_custom%"=="0" goto :edit_tabbyapi_modules_maxseqlen_menu


pause
goto :edit_tabbyapi_modules_maxseqlen_menu