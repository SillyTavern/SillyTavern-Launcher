@echo off

REM ############################################################
REM ############## EDIT SDWEBUIFORGE MODULES - FRONTEND ########
REM ############################################################
:edit_sdwebuiforge_modules
title STL [EDIT SDWEBUIFORGE MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Image Generation / Edit Stable Diffusion WebUI Forge Modules%reset%
echo -------------------------------------------------------------
echo Choose sdwebuiforge modules to enable or disable (e.g., "1 2 4" to enable autolaunch, api, and opt-sdp-attention)

REM Display module options with colors based on their status
call :printModule "1. autolaunch (--autolaunch)" %sdwebuiforge_autolaunch_trigger%
call :printModule "2. api (--api)" %sdwebuiforge_api_trigger%
call :printModule "3. port (--port 7900)" %sdwebuiforge_port_trigger%
call :printModule "4. opt-sdp-attention (--opt-sdp-attention)" %sdwebuiforge_optsdpattention_trigger%
call :printModule "5. listen (--listen)" %sdwebuiforge_listen_trigger%
call :printModule "6. theme dark (--theme dark)" %sdwebuiforge_themedark_trigger%
call :printModule "7. skip torchcudatest (--skip-torch-cuda-test)" %sdwebuiforge_skiptorchcudatest_trigger%
call :printModule "8. low vram (--lowvram)" %sdwebuiforge_lowvram_trigger%
call :printModule "9. med vram (--medvram)" %sdwebuiforge_medvram_trigger%
call :printModule "10. cuda malloc (--cuda-malloc)" %sdwebuiforge_cudamalloc_trigger%
echo 00. Quick Start Stable Diffusion WebUI Forge
echo 0. Back

set "python_command="

set /p xtts_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%xtts_module_choices%) do (
    if "%%i"=="1" (
        if "%sdwebuiforge_autolaunch_trigger%"=="true" (
            set "sdwebuiforge_autolaunch_trigger=false"
        ) else (
            set "sdwebuiforge_autolaunch_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%sdwebuiforge_api_trigger%"=="true" (
            set "sdwebuiforge_api_trigger=false"
        ) else (
            set "sdwebuiforge_api_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%sdwebuiforge_port_trigger%"=="true" (
            set "sdwebuiforge_port_trigger=false"
        ) else (
            set "sdwebuiforge_port_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%sdwebuiforge_optsdpattention_trigger%"=="true" (
            set "sdwebuiforge_optsdpattention_trigger=false"
        ) else (
            set "sdwebuiforge_optsdpattention_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%sdwebuiforge_listen_trigger%"=="true" (
            set "sdwebuiforge_listen_trigger=false"
        ) else (
            set "sdwebuiforge_listen_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%sdwebuiforge_themedark_trigger%"=="true" (
            set "sdwebuiforge_themedark_trigger=false"
        ) else (
            set "sdwebuiforge_themedark_trigger=true"
        )
    ) else if "%%i"=="7" (
        if "%sdwebuiforge_skiptorchcudatest_trigger%"=="true" (
            set "sdwebuiforge_skiptorchcudatest_trigger=false"
        ) else (
            set "sdwebuiforge_skiptorchcudatest_trigger=true"
        )
    ) else if "%%i"=="8" (
        if "%sdwebuiforge_lowvram_trigger%"=="true" (
            set "sdwebuiforge_lowvram_trigger=false"
        ) else (
            set "sdwebuiforge_lowvram_trigger=true"
        )
    ) else if "%%i"=="9" (
        if "%sdwebuiforge_medvram_trigger%"=="true" (
            set "sdwebuiforge_medvram_trigger=false"
        ) else (
            set "sdwebuiforge_medvram_trigger=true"
        )
    ) else if "%%i"=="10" (
        if "%sdwebuiforge_cudamalloc_trigger%"=="true" (
            set "sdwebuiforge_cudamalloc_trigger=false"
        ) else (
            set "sdwebuiforge_cudamalloc_trigger=true"
        )

    ) else if "%%i"=="00" (
        set "caller=app_launcher_image_generation"
        if exist "%app_launcher_image_generation_dir%\start_sdwebuiforge.bat" (
            call %app_launcher_image_generation_dir%\start_sdwebuiforge.bat
            goto :home
        ) else (
            echo [%DATE% %TIME%] ERROR: start_sdwebuiforge.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
            echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_sdwebuiforge.bat not found in: %app_launcher_image_generation_dir%%reset%
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
            git pull
            pause
            goto :edit_sdwebuiforge_modules
        )

    ) else if "%%i"=="0" (
        goto :editor_image_generation
    )
)

REM Save the module flags to modules-sdwebuiforge
echo sdwebuiforge_autolaunch_trigger=%sdwebuiforge_autolaunch_trigger%>%sdwebuiforge_modules_path%
echo sdwebuiforge_api_trigger=%sdwebuiforge_api_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_port_trigger=%sdwebuiforge_port_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_optsdpattention_trigger=%sdwebuiforge_optsdpattention_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_listen_trigger=%sdwebuiforge_listen_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_themedark_trigger=%sdwebuiforge_themedark_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_skiptorchcudatest_trigger=%sdwebuiforge_skiptorchcudatest_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_lowvram_trigger=%sdwebuiforge_lowvram_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_medvram_trigger=%sdwebuiforge_medvram_trigger%>>%sdwebuiforge_modules_path%
echo sdwebuiforge_cudamalloc_trigger=%sdwebuiforge_cudamalloc_trigger%>>%sdwebuiforge_modules_path%

REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python launch.py"
if "%sdwebuiforge_autolaunch_trigger%"=="true" (
    set "python_command=%python_command% --autolaunch"
)
if "%sdwebuiforge_api_trigger%"=="true" (
    set "python_command=%python_command% --api"
)
if "%sdwebuiforge_port_trigger%"=="true" (
    set "python_command=%python_command% --port 7900"
)
if "%sdwebuiforge_optsdpattention_trigger%"=="true" (
    set "python_command=%python_command% --opt-sdp-attention"
)
if "%sdwebuiforge_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%sdwebuiforge_themedark_trigger%"=="true" (
    set "python_command=%python_command% --theme dark"
)
if "%sdwebuiforge_skiptorchcudatest_trigger%"=="true" (
    set "python_command=%python_command% --skip-torch-cuda-test"
)
if "%sdwebuiforge_lowvram_trigger%"=="true" (
    set "python_command=%python_command% --lowvram"
)
if "%sdwebuiforge_medvram_trigger%"=="true" (
    set "python_command=%python_command% --medvram"
)
if "%sdwebuiforge_cudamalloc_trigger%"=="true" (
    set "python_command=%python_command% --cuda-malloc"
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

REM Save the constructed Python command to modules-sdwebuiforge for testing
echo sdwebuiforge_start_command=%python_command%>>%sdwebuiforge_modules_path%
goto :edit_sdwebuiforge_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b
