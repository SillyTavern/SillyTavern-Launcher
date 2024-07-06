@echo off
setlocal

REM Define the path to the log file
set LOG_FILE=..\bin\logs\st_console_output.log

REM Set necessary environment variables for Node.js
set NODE_ENV=production

REM Determine the command to run
if "%1"=="ssl" (
    set NODE_CMD=node server.js --ssl
) else (
    set NODE_CMD=node server.js
)

REM Start the Node.js server and log the output using PowerShell Tee-Object, suppressing specific warnings
echo Starting Node.js server with command: %NODE_CMD%
powershell -Command "& {%NODE_CMD% 2>&1 | Where-Object {$_ -notmatch 'Security has been overridden'} | Tee-Object -FilePath '%LOG_FILE%'}"
echo Node.js server started.
pause

REM Pause to keep the window open
pause
