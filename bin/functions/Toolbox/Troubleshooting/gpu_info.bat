@echo off

REM Initialize variables
set "GPU_name=Unknown"
set "VRAM=Unknown"
set "GPU_TYPE=Unknown"
set "primary_gpu_found=false"
set "gpuDetected=false"
setlocal enabledelayedexpansion

REM Detect GPU name using wmic based on AdapterRAM size
for /f "tokens=2 delims==" %%f in ('wmic path Win32_VideoController where "AdapterRAM > 0" get name /value ^| find "="') do (
    set "current_gpu=%%f"
    if /i "!current_gpu!" neq "Microsoft Basic Display Adapter" (
        set "GPU_name=!current_gpu!"
        set "primary_gpu_found=true"
        goto :vram_check
    ) else if "!primary_gpu_found!" equ "false" (
        set "GPU_name=!current_gpu!"
        goto :vram_check
    )
)

:vram_check
REM Run PowerShell command to retrieve VRAM size and divide by 1GB
for /f "usebackq tokens=*" %%i in (`powershell -Command "$qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'; if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) { $qwMemorySize = [double]$qwMemorySize[0] } else { $qwMemorySize = [double]$qwMemorySize }; if ($null -ne $qwMemorySize) { [math]::Round($qwMemorySize/1GB) } else { 'Property not found' }"`) do (
    set "VRAM=%%i"
)
set "gpuDetected=true"

:gpu_found
if "%gpuDetected%"=="true" (
    echo GPU: %cyan_fg_strong%%GPU_name%%reset% - VRAM: %cyan_fg_strong%%VRAM%%reset% GB
) else (
    echo GPU Info not found
)

endlocal
