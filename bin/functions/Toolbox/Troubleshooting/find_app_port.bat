@echo off

REM Function to find and display the application using the specified port
:find_app_port
cls
setlocal EnableDelayedExpansion

if "%~1"=="" (
    set /p port_choice="(0 to cancel)Insert port number: "
) else (
    set "port_choice=%~1"
)

if "%port_choice%"=="0" goto :troubleshooting

REM Check if the input is a number
set "valid=true"
for /f "delims=0123456789" %%i in ("!port_choice!") do set "valid=false"
if "!valid!"=="false" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid input: Not a number.%reset%
    pause
    goto :troubleshooting
)

REM Check if the port is within range
if !port_choice! gtr 65535 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Port out of range. There are only 65,535 possible port numbers.%reset%
    echo [0-1023]: These ports are reserved for system services or commonly used protocols.
    echo [1024-49151]: These ports can be used by user processes or applications.
    echo [49152-65535]: These ports are available for use by any application or service on the system.
    pause
    goto :troubleshooting
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Searching for application using port: !port_choice!...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r "\<!port_choice!\>"') do (
    set pid=%%a
)

if defined pid (
    for /f "tokens=2*" %%b in ('tasklist /fi "PID eq !pid!" /fo list ^| find "Image Name"') do (
        set app_name=%%c
        echo Application Name: %cyan_fg_strong%!app_name!%reset%
        echo PID of Port !port_choice!: %cyan_fg_strong%!pid!%reset%

        REM Fetch the page title for the specified port
        call :fetch_page_title !port_choice!
        if defined PAGE_TITLE (
            echo Title of Application: %cyan_fg_strong%!PAGE_TITLE!%reset%
        ) else (
            echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN]%reset% Could not retrieve page title.
        )
    )
) else (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN]%reset% Port: !port_choice! not found.
)
endlocal
pause
goto :port_exit

:fetch_page_title
setlocal
set "PORT=%1"
set "URL=http://localhost:%PORT%"

REM Use JScript to fetch and parse the title
for /f "delims=" %%I in ('cscript /nologo "%troubleshooting_dir%\fetch_title.js" "%URL%"') do (
    set "PAGE_TITLE=%%I"
)

endlocal & set "PAGE_TITLE=%PAGE_TITLE%"
goto :EOF

:port_exit
if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)
