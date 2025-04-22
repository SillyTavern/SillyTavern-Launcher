@echo off

REM ############################################################
REM ############## EDIT SDWEBUI MODULES - FRONTEND #############
REM ############################################################
:edit_sdwebui_modules
title STL [EDIT SDWEBUI MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Image Generation / Edit Stable Diffusion WebUI Modules%reset%
echo -------------------------------------------------------------
echo Choose SDWEBUI modules to enable or disable (e.g., "1 2 4" to enable autolaunch, api, and opt-sdp-attention)

REM Display module options with colors based on their status
call :printModule "1. autolaunch (--autolaunch)" %sdwebui_autolaunch_trigger%
call :printModule "2. api (--api)" %sdwebui_api_trigger%
call :printModule "3. port (--port 7900)" %sdwebui_port_trigger%
call :printModule "4. opt-sdp-attention (--opt-sdp-attention)" %sdwebui_optsdpattention_trigger%
call :printModule "5. listen (--listen)" %sdwebui_listen_trigger%
call :printModule "6. theme dark (--theme dark)" %sdwebui_themedark_trigger%
call :printModule "7. skip torchcudatest (--skip-torch-cuda-test)" %sdwebui_skiptorchcudatest_trigger%
call :printModule "8. low vram (--lowvram)" %sdwebui_lowvram_trigger%
call :printModule "9. med vram (--medvram)" %sdwebui_medvram_trigger%
echo 00. Quick Start Stable Diffusion WebUI
echo 0. Back

set "python_command="

set /p xtts_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%xtts_module_choices%) do (
    if "%%i"=="1" (
        if "%sdwebui_autolaunch_trigger%"=="true" (
            set "sdwebui_autolaunch_trigger=false"
        ) else (
            set "sdwebui_autolaunch_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%sdwebui_api_trigger%"=="true" (
            set "sdwebui_api_trigger=false"
        ) else (
            set "sdwebui_api_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%sdwebui_port_trigger%"=="true" (
            set "sdwebui_port_trigger=false"
        ) else (
            set "sdwebui_port_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%sdwebui_optsdpattention_trigger%"=="true" (
            set "sdwebui_optsdpattention_trigger=false"
        ) else (
            set "sdwebui_optsdpattention_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%sdwebui_listen_trigger%"=="true" (
            set "sdwebui_listen_trigger=false"
        ) else (
            set "sdwebui_listen_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%sdwebui_themedark_trigger%"=="true" (
            set "sdwebui_themedark_trigger=false"
        ) else (
            set "sdwebui_themedark_trigger=true"
        )
    ) else if "%%i"=="7" (
        if "%sdwebui_skiptorchcudatest_trigger%"=="true" (
            set "sdwebui_skiptorchcudatest_trigger=false"
        ) else (
            set "sdwebui_skiptorchcudatest_trigger=true"
        )
    ) else if "%%i"=="8" (
        if "%sdwebui_lowvram_trigger%"=="true" (
            set "sdwebui_lowvram_trigger=false"
        ) else (
            set "sdwebui_lowvram_trigger=true"
        )
    ) else if "%%i"=="9" (
        if "%sdwebui_medvram_trigger%"=="true" (
            set "sdwebui_medvram_trigger=false"
        ) else (
            set "sdwebui_medvram_trigger=true"
        )

    ) else if "%%i"=="00" (
        set "caller=app_launcher_image_generation"
        if exist "%app_launcher_image_generation_dir%\start_sdwebui.bat" (
            call %app_launcher_image_generation_dir%\start_sdwebui.bat
            goto :home
        ) else (
            echo [%DATE% %TIME%] ERROR: start_sdwebui.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
            echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_sdwebui.bat not found in: %app_launcher_image_generation_dir%%reset%
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
            git pull
            pause
            goto :edit_sdwebui_modules
        )

    ) else if "%%i"=="0" (
        goto :editor_image_generation
    )
)

REM Save the module flags to modules-sdwebui
echo sdwebui_autolaunch_trigger=%sdwebui_autolaunch_trigger%>%sdwebui_modules_path%
echo sdwebui_api_trigger=%sdwebui_api_trigger%>>%sdwebui_modules_path%
echo sdwebui_port_trigger=%sdwebui_port_trigger%>>%sdwebui_modules_path%
echo sdwebui_optsdpattention_trigger=%sdwebui_optsdpattention_trigger%>>%sdwebui_modules_path%
echo sdwebui_listen_trigger=%sdwebui_listen_trigger%>>%sdwebui_modules_path%
echo sdwebui_themedark_trigger=%sdwebui_themedark_trigger%>>%sdwebui_modules_path%
echo sdwebui_skiptorchcudatest_trigger=%sdwebui_skiptorchcudatest_trigger%>>%sdwebui_modules_path%
echo sdwebui_lowvram_trigger=%sdwebui_lowvram_trigger%>>%sdwebui_modules_path%
echo sdwebui_medvram_trigger=%sdwebui_medvram_trigger%>>%sdwebui_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python launch.py"
if "%sdwebui_autolaunch_trigger%"=="true" (
    set "python_command=%python_command% --autolaunch"
)
if "%sdwebui_api_trigger%"=="true" (
    set "python_command=%python_command% --api"
)
if "%sdwebui_port_trigger%"=="true" (
    set "python_command=%python_command% --port 7900"
)
if "%sdwebui_optsdpattention_trigger%"=="true" (
    set "python_command=%python_command% --opt-sdp-attention"
)
if "%sdwebui_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%sdwebui_themedark_trigger%"=="true" (
    set "python_command=%python_command% --theme dark"
)
if "%sdwebui_skiptorchcudatest_trigger%"=="true" (
    set "python_command=%python_command% --skip-torch-cuda-test"
)
if "%sdwebui_lowvram_trigger%"=="true" (
    set "python_command=%python_command% --lowvram"
)
if "%sdwebui_medvram_trigger%"=="true" (
    set "python_command=%python_command% --medvram"
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

REM Save the constructed Python command to modules-sdwebui for testing
echo sdwebui_start_command=%python_command%>>%sdwebui_modules_path%
goto :edit_sdwebui_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b
