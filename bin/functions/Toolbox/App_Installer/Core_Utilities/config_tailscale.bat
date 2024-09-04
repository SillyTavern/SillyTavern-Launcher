@echo off
setlocal enabledelayedexpansion


title STL [TAILSCALE CONFIGURATION]
cls
echo / Home / Toolbox /  App Installer / Core Utilities / Tailscale 
echo -------------------------------------------------------------

rem Calculate the path to the logs folder based on the current script location
set log_dir=%~dp0..\..\..\..\logs
rem Normalize the path
for %%i in ("%log_dir%") do set log_dir=%%~fi

set log_file=%log_dir%\tailscale_status.txt

rem Check if the log file exists before attempting to clear it
if exist "%log_file%" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Clearing existing log file...
    powershell -command "Clear-Content '%log_file%'"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Log file does not exist, no need to clear.
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Configuring Tailscale...
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Tailscale login...

tailscale up

if %errorlevel%==0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Tailscale configuration successful.
    
    echo -------------------------------------------------------------
    echo Select an option:
    echo 1. Find Tailscale SillyTavern Remote URLs
    echo 2. Home

    choice /c 12 /m "Enter the number corresponding to your choice:"

    if errorlevel 2 (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Returning to Home...
    ) else if errorlevel 1 (
        echo.
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Fetching Tailscale status...
        rem Use the dynamic path based on %~dp0 to write to the logs folder
        powershell -command ^
        "$json = tailscale status --json | ConvertFrom-Json; " ^
        "$self = $json.Self; " ^
        "$ip4 = $self.TailscaleIPs[0]; " ^
        "$hostName = $self.HostName; " ^
        "$dnsName = $self.DNSName; " ^
        "$logPath = '%~dp0..\..\..\..\logs\tailscale_status.txt'; " ^
        "Out-File -FilePath $logPath -InputObject $ip4 -Encoding ascii; " ^
        "Out-File -FilePath $logPath -InputObject $hostName -Append -Encoding ascii; " ^
        "Out-File -FilePath $logPath -InputObject $dnsName -Append -Encoding ascii"

        rem Read the values directly using delayed expansion
        set count=0
        for /f "tokens=* delims=" %%i in (%log_file%) do (
            set /a count+=1
            if !count! equ 1 set ip4=%%i
            if !count! equ 2 set hostName=%%i
            if !count! equ 3 set dnsName=%%i
        )

        rem Remove trailing period from dnsName if it exists
        if "!dnsName:~-1!"=="." set "dnsName=!dnsName:~0,-1!"

        echo %blue_fg_strong%-------------------------------------------------------------%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% "Tailscale Remote SillyTavern URLs (if you changed your SillyTavern Port # change 8000 to that new port):"
        echo %cyan_fg_strong%IP4:%reset% http://!ip4!:8000
        echo %cyan_fg_strong%Machine Name:%reset% http://!hostName!:8000
        echo %cyan_fg_strong%MagicDNS Name:%reset% http://!dnsName!:8000
        echo %blue_fg_strong%-------------------------------------------------------------%reset%

        rem Prompt the user to open the additional config instructions page
        set /p userChoice="Do you want to open the additional configuration instructions page (Y/N)? "
        if /i "!userChoice!"=="Y" (
            rem Open the configuration URL
            powershell -command ^
            "$url = 'https://sillytavernai.com/tailscale-config/?HostName=!hostName!&DNSName=!dnsName!&IP4=!ip4!#STL'; " ^
            "Start-Process $url"
        ) else (
            echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Skipping additional configuration instructions.
        )
    )
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ERROR]%reset% %red_fg_strong%Tailscale configuration failed.%reset%
)

pause
