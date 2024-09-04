@echo off
setlocal enabledelayedexpansion

:install_tailscale
title STL [INSTALL-TAILSCALE]
set log_dir=%log_dir%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Do you already have a Tailscale account set up? (Y/N)
set /p tailscale_account="Answer (Y/N): "

if /i "%tailscale_account%"=="Y" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Tailscale...
    winget install Tailscale.Tailscale

    if %errorlevel%==0 (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Tailscale installed successfully.%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Tailscale configuration...
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Restart the launcher and go to Toolbox / Editor / Core Utilities / View Tailscale Configuration to see your Tailscale Remote SillyTavern URLS.
        echo Press any key to restart the launcher
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Restarting launcher...%reset%
        timeout /t 10
        start %stl_root%/launcher.bat
        exit
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ERROR]%reset% %red_fg_strong%Tailscale installation failed.%reset%
    )
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Opening Tailscale sign-up page...
    start "" "https://login.tailscale.com/start"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Press any key after signing up to continue installation...
    pause

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Tailscale...
    winget install Tailscale.Tailscale

    if %errorlevel%==0 (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Tailscale installed successfully.%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Restart the launcher, your Tailscale Remote SillyTavern URLS should appear on the home menu.  
        echo If they don't appear, go to Toolbox / Editor / Core Utilities / View Tailscale Configuration.
        echo Press any key to restart the launcher
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Restarting launcher...%reset%
        timeout /t 10
        start %stl_root%/launcher.bat
        exit
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ERROR]%reset% %red_fg_strong%Tailscale installation failed.%reset%
    )
)

pause
