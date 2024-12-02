@echo off

:remove_npm_cache
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Clearing npm cache...
npm cache clean --force
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Could not clear npm cache.%reset%
    echo Please try again.
    pause
    goto :npm_exit
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%npm cache cleared successfully.%reset%
pause

:npm_exit
if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)