@echo off

:remove_pip_cache
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Clearing pip cache...
pip cache purge
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Could not clear pip cache.%reset%
    echo Please try again.
    pause
    goto :pip_exit
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%pip cache cleared successfully.%reset%
pause

:pip_exit
if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)