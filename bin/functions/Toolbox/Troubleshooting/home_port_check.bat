@echo off

REM Set the log file
set "log_file=%log_dir%\port_8000_status.log"

REM Function to check the application using port 8000
:check_port_8000
setlocal EnableDelayedExpansion

REM Initialize variables
set "port_choice=8000"
set "pid="
set "app_name="
set "PAGE_TITLE="

echo Searching for application using port: !port_choice!... > "%log_file%"
for /f "tokens=5" %%a in ('netstat -aon ^| findstr /r "\<!port_choice!\>"') do (
    set "pid=%%a"
)

if defined pid (
    if "!pid!" neq "0" (
        for /f "tokens=2*" %%b in ('tasklist /fi "PID eq !pid!" /fo list ^| find "Image Name"') do (
            set "app_name=%%c"
            echo Application Name: !app_name! >> "%log_file%"
            echo PID of Port !port_choice!: !pid! >> "%log_file%"
            
            REM Fetch the page title for the specified port
            call :fetch_page_title !port_choice!
            if "!PAGE_TITLE!"=="The server returned an invalid or unrecognized response" (
                echo Port Status: %red_fg_strong%8000 in Use: App title not found, may be using HTTPS%reset% >> "%log_file%"
            ) else if defined PAGE_TITLE (
                echo Port Status: %red_fg_strong%8000 in Use: !PAGE_TITLE!%reset% >> "%log_file%"
            ) else (
                echo Port Status: %red_fg_strong%8000 in Use: !app_name!%reset% >> "%log_file%"
            )
        )
    ) else (
        echo Port Status: %green_fg_strong%8000 not in use%reset% >> "%log_file%"
    )
) else (
    echo Port Status: %green_fg_strong%8000 not in use%reset% >> "%log_file%"
)

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
    echo Could not retrieve page title from URL: %URL% >> "%log_file%"
)

endlocal & set "PAGE_TITLE=%PAGE_TITLE%"
goto :EOF

REM Call the function to check port 8000
call :check_port_8000

echo Port status has been logged to %log_file%.
pause
