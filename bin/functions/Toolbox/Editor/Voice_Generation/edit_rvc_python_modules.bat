@echo off

REM ############################################################
REM ############## EDIT rvc-python MODULES - FRONTEND ##########
REM ############################################################
:edit_rvc_python_modules
title STL [EDIT RVC-PYTHON MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Voice Generation / Edit RVC-PYTHON Modules%reset%
echo -------------------------------------------------------------
echo Choose RVC modules to enable or disable (e.g., "1 2 4" to enable CUDA, Harvest, and Preload Model)

REM Display module options with colors based on their status
call :printModule "1. CUDA (--device cuda:0)" %rvc_python_cuda_trigger%
call :printModule "2. Harvest Method (--method harvest)" %rvc_python_harvest_trigger%
call :printModule "3. Listen (--listen)" %rvc_python_listen_trigger%
call :printModule "4. Preload Model (--preload-model)" %rvc_python_preload_trigger%
echo 00. Quick Start RVC-Python
echo 0. Back

set "python_command="

set /p rvc_python_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%rvc_python_module_choices%) do (
    if "%%i"=="1" (
        if "%rvc_python_cuda_trigger%"=="true" (
            set "rvc_python_cuda_trigger=false"
        ) else (
            set "rvc_python_cuda_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%rvc_python_harvest_trigger%"=="true" (
            set "rvc_python_harvest_trigger=false"
        ) else (
            set "rvc_python_harvest_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%rvc_python_listen_trigger%"=="true" (
            set "rvc_python_listen_trigger=false"
        ) else (
            set "rvc_python_listen_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%rvc_python_preload_trigger%"=="true" (
            set "rvc_python_preload_trigger=false"
        ) else (
            set "rvc_python_preload_trigger=true"
        )

    ) else if "%%i"=="00" (
        set "caller=app_launcher_voice_generation"
        if exist "%app_launcher_voice_generation_dir%\start_rvc_python.bat" (
            call %app_launcher_voice_generation_dir%\start_rvc_python.bat
            goto :home
        ) else (
            echo [%DATE% %TIME%] ERROR: start_rvc_python.bat not found in: app_launcher_voice_generation_dir% >> %logs_stl_console_path%
            echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_rvc_python.bat not found in: %app_launcher_voice_generation_dir%%reset%
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
            git pull
            pause
            goto :edit_rvc_python_modules
        )

    ) else if "%%i"=="0" (
        goto :editor_voice_generation
    )
)

REM Save the module flags to rvc-python
echo rvc_python_cuda_trigger=%rvc_python_cuda_trigger%>%rvc_python_modules_path%
echo rvc_python_harvest_trigger=%rvc_python_harvest_trigger%>>%rvc_python_modules_path%
echo rvc_python_listen_trigger=%rvc_python_listen_trigger%>>%rvc_python_modules_path%
echo rvc_python_preload_trigger=%rvc_python_preload_trigger%>>%rvc_python_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command (default to API mode; adjust for CLI if needed)
set "python_command=python -m rvc_python api"
if "%rvc_python_cuda_trigger%"=="true" (
    set "python_command=%python_command% --device cuda:0"
) else (
    set "python_command=%python_command% --device cpu"
)
if "%rvc_python_harvest_trigger%"=="true" (
    set "python_command=%python_command% --method harvest"
)
if "%rvc_python_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%rvc_python_preload_trigger%"=="true" (
    set "python_command=%python_command% --preload-model default_model.pth"
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

REM Save the constructed Python command to rvc-python for testing
echo rvc_python_start_command=%python_command%>>%rvc_python_modules_path%
goto :edit_rvc_python_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b
