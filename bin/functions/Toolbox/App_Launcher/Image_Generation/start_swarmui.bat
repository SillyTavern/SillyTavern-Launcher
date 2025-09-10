@echo off

:start_swarmui

REM Force x64 to be read first
set PATH=C:\Program Files\dotnet;%PATH%
set DOTNET_CLI_TELEMETRY_OPTOUT=1

cd /d "%swarmui_install_path%"

REM Server settings option
if exist .\src\bin\always_pull (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] Pulling latest changes...
    git pull
)

REM Check if a build is needed
for /f "delims=" %%i in ('git rev-parse HEAD') do set CUR_HEAD=%%i
set /p BUILT_HEAD=<src/bin/last_build
if not "!CUR_HEAD!"=="!BUILT_HEAD!" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] No build detected. Building the app now...%reset%
    echo. 2>.\src\bin\must_rebuild
)

if exist .\src\bin\must_rebuild (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Building SwarmUI...
    if exist .\src\bin\live_release (
        rmdir /s /q .\src\bin\live_release_backup
        move .\src\bin\live_release .\src\bin\live_release_backup
    )
    del .\src\bin\must_rebuild
)

REM Build the app if the executable is missing
if not exist src\bin\live_release\SwarmUI.exe (
    REM Add microsoft nuget source just in case it isn't there
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Adding NuGet official package source...
    dotnet nuget add source https://api.nuget.org/v3/index.json --name "NuGet official package source"
    dotnet build src/SwarmUI.csproj --configuration Release -o src/bin/live_release
    for /f "delims=" %%i in ('git rev-parse HEAD') do set CUR_HEAD2=%%i
    echo !CUR_HEAD2!> src/bin/last_build
)

REM If the build failed and there is a backup, restore it
if not exist src\bin\live_release\SwarmUI.exe if exist src\bin\live_release_backup\SwarmUI.exe (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Build failed, restoring last known good build...%reset%
    timeout 5

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Restoring backup...
    rmdir /s /q src\bin\live_release
    move src\bin\live_release_backup src\bin\live_release
)

REM Default env configuration, gets overwritten by the C# code's settings handler
set ASPNETCORE_ENVIRONMENT="Production"
set ASPNETCORE_URLS="http://*:7801"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Launching SwarmUI...
.\src\bin\live_release\SwarmUI.exe %*

goto :home