@echo off

:uninstall_jq
title STL [UNINSTALL-JQ]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling jq...
winget uninstall --id jqlang.jq
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%jq has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities