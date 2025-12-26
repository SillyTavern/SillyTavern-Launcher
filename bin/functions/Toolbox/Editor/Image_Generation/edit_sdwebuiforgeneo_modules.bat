@echo off

REM ############################################################
REM ############## EDIT FORGE-NEO MODULES - FRONTEND ###########
REM ############################################################
:edit_sdwebuiforgeneo_modules
title STL [EDIT FORGE-NEO MODULES]
cls
echo %blue_fg_strong%^| ^> / Home / Toolbox / Editor / Image Generation / Forge NEO Modules   ^|%reset%
echo %blue_fg_strong% =========================================================================%reset%
echo Choose modules to enable or disable (e.g., "1 3 5" to toggle UV, Sage, and Cuda-Malloc)

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Performance                                                  ^|%reset%
call :printModule "1.  Use UV (Recommended)    " %sdwfn_uv_trigger%
call :printModule "2.  Xformers Attention      " %sdwfn_xformers_trigger%
call :printModule "3.  Sage Attention (Neo)    " %sdwfn_sage_trigger%
call :printModule "4.  Flash Attention (Neo)   " %sdwfn_flash_trigger%
call :printModule "5.  CUDA Malloc (Optimized) " %sdwfn_cudamalloc_trigger%
call :printModule "6.  CUDA Stream             " %sdwfn_cudastream_trigger%
call :printModule "7.  Fast FP16               " %sdwfn_fastfp16_trigger%

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| VRAM / Memory Management                                    ^|%reset%
call :printModule "8.  Always High VRAM        " %sdwfn_highvram_trigger%
call :printModule "9.  Always Low VRAM         " %sdwfn_lowvram_trigger%
call :printModule "10. BitsAndBytes (4-bit)    " %sdwfn_bnb_trigger%

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Server ^& UI                                                  ^|%reset%
call :printModule "11. Auto-Launch Browser     " %sdwfn_autolaunch_trigger%
call :printModule "12. Enable API              " %sdwfn_api_trigger%
call :printModule "13. Listen (LAN Access)     " %sdwfn_listen_trigger%
call :printModule "14. Custom Port (7900)      " %sdwfn_port_trigger%
call :printModule "15. Theme: Dark             " %sdwfn_themedark_trigger%

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    00. Save and Quick Start Forge NEO
echo    0. Back
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

:: Define a variable containing a single backspace character
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set "BS=%%A"

:: Set the prompt with spaces
set /p "sdwfn_choice=%BS%   Choose Your Destiny: "

REM Handle choices
for %%i in (%sdwfn_choice%) do (
    if "%%i"=="1" ( if "!sdwfn_uv_trigger!"=="true" (set "sdwfn_uv_trigger=false") else (set "sdwfn_uv_trigger=true") )
    if "%%i"=="2" ( if "!sdwfn_xformers_trigger!"=="true" (set "sdwfn_xformers_trigger=false") else (set "sdwfn_xformers_trigger=true") )
    if "%%i"=="3" ( if "!sdwfn_sage_trigger!"=="true" (set "sdwfn_sage_trigger=false") else (set "sdwfn_sage_trigger=true") )
    if "%%i"=="4" ( if "!sdwfn_flash_trigger!"=="true" (set "sdwfn_flash_trigger=false") else (set "sdwfn_flash_trigger=true") )
    if "%%i"=="5" ( if "!sdwfn_cudamalloc_trigger!"=="true" (set "sdwfn_cudamalloc_trigger=false") else (set "sdwfn_cudamalloc_trigger=true") )
    if "%%i"=="6" ( if "!sdwfn_cudastream_trigger!"=="true" (set "sdwfn_cudastream_trigger=false") else (set "sdwfn_cudastream_trigger=true") )
    if "%%i"=="7" ( if "!sdwfn_fastfp16_trigger!"=="true" (set "sdwfn_fastfp16_trigger=false") else (set "sdwfn_fastfp16_trigger=true") )
    if "%%i"=="8" ( if "!sdwfn_highvram_trigger!"=="true" (set "sdwfn_highvram_trigger=false") else (set "sdwfn_highvram_trigger=true") )
    if "%%i"=="9" ( if "!sdwfn_lowvram_trigger!"=="true" (set "sdwfn_lowvram_trigger=false") else (set "sdwfn_lowvram_trigger=true") )
    if "%%i"=="10" ( if "!sdwfn_bnb_trigger!"=="true" (set "sdwfn_bnb_trigger=false") else (set "sdwfn_bnb_trigger=true") )
    if "%%i"=="11" ( if "!sdwfn_autolaunch_trigger!"=="true" (set "sdwfn_autolaunch_trigger=false") else (set "sdwfn_autolaunch_trigger=true") )
    if "%%i"=="12" ( if "!sdwfn_api_trigger!"=="true" (set "sdwfn_api_trigger=false") else (set "sdwfn_api_trigger=true") )
    if "%%i"=="13" ( if "!sdwfn_listen_trigger!"=="true" (set "sdwfn_listen_trigger=false") else (set "sdwfn_listen_trigger=true") )
    if "%%i"=="14" ( if "!sdwfn_port_trigger!"=="true" (set "sdwfn_port_trigger=false") else (set "sdwfn_port_trigger=true") )
    if "%%i"=="15" ( if "!sdwfn_themedark_trigger!"=="true" (set "sdwfn_themedark_trigger=false") else (set "sdwfn_themedark_trigger=true") )
    
    if "%%i"=="00" (
        set "caller=app_launcher_image_generation"
        if exist "%app_launcher_image_generation_dir%\start_sdwebuiforgeneo.bat" (
            call %app_launcher_image_generation_dir%\start_sdwebuiforgeneo.bat
            goto :home
        ) else (
            echo [%DATE% %TIME%] ERROR: start_sdwebuiforgeneo.bat not found in: app_launcher_image_generation_dir% >> %logs_stl_console_path%
            echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] start_sdwebuiforgeneo.bat not found in: %app_launcher_image_generation_dir%%reset%
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Automatic Repair...
            git pull
            pause
            goto :edit_sdwebuiforgeneo_modules
        )

    )
    if "%%i"=="0" ( goto :editor_image_generation )
)

