@echo off

:uninstall_yq
title STL [UNINSTALL-YQ]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling yq...
winget uninstall --id MikeFarah.yq
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%yq has been uninstalled successfully.%reset%
pause

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)