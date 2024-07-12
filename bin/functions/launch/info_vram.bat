@echo off

:info_vram
title STL [VRAM INFO]
chcp 65001 > nul
cls
echo %blue_fg_strong%/ Home / VRAM Info%reset%
echo -------------------------------------------------------------
REM Recommendations Based on VRAM Size
if %VRAM% lss 8 (
    echo %cyan_fg_strong%GPU VRAM: %VRAM% GB%reset% - It's recommended to stick with APIs like OpenAI, Claude or OpenRouter for LLM usage, 
    echo Local models will result in memory error or perform a REAL SLOW output
) else if %VRAM% lss 12 (
    echo %cyan_fg_strong%GPU VRAM: %VRAM% GB%reset% - Can run 7B and 8B models. Check info below for BPW
    echo %blue_bg%╔════ BPW - Bits Per Weight ═════════════════════════════════╗%reset%
    echo %blue_bg%║                                                            ║%reset%
    echo %blue_bg%║* EXL2: 5_0                                                 ║%reset%
    echo %blue_bg%║* GGUF: Q5_K_M                                              ║%reset%
    echo %blue_bg%╚════════════════════════════════════════════════════════════╝%reset%
    echo.
) else if %VRAM% lss 22 (
    echo %cyan_fg_strong%GPU VRAM: %VRAM% GB%reset% - Can run 7B, 8B and 13B models. Check info below for BPW
    echo %blue_bg%╔════ BPW - Bits Per Weight ═════════════════════════════════╗%reset%
    echo %blue_bg%║                                                            ║%reset%
    echo %blue_bg%║* EXL2: 6_5                                                 ║%reset%
    echo %blue_bg%║* GGUF: Q5_K_M                                              ║%reset%
    echo %blue_bg%╚════════════════════════════════════════════════════════════╝%reset%
    echo.
) else if %VRAM% lss 25 (
    echo %cyan_fg_strong%GPU VRAM: %VRAM% GB%reset% - Good for 7B, 8B, 13B, 30B, and some efficient 70B models. Powerful local models will run well 
    echo.
    echo ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    echo ║ Branch ║ Bits ║ lm_head bits ║ VRAM - 4k ║ VRAM - 8k ║ VRAM - 16k ║ VRAM - 32k ║ Description                                             ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 8.0    ║ 8.0  ║ 8.0          ║ 10.1 GB   ║ 10.5 GB   ║ 11.5 GB    ║ 13.6 GB    ║ Maximum quality that ExLlamaV2 can produce, near        ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ unquantized performance.                                ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 6.5    ║ 6.5  ║ 8.0          ║ 8.9 GB    ║ 9.3 GB    ║ 10.3 GB    ║ 12.4 GB    ║ Very similar to 8.0, good tradeoff of size vs           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ performance, recommended.                               ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 5.0    ║ 5.0  ║ 6.0          ║ 7.7 GB    ║ 8.1 GB    ║ 9.1 GB     ║ 11.2 GB    ║ Slightly lower quality vs 6.5, but usable on 8GB cards. ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 4.25   ║ 4.25 ║ 6.0          ║ 7.0 GB    ║ 7.4 GB    ║ 8.4 GB     ║ 10.5 GB    ║ GPTQ equivalent bits per weight, slightly higher        ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ quality.                                                ║
    echo ║══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 3.5    ║ 3.5  ║ 6.0          ║ 6.4 GB    ║ 6.8 GB    ║ 7.8 GB     ║ 9.9 GB     ║ Lower quality, only use if you have to.                 ║
    echo ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
    echo.
) else if %VRAM% gtr 25 (
    echo %cyan_fg_strong%GPU VRAM: %VRAM% GB%reset% - Suitable for most models, including larger LLMs. 
    echo You likely have the necessary expertise to pick your own model if you possess more than 25GB of VRAM.
) else (
    echo An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.
)
echo.

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
)

echo.
echo %blue_bg%╔════ GPU INFO ═════════════════════════════════╗%reset%
echo %blue_bg%║                                               ║%reset%
echo %blue_bg%║* %gpu_info:~1%                   ║%reset%
echo %blue_bg%║                                               ║%reset%
echo %blue_bg%╚═══════════════════════════════════════════════╝%reset%
echo.

endlocal

echo Would you like to open the VRAM calculator website to check compatible models?
set /p uservram_choice=Check compatible models? [Y/N] 

REM Check if user input is not empty and is neither "Y" nor "N"
if not "%uservram_choice%"=="" (
    if /i not "%uservram_choice%"=="Y" if /i not "%uservram_choice%"=="N" (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input. Please enter Y for yes or N for no%reset%
        pause
        goto :info_vram
    )
)

if /i "%uservram_choice%"=="Y" ( start https://sillytavernai.com/llm-model-vram-calculator/?vram=%VRAM%
)
goto :home