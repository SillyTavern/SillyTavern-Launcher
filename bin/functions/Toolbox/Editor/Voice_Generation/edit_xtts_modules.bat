@echo off

REM ############################################################
REM ############## EDIT XTTS MODULES - FRONTEND ################
REM ############################################################
:edit_xtts_modules
title STL [EDIT XTTS MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Edit XTTS Modules%reset%
echo -------------------------------------------------------------
echo Choose XTTS modules to enable or disable (e.g., "1 2 4" to enable Cuda, hs, and cache)

REM Display module options with colors based on their status
call :printModule "1. cuda (--device cuda)" %xtts_cuda_trigger%
call :printModule "2. hs (-hs 0.0.0.0)" %xtts_hs_trigger%
call :printModule "3. deepspeed (--deepspeed)" %xtts_deepspeed_trigger%
call :printModule "4. cache (--use-cache)" %xtts_cache_trigger%
call :printModule "5. listen (--listen)" %xtts_listen_trigger%
call :printModule "6. model (--model-source local)" %xtts_model_trigger%
echo 00. Quick Start XTTS
echo 0. Back

set "python_command="

set /p xtts_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%xtts_module_choices%) do (
    if "%%i"=="1" (
        if "%xtts_cuda_trigger%"=="true" (
            set "xtts_cuda_trigger=false"
        ) else (
            set "xtts_cuda_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%xtts_hs_trigger%"=="true" (
            set "xtts_hs_trigger=false"
        ) else (
            set "xtts_hs_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%xtts_deepspeed_trigger%"=="true" (
            set "xtts_deepspeed_trigger=false"
        ) else (
            set "xtts_deepspeed_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%xtts_cache_trigger%"=="true" (
            set "xtts_cache_trigger=false"
        ) else (
            set "xtts_cache_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%xtts_listen_trigger%"=="true" (
            set "xtts_listen_trigger=false"
        ) else (
            set "xtts_listen_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%xtts_model_trigger%"=="true" (
            set "xtts_model_trigger=false"
        ) else (
            set "xtts_model_trigger=true"
        )

    ) else if "%%i"=="00" (
        goto :start_xtts

    ) else if "%%i"=="0" (
        goto :editor_voice_generation
    )
)

REM Save the module flags to modules-xtts
echo xtts_cuda_trigger=%xtts_cuda_trigger%>%xtts_modules_path%
echo xtts_hs_trigger=%xtts_hs_trigger%>>%xtts_modules_path%
echo xtts_deepspeed_trigger=%xtts_deepspeed_trigger%>>%xtts_modules_path%
echo xtts_cache_trigger=%xtts_cache_trigger%>>%xtts_modules_path%
echo xtts_listen_trigger=%xtts_listen_trigger%>>%xtts_modules_path%
echo xtts_model_trigger=%xtts_model_trigger%>>%xtts_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python -m xtts_api_server"
if "%xtts_cuda_trigger%"=="true" (
    set "python_command=%python_command% --device cuda"
)
if "%xtts_hs_trigger%"=="true" (
    set "python_command=%python_command% -hs 0.0.0.0"
)
if "%xtts_deepspeed_trigger%"=="true" (
    set "python_command=%python_command% --deepspeed"
)
if "%xtts_cache_trigger%"=="true" (
    set "python_command=%python_command% --use-cache"
)
if "%xtts_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%xtts_model_trigger%"=="true" (
    set "python_command=%python_command% --model-source local"
)

REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-xtts for testing
echo xtts_start_command=%python_command%>>%xtts_modules_path%
goto :edit_xtts_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b