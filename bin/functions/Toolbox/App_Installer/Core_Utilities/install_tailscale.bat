@echo off
setlocal enabledelayedexpansion
:install_tailscale
title STL [INSTALL-TAILSCALE]
set log_dir = %log_dir%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Do you already have a Tailscale account set up? (Y/N)
set /p tailscale_account="Answer (Y/N): "

if /i "%tailscale_account%"=="Y" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Tailscale configuration...
    call %app_installer_core_utilities_dir%\config_tailscale.bat
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Opening Tailscale sign-up page...
    start "" "https://login.tailscale.com/start"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Press any key after signing up to continue configuration...
    pause

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Tailscale configuration...
    call config_tailscale.bat
)

pause
