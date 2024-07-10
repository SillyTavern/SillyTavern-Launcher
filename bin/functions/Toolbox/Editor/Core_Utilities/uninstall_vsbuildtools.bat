@echo off

:uninstall_vsbuildtools
title STL [UNINSTALL-VSBUILDTOOLS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling Visual Studio BuildTools 2022...
winget uninstall --id Microsoft.VisualStudio.2022.BuildTools
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Visual Studio BuildTools 2022 has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities