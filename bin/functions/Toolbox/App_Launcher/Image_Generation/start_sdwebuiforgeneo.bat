@echo off
:start_sdwebuiforgeneo
cd /d "%sdwebuiforgeneo_install_path%"

REM Check if pixi exists
pixi --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[ERROR] Pixi not found. Please install Pixi first.%reset%
    pause
    goto :home
)

set "sdwfn_start_command="
for /F "tokens=*" %%a in ('findstr /I "sdwfn_start_command=" "%sdwebuiforgeneo_modules_path%"') do (
    set "%%a"
)

if not defined sdwfn_start_command (
    echo %yellow_fg_strong%[WARN] No modules configured. Redirecting to Editor...%reset%
    pause
    call "%editor_image_generation_dir%\edit_sdwebuiforgeneo_modules.bat"
    goto :start_sdwebuiforgeneo
)

set "sdwfn_start_command=%sdwfn_start_command:sdwfn_start_command=%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Launching Forge-NEO via Pixi...
start cmd /k "title FORGE-NEO && cd /d %sdwebuiforgeneo_install_path% && %sdwfn_start_command%"
goto :home