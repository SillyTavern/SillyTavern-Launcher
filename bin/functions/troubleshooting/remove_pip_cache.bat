@echo off
REM Set base directory
set "base_dir=%~dp0\..\.."

:remove_pip_cache
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Clearing pip cache...
pip cache purge
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Could not clear the pip cache.%reset%
    echo Please try again.
    pause
    goto :pip_exit
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%The pip cache has been cleared successfully.%reset%
pause

:pip_exit
if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)