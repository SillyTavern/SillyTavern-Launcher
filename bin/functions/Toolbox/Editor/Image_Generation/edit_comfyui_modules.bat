@echo off

REM ############################################################
REM ############## EDIT COMFYUI MODULES - FRONTEND #############
REM ############################################################
:edit_comfyui_modules
title STL [EDIT COMFYUI MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Image Generation / Edit comfyui Modules%reset%
echo -------------------------------------------------------------
echo Choose comfyui modules to enable or disable (e.g., "2 3 5" to enable port, listen, and medvram)

REM Display module options with colors based on their status
call :printModule "1. Disable Auto Launch (--disable-auto-launch)" %comfyui_disableautolaunch_trigger%
call :printModule "2. Port (--port 7969)" %comfyui_port_trigger%
call :printModule "3. Listen (--listen)" %comfyui_listen_trigger%
call :printModule "4. Low VRAM (--lowvram)" %comfyui_lowvram_trigger%
call :printModule "5. Med VRAM (--medvram)" %comfyui_medvram_trigger%
call :printModule "6. Use CPU Only (--cpu)" %comfyui_cpu_trigger%
echo 00. Quick Start ComfyUI
echo 0. Back

set "python_command="

set /p comfyui_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%comfyui_module_choices%) do (
    if "%%i"=="1" (
        if "%comfyui_disableautolaunch_trigger%"=="true" (
            set "comfyui_disableautolaunch_trigger=false"
        ) else (
            set "comfyui_disableautolaunch_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%comfyui_port_trigger%"=="true" (
            set "comfyui_port_trigger=false"
        ) else (
            set "comfyui_port_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%comfyui_listen_trigger%"=="true" (
            set "comfyui_listen_trigger=false"
        ) else (
            set "comfyui_listen_trigger=true"
        )


    ) else if "%%i"=="4" (
        if "%comfyui_lowvram_trigger%"=="true" (
            set "comfyui_lowvram_trigger=false"
        ) else (
            set "comfyui_lowvram_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%comfyui_medvram_trigger%"=="true" (
            set "comfyui_medvram_trigger=false"
        ) else (
            set "comfyui_medvram_trigger=true"
        )

    ) else if "%%i"=="6" (
        if "%comfyui_cpu_trigger%"=="true" (
            set "comfyui_cpu_trigger=false"
        ) else (
            set "comfyui_cpu_trigger=true"
        )

    ) else if "%%i"=="00" (
        set "caller=app_launcher_image_generation"
        if exist "%app_launcher_image_generation_dir%\start_comfyui.bat" (
            call %app_launcher_image_generation_dir%\start_comfyui.bat
            goto :home
        ) else (
            echo [%DATE% %TIME%] ERROR: start_comfyui.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
            echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_comfyui.bat not found in: %app_launcher_image_generation_dir%%reset%
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
            git pull
            pause
            goto :edit_comfyui_modules
        )

    ) else if "%%i"=="0" (
        goto :editor_image_generation
    )
)

REM Save the module flags to modules-comfyui
echo comfyui_disableautolaunch_trigger=%comfyui_disableautolaunch_trigger%>%comfyui_modules_path%
echo comfyui_port_trigger=%comfyui_port_trigger%>>%comfyui_modules_path%
echo comfyui_listen_trigger=%comfyui_listen_trigger%>>%comfyui_modules_path%
echo comfyui_lowvram_trigger=%comfyui_lowvram_trigger%>>%comfyui_modules_path%
echo comfyui_medvram_trigger=%comfyui_medvram_trigger%>>%comfyui_modules_path%
echo comfyui_cpu_trigger=%comfyui_cpu_trigger%>>%comfyui_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python main.py"
if "%comfyui_disableautolaunch_trigger%"=="true" (
    set "python_command=%python_command% --disable-auto-launch"
)


if "%comfyui_port_trigger%"=="true" (
    set "python_command=%python_command% --port 7969"
)

if "%comfyui_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)

if "%comfyui_lowvram_trigger%"=="true" (
    set "python_command=%python_command% --lowvram"
)

if "%comfyui_medvram_trigger%"=="true" (
    set "python_command=%python_command% --medvram"
)

if "%comfyui_cpu_trigger%"=="true" (
    set "python_command=%python_command% --cpu"
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

REM Save the constructed Python command to modules-comfyui for testing
echo comfyui_start_command=%python_command%>>%comfyui_modules_path%
goto :edit_comfyui_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b
