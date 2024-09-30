# This script exists because batch is terrible at processing lists of information, and does not have tables.

# Set up some variables for later use...
$gpus = Get-WmiObject -Class Win32_VideoController
$gpuInfo = @()
$global:increment = 0

# Iterate through all the GPUs and collect the name and vram info.
foreach ($gpu in $gpus) {
    $qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'
    if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) {
        $qwMemorySize = [double]$qwMemorySize[$global:increment]
    }
    else {
        $qwMemorySize = [double]$qwMemorySize
    }
    if ($null -ne $qwMemorySize) {
        $qwMemorySize = [math]::Round($qwMemorySize/1GB)
    }
    else {
        'Property not found'
    }
	# Set up an object so we can parse it later.
    $gpuInfo += [PSCustomObject]@{
        Name = $gpu.Name
        VRAM = $qwMemorySize
    }
	# Have to manually increment or it will only fetch the first gpu's information.
    $global:increment++
}

# Sort the object from highest-lowest based on the VRAM values, then return the first item.
$preferredGpu = $gpuInfo | Sort-Object VRAM -Descending | Select-Object -First 1
Write-Output "$($preferredGpu.Name):$($preferredGpu.VRAM)"
