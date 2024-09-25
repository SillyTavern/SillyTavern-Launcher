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
for /f "tokens=2 delims==" %%f in ('wmic path Win32_VideoController get name /value ^| find "="') do (
	REM If GPU name is blank, set it; else, if it is not blank and does not equal the current value of f,
	REM move gpu name to last_gpu and set gpu_name to the new value. This is here so that if the current card has less
	REM VRAM than the previous card, we can set the name back properly. I doubt it would be needed... but you never know.
	if /i !GPU_name! equ "" (
		set "GPU_name=%%f"
	) else if !GPU_name! neq %%f (
		set "last_GPU=!GPU_name!"
		set "GPU_name=%%f"
	)
	REM Run PowerShell command to retrieve VRAM size and divide by 1GB
	for /f "usebackq tokens=*" %%i in (`powershell -Command "$qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'; if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) { $qwMemorySize = [double]$qwMemorySize[!iteration!] } else { $qwMemorySize = [double]$qwMemorySize }; if ($null -ne $qwMemorySize) { [math]::Round($qwMemorySize/1GB) } else { 'Property not found' }"`) do (
		set "VRAM=%%i"
	)
	REM iterate so we can move through the objects in the powershell script...
	set /a iteration=!iteration!+1
	REM If the VRAM is greater than 0 (it always should be, but just in case...) AND the lastVRAM is not the same as VRAM
	REM (might have to change this in the case where two cards have the same VRAM, but the user wants the first card...
	REM in which case we would want to see if it is the first iteration or not... but I'm not here to do all your work!)
	REM AND the lastVRAM is Grt than VRAM... set it to the previous card. We don't have to check the other way, because
	REM we already set VRAM. This way takes more builds into account... but not all.
	if /i !lastVRAM! gtr 0 (
		if /i !lastVRAM! neq !VRAM! (
			if /i !lastVRAM! gtr !VRAM! (
				set "VRAM=!lastVRAM!"
				set "GPU_name=!last_GPU!"
			)
		)
	) else (
		set "lastVRAM=!VRAM!"
	)
)

REM Display GPU name and VRAM
echo GPU: %cyan_fg_strong%%GPU_name%%reset% - VRAM: %cyan_fg_strong%%VRAM%%reset% GB
endlocal
