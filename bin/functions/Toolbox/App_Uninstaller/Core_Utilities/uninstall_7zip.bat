@echo off

:uninstall_7zip
title STL [UNINSTALL-7ZIP]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling 7-Zip...
winget uninstall --id 7zip.7zip
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%7-Zip has been uninstalled successfully.%reset%
pause

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)