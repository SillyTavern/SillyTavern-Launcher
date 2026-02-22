@echo off
:install_sdwebuiforgeneo
title STL [INSTALL SDWEBUI FORGE-NEO]
cls
echo %blue_fg_strong%/ Home / Toolbox / App Installer / Image Generation / Install Forge-NEO%reset%
echo -------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Forge-NEO via Pixi...

if not exist "%image_generation_dir%" mkdir "%image_generation_dir%"
cd /d "%image_generation_dir%"

set max_retries=3
set retry_count=0
:retry_clone
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Cloning Forge-NEO branch...
git clone -b neo https://github.com/Haoming02/sd-webui-forge-classic.git stable-diffusion-webui-forge-neo

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[WARN] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_clone
    pause
    goto :home
)

cd /d "%sdwebuiforgeneo_install_path%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Creating Pixi configuration...
(
echo [workspace]
echo name = "forge-neo"
echo channels = ["conda-forge", "pytorch", "nvidia"]
echo platforms = ["win-64"]
echo.
echo [dependencies]
echo python = "3.13.12.*"
echo uv = "*"
) > pixi.toml

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Running Pixi Install (Environment Setup)...
call pixi install

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%Forge-NEO installed Successfully.%reset%
pause
goto :home