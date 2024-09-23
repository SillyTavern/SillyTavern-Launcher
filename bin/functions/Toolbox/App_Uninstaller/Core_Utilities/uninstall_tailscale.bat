@echo off

:uninstall_tailscale
title STL [UNINSTALL-TAILSCALE]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling Tailscale...
winget uninstall --id tailscale.tailscale
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Tailscale has been uninstalled successfully.%reset%
goto :app_uninstaller_core_utilities