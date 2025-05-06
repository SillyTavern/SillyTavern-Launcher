@echo off
:info_vram
title STL [VRAM INFO]
chcp 65001 > nul
setlocal enabledelayedexpansion

REM Confirm script start and input arguments
set "UVRAM=%~1"

REM Handle undefined or invalid UVRAM
if not defined UVRAM (
    echo DEBUG: UVRAM is not defined. Defaulting to 0.
    set "UVRAM=0"
) else if "%UVRAM%"=="Property not found" (
    echo DEBUG: UVRAM could not be detected. Defaulting to 0.
    set "UVRAM=0"
)

REM Get GPU information safely using PowerShell
set "gpu_info="
for /f "tokens=*" %%i in ('powershell -Command "Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name -First 1"') do (
    if not "%%i"=="" set "gpu_info=%%i"
)

cls
echo %blue_fg_strong%^| ^> / Home / VRAM ^& LLM Info                                                                           ^|%reset%
echo %blue_fg_strong% ======================================================================================================%reset%   
REM Recommendations Based on VRAM Size
if %UVRAM% lss 8 (
    @REM echo %cyan_fg_strong%GPU: %gpu_info:~1%%reset%
    echo %cyan_fg_strong%GPU VRAM: %UVRAM% GB%reset% - It's recommended to stick with APIs like OpenAI, Claude or OpenRouter for LLM usage, 
    echo Local models will result in memory error or perform a REAL SLOW output
) else if %UVRAM% lss 12 (
    @REM echo %cyan_fg_strong%GPU: %gpu_info:~1%%reset%
    echo %cyan_fg_strong%GPU VRAM: %UVRAM% GB%reset% - Great for 7B and 8B models. Check info below for BPW
    endlocal
    echo.
    echo ╔══ EXL2 - RECOMMENDED BPW [Bits Per Weight] ═════════════════════════════════════════════════════════════════════════════════╗
    echo ║ Branch ║ Bits ║ lm_head bits ║ VRAM - 4k ║ VRAM - 8k ║ VRAM - 16k ║ VRAM - 32k ║ Description                                ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 8.0    ║ 8.0  ║ 8.0          ║ 10.1 GB   ║ 10.5 GB   ║ 11.5 GB    ║ 13.6 GB    ║ Maximum quality that ExLlamaV2             ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ can produce, near unquantized performance. ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 6.5    ║ 6.5  ║ 8.0          ║ 8.9 GB    ║ 9.3 GB    ║ 10.3 GB    ║ 12.4 GB    ║ similar to 8.0, good tradeoff of           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ size vs performance.                       ║
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo %green_bg%║ 5.0    ║ 5.0  ║ 6.0          ║ 7.7 GB    ║ 8.1 GB    ║ 9.1 GB     ║ 11.2 GB    ║ Slightly lower quality vs 6.5,             ║%reset%
    echo %green_bg%║        ║      ║              ║           ║           ║            ║            ║ but usable on 8GB cards. RECOMMENDED       ║%reset%
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo ║ 4.25   ║ 4.25 ║ 6.0          ║ 7.0 GB    ║ 7.4 GB    ║ 8.4 GB     ║ 10.5 GB    ║ GPTQ equivalent bits per weight,           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ slightly higher quality.                   ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 3.5    ║ 3.5  ║ 6.0          ║ 6.4 GB    ║ 6.8 GB    ║ 7.8 GB     ║ 9.9 GB     ║ Lower quality, only use if you have to.    ║
    echo ╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
    echo.
) else if %UVRAM% lss 22 (
    @REM echo %cyan_fg_strong%GPU: %gpu_info:~1%%reset%
    echo %cyan_fg_strong%GPU VRAM: %UVRAM% GB%reset% - Great for 7B, 8B and 13B models. Check info below for BPW
    endlocal
    echo.
    echo ╔══ EXL2 - RECOMMENDED BPW [Bits Per Weight] ═════════════════════════════════════════════════════════════════════════════════╗
    echo ║ Branch ║ Bits ║ lm_head bits ║ VRAM - 4k ║ VRAM - 8k ║ VRAM - 16k ║ VRAM - 32k ║ Description                                ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 8.0    ║ 8.0  ║ 8.0          ║ 10.1 GB   ║ 10.5 GB   ║ 11.5 GB    ║ 13.6 GB    ║ Maximum quality that ExLlamaV2             ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ can produce, near unquantized performance. ║
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo %green_bg%║ 6.5    ║ 6.5  ║ 8.0          ║ 8.9 GB    ║ 9.3 GB    ║ 10.3 GB    ║ 12.4 GB    ║ similar to 8.0, good tradeoff of           ║%reset%
    echo %green_bg%║        ║      ║              ║           ║           ║            ║            ║ size vs performance, RECOMMENDED.          ║%reset%
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo ║ 5.0    ║ 5.0  ║ 6.0          ║ 7.7 GB    ║ 8.1 GB    ║ 9.1 GB     ║ 11.2 GB    ║ Slightly lower quality vs 6.5,             ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ but usable on 8GB cards.                   ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 4.25   ║ 4.25 ║ 6.0          ║ 7.0 GB    ║ 7.4 GB    ║ 8.4 GB     ║ 10.5 GB    ║ GPTQ equivalent bits per weight,           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ slightly higher quality.                   ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 3.5    ║ 3.5  ║ 6.0          ║ 6.4 GB    ║ 6.8 GB    ║ 7.8 GB     ║ 9.9 GB     ║ Lower quality, only use if you have to.    ║
    echo ╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
    echo.
) else if %UVRAM% lss 25 (
    @REM echo %cyan_fg_strong%GPU: %gpu_info:~1%%reset%
    echo %cyan_fg_strong%GPU VRAM: %UVRAM% GB%reset% - Great for 7B, 8B, 13B and 30B models, Check info below for BPW
    endlocal
    echo.
    echo ╔══ EXL2 - RECOMMENDED BPW [Bits Per Weight] ═════════════════════════════════════════════════════════════════════════════════╗
    echo ║ Branch ║ Bits ║ lm_head bits ║ VRAM - 4k ║ VRAM - 8k ║ VRAM - 16k ║ VRAM - 32k ║ Description                                ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 8.0    ║ 8.0  ║ 8.0          ║ 10.1 GB   ║ 10.5 GB   ║ 11.5 GB    ║ 13.6 GB    ║ Maximum quality that ExLlamaV2             ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ can produce, near unquantized performance. ║
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo %green_bg%║ 6.5    ║ 6.5  ║ 8.0          ║ 8.9 GB    ║ 9.3 GB    ║ 10.3 GB    ║ 12.4 GB    ║ similar to 8.0, good tradeoff of           ║%reset%
    echo %green_bg%║        ║      ║              ║           ║           ║            ║            ║ size vs performance, RECOMMENDED.          ║%reset%
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo ║ 5.0    ║ 5.0  ║ 6.0          ║ 7.7 GB    ║ 8.1 GB    ║ 9.1 GB     ║ 11.2 GB    ║ Slightly lower quality vs 6.5,             ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ but usable on 8GB cards.                   ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 4.25   ║ 4.25 ║ 6.0          ║ 7.0 GB    ║ 7.4 GB    ║ 8.4 GB     ║ 10.5 GB    ║ GPTQ equivalent bits per weight,           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ slightly higher quality.                   ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 3.5    ║ 3.5  ║ 6.0          ║ 6.4 GB    ║ 6.8 GB    ║ 7.8 GB     ║ 9.9 GB     ║ Lower quality, only use if you have to.    ║
    echo ╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
    echo.
) else if %UVRAM% gtr 25 (
    @REM echo %cyan_fg_strong%GPU: %gpu_info:~1%%reset%
    echo %cyan_fg_strong%GPU VRAM: %UVRAM% GB%reset% - Great for 7B, 8B, 13B, 30B and 70B models. Check info below for BPW
    endlocal
    echo.
    echo ╔══ EXL2 - RECOMMENDED BPW [Bits Per Weight] ═════════════════════════════════════════════════════════════════════════════════╗
    echo ║ Branch ║ Bits ║ lm_head bits ║ VRAM - 4k ║ VRAM - 8k ║ VRAM - 16k ║ VRAM - 32k ║ Description                                ║
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo %green_bg%║ 8.0    ║ 8.0  ║ 8.0          ║ 10.1 GB   ║ 10.5 GB   ║ 11.5 GB    ║ 13.6 GB    ║ Maximum quality that ExLlamaV2             ║%reset%
    echo %green_bg%║        ║      ║              ║           ║           ║            ║            ║ can produce, near unquantized performance. ║%reset%
    echo %green_bg%║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║%reset%
    echo ║ 6.5    ║ 6.5  ║ 8.0          ║ 8.9 GB    ║ 9.3 GB    ║ 10.3 GB    ║ 12.4 GB    ║ similar to 8.0, good tradeoff of           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ size vs performance, RECOMMENDED.          ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 5.0    ║ 5.0  ║ 6.0          ║ 7.7 GB    ║ 8.1 GB    ║ 9.1 GB     ║ 11.2 GB    ║ Slightly lower quality vs 6.5,             ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ but usable on 8GB cards.                   ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 4.25   ║ 4.25 ║ 6.0          ║ 7.0 GB    ║ 7.4 GB    ║ 8.4 GB     ║ 10.5 GB    ║ GPTQ equivalent bits per weight,           ║
    echo ║        ║      ║              ║           ║           ║            ║            ║ slightly higher quality.                   ║
    echo ║═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════║
    echo ║ 3.5    ║ 3.5  ║ 6.0          ║ 6.4 GB    ║ 6.8 GB    ║ 7.8 GB     ║ 9.9 GB     ║ Lower quality, only use if you have to.    ║
    echo ╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
    echo.
) else (
    echo An unexpected amount of VRAM detected or unable to detect VRAM. Check your system specifications.
)

set /p "info_vram_choice=Check for compatible models on VRAM calculator website? [Y/N]: "
if /i "%info_vram_choice%"=="Y" (
    REM Open website in default browser
    start https://sillytavernai.com/llm-model-vram-calculator/?vram=%UVRAM%
    goto :home
) else if /i "%info_vram_choice%"=="N" (
    goto :home
)

:home