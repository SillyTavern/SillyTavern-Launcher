@echo off

:uninstall_nodejs
title STL [UNINSTALL-NODEJS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling Node.js...
winget uninstall --id OpenJS.NodeJS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Node.js has been uninstalled successfully.%reset%
pause

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)