@echo off
setlocal enabledelayedexpansion

REM Set the log file
set "log_file=%log_dir%\port_8000_status.txt"

REM Function to check the application using port 8000
:check_port_8000
setlocal EnableDelayedExpansion

REM Initialize variables
set "port_choice=8000"
set "pid="
set "app_name="
set "PAGE_TITLE="

for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r "\<!port_choice!\>"') do (
    set "pid=%%a"
)

if defined pid (
    if "!pid!" neq "0" (
        for /f "tokens=2*" %%b in ('tasklist /fi "PID eq !pid!" /fo list ^| find "Image Name"') do (
            set "app_name=%%c"
            
            REM Fetch the page title for the specified port
            call :fetch_page_title !port_choice!
            if "!PAGE_TITLE!"=="The server returned an invalid or unrecognized response" (
                set "portStatus=Port Status: %red_fg_strong%8000 in Use: App title not found, may be using HTTPS%reset%"
            ) else if defined PAGE_TITLE (
                set "portStatus=Port Status: %red_fg_strong%8000 in Use: !PAGE_TITLE!%reset%"
            ) else (
                set "portStatus=Port Status: %red_fg_strong%8000 in Use: !app_name!%reset%"
            )
        )
    ) else (
        set "portStatus=Port Status: %green_fg_strong%8000 not in use%reset%"
    )
) else (
    set "portStatus=Port Status: %green_fg_strong%8000 not in use%reset%"
)

echo !portStatus!

endlocal
goto :EOF

:fetch_page_title
setlocal
set "PORT=%1"

REM Attempt HTTP first
set "URL=http://localhost:%PORT%"

for /f "delims=" %%I in ('cscript /nologo "%troubleshooting_dir%\fetch_title.js" "%URL%" 2^>^&1') do (
    set "PAGE_TITLE=%%I"
)

REM Log if HTTP fails and do not attempt HTTPS
if "!PAGE_TITLE!"=="The server returned an invalid or unrecognized response" (
    set "PAGE_TITLE=App title not found, may be using HTTPS"
) else (
    if "!PAGE_TITLE!"=="The download of the specified resource has failed." (
        set "PAGE_TITLE=App title not found, may be using HTTPS"
    )
)

REM Log if PAGE_TITLE is not retrieved
if not defined PAGE_TITLE (
    set "PAGE_TITLE=Could not find App Title"
)

endlocal & set "PAGE_TITLE=%PAGE_TITLE%"
goto :EOF

REM Call the function to check port 8000
call :check_port_8000

pause
