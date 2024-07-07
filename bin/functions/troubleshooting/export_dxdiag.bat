@echo off
REM Set base directory
set "base_dir=%~dp0\..\.."


:export_dxdiag
REM Ensure the logs directory exists
if not exist "%base_dir%\logs" (
    mkdir "%base_dir%\logs"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Exporting DirectX Diagnostic Tool information...
dxdiag /t "%base_dir%\logs\dxdiag_info.txt"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%You can find the dxdiag_info.txt at: "bin\logs\dxdiag_info.txt"%reset%
pause

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)