:save_config
REM Save module flags
(
echo sdwfn_uv_trigger=%sdwfn_uv_trigger%
echo sdwfn_xformers_trigger=%sdwfn_xformers_trigger%
echo sdwfn_sage_trigger=%sdwfn_sage_trigger%
echo sdwfn_flash_trigger=%sdwfn_flash_trigger%
echo sdwfn_cudamalloc_trigger=%sdwfn_cudamalloc_trigger%
echo sdwfn_cudastream_trigger=%sdwfn_cudastream_trigger%
echo sdwfn_fastfp16_trigger=%sdwfn_fastfp16_trigger%
echo sdwfn_highvram_trigger=%sdwfn_highvram_trigger%
echo sdwfn_lowvram_trigger=%sdwfn_lowvram_trigger%
echo sdwfn_bnb_trigger=%sdwfn_bnb_trigger%
echo sdwfn_autolaunch_trigger=%sdwfn_autolaunch_trigger%
echo sdwfn_api_trigger=%sdwfn_api_trigger%
echo sdwfn_listen_trigger=%sdwfn_listen_trigger%
echo sdwfn_port_trigger=%sdwfn_port_trigger%
echo sdwfn_themedark_trigger=%sdwfn_themedark_trigger%
) > "%sdwebuiforgeneo_modules_path%"

REM Build the Pixi command
set "python_command=pixi run python launch.py"
if "%sdwfn_uv_trigger%"=="true" set "python_command=%python_command% --uv"
if "%sdwfn_xformers_trigger%"=="true" set "python_command=%python_command% --xformers"
if "%sdwfn_sage_trigger%"=="true" set "python_command=%python_command% --sage"
if "%sdwfn_flash_trigger%"=="true" set "python_command=%python_command% --flash"
if "%sdwfn_cudamalloc_trigger%"=="true" set "python_command=%python_command% --cuda-malloc"
if "%sdwfn_cudastream_trigger%"=="true" set "python_command=%python_command% --cuda-stream"
if "%sdwfn_fastfp16_trigger%"=="true" set "python_command=%python_command% --fast-fp16"
if "%sdwfn_highvram_trigger%"=="true" set "python_command=%python_command% --always-high-vram"
if "%sdwfn_lowvram_trigger%"=="true" set "python_command=%python_command% --always-low-vram"
if "%sdwfn_bnb_trigger%"=="true" set "python_command=%python_command% --bnb"
if "%sdwfn_autolaunch_trigger%"=="true" set "python_command=%python_command% --autolaunch"
if "%sdwfn_api_trigger%"=="true" set "python_command=%python_command% --api"
if "%sdwfn_listen_trigger%"=="true" set "python_command=%python_command% --listen"
if "%sdwfn_port_trigger%"=="true" set "python_command=%python_command% --port 7900"
if "%sdwfn_themedark_trigger%"=="true" set "python_command=%python_command% --theme dark"

echo sdwfn_start_command=%python_command% >> "%sdwebuiforgeneo_modules_path%"
goto :edit_sdwebuiforgeneo_modules


:printModule
if "%2"=="true" (
    echo    %1 [%green_fg_strong%Enabled%reset%]
) else (
    echo    %1 [%red_fg_strong%Disabled%reset%]
)
exit /b