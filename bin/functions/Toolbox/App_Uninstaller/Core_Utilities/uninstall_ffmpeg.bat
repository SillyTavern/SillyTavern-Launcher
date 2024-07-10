@echo off

:uninstall_ffmpeg
title STL [UNINSTALL-FFMPEG]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Uninstalling ffmpeg...
rmdir /s /q "%ffmpeg_install_path%"

setlocal EnableDelayedExpansion
rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Remove the path from the current PATH if it exists
set "new_path=!current_path:%ffmpeg_path_bin%=!"

REM Update the PATH value in the registry
reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

REM Update the PATH value for the current session
setx PATH "!new_path!" > nul
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ffmpeg removed from PATH.%reset%
endlocal

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%ffmpeg has been uninstalled successfully.%reset%
goto :app_uninstaller_core_utilities