@echo off

:export_dxdiag
REM Create the logs folder if it doesn't exist
if not exist "%log_dir%" (
    mkdir "%log_dir%"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Exporting DirectX Diagnostic Tool information...
dxdiag /t "%log_dir%\dxdiag_info.txt"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%You can find the dxdiag_info.txt at: "%log_dir%\dxdiag_info.txt"%reset%
pause

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)

