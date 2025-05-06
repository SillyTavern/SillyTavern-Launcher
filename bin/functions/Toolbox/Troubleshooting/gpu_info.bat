@echo off

REM Initialize variables
setlocal enabledelayedexpansion
set /a iteration=0
set /a last_VRAM=0
set "last_GPU=Unknown"
set "GPU_name=Unknown"
set "VRAM=Unknown"
set "primary_gpu_found=false"

REM Detect GPU and store name, excluding integrated GPUs if discrete GPUs are found
for /f "tokens=*" %%f in ('powershell -Command "Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name"') do (
    REM If GPU name is blank, set it; else, if it is not blank and does not equal the current value of f,
    REM move gpu name to last_gpu and set gpu_name to the new value.
    if /i "!GPU_name!" equ "" (
        set "GPU_name=%%f"
    ) else if "!GPU_name!" neq "%%f" (
        set "last_GPU=!GPU_name!"
        set "GPU_name=%%f"
    )

    REM Run PowerShell command to retrieve VRAM size and divide by 1GB
    for /f "usebackq tokens=*" %%i in (`powershell -Command "$qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'; if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) { $qwMemorySize = [double]$qwMemorySize[!iteration!] } else { $qwMemorySize = [double]$qwMemorySize }; if ($null -ne $qwMemorySize) { [math]::Round($qwMemorySize/1GB) } else { 'Property not found' }"`) do (
        set "VRAM=%%i"
    )

    REM Iterate to move through the objects in the PowerShell script
    set /a iteration=!iteration!+1

    REM Update VRAM and GPU name only if current VRAM is greater than last_VRAM
    if /i !VRAM! gtr !last_VRAM! (
        set /a last_VRAM=!VRAM!
        set "last_GPU=!GPU_name!"
    )
)

REM Restore the GPU name and VRAM to the one with the highest VRAM
set "GPU_name=!last_GPU!"
set "VRAM=!last_VRAM!"

REM Display GPU name and VRAM
echo GPU: %cyan_fg_strong%!GPU_name!%reset% - VRAM: %cyan_fg_strong%!VRAM!%reset% GB
endlocal