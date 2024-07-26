@echo off
REM This script detects if a VPN is active by checking network adapters using netsh and an external IP check.

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

REM Check external IP for VPN status if no VPN detected yet
if "%vpnDetected%"=="false" (
    echo No VPN adapter detected locally, checking external IP... >> "%logfile%"
    
    REM Get the external IP address
    for /f "delims=" %%i in ('curl -s --max-time 5 https://api.ipify.org') do set "externalIP=%%i"
    echo External IP: !externalIP! >> "%logfile%"

    REM Check the external IP for VPN status using proxycheck.io
    set "apiResponse="
    for /f "delims=" %%i in ('curl -s --max-time 5 "https://proxycheck.io/v2/!externalIP!?vpn=2"') do set "apiResponse=!apiResponse! %%i"
    echo ProxyCheck API Response: !apiResponse! >> "%logfile%"

    REM Write the API response to a temporary file
    echo !apiResponse! > "%log_dir%\vpn_check.json"

    REM Parse the JSON response to find the proxy value
    for /f "delims=" %%a in ('type %log_dir%\vpn_check.json') do (
        set "line=%%a"
        if "!line!"=="proxy:" (
            set "vpnDetected=true"
            echo VPN detected based on external IP check. >> "%logfile%"
            goto :vpn_found
        )
    )
    echo No VPN detected based on external IP check. >> "%logfile%"
)

:vpn_found
if "%vpnDetected%"=="true" (
    echo VPN Status: %yellow_fg_strong%VPN detected. Local IP access and NodeJS install issues possible.%reset%
) else (
    echo VPN Status: %green_fg_strong%No VPN detected.%reset%
)

endlocal
