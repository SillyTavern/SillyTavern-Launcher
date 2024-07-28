@echo off
REM This script detects if a VPN is active by checking network adapters using netsh.

REM Initialize variables
set "vpnDetected=false"
setlocal enabledelayedexpansion

REM Create a troubleshooting log
set "logfile=%log_dir%\troubleshooting_vpn_detection.log"
echo Troubleshooting VPN detection log > "%logfile%"
echo ================================== >> "%logfile%"
netsh interface show interface >> "%logfile%"
echo ================================== >> "%logfile%"

REM Loop through netsh output and check for active VPN adapters
for /f "skip=3 tokens=1,2,3,4,* delims= " %%a in ('netsh interface show interface') do (
    set "adminState=%%a"
    set "state=%%b"
    set "type=%%c"
    set "name=%%d %%e %%f"

    REM Only check connected interfaces
    if /i "!state!"=="Connected" (
        echo Checking interface: !name! >> "%logfile%"
        if /i "!name:VPN=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:Virtual Private=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:TAP-Windows Adapter V9=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:WireGuard Tunnel=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:Mullvad=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:OpenVPN Wintun=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:ProtonVPN=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:TunnelBear=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:ExpressVPN=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
        if /i "!name:SurfShark=!" NEQ "!name!" (
            set "vpnDetected=true"
            echo Detected VPN adapter: !name! >> "%logfile%"
            goto :vpn_found
        )
    )
)

:vpn_found
if "%vpnDetected%"=="true" (
    echo VPN Status: %yellow_fg_strong%VPN detected. Local IP access and NodeJS install issues possible.%reset%
) else (
    echo VPN Status: %green_fg_strong%No VPN detected.%reset%
)

endlocal
