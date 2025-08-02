@echo off
setlocal

REM Set necessary environment variables for Node.js
set NODE_ENV=production

REM Determine the command to run
if "%1"=="ssl" (
    set NODE_CMD=node server.js --ssl
) else (
    set NODE_CMD=node server.js
)

REM Start the Node.js server and log the output using PowerShell Tee-Object
echo Starting Node.js server with command: %NODE_CMD%
cmd /c "%NODE_CMD%" 2>&1 | powershell -Command "$input | Tee-Object -FilePath '%logs_st_console_path%'"
echo Node.js server stopped.
pause
