@echo off

REM Initialize variables
set "GPU_names="
set "VRAMs="
set "TotalVRAM=0"
set "gpuDetected=false"
setlocal enabledelayedexpansion

REM Detect GPU names using wmic and store them in GPU_names
for /f "tokens=2 delims==" %%f in ('wmic path Win32_VideoController where "AdapterRAM > 0" get name /value ^| find "="') do (
    set "current_gpu=%%f"
    if /i "!current_gpu!" neq "Microsoft Basic Display Adapter" (
        if /i "!current_gpu!" neq "Intel(R) UHD Graphics" (
            if defined GPU_names (
                set "GPU_names=!GPU_names!, !current_gpu!"
            ) else (
                set "GPU_names=!current_gpu!"
            )
        )
    )
)

REM Detect VRAM for each GPU found
set "GPU_index=0"
for %%G in (%GPU_names%) do (
    set /a "GPU_index+=1"
    for /f "usebackq tokens=*" %%i in (`powershell -Command "$qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'; if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) { $qwMemorySize = [double]$qwMemorySize[0] } else { $qwMemorySize = [double]$qwMemorySize }; if ($null -ne $qwMemorySize) { [math]::Round($qwMemorySize/1GB) } else { 'Property not found' }"`) do (
        set /a "TotalVRAM+=%%i"
        if defined VRAMs (
            set "VRAMs=!VRAMs!, %%i GB"
        ) else (
            set "VRAMs=%%i GB"
        )
    )
)

REM Combine GPU and VRAM information into a single output
set "gpuDetected=true"
set "OutputLine="
if "%gpuDetected%"=="true" (
    set "GPU_index=0"
    for %%G in (%GPU_names%) do (
        set /a "GPU_index+=1"
        for /f "tokens=1 delims=," %%V in ("!VRAMs!") do (
            if defined OutputLine (
                set "OutputLine=!OutputLine! | GPU%%GPU_index%%: %%G - VRAM: %%V"
            ) else (
                set "OutputLine=GPU%%GPU_index%%: %%G - VRAM: %%V"
            )
            set "VRAMs=!VRAMs:%%V=!"
        )
    )
    echo !OutputLine! | Total VRAM: %TotalVRAM% GB
) else (
    echo GPU Info not found
)

endlocal
